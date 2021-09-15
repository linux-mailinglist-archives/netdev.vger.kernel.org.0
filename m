Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3334340CDC5
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhIOUPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 16:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbhIOUPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 16:15:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D08FC061574;
        Wed, 15 Sep 2021 13:13:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i23so5791280wrb.2;
        Wed, 15 Sep 2021 13:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=53J8j8nEl3qE/yQYL0tzp4aajAMaMXHvF0XEENqUg7c=;
        b=aluCyDBqVfKgVeHCLrpE/3qMA8CnVkhIkPH8Nj53N6/f6fYKtxj0/bBZ0YOXNm9OZ1
         NJWzekn2L+65SZ5PPDAH7mEwzatFjlQ45i2y9S+E95GLrcu7gjaf/ggwXFYNp9ABEniv
         F2aUiSAA9fU4Z4en/Xj46ZSUyRjNH4kOI9iGA7MDRlcq5SAeA14miG1M40XOq4Jgz7fo
         pHDXoeQkejULBNOEc9EpOb7bAPGc2+R5mShVWJNBZGE6K4oeUeV1kqQ9qovhrg5EVmNM
         38uZOtrMJraaDfQKnqwYs9TZsly3WxtTdZ2OlJwHBIOyeP9iLR5YBvyA5wuiDsh77e7N
         Oy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=53J8j8nEl3qE/yQYL0tzp4aajAMaMXHvF0XEENqUg7c=;
        b=Ngxn8yReDu9QA0n+zM3iJljCMZ/satlpEZAVcoikBaOP8y0rx6hrhr+uhhb9PobxC4
         G2m85wsgIbGMTTa1eEWwySt7upIBd1UjKDZmeu87BO7UP+WGDFCmHS0rD/5gDU51cw1Y
         X4vJQe+blBlBNPMgLNv60zLfhxLGq1QN6enJeM7gQtLc/V5cSKxQ5AG5O+TU5a/17hEn
         5Jmg2tAFJnYxYnmTkqhbmkc+nzZ03mZX61bC+501wcKOAEz36eJqKypfIwj5KJAHcO2o
         PKV9YvzH69CYNNKHR4Wcij36D+kkAQenCbfMBsjGO5UZ4IO+3hptlBW50c/m0guWZwmO
         +dtw==
X-Gm-Message-State: AOAM531Tzl5x0EMjwSR6hHlQt1ASVM82G3FTTJtjwXy5Rwe11xLI//pt
        VRnKDhQJkpxDvYH0ZBCzGBilDKzItfQ=
X-Google-Smtp-Source: ABdhPJwOtsDOJigK08UwIxF0TPj952ndiNEjS5LHxk7c34B8FfFmU9tdFSB0QwZlj4a8kGVeA3MHsA==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr1984960wru.285.1631736837709;
        Wed, 15 Sep 2021 13:13:57 -0700 (PDT)
Received: from [10.8.0.26] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id g9sm5523866wmg.21.2021.09.15.13.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 13:13:57 -0700 (PDT)
Subject: Re: [patch] send.2: Add MSG_FASTOPEN flag
To:     Wei Wang <weiwan@google.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>, linux-man@vger.kernel.org
References: <20210915173758.2608988-1-weiwan@google.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <4d9952e8-040b-1bde-51a4-9687d6adb320@gmail.com>
Date:   Wed, 15 Sep 2021 22:13:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210915173758.2608988-1-weiwan@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Wei!

On 9/15/21 7:37 PM, Wei Wang wrote:
> MSG_FASTOPEN flag is available since Linux 3.7. Add detailed description
> in the manpage according to RFC7413.
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> Reviewed-by: Yuchung Cheng <ycheng@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> ---
>   man2/send.2 | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/man2/send.2 b/man2/send.2
> index fd28fed90..a40ae6214 100644
> --- a/man2/send.2
> +++ b/man2/send.2
> @@ -252,6 +252,33 @@ data on sockets that support this notion (e.g., of type
>   the underlying protocol must also support
>   .I out-of-band
>   data.
> +.TP
> +.BR MSG_FASTOPEN " (since Linux 3.7)"
> +Attempts TCP Fast Open (RFC7413) and sends data in the SYN like a
> +combination of
> +.BR connect (2)
> +and
> +.BR write (2)

You should merge the comma with the above, to avoid an unwanted space:

.BR write (2),

> +, by performing an implicit
> +.BR connect (2)
> +operation. It blocks until the data is buffered and the handshake

Please use semantic newlines.  See man-pages(7):

    Use semantic newlines
        In the source of a manual page,  new  sentences  should  be
        started  on  new  lines, and long sentences should be split
        into lines at clause breaks  (commas,  semicolons,  colons,
        and  so on).  This convention, sometimes known as "semantic
        newlines", makes it easier to see the  effect  of  patches,
        which often operate at the level of individual sentences or
        sentence clauses.


This is especially important after a period, since groff(1) will usually 
put 2 spaces after it, but if you hardcode it like above, it will only 
print 1 space.


> +has completed.
> +For a non-blocking socket, it returns the number of bytes buffered
> +and sent in the SYN packet. If the cookie is not available locally,
> +it returns
> +.B EINPROGRESS

.BR EINPROGRESS ,

> +, and sends a SYN with a Fast Open cookie request automatically.
> +The caller needs to write the data again when the socket is connected.
> +On errors, it returns the same errno as

errno should be highlighted:

.I errno

Also, errno is set, not returned (as far as user space is concerned); so 
something along the lines of "errno is set by connect(2)" or "it can 
fail for the same reasons that connect(2) can".  Michael probably knows 
if there's a typical wording for this in the current manual pages, to 
add some consistency.

BTW, should anything be added to the ERRORS section?

> +.BR connect (2) > +if the handshake fails. This flag requires enabling TCP Fast Open
> +client support on sysctl net.ipv4.tcp_fastopen.

net.ipv4.tcp_fastopen should be highlighted:

.IR net.ipv4.tcp_fastopen .

> +

Also from man-pages(7):

    Formatting conventions (general)
        Paragraphs should be separated by suitable markers (usually
        either .PP or .IP).  Do not separate paragraphs using blank
        lines, as this results in poor  rendering  in  some  output
        formats (such as PostScript and PDF).


Thanks!

Alex



-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
