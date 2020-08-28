Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8672925593F
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 13:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgH1LW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 07:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbgH1LWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 07:22:48 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8833C061234
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 04:14:14 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m23so804080iol.8
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 04:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2L600FixKl2X0p38Oa+3csF7zFB3gsUUZZTZssQvcmg=;
        b=QsTOuCe09I2EwMPty9Gckdy2oqBaT1CHiVt6MuxK+G6e8xgLyYbcIT6xhru3N+m1YI
         f4hrp/pvNjb0jRUIteWtVramTNTk8DU8qM60w/RgWeHgX00tEjh/0OLxMNixMTqI+aSg
         cHnjKtfPgw0hHrCnzhiIlnlR9+VgWKlneh5snidAH87A5vWGtdTyp7JiZY4zXGuBbnRv
         pAU0NZk7u7m5XOK8IO4u0HNFJ/i2YLKIv3L2KxZR8HRo/fvcbgK4wYzGYvPJ4H97ZdeE
         Go+0r4WhebkzCOsfM7eqfpsy3dXk26d3DM+Qjv5eol1KOHQgy9BAhGq5HjC7fBS3TiBg
         3+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2L600FixKl2X0p38Oa+3csF7zFB3gsUUZZTZssQvcmg=;
        b=Pol06s5mQY44ZFdhH/wqqy8t11cgzyzRG/kGJZfJ10okUIxJ8/QuTVgMPEdsE/mFCP
         q2fkrAv9PqrE6VabaUkzU6WBmYfjjKK/VaVqesYMuY9uq2DAKuiMOaBsmvQiOJMIJ/sW
         9Pp+jldVthaVAf+vnqqVxzKTlhy9BQJU3m4hCO7TyEx3lyEaRgzWQb0JjFZQjYywXaiu
         5nqOkkMFis5R4Bfrb9nz7+xBGQiXENPB9kMAbCKXifO6gqKBkPqz452grBnExgVKw9Gm
         SRvNAApONkaEcWH/5ToRDDIrdup4Yqe7+CiqBbmfpziXokOoq6rpgFBHEblIV7yEOjk6
         f4aA==
X-Gm-Message-State: AOAM533E82PGWRyUIcWUIBCzupj4iaPJeesplvJa12GsQYROL4iIiLon
        WcQ6cc0J3JkIMKcaok2mAwIfQk54//io9479VVf3JjA3Fqs=
X-Google-Smtp-Source: ABdhPJw86t3OKPgPtNKg0cBnXUwJ+ky/d/Qz2+M8XRFNsHR/ceaLa0IGwqyr5Aos3zu3zA4jSpRGBP/NxUgInOwAAnQ=
X-Received: by 2002:a02:2715:: with SMTP id g21mr644620jaa.114.1598613253614;
 Fri, 28 Aug 2020 04:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200818141224.5113-1-yhayakawa3720@gmail.com>
In-Reply-To: <20200818141224.5113-1-yhayakawa3720@gmail.com>
From:   Yutaro Hayakawa <yhayakawa3720@gmail.com>
Date:   Fri, 28 Aug 2020 20:14:02 +0900
Message-ID: <CABTgxWFnbZLDNDUv9EVY4WsDDjM7aSGgxOmak4otMKXw_nKvPw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] net/tls: Implement getsockopt SOL_TLS TLS_RX
To:     netdev@vger.kernel.org
Cc:     Michio Honda <michio.honda@ed.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, is there any chance that this patch gets reviewed?

Thanks,
Yutaro


