Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581ED412BD8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351032AbhIUCiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhIUC2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:28:43 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0C9C0F344E;
        Mon, 20 Sep 2021 12:24:04 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x6so32694036wrv.13;
        Mon, 20 Sep 2021 12:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YmGPZteYFbIZ2nRx8xuxHgT2azyXIam+Snq0MYad3PA=;
        b=lDqYhmdr3cu9apoGHWl+DD06++JvQoBI7Y96RPZRQRRr24BX9WG/CRIUEneowIlC80
         sDExEbfY/bhH9xRbhIOHU9CeBqDY4YlwiDspiU/fS8AX7ka8GP13kZ1HEM6YZ3QTR1JC
         FOv4mDAbafes0HqV2zPFUaMEKWTISbdYV06vOVj2UC1w/czxLbytcqCqFZQaIudbNCvY
         kLATbbgVxfcNnTHBEEtO9hEzr6rvFMriRWPi26BXj7i0JcH2wF6ghBoRPQPGR0Eud47+
         gRsEfYIH2DeC0RfJ3n9YgDvUFGf2so50viAHOuzVE6p6MmdMZJ4KyXx7NtPQSqdoaGgR
         cwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YmGPZteYFbIZ2nRx8xuxHgT2azyXIam+Snq0MYad3PA=;
        b=n9KjmFauCDypHl7ju3DZ6ZRVnEkqiwXEl6OlectJf34oQ54dliyCrbcX1DmXnzexZI
         Z8Et0KMLsJah4ywmqWtAYctjHEOHAV9zXUTgZydiYysV9qoguWiI7NnE4H9CnV9gtbaU
         gzR34PDVQiICYpbofv5BZ2g4oLZz1Yy2VbKnp8kirLurzfbwgfmV+hwq9ubHTqfKekmy
         FO3yO0N1NuBdXfuVg9UK1PkYnc/IB4D9PK7YO0bnxaDU/kXih0zLF/CaSX5cWt+4WwGl
         jF+DR/qFDplWdvuJPworUDDXqtWbDzgNJfOBtWoK3iRo2O71AIVWVAXihc6kFlk3c3tz
         V6dg==
X-Gm-Message-State: AOAM532pV/UILGt5eBJoYnNLHsyML+WFH1zDqt65lcafT0FqMFStNNHP
        TWMeoEy+2QKky8d/m7tbzyU=
X-Google-Smtp-Source: ABdhPJwkl/VpP9H9CGjqpJnO1QJGJyx9Xap8AwmiTR6DTQFg/rkuHzwEEdwOXyKb3JxbJsEWdQgRVA==
X-Received: by 2002:a7b:cb49:: with SMTP id v9mr675793wmj.76.1632165843627;
        Mon, 20 Sep 2021 12:24:03 -0700 (PDT)
Received: from [10.8.0.102] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id w1sm425445wmc.19.2021.09.20.12.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 12:24:03 -0700 (PDT)
Subject: Re: [patch v2] send.2: Add MSG_FASTOPEN flag
To:     Wei Wang <weiwan@google.com>, linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20210917041606.167192-1-weiwan@google.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <082801bf-a641-1483-600a-cc46eb580afe@gmail.com>
Date:   Mon, 20 Sep 2021 21:24:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917041606.167192-1-weiwan@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei,

On 9/17/21 6:16 AM, Wei Wang wrote:
> MSG_FASTOPEN flag is available since Linux 3.7. Add detailed description
> in the manpage according to RFC7413.
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> Reviewed-by: Yuchung Cheng <ycheng@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Patch applied!

Thanks (and to the reviewers too!),

Alex

> ---
> Change in v2: corrected some format issues
> 
>   man2/send.2 | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
> 
> diff --git a/man2/send.2 b/man2/send.2
> index fd28fed90..acaa05be9 100644
> --- a/man2/send.2
> +++ b/man2/send.2
> @@ -252,6 +252,38 @@ data on sockets that support this notion (e.g., of type
>   the underlying protocol must also support
>   .I out-of-band
>   data.
> +.TP
> +.BR MSG_FASTOPEN " (since Linux 3.7)"
> +Attempts TCP Fast Open (RFC7413) and sends data in the SYN like a
> +combination of
> +.BR connect (2)
> +and
> +.BR write (2),
> +by performing an implicit
> +.BR connect (2)
> +operation.
> +It blocks until the data is buffered and the handshake has completed.
> +For a non-blocking socket,
> +it returns the number of bytes buffered and sent in the SYN packet.
> +If the cookie is not available locally,
> +it returns
> +.BR EINPROGRESS ,
> +and sends a SYN with a Fast Open cookie request automatically.
> +The caller needs to write the data again when the socket is connected.
> +On errors,
> +it sets the same
> +.I errno
> +as
> +.BR connect (2)
> +if the handshake fails.
> +This flag requires enabling TCP Fast Open client support on sysctl
> +.IR net.ipv4.tcp_fastopen .
> +.IP
> +Refer to
> +.B TCP_FASTOPEN_CONNECT
> +socket option in
> +.BR tcp (7)
> +for an alternative approach.
>   .SS sendmsg()
>   The definition of the
>   .I msghdr
> 


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
