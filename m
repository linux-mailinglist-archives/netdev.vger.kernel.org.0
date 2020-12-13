Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DD72D909B
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 21:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405978AbgLMUgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 15:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgLMUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 15:36:16 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BEFC0613D3
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 12:35:35 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id j22so1752492eja.13
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 12:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jFob+0/Vv3lhyTdGVKL3KehVl/9qV4DHLkbOLJ2OYgE=;
        b=a1RyF1RjzYQ4eiIbudj3kmEba/xZJRAXbhxfA9PaXDnSjcCpD97huIVTck8syAz3cI
         /7VGayMValLfwZhByoRBjzE25FBPIYuPfmG3R+F/B7jEG+Y3KzLNRNnPJup0FXdC2tLJ
         GNKOCL34IyoJ5CevGSKvz3oVsd/agP/9AlY3U8L6LFwY+WBnFEqh5cJAVJ3QLen5Ia9Q
         9LYkkqqLnn6wCbc5T9twgCLPTetoe+erhRWgNLLVnR/VmMHt07IR7AypksJHxc8E8gPI
         /344PsSVpeRsIxMu05sTaHWNNBptrg82GF+v6ev2TaF5FBUtzcdJXBuZFDLc8sNMTzMj
         YN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jFob+0/Vv3lhyTdGVKL3KehVl/9qV4DHLkbOLJ2OYgE=;
        b=VlPAaMjJjXa4T3rjz6op8AMgBGgh2Ns+LzlA+iVO9H8xl6YXA08P6PGjwgd9oRgKJ9
         19Ko25FoQV6B170nNkKnSwUlGiGbGY8Y/A65PshQvcNooZDDEenheZWPqmiLLzSdtndK
         AnjlXfkaq78vHaODV/gtWqYiAeQWwqbwKCzgnZmbfyCkMlh1rQW/7nQBHitBsbtCJOr5
         Bk2/j83+oXXr8yFlCfhfdvAvGwBrI542v8GwsCB5rm/TKtNgTmEegsyg5sKsrTUyVu7U
         4nyRGrrUV9V+niS8ZK+QaRb8utQuPQ7ZubhzD2QkEo+1hRjK7o/81r/mFh3LHON938CP
         oNxw==
X-Gm-Message-State: AOAM532HP2lc+tyrjHuit7Tk+mjWawiJkvgz28DBD0SalBHiLKSnK1JE
        H+e7nQzzhLiLq3BBHCqmGMBnWZGdOKTAjrJcCxq3gQ==
X-Google-Smtp-Source: ABdhPJzbOK2YzsYa1LzFGBRZjZ8TA6HYHZYy08T1dLx+JaQa6bkXNUQ2vOGRbjfptjoo661UEzAyOHW2moFYqErqXIc=
X-Received: by 2002:a17:906:5912:: with SMTP id h18mr19699780ejq.261.1607891734510;
 Sun, 13 Dec 2020 12:35:34 -0800 (PST)
MIME-Version: 1.0
References: <20201213203112.24152-1-v@nametag.social> <20201213203112.24152-2-v@nametag.social>
In-Reply-To: <20201213203112.24152-2-v@nametag.social>
From:   Victor Stewart <v@nametag.social>
Date:   Sun, 13 Dec 2020 20:35:23 +0000
Message-ID: <CAM1kxwiNO5XdKpC0L8OUWRTnmsBFs9WxX8ky_7D78+OVDsGA5g@mail.gmail.com>
Subject: Re: [PATCH] allow UDP cmsghdrs through io_uring
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the header didn't come through on my email, but i see it in the
archive. almost got this git send-email thing working lol. the patch
got a different subject line for some reason.

On Sun, Dec 13, 2020 at 8:31 PM Victor Stewart <v@nametag.social> wrote:
>
> ---
>  net/ipv4/af_inet.c  | 1 +
>  net/ipv6/af_inet6.c | 1 +
>  net/socket.c        | 8 +++++---
>  3 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index b7260c8cef2e..c9fd5e7cfd6e 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1052,6 +1052,7 @@ EXPORT_SYMBOL(inet_stream_ops);
>
>  const struct proto_ops inet_dgram_ops = {
>         .family            = PF_INET,
> +       .flags             = PROTO_CMSG_DATA_ONLY,
>         .owner             = THIS_MODULE,
>         .release           = inet_release,
>         .bind              = inet_bind,
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index e648fbebb167..560f45009d06 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -695,6 +695,7 @@ const struct proto_ops inet6_stream_ops = {
>
>  const struct proto_ops inet6_dgram_ops = {
>         .family            = PF_INET6,
> +       .flags             = PROTO_CMSG_DATA_ONLY,
>         .owner             = THIS_MODULE,
>         .release           = inet6_release,
>         .bind              = inet6_bind,
> diff --git a/net/socket.c b/net/socket.c
> index 6e6cccc2104f..6995835d6355 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2416,9 +2416,11 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
>  long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
>                         unsigned int flags)
>  {
> -       /* disallow ancillary data requests from this path */
> -       if (msg->msg_control || msg->msg_controllen)
> -               return -EINVAL;
> +       if (msg->msg_control || msg->msg_controllen) {
> +               /* disallow ancillary data reqs unless cmsg is plain data */
> +               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
> +                       return -EINVAL;
> +       }
>
>         return ____sys_sendmsg(sock, msg, flags, NULL, 0);
>  }
> --
> 2.26.2
>
