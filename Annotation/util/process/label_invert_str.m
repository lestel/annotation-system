function str_label=label_invert_str(label)
switch label
    case 1
    str_label=['NOT MASS:N'];
    case 0
    str_label=['MASS:B'];
    case -1
    str_label=['MASS:C'];
end