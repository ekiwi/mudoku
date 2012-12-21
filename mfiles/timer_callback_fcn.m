% Plot the scanner image
function timer_callback_fcn(timerObj, event)

    rawImage = get(timerObj, 'UserData');

    maxi = max(max(rawImage));
    mini = min(min(rawImage));

    rawImage = ((rawImage-mini)./(maxi-mini)).*255;

    figure(1); imshow(uint8(rawImage'));
    rawImage = interpolation(rawImage);
    figure(2); imshow(uint8(rawImage'));

end

