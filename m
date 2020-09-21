Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B13272AA0
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgIUPrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgIUPq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:46:59 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F46C061755;
        Mon, 21 Sep 2020 08:46:59 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k14so9378101pgi.9;
        Mon, 21 Sep 2020 08:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tyLaKX+ZXQNEwh3E1qkcof0zX8W+yFwuvBEefQ2pobs=;
        b=rCbk0SUoE40KswqYKh/h8aw8Rsfpii9J5mlMwDK0nzfoQY05srulSG8m8XiiRbqH7p
         KbWkrneUj6h4+1+tZH7qgPPMrC1kjgjdCVtAjaxAzEQwGQwPKq01iO3I5kORIcNlY1L7
         NZ3basEb/UNLfamfbCKlmRXo/UG6UFyxqC21udau1hqgr07oq7ae3+FbsnnJQcEF88pA
         9clelnR9Xdne87rJVntF2t+JdxnEupVDx6YEyrapEZxFYd1gGCYsApT3NSxjc5n3B9Ng
         oNyLAlWZqlWLyfeouAPUdW9xEGENNzIQXv/w2b0NeG3Bu0FUUJ1JFGCLhynds1ne89mh
         1Czg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tyLaKX+ZXQNEwh3E1qkcof0zX8W+yFwuvBEefQ2pobs=;
        b=FrYdTOmvC7OUVlXYzuT3+ZowBR665gCE/gv5G5ANzBSL7h4SHup8ZZecL1SOPQgFd/
         3dy/m34+1gAhbV9HsX2BALNPy7KFWe3tKQPhFP3RhJWAxO00U5RLFrbWr1tmnsVWwK1G
         3SRMxLrQBy+wUvtsQN8dzsEj2H1O83zcXnINCeMWEXuANsUfFBheD0Pr770OlX9wzu3B
         EluYOk97W9HdGrNtJeeg1Am+6Urnyr23vCkek0YavDsjk24y18rQXSDhZ3ELaKRXaecw
         xcififLtM3641gAZ/nyCRqo/HKKTmqoFeXfBpZsePs2fisGhGfw2iEDiu47Z+ppiAIc+
         +i1Q==
X-Gm-Message-State: AOAM533fI8935tbAZNlpJvQb1n30QfFC5tJl1wzEVCq9PqiG38F5aIeA
        AW8Wl46sT3y90q7zJ04UDxY=
X-Google-Smtp-Source: ABdhPJwj5WU7Pk/JkwuKLXjJ1BpLVfjEoIP5E1oHD8MADd71iP/c8getpSd2tMNn5cnJugD4v1leSw==
X-Received: by 2002:aa7:939b:0:b029:142:2501:39de with SMTP id t27-20020aa7939b0000b0290142250139demr400328pfe.45.1600703219311;
        Mon, 21 Sep 2020 08:46:59 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q5sm12387622pfn.109.2020.09.21.08.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 08:46:58 -0700 (PDT)
Date:   Mon, 21 Sep 2020 08:46:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <5f68caed36dab_17370208e9@john-XPS-13-9370.notmuch>
In-Reply-To: <90f81508ecc57bc0da318e0fe0f45cfe49b17ea7.1600417359.git.Tony.Ambardar@gmail.com>
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
 <90f81508ecc57bc0da318e0fe0f45cfe49b17ea7.1600417359.git.Tony.Ambardar@gmail.com>
Subject: RE: [PATCH bpf v1 3/3] libbpf: fix native endian assumption when
 parsing BTF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Ambardar wrote:
> Code in btf__parse_raw() fails to detect raw BTF of non-native endianness
> and assumes it must be ELF data, which then fails to parse as ELF and
> yields a misleading error message:
> 
>   root:/# bpftool btf dump file /sys/kernel/btf/vmlinux
>   libbpf: failed to get EHDR from /sys/kernel/btf/vmlinux
> 
> For example, this could occur after cross-compiling a BTF-enabled kernel
> for a target with non-native endianness, which is currently unsupported.
> 
> Check for correct endianness and emit a clearer error message:
> 
>   root:/# bpftool btf dump file /sys/kernel/btf/vmlinux
>   libbpf: non-native BTF endianness is not supported
> 
> Fixes: 94a1fedd63ed ("libbpf: Add btf__parse_raw() and generic btf__parse() APIs")
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
>  tools/lib/bpf/btf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 7dfca7016aaa..6bdbc389b493 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -659,6 +659,12 @@ struct btf *btf__parse_raw(const char *path)
>  		err = -EIO;
>  		goto err_out;
>  	}
> +	if (magic == __bswap_16(BTF_MAGIC)) {
> +		/* non-native endian raw BTF */
> +		pr_warn("non-native BTF endianness is not supported\n");
> +		err = -LIBBPF_ERRNO__ENDIAN;
> +		goto err_out;
> +	}
>  	if (magic != BTF_MAGIC) {
>  		/* definitely not a raw BTF */
>  		err = -EPROTO;
> -- 
> 2.25.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