2020=E5=B9=B48=E6=9C=8818=E6=97=A5(=E7=81=AB) 23:12 Yutaro Hayakawa <yhayak=
awa3720@gmail.com>:
>
> Implement the getsockopt SOL_TLS TLS_RX which is currently missing. The
> primary usecase is to use it in conjunction with TCP_REPAIR to
> checkpoint/restore the TLS record layer state.
>
> TLS connection state usually exists on the user space library. So
> basically we can easily extract it from there, but when the TLS
> connections are delegated to the kTLS, it is not the case. We need to
> have a way to extract the TLS state from the kernel for both of TX and
> RX side.
>
> The new TLS_RX getsockopt copies the crypto_info to user in the same
> way as TLS_TX does.
>
> We have described use cases in our research work in Netdev 0x14
> Transport Workshop [1].
>
> Also, there is an TLS implementation called tlse [2] which supports
> TLS connection migration. They have support of kTLS and their code
> shows that they are expecting the future support of this option.
>
> [1] https://speakerdeck.com/yutarohayakawa/prism-proxies-without-the-pain
> [2] https://github.com/eduardsui/tlse
>
> Signed-off-by: Yutaro Hayakawa <yhayakawa3720@gmail.com>
> ---
>  net/tls/tls_main.c | 50 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 36 insertions(+), 14 deletions(-)
>
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index bbc52b088d29..ea66cac2cd84 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -330,8 +330,8 @@ static void tls_sk_proto_close(struct sock *sk, long =
timeout)
>                 tls_ctx_free(sk, ctx);
>  }
>
> -static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
> -                               int __user *optlen)
> +static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
> +                                 int __user *optlen, int tx)
>  {
>         int rc =3D 0;
>         struct tls_context *ctx =3D tls_get_ctx(sk);
> @@ -352,7 +352,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, cha=
r __user *optval,
>         }
>
>         /* get user crypto info */
> -       crypto_info =3D &ctx->crypto_send.info;
> +       if (tx) {
> +               crypto_info =3D &ctx->crypto_send.info;
> +       } else {
> +               crypto_info =3D &ctx->crypto_recv.info;
> +       }
>
>         if (!TLS_CRYPTO_INFO_READY(crypto_info)) {
>                 rc =3D -EBUSY;
> @@ -378,11 +382,19 @@ static int do_tls_getsockopt_tx(struct sock *sk, ch=
ar __user *optval,
>                         goto out;
>                 }
>                 lock_sock(sk);
> -               memcpy(crypto_info_aes_gcm_128->iv,
> -                      ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
> -                      TLS_CIPHER_AES_GCM_128_IV_SIZE);
> -               memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
> -                      TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> +               if (tx) {
> +                       memcpy(crypto_info_aes_gcm_128->iv,
> +                              ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_S=
IZE,
> +                              TLS_CIPHER_AES_GCM_128_IV_SIZE);
> +                       memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.=
rec_seq,
> +                              TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> +               } else {
> +                       memcpy(crypto_info_aes_gcm_128->iv,
> +                              ctx->rx.iv + TLS_CIPHER_AES_GCM_128_SALT_S=
IZE,
> +                              TLS_CIPHER_AES_GCM_128_IV_SIZE);
> +                       memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->rx.=
rec_seq,
> +                              TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> +               }
>                 release_sock(sk);
>                 if (copy_to_user(optval,
>                                  crypto_info_aes_gcm_128,
> @@ -402,11 +414,19 @@ static int do_tls_getsockopt_tx(struct sock *sk, ch=
ar __user *optval,
>                         goto out;
>                 }
>                 lock_sock(sk);
> -               memcpy(crypto_info_aes_gcm_256->iv,
> -                      ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
> -                      TLS_CIPHER_AES_GCM_256_IV_SIZE);
> -               memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
> -                      TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
> +               if (tx) {
> +                       memcpy(crypto_info_aes_gcm_256->iv,
> +                              ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_S=
IZE,
> +                              TLS_CIPHER_AES_GCM_256_IV_SIZE);
> +                       memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.=
rec_seq,
> +                              TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
> +               } else {
> +                       memcpy(crypto_info_aes_gcm_256->iv,
> +                              ctx->rx.iv + TLS_CIPHER_AES_GCM_256_SALT_S=
IZE,
> +                              TLS_CIPHER_AES_GCM_256_IV_SIZE);
> +                       memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->rx.=
rec_seq,
> +                              TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
> +               }
>                 release_sock(sk);
>                 if (copy_to_user(optval,
>                                  crypto_info_aes_gcm_256,
> @@ -429,7 +449,9 @@ static int do_tls_getsockopt(struct sock *sk, int opt=
name,
>
>         switch (optname) {
>         case TLS_TX:
> -               rc =3D do_tls_getsockopt_tx(sk, optval, optlen);
> +       case TLS_RX:
> +               rc =3D do_tls_getsockopt_conf(sk, optval, optlen,
> +                                           optname =3D=3D TLS_TX);
>                 break;
>         default:
>                 rc =3D -ENOPROTOOPT;
> --
> 2.26.2
>
