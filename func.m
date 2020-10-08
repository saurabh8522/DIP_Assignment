function [output]=func(img)
X=[];
W=[1 3 5 7 9];
x_sz=size(X);
x_sz=x_sz(1,2)
window_sz=size(W);
window_sz=window_sz(1,2)
Y1=zeros(size(X));
Y2=zeros(size(X));
Y3=zeros(size(X));
T1=zeros(size(W));
T2=zeros(size(W));
T3=zeros(size(W));
img=double(img);

    for i=1:x_sz
        noised_img=img+X(i)*randn(size(img));

        N1=colfilt(noised_img,[5 5],'sliding',@std);
        noise=mode(round(N1(:)));
        fprintf("noise=%f\n",noise);
        D1=PNLM(noised_img,1,5,X(i),1);

        fprintf('Denoised image with PNLM generated\n');
        D2=NLmeansfilter(noised_img,5,1,X(i));

        fprintf('Denoised image with Normal NLM generated\n');
        D3=FAST_NLM_II(noised_img,1,5,X(i));

        fprintf('Denoised image with Fast NLM generated\n');
        Y1(1,i)=DEF_PSNR(img,D1);
        Y2(1,i)=DEF_PSNR(img,D2);
        Y3(1,i)=DEF_PSNR(img,D3);
        fprintf('%f %f %f\n',Y1,Y2,Y3);
    end
    for i=1:window_sz
        noised_img=img+20*randn(size(img));
        fprintf("window_size=%f\n",W(i));
        tic
        D1=PNLM(noised_img,1,W(i),20,1);
        pnlm_time=toc
        fprintf('Denoised image using PNLM time=%d\n',pnlm_time);
        tic
        D2=NLmeansfilter(noised_img,W(i),1,20);
        nlm_time =toc
        fprintf('Denoised image using Normal NLM time=%d\n',nlm_time);
        tic
        D3=FAST_NLM_II(noised_img,1,W(i),20);
        fast_nlm_time=toc
        fprintf('Denoised image using Fast NLM time=%d\n',fast_nlm_time);
        T1(1,i)=pnlm_time
        T2(1,i)=nlm_time
        T3(1,i)=fast_nlm_time
    end
    plot(X,Y1,'-o','DisplayName','PNLM');
    title('PSNR vs noise');
    hold on
    plot(X,Y2,'-x','DisplayName','Normal NLM');
    plot(X,Y3,'-*','DisplayName','Fast NLM');
    hold off
    legend();
    output=[X,Y1,Y2,Y3]
    figure();
    plot(W,T1,'-o','DisplayName','PNLM');
    title('Time taken(seconds) vs Window size');
    hold on
    plot(W,T2,'-x','DisplayName','Normal NLM');
    plot(W,T3,'-*','DisplayName','Fast NLM');
    hold off
    legend();
    output=[W,T1,T2,T3];
end