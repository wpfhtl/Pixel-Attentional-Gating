classdef BatchNorm < dagnn.ElementWise
    properties
        numChannels
        epsilon = 1e-5
        opts = {'NoCuDNN'} % ours seems slightly faster
        usingGlobal = false;
    end
    
    properties (Transient)
        moments
    end
    
    methods
        function outputs = forward(obj, inputs, params)
            if strcmpi(obj.net.mode, 'test')
                outputs{1} = vl_nnbnorm(inputs{1}, params{1}, params{2}, 'moments', params{3}, 'epsilon', obj.epsilon, obj.opts{:}) ;                
%                 EPSILON = 0.00001;
%                 Y = bsxfun(@minus, inputs{1}, reshape(params{3}(:,1),[1, 1, numel(params{3}(:,1))]));
%                 Y = bsxfun(@times, Y, reshape(params{1},[1, 1, numel(params{1})]));
%                 Y = bsxfun(@rdivide, Y, reshape(EPSILON+params{3}(:,2),[1, 1, numel(params{3}(:,2))]));
%                 Y = bsxfun(@plus, Y, reshape(params{2},[1, 1, numel(params{2})]));
                                
            elseif strcmpi(obj.net.mode, 'trainGlobalBN') && obj.usingGlobal
                [outputs{1},obj.moments] = vl_nnbnorm(inputs{1}, params{1}, params{2}, 'moments', params{3}, 'epsilon', obj.epsilon, obj.opts{:}) ;                
            elseif strcmpi(obj.net.mode, 'trainGlobalBN') && ~obj.usingGlobal
                [outputs{1},obj.moments] = vl_nnbnorm(inputs{1}, params{1}, params{2}, 'epsilon', obj.epsilon, obj.opts{:}) ;
            elseif strcmpi(obj.net.mode, 'trainLocalBN') && obj.usingGlobal
                [outputs{1},obj.moments] = vl_nnbnorm(inputs{1}, params{1}, params{2}, 'moments', params{3}, 'epsilon', obj.epsilon, obj.opts{:}) ;
            elseif strcmpi(obj.net.mode, 'trainLocalBN') && ~obj.usingGlobal
                [outputs{1},obj.moments] = vl_nnbnorm(inputs{1}, params{1}, params{2}, 'epsilon', obj.epsilon, obj.opts{:}) ;
            else
                [outputs{1},obj.moments] = vl_nnbnorm(inputs{1}, params{1}, params{2}, 'epsilon', obj.epsilon, obj.opts{:}) ;
            end
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            [derInputs{1}, derParams{1}, derParams{2}, derParams{3}] = ...
                vl_nnbnorm(inputs{1}, params{1}, params{2}, derOutputs{1}, ...
                'epsilon', obj.epsilon, ...
                'moments', obj.moments, ...
                obj.opts{:}) ;
            obj.moments = [] ;
            % multiply the moments update by the number of images in the batch
            % this is required to make the update additive for subbatches
            % and will eventually be normalized away
            derParams{3} = derParams{3} * size(inputs{1},4) ;
        end
        
        % ---------------------------------------------------------------------
        function obj = BatchNorm(varargin)
            obj.load(varargin{:}) ;
        end
        
        function params = initParams(obj)
            params{1} = ones(obj.numChannels,1,'single') ;
            params{2} = zeros(obj.numChannels,1,'single') ;
            params{3} = zeros(obj.numChannels,2,'single') ;
        end
        
        function attach(obj, net, index)
            attach@dagnn.ElementWise(obj, net, index) ;
            p = net.getParamIndex(net.layers(index).params{3}) ;
            net.params(p).trainMethod = 'average' ;
            net.params(p).learningRate = 0.1 ;
        end
    end
end
