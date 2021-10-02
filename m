Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DF041FD9B
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 20:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhJBSOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 14:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbhJBSOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 14:14:37 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4F6C0613EC;
        Sat,  2 Oct 2021 11:12:51 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g193-20020a1c20ca000000b0030d55f1d984so2869878wmg.3;
        Sat, 02 Oct 2021 11:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qAx8Ph8yHpfd+qqFteveW8Jhq76CVl7OJQ5XRiR08GY=;
        b=pN+Zi1sPGEM7sebl/eyiD3dpFrjklfLaXydTNZrbxZA1lyJ1dkX/BXDH7isFf7Kdx+
         kXrTITWYNvKRdzI2Q6gF6ryXqVjiYmY3NnvP1bvB78W25TfRROITUdzc9IKEZ6OeSCkq
         pNEn555iLmxwueoc5ORMWu4JuA4+sv186rgI56PfVfbzoRoSA2rVweRGLh+BPsRqOs62
         Pq8re3GDVIwUdVDguuCLwUxj63w/kS3EkAYb9AiL2a2b77FiAXa2u/ObTaXeL1ECdSOx
         Sg/Osc+N1z+gs1MKAD+QxrRx4ovzndvrU/j6aG5AkIAVp6NYXBd1n+CbC0l1RS+xpY7s
         1kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qAx8Ph8yHpfd+qqFteveW8Jhq76CVl7OJQ5XRiR08GY=;
        b=joMKJ/yosz5oJjbsBixEbHlWIUSSmRICgm1M0goBoSqT1TC6FXKPbn83nKsZcqPxGr
         AM7GRr90YEFLqA8EvD2+bo3GAs8hJhFSwHPeBrlG8Q/78IJVpfHcbp0KeRUi8aypw+8q
         SBnw/LBKoj2izAL8L/3s8rDoJAXgkWQz+E5rru7zbkg67N44qtMnKgNh+C8lSWxnJdfZ
         Y5v6JoIJ31UsaQ0pM+r8MFZsQEGF3FXhaH6i80tA3SdLPPKzDf+2BKIdtOjlhjxwOM4r
         5UvmjIJ1avoLcI7oYtjg8sBNlt23I2hPWkzTixNXZhdLPStdmdKv2lEc/yyRO3/DPZMw
         4+1g==
X-Gm-Message-State: AOAM531p9Z8jLXO9LDrCTFhE7nRGrwrQRHkidY7rRpBNbv9kMw0kbJLb
        PWeIJbpSJq2k19OLeuQNrUFU9TcMHeo=
X-Google-Smtp-Source: ABdhPJwKCjrTtW0lDoBG124+VEM+bDkqnOY8Td/ZKyqbiHoP+s7iHayq92Ykng8HOnabm2N+R46Kzg==
X-Received: by 2002:a05:600c:4144:: with SMTP id h4mr2673948wmm.105.1633198370334;
        Sat, 02 Oct 2021 11:12:50 -0700 (PDT)
Received: from [10.8.0.30] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id y8sm5915128wrr.21.2021.10.02.11.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 11:12:50 -0700 (PDT)
Subject: Re: [PATCH] unix.7: Add a description for ENFILE.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20210929013841.1694-1-kuniyu@amazon.co.jp>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <84a95c03-43e6-36b8-fdd3-fbb3d74dcd0e@gmail.com>
Date:   Sat, 2 Oct 2021 20:12:48 +0200
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

Patch applied!

Thanks,

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
