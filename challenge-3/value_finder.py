def value_finder(key, obj):
    if "/" in key:
        keys = key.split('/')
        child_obj = {}
        for i in keys:
            child_obj = obj.get(i)
            obj = child_obj
            if i == keys[-1]:
                if obj is None:
                    return 'value not found for key sequence'
                return obj


