Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F854D04E2
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbiCGRHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiCGRHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:07:15 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F0C7C17C
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 09:06:20 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id p9so24365557wra.12
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 09:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sr6hFLYKJ6ZsTgfOYjeBp4uWIne5BXMN/b0HprWBPy4=;
        b=12DRR/xZnfcwRl5Fq9ydzhNfHtZYiYBxvFitpmWuxkWWA1envSdYXKq9vlEx7X248U
         tD6c7yGEmP3BmF0BUbY9aSb9Scxmhvhf74qEvzc31aCVBTThjhVprYY/UC1GIQ2RcfUb
         kohvvhIRfvRA5s/0+oOelEedeyJlZ+d+zH893bztNpYYuGtxQXiQyKnOBhbBto1Ahsbn
         AZeem6lJjFhMUcVRspEFGE8g4hvIDSksaNyIcxaRkCuOrWNop+6uRvctNpuqOYJnTtSp
         EkNdwreve0L3GWAV1sU+XyVO7oEflTcr5cad37TY4HN/MVbU/lu3qDcwM7T28lZ5VTA6
         3jCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sr6hFLYKJ6ZsTgfOYjeBp4uWIne5BXMN/b0HprWBPy4=;
        b=Id4jJp2N22FshNzHhu/nxwA777LpCMVO6kYGCIo0GPd3iO/QuFArzmnC58llqCv3+k
         z6vrd2m/x6MPT6dS0e4CsNIXaMqmGTtTgKh/8XJEfCqqFNJAvcUBdulfAzXO3WwhK3aV
         eGvsRIpb5WvOQw7R0Nx+Ei+Ln2c2Lqc1yvnfnmxySnbzDt+OyJtXu2Ym1qLykJ79+agS
         BZws68OqSOrs93hnPpoB2uI5j3FD1hPR5Hn19Dw1uFdCjNL49qic+dL8I9750a3/QtZH
         muODZKfTGpk5vC7rRrQkxsld+5hfX2lonRaeP4qHTOVcHglW6nkzcf2ieVLw/YC9B4q5
         uVCA==
X-Gm-Message-State: AOAM530XVuBFWdasgptHiKsI+yQN957iK3rOuSAm2q8b4Y5wodjRFyta
        M9+7FhVzQ6ORvBgLBmuPCvC8hA==
X-Google-Smtp-Source: ABdhPJws0CTTyXTbkfcrLlHvLeHfV9Sn474JetVyckBI6FLVcWdRLhFnjOg4U7REZmNBNRxJx8QNqw==
X-Received: by 2002:a05:6000:1a52:b0:1f0:2d62:2bbb with SMTP id t18-20020a0560001a5200b001f02d622bbbmr9022775wry.614.1646672778788;
        Mon, 07 Mar 2022 09:06:18 -0800 (PST)
Received: from [192.168.1.8] ([149.86.77.40])
        by smtp.gmail.com with ESMTPSA id n7-20020a05600c3b8700b00389a6241669sm3088772wms.33.2022.03.07.09.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 09:06:18 -0800 (PST)
Message-ID: <56b9dab5-6a3d-58ff-69c9-7abaabf41d05@isovalent.com>
Date:   Mon, 7 Mar 2022 17:06:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next] bpf: Remove redundant slash
Content-Language: en-GB
To:     Yuntao Wang <ytcoode@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220305161013.361646-1-ytcoode@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220305161013.361646-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-03-06 00:10 UTC+0800 ~ Yuntao Wang <ytcoode@gmail.com>
> The trailing slash of LIBBPF_SRCS is redundant, remove it.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  kernel/bpf/preload/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> index 167534e3b0b4..7b62b3e2bf6d 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
> -LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
> +LIBBPF_SRCS = $(srctree)/tools/lib/bpf
>  LIBBPF_INCLUDE = $(LIBBPF_SRCS)/..
>  
>  obj-$(CONFIG_BPF_PRELOAD_UMD) += bpf_preload.o

Looks good to me, but we could maybe just as well get rid of LIBBPF_SRCS
in this file?:

	LIBBPF_INCLUDE = $(srctree)/tools/lib

Quentin
