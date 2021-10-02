Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33C841FD82
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 19:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhJBRqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 13:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbhJBRql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 13:46:41 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB05C0613EC;
        Sat,  2 Oct 2021 10:44:55 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j10-20020a1c230a000000b0030d523b6693so3515629wmj.2;
        Sat, 02 Oct 2021 10:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TDptnlX5D3kk5KeBvQAiSIEzvz/mdqtpEDNI3MannFA=;
        b=VDeyZH077ujEG5sD746uF68NcPvUo3IEzFO/BaQy6cARXZfZ+6lJcKZ0srd3VLI4K+
         GUC5ZJVYIvAdKNIcPr9cRkCj5l6+6lYS7nQ0KfOljdguNymAEV2FAHYcm/5Kht4BaTVK
         AB/qxs1cjIV4I5ylfpQgImgXbrVELD7Qj2AsdfH/2n1x2X0TJmrwvUprEdpBy8HyTxOx
         I3H/3rCxnJjhH4osAcQ2H2G+Csm5A+YwcBGOAKcoxhXFdQsPWHdmQvUPiDgUvIsKNHT0
         vSP4GZSTtCb9ylqoBA/EWXiamzXVaFAgo0edC9RAAekT379uc2H5oGvufld33FlqQg5f
         L4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TDptnlX5D3kk5KeBvQAiSIEzvz/mdqtpEDNI3MannFA=;
        b=65p9NqvWoOCh5I11aouHnTLYCO/8F4GszhY0bzpWxDluC3b5mE/ZnCSDtn8yVJUTix
         PUYeiQ//HU7wvRgp97EWIXj/6gmyHdCt5syyWNFvapya3atlqGsNHFegG0jDPgwj39KC
         j4B5E3j+lnNGbOFX4CrgfeGvRk3L2IhtcaiR7FaSNZet4QjH92IrNxXZAtj9dMh8p0sd
         5MfqW1GImyQ/YhgLm6UyluRECI460KG9gBsYEhA0FLBHsG+IpJYx6WnOvpaGJXfiw+vR
         A/Kax+Eo4sl+yZ7H1ndoyzdgH+0bZmjoVN1ZMiiiC0443RnyaDO4T200P/kJ1Hik8RZt
         i/IA==
X-Gm-Message-State: AOAM531U79Ns9WTj8ngy4b91dKPKQcO4JAe8M5mDqjqMxV4agR15nP1Y
        M1phvHV03Q1vwpqIhotmjd8=
X-Google-Smtp-Source: ABdhPJwFBJNH+oKm6V02Fm9cyONB3sj9FfLlyZHD2MQVeVjjZ2I19mMWb7jYXJQbqyYlfKmxPZtZqQ==
X-Received: by 2002:a7b:ce83:: with SMTP id q3mr10399372wmj.103.1633196693823;
        Sat, 02 Oct 2021 10:44:53 -0700 (PDT)
Received: from [10.8.0.30] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id d24sm9094826wmb.35.2021.10.02.10.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 10:44:53 -0700 (PDT)
Subject: Re: [PATCH] unix.7: Add a description for ENFILE.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20210929013841.1694-1-kuniyu@amazon.co.jp>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <206a26e5-0515-44b9-39cb-bc46013bfc6c@gmail.com>
Date:   Sat, 2 Oct 2021 19:44:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210929013841.1694-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Kuniyuki,

On 9/29/21 3:38 AM, Kuniyuki Iwashima wrote:
> When creating UNIX domain sockets, the kernel used to return -ENOMEM on
> error where it should return -ENFILE.  The behaviour has been wrong since
> 2.2.4 and fixed in the recent commit f4bd73b5a950 ("af_unix: Return errno
> instead of NULL in unix_create1().").
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
> Note to maintainers of man-pages, the commit is merged in the net tree [0]
> but not in the Linus' tree yet.
> 
> [0]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=f4bd73b5a950

Thanks!

The patch looks good to me, so could you ping back when this is merged 
in Linus's tree?

Cheers,

Alex

> ---
>   man7/unix.7 | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/man7/unix.7 b/man7/unix.7
> index 6d30b25cd..2dc96fea1 100644
> --- a/man7/unix.7
> +++ b/man7/unix.7
> @@ -721,6 +721,9 @@ invalid state for the applied operation.
>   called on an already connected socket or a target address was
>   specified on a connected socket.
>   .TP
> +.B ENFILE
> +The system-wide limit on the total number of open files has been reached.
> +.TP
>   .B ENOENT
>   The pathname in the remote address specified to
>   .BR connect (2)
> 


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
