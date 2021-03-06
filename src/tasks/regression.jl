struct Regression <: Task end

function args(
    ::Type{Regression};
    binarize = true,
    threshold = Inf,
    kwargs...
)

    return (; binarize, threshold)
end

function partition(::Dataset{N, F, T}, targets, at::Real) where {N, F, T<:Regression}
    n = length(targets)
    k = round(Int, n*at)
    return (1:k, (k+1):n)
end

function partition(d::Dataset{N, F, T}, targets, at) where {N, F, T<:Regression}
    if length(at) == 1
        return partition(d, targets, at[1])
    end
    n = length(targets)
    i = 0
    inds = []
    for at_i in at
        k = round(Int, n*at_i)
        push!(inds, i .+ (1:k)) 
        i += k
    end
    return (inds..., (i+1):n)
end

function postprocess(
    N::Type{<:Name},
    ::Type{Regression},
    data;
    binarize,
    threshold,
    kwargs...
    )
    
    if binarize && !isinf(threshold)
        data = data_binarize_regression(data, threshold)
    end
    return data
end