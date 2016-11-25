export CoOccurrence

immutable CoOccurrence <: Recommender
    da::DataAccessor
    i_ref::Int
    scores::AbstractVector
    states::States
end

CoOccurrence(da::DataAccessor, i_ref::Int) = begin
    n_item = size(da.R, 2)
    CoOccurrence(da, i_ref, zeros(n_item), States(:is_built => false))
end

function build(rec::CoOccurrence)
    n_item = size(rec.da.R, 2)

    v_ref = rec.da.R[:, rec.i_ref]
    c = countnz(v_ref)

    for i in 1:n_item
        v = rec.da.R[:, i]
        cc = length(v_ref[(v_ref .> 0) & (v .> 0)])
        rec.scores[i] = cc / c * 100.0
    end

    rec.states[:is_built] = true
end

function ranking(rec::CoOccurrence, u::Int, i::Int)
    check_build_status(rec)
    rec.scores[i]
end
