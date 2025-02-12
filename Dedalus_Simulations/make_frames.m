% process frames

clear

filename = 'snapshots_2';
dataname = [filename '/' filename '_s1.h5'];

f = h5info(dataname);
x_name = f.Groups(1).Datasets(7).Name;
x = h5read(dataname, ['/scales/' x_name]);
Lx = -2*x(1);

t = h5read(dataname, '/scales/sim_time');

b = permute(h5read(dataname,'/tasks/b'),[2 1 3]) + 2/Lx*x;

if ~exist("frames", "dir")
    mkdir frames
end

system('rm frames/*');
system('rm mov.mp4');

save_frames(b,'frames/frame','png',cmap2(),[-1 1])

S = size(b);

if S(3) > 99
    system('ffmpeg -framerate 20 -i frames/frame_%03d.png mov.mp4');
else
    system('ffmpeg -framerate 20 -i frames/frame_%02d.png mov.mp4');
end

M2 = permute(h5read(dataname, '/tasks/M2'),[2 1 3]);
M2_max = squeeze(max(M2(:,end,:)));

plot(t, M2_max, 'k'); grid; xlabel('t'); ylabel('max_x[M^2]')
