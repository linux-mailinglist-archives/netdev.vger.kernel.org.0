Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F392F5C94
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbhANIli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbhANIlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:41:36 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54EAC061794;
        Thu, 14 Jan 2021 00:40:55 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id f11so5517226ljm.8;
        Thu, 14 Jan 2021 00:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZyuwqgUBskABVFLYIWGAD2FMF/t9yzwUC2QTWtpxG8=;
        b=M9TsRLMOYhUEtXeMsks6hjymvFGTAFTtcnSeAioUr1V+e+Ys/w+5+tmqSuQePbJWQN
         nLX1XzhyCkUuxejX9U0wCBV7ltnfewMSvNOsCBSHvm6lwsiYXfuc7fUQ78au0oc61Jty
         b86r7TpT/4J5m+IyZw8My3f2eTw/PnR5ILB4rSDdqb7zATPtcCA2ec6OeOPgCj+Lpz3F
         wDdCpERqEDPy95Q4ktU8XrtwdlPJONjEUnSUHYOPhQYFkg0d3DfV1RUb40UCRj/N8GLN
         SZG7CNzjeGOBkp4gfx2/FRDLg18C47oM0goFLQC4r41mH/yWXONx4CfJYELM97u6ch54
         mztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yZyuwqgUBskABVFLYIWGAD2FMF/t9yzwUC2QTWtpxG8=;
        b=ClvHaL9jKNmU54YObMuqaaVlECsovXYBqaVDD4UMk9zyqDp+qr4i0HPbZarb1uIZfR
         niEbibsq0LMckibcBL22lN7a2YyjeshuxBkvCT13gn2drCYZgAEtnuW9Zgdm0oF5+9a7
         yHtQT80UHIIr8R0R4fif7mtcvkO0CLi/425xcvn2WW7sfKuIPFdFE5/3LMauECIltgTC
         7ld6yoHWgUh68EhvKmkiFhDa30KHbdAxTxjg0IQWMgL11bNA0I6PETMOTNf89LekyMQK
         Qq01qIdiOito9wuIF1uKPBsDtwJwMDfVmoHPfUETcnSVF5yre6mTlUv1dtAd8x9e/ZH+
         tKzw==
X-Gm-Message-State: AOAM533x5ChcCI7G+NwNyX07XPlWKxfW3YTUR2iK+2L8WBqxr1jC1JAq
        8GS6jvrnabWS/4Rxyszv53gjt4vI53HYbQ==
X-Google-Smtp-Source: ABdhPJxonLgQGhSHZPoirG03V75YnKFqQQBe+h3FFzullyWpE6EXPydwpEsbUTDijMJvfHPA3qrGbA==
X-Received: by 2002:a2e:8745:: with SMTP id q5mr2546502ljj.77.1610613654215;
        Thu, 14 Jan 2021 00:40:54 -0800 (PST)
Received: from [192.168.1.100] ([178.176.79.115])
        by smtp.gmail.com with ESMTPSA id p5sm476176lfj.295.2021.01.14.00.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 00:40:53 -0800 (PST)
Subject: Re: [PATCH 2/2] compiler.h: Include asm/rwonce.h under ARM64 and
 ALPHA to fix build errors
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-sparse@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
References: <1610535453-2352-1-git-send-email-yangtiezhu@loongson.cn>
 <1610535453-2352-3-git-send-email-yangtiezhu@loongson.cn>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <04749e2c-6e80-5316-a575-e4aaf780bb81@gmail.com>
Date:   Thu, 14 Jan 2021 11:40:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1610535453-2352-3-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 13.01.2021 13:57, Tiezhu Yang wrote:

> When make M=samples/bpf on the Loongson 3A3000 platform which
> belongs to MIPS arch, there exists many similar build errors
> about 'asm/rwonce.h' file not found, so include it only under
> CONFIG_ARM64 and CONFIG_ALPHA due to it exists only in arm64
> and alpha arch.
> 
>    CLANG-bpf  samples/bpf/xdpsock_kern.o
> In file included from samples/bpf/xdpsock_kern.c:2:
> In file included from ./include/linux/bpf.h:9:
> In file included from ./include/linux/workqueue.h:9:
> In file included from ./include/linux/timer.h:5:
> In file included from ./include/linux/list.h:9:
> In file included from ./include/linux/kernel.h:10:
> ./include/linux/compiler.h:246:10: fatal error: 'asm/rwonce.h' file not found
>           ^~~~~~~~~~~~~~
> 1 error generated.
> 
> $ find . -name rwonce.h
> ./include/asm-generic/rwonce.h
> ./arch/arm64/include/asm/rwonce.h
> ./arch/alpha/include/asm/rwonce.h
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   include/linux/compiler.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index b8fe0c2..bdbe759 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -243,6 +243,12 @@ static inline void *offset_to_ptr(const int *off)
>    */
>   #define prevent_tail_call_optimization()	mb()
>   
> +#ifdef CONFIG_ARM64

    Why not #if defined(CONFIG_ALPHA) || defined(CONFIG_ARM64)?

>   #include <asm/rwonce.h>
> +#endif
> +
> +#ifdef CONFIG_ALPHA
> +#include <asm/rwonce.h>
> +#endif
>   
>   #endif /* __LINUX_COMPILER_H */
> 

MBR, Sergei
