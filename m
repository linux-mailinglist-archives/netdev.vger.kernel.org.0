Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3421D795F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 15:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgERNLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 09:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgERNLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 09:11:00 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE22C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 06:10:58 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 17so9758530ilj.3
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 06:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lFdla0+S9U4I/fivQd5o+5JJj0VYqIoHyjG5P7hDOw0=;
        b=vkR+8enPo881uD4Ykz0uUNQi3KFMXlUSZucX30V8/0Jwp+nnpklTgJFlG+aW9edwpU
         KJM13wyZ57n0KXyOO84QTAb1dZujer6dIaT8g1zR3MLc206YuBlATXa2uLTrW+KqPiFP
         SDllr9fvCFD4IVRbVK5xBHc3dWIDefx8h1L/A2wgKiKbWGXY4Zvvmxtky8eSf4p2epEz
         +O3CqILXjBbOSsQk5ipUM5QISnDDCKdy4tTYFEWThv1UsIHm4h7qJjQyj4AAn2yXgrys
         D8Co2FW84nmPEvZ6oYR8uoDHKn+4e5H4aAocfwLdxv5zU0k7CGKP5Eb1WCBtNiIme/Dl
         ntzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lFdla0+S9U4I/fivQd5o+5JJj0VYqIoHyjG5P7hDOw0=;
        b=C0uHKQvcjFdjPDqT+YXsZySxE9vT7x7EPpYKBzFIzwoQuM+gN3FVr9NaA2FYHxRhf+
         PaBDlGLfPlOneZuGi1r46fGkehjyp8JES4JWKPIawQJRpL/3vC9tZesfvucVtIL2YotL
         t/AOmtkgiaSh+wuC7NrwIuLhIT9Ta/nw0oQAssCvYV2C4reFtD78tUHdKHiSCEpKdC4M
         eFX9tiL82SUaPrdoUlHja1R1+RHPi/+FMOmRjfsXjQBOh9oBqX1JJYubfJYOSjBu/TlE
         sbBXe1PQGS0IOAIto3YfmQ9yOM30/9ZFZCe5R2uXKhrlNS4fE56dH3G7ZHZEiaBsqJxB
         S+6Q==
X-Gm-Message-State: AOAM533BRFw8ZKS3V37s0Zq9myrFrPWGO8MZzXLI54Bdd2OtQTLHPG/D
        PJ6DT5/bjZV1qpZuyhOe/XMyyUgt4fSADg==
X-Google-Smtp-Source: ABdhPJwhJsrg93MyALF+Py6l9o9ptFlDy8Eqp0bBiNYSFftxg2rUVQPZhOz3a+cBC3kZbA1mgeVU5A==
X-Received: by 2002:a05:6e02:8ee:: with SMTP id n14mr1196521ilt.189.1589807458178;
        Mon, 18 May 2020 06:10:58 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id c11sm4797383ilg.20.2020.05.18.06.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 06:10:57 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
To:     Roman Mashak <mrv@mojatatu.com>, dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <1a7ed71e-a169-a583-8e8b-f700d3413a08@mojatatu.com>
Date:   Mon, 18 May 2020 09:10:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-17 9:28 a.m., Roman Mashak wrote:
> Have print_tm() dump firstuse value along with install, lastuse
> and expires.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> ---
>   tc/tc_util.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/tc/tc_util.c b/tc/tc_util.c
> index 12f865cc71bf..f6aa2ed552a9 100644
> --- a/tc/tc_util.c
> +++ b/tc/tc_util.c
> @@ -760,6 +760,11 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>   		print_uint(PRINT_FP, NULL, " used %u sec",
>   			   (unsigned int)(tm->lastuse/hz));
>   	}
> +	if (tm->firstuse != 0) {
> +		print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
> +		print_uint(PRINT_FP, NULL, " firstused %u sec",
> +			   (unsigned int)(tm->firstuse/hz));
> +	}

Maybe an else as well to print something like "firstused NEVER"
or alternatively just print 0 (to be backward compatible on old
kernels it will never be zero).

cheers,
jamal
