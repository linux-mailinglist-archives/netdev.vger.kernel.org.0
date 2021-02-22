Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D03A321C59
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhBVQFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhBVQEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 11:04:52 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043E6C061574
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 08:02:51 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a132so14075925wmc.0
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 08:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nVMMtKx0VlqciV128RnhkENUid0lRp3pL502vGjjHM4=;
        b=FwQg/roPWZG3W+IUaS9nl5flX3XuAXTDA9SX9fI3i5w1qGZaUCrCeSDIdGmRA6Uarq
         bmsOgx55Ql4PKBoFd1cxZPv3X4VtGYMzcgjhii15MnlwoO+NtGryrSl4uhJvUsC/Zi7t
         yyfHbRVF5tVjNqGnu9EeT4PgILsgpEisQKVXu5F4oz96PdcxbDTg8hkuV8l4SC6LeHS4
         t+X24p3Bjg9S34roWpZBQmhYqC/AJfTFQ6aT5VZ5R5yvQ2stpryRgew7DdE/fH/l/PdN
         KZVv/77YsSaNMDUTeeLB+CTPPzYvEDjnrtcDYq2xtzix/Upx8VBoIjo5wXZVkwK7XEx7
         oC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nVMMtKx0VlqciV128RnhkENUid0lRp3pL502vGjjHM4=;
        b=HTomX4nTmVhXCgHlotEI9DdLxQsWT9I4kI8zmhRqQ1tnuy+KpSof4tEnUqU9/QuZYe
         tmAvwxdtZvWhvoCVoQ5x8DuFXYwrOl2l4Wf+neQS3Ftww29lAh1UNkrlpJ0OZWkoR6o8
         zS3SiZRsXqUpdqxVa1Tt131hZA8+cJP8H9PCkHA8xC1PAHHFrxQ5jFh6DCG3qHzrbqLy
         E1vni4x724Dx9zC6pxbRjc9b46S6i0UbY7znwhf8309en4DWIWUF7Q8FUAP2smTBfO9v
         aNPlnU1sKvjZp3YEPkkCjH6mh0US1ngsWK31NOsjl21y7RJLrHPk7T7BBjziEMpox1xX
         gNsA==
X-Gm-Message-State: AOAM531GS9e/e/qO+9fMs16gVYDd5o9mqJOm/z40ZZmJ9VRWDN4v+NUM
        tdcPmupz38O3xZWAsAz6R7YY4g==
X-Google-Smtp-Source: ABdhPJz0//kM8SUkGqqFIx1gj1jx2kzD0OKCsbRdL+DiDYSdLU8zDGxfAae3o/ZjBPJnecb6kClNyg==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr14178385wmc.51.1614009769805;
        Mon, 22 Feb 2021 08:02:49 -0800 (PST)
Received: from [192.168.1.9] ([194.35.118.245])
        by smtp.gmail.com with ESMTPSA id r20sm5327570wmd.18.2021.02.22.08.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 08:02:49 -0800 (PST)
Subject: Re: [PATCH v3 bpf-next] Add CONFIG_DEBUG_INFO_BTF check to bpftool
 feature command
To:     grantseltzer <grantseltzer@gmail.com>, andrii@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     irogers@google.com, yhs@fb.com, tklauser@distanz.ch,
        netdev@vger.kernel.org, mrostecki@opensuse.org, ast@kernel.org,
        bpf@vger.kernel.org
References: <20210220171307.128382-1-grantseltzer@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <fb6b0a82-5a60-0574-6557-93aaa03fdbf1@isovalent.com>
Date:   Mon, 22 Feb 2021 16:02:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210220171307.128382-1-grantseltzer@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-02-20 17:13 UTC+0000 ~ grantseltzer <grantseltzer@gmail.com>
> This adds the CONFIG_DEBUG_INFO_BTF kernel compile option to output of
> the bpftool feature command. This is relevant for developers that want
> to use libbpf to account for data structure definition differences
> between kernels.
> 
> Signed-off-by: grantseltzer <grantseltzer@gmail.com>
> ---
>  tools/bpf/bpftool/feature.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 359960a8f..b90cc6832 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -336,6 +336,8 @@ static void probe_kernel_image_config(const char *define_prefix)
>  		{ "CONFIG_BPF_JIT", },
>  		/* Avoid compiling eBPF interpreter (use JIT only) */
>  		{ "CONFIG_BPF_JIT_ALWAYS_ON", },
> +		/* Kernel BTF debug information available */
> +		{ "CONFIG_DEBUG_INFO_BTF", },
>  
>  		/* cgroups */
>  		{ "CONFIG_CGROUPS", },
> 


Thanks for the change!

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

(Note: the date of the email is not correct, but I discussed offline
with Grant and this is now sorted out for future submissions.)

Quentin
