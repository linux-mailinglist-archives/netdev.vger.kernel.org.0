Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608132CD476
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 12:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgLCLVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 06:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLCLVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 06:21:22 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69527C061A4D;
        Thu,  3 Dec 2020 03:20:42 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id k10so2386957wmi.3;
        Thu, 03 Dec 2020 03:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IQRSCmrh2+qWolPzIkIYzeNCzaja9ShgDL/B/7yO0+A=;
        b=tjLInjORPKJzx1EajyosM7pChzoZX80UaquVSzGbG6UKW2H1gsfCg11MljdS6Hvdhy
         eqMvUIgAcTqy5yKVhp1uSzRwQ8Ki4y8hdeYttN8Xcgm/psRUFCnSI2+A6S+YcBh/yX2p
         esbSJL6F71cbMCW2oXzZ7hdyDNBOFxvfQ6BdJhQMvgzsiBj2AHeNg3z8gZn5VQtmZubP
         l0MOCISUf+Ai6GZJPfIPzinuX3G/c6hU3MYQ17u4izBLVFmyHNUqmMufsksHgTWER1re
         pkdA9gSBkuqt9l5C91F+3mxcffRmEj0cLvXEJzliiBVVBSW1Um+CAPhpUTeauWTE3fLg
         VEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IQRSCmrh2+qWolPzIkIYzeNCzaja9ShgDL/B/7yO0+A=;
        b=i0CYrljEGVnFWhQ9+X6+05vLS0jaRBOVdUhFVkc6FDYInkAfx/FFaEnw6lW8MGs850
         Febbe2HE7Hiqy6V+v+cTyvwAJNQVgXHO6T95Rly/jPCFgFdJH80AQwuJqs/DuYOW/Eb+
         aPkMteuKQF6i5leRVvCh+X4/zmmZYKgE43+OVrLdE70NmYN2vY+QNDxyapdp9SppXi6l
         5YhMgx5S1jlL4VjIkRlx75JN2farVdg6+YRo576iD5w+ByQsJX/rpSmPhoA7OhMrg+i+
         rOkgeWqemlvuHO0urBB9KZ26lIbueeMnqlzwyGL9By+/6TtarDFK12la4H6thSj1vdjv
         26Qw==
X-Gm-Message-State: AOAM530iKBfI0Yo3gazswLmPK0exEyixJTTimCw16rY9X0vIVXIHDbw2
        8BZFErbbWF2L3RYIt9PsleY=
X-Google-Smtp-Source: ABdhPJwseREQ28NzlNb1w9gD4HrCqRAvzffOsqDvs6X0EKVN9i1jqE0NXz/DlMN0Sh8I+7es5onWyA==
X-Received: by 2002:a1c:3d55:: with SMTP id k82mr2729891wma.57.1606994440643;
        Thu, 03 Dec 2020 03:20:40 -0800 (PST)
Received: from [192.168.8.116] ([37.171.65.93])
        by smtp.gmail.com with ESMTPSA id q16sm1363131wrn.13.2020.12.03.03.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 03:20:40 -0800 (PST)
Subject: Re: [PATCH] bpf, x64: bump the number of passes to 64
To:     Gary Lin <glin@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
References: <20201203091252.27604-1-glin@suse.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8fbcb23d-d140-48fb-819d-61f49672d9bd@gmail.com>
Date:   Thu, 3 Dec 2020 12:20:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203091252.27604-1-glin@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/20 10:12 AM, Gary Lin wrote:
> The x64 bpf jit expects bpf images converge within the given passes, but
> it could fail to do so with some corner cases. For example:
> 
>       l0:     ldh [4]
>       l1:     jeq #0x537d, l2, l40
>       l2:     ld [0]
>       l3:     jeq #0xfa163e0d, l4, l40
>       l4:     ldh [12]
>       l5:     ldx #0xe
>       l6:     jeq #0x86dd, l41, l7
>       l8:     ld [x+16]
>       l9:     ja 41
> 
>         [... repeated ja 41 ]
> 
>       l40:    ja 41
>       l41:    ret #0
>       l42:    ld #len
>       l43:    ret a
> 
> This bpf program contains 32 "ja 41" instructions which are effectively
> NOPs and designed to be replaced with valid code dynamically. Ideally,
> bpf jit should optimize those "ja 41" instructions out when translating
> the bpf instructions into x86_64 machine code. However, do_jit() can
> only remove one "ja 41" for offset==0 on each pass, so it requires at
> least 32 runs to eliminate those JMPs and exceeds the current limit of
> passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> is set even though it's legit as a classic socket filter.
> 
> Since this kind of programs are usually handcrafted rather than
> generated by LLVM, those programs tend to be small. To avoid increasing
> the complexity of BPF JIT, this commit just bumps the number of passes
> to 64 as suggested by Daniel to make it less likely to fail on such cases.
> 

Another idea would be to stop trying to reduce size of generated
code after a given number of passes have been attempted.

Because even a limit of 64 wont ensure all 'valid' programs can be JITed.




> Signed-off-by: Gary Lin <glin@suse.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 796506dcfc42..43cc80387548 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2042,7 +2042,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  	 * may converge on the last pass. In such case do one more
>  	 * pass to emit the final image.
>  	 */
> -	for (pass = 0; pass < 20 || image; pass++) {
> +	for (pass = 0; pass < 64 || image; pass++) {
>  		proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
>  		if (proglen <= 0) {
>  out_image:
> 
