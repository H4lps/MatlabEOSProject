clc;close all; clear;
%Grabbing the image from the user and picking a row of pixels

[FileName, PathName] = uigetfile({'*.png;*.jpg;*.jpeg','Image Files (*.png, *.jpg, *.jpeg)'}, 'Select an image file');
fullFileName = fullfile(PathName,FileName);
user_img = imread(fullFileName);
main_img = imread("Main_img.jpg");

%Simplifying the color channel

user_img = rgb2gray(user_img);
main_img = rgb2gray(main_img);

%Compressing the amount of pixels in the image

min_length = min(length(user_img),length(main_img));
resize = [min_length/4,min_length/4];
main_row = imresize(main_img,resize);
user_row = imresize(user_img,resize);

%flattening our matrix into a row

main_row = main_row(:);
user_row = user_row(:);

%Comparisson between given image and image of lebron

next_row = bitxor(main_row, user_row);

%We take 16 uint8 values evenly spaced to maintain high entropy
%We also must round each value to create integers, that are indexable

sz = linspace(1,length(next_row),16);
for x = 1:16
    sz(x) = ceil(sz(x));
end

%Possible characters for the hash

list_chars = ['A':'Z', 'a':'z','0':'9'];

%Adding a salt to further increase Entropy
rng('shuffle')
salt = uint8(randi([0,255],[1,16]));

%Append Each character by taking the uint8 value
%We use modulus and +1 to make sure we stay in bounds

out = [];
for x =1:16
    a = bitxor(next_row(sz(x)),salt(x));
    b = list_chars(mod(a,length(list_chars))+1);
    out = [out,b];
end

final = [final;out,salt];








