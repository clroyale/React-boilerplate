import { orderActionTypes } from './orderActions';

const initialState = {
    list: [],
    item: null,
    error: null,
    loading: false,
};

export default (state = initialState, { type, payload }) => {
    switch (type) {
    case orderActionTypes.list.REQUEST:
    case orderActionTypes.item.REQUEST:
        return {
            ...state,
            loading: true,
        };

    case orderActionTypes.list.SUCCESS:
        return {
            ...state,
            list: payload,
            error: null,
            loading: false,
        };

    case orderActionTypes.list.FAILURE:
        return {
            ...state,
            list: [],
            error: payload,
            loading: false,
        };

    case orderActionTypes.item.SUCCESS:
        return {
            ...state,
            item: payload,
            error: null,
            loading: false,
        };

    case orderActionTypes.item.FAILURE:
        return {
            ...state,
            item: null,
            error: payload,
            loading: false,
        };

    default:
        return state;
    }
};
