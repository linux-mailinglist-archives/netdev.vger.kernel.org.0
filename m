Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5124BBD61
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 17:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbiBRQVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 11:21:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238425AbiBRQVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 11:21:12 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB2B2B5238
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 08:20:50 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id d10so16158211eje.10
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 08:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=poc9DUiPbdIfDlqClJVZ7+KtOVsWHbqOeRzWYbKxlLk=;
        b=Ugm49Ow0O5W5nYIIAtidY+bP95bNW8BGPz1ImYbRQkNrjBv03BowFSvrDHmCuFXLKj
         6uFueWRVJarL3DfMdU+Zb3/mDmBAah/Z73T0YsACqKxIKreu4iPfKQfjvm9VCs1OBkl5
         irCjirwJPfq3/FYUjDRXro7uar/4V86smBqA+yMIKUYUdkOQ49MccFGpDTsAvRVSsEEe
         s5oitWpORuCRNUYeTQh7X8ndVi8IyiZjym5oKRvOFFVjUZh8BniBlcm13NrhKPabqTWJ
         oHw+GPZGWZBhI9iozmq6cId9/UHmE36Uz3dvDleheqLIsJXHaBgMYKno1zZqKcFlSwWK
         wCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=poc9DUiPbdIfDlqClJVZ7+KtOVsWHbqOeRzWYbKxlLk=;
        b=BiEjh++2u/RUkq771ryKpTGGGAv78/WN1qdt8pyE3tGI9TI2X21PFDyUXxmiZ/bXLG
         70Om67hQUOgoTbb8kkjm/RRTSUQNESeXTyvVN5iYTOGlCsupJDmwSxdhS9gUgYMYP9Ng
         I6EsFQGq6v1E/nQb5nVlLkh8BWmq8LiDn9IumLK8k3WemQsUjYnddtbmI29D2DrrmXEK
         zUFl0Wmh7hBdzc/hF5LvCSPe6EuFKKsWyUxPWpjzGft9VMEFVS2xVoTdG5z6Zp9Vy4rM
         b6ILmuokWiYQgmS+khyGGPd+sUyrPe1VVNDnC5Ab2FPnErDYhXnQDA+B9S+6i90FQO33
         oCNg==
X-Gm-Message-State: AOAM532Ufj8yI2BHMzZn0jc7kCR+BrO/ZQjkvu+CascjQ2yvLjaG3Vqu
        3Cs0JnfOgZBk/6qWhRuv9C5J9g==
X-Google-Smtp-Source: ABdhPJy8PEtvWN7Fnc/dZLi103kGO4Kl8FGoiU5X/LnC1jpeAnTReDgOlI4ZeowHVxcUEYalPuE0Ww==
X-Received: by 2002:a17:906:cc8d:b0:6c9:6df1:7c55 with SMTP id oq13-20020a170906cc8d00b006c96df17c55mr6979896ejb.317.1645201248540;
        Fri, 18 Feb 2022 08:20:48 -0800 (PST)
Received: from [192.168.1.8] ([149.86.66.54])
        by smtp.gmail.com with ESMTPSA id j1sm2362126ejx.123.2022.02.18.08.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 08:20:47 -0800 (PST)
Message-ID: <3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@isovalent.com>
Date:   Fri, 18 Feb 2022 16:20:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH bpf-next v7 4/7] bpftool: Implement "gen min_core_btf"
 logic
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220215225856.671072-1-mauricio@kinvolk.io>
 <20220215225856.671072-5-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220215225856.671072-5-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-02-15 17:58 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> This commit implements the logic for the gen min_core_btf command.
> Specifically, it implements the following functions:
> 
> - minimize_btf(): receives the path of a source and destination BTF
> files and a list of BPF objects. This function records the relocations
> for all objects and then generates the BTF file by calling
> btfgen_get_btf() (implemented in the following commit).
> 
> - btfgen_record_obj(): loads the BTF and BTF.ext sections of the BPF
> objects and loops through all CO-RE relocations. It uses
> bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> btfgen_record_reloc(), that calls one of the following functions
> depending on the relocation kind.
> 
> - btfgen_record_field_relo(): uses the target specification to mark all
> the types that are involved in a field-based CO-RE relocation. In this
> case types resolved and marked recursively using btfgen_mark_type().
> Only the struct and union members (and their types) involved in the
> relocation are marked to optimize the size of the generated BTF file.
> 
> - btfgen_record_type_relo(): marks the types involved in a type-based
> CO-RE relocation. In this case no members for the struct and union types
> are marked as libbpf doesn't use them while performing this kind of
> relocation. Pointed types are marked as they are used by libbpf in this
> case.
> 
> - btfgen_record_enumval_relo(): marks the whole enum type for enum-based
> relocations.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/Makefile |   8 +-
>  tools/bpf/bpftool/gen.c    | 455 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 457 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 94b2c2f4ad43..a137db96bd56 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -34,10 +34,10 @@ LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)/include
>  LIBBPF_BOOTSTRAP_HDRS_DIR := $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
>  LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>  
> -# We need to copy hashmap.h and nlattr.h which is not otherwise exported by
> -# libbpf, but still required by bpftool.
> -LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
> -LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
> +# We need to copy hashmap.h, nlattr.h, relo_core.h and libbpf_internal.h
> +# which are not otherwise exported by libbpf, but still required by bpftool.
> +LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h relo_core.h libbpf_internal.h)
> +LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h relo_core.h libbpf_internal.h)
>  
>  $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
>  	$(QUIET_MKDIR)mkdir -p $@
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 8e066c747691..806001020841 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -14,6 +14,7 @@
>  #include <unistd.h>
>  #include <bpf/bpf.h>
>  #include <bpf/libbpf.h>
> +#include <bpf/libbpf_internal.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <sys/mman.h>

Mauricio, did you try this patch on a system with an old Glibc (< 2.26)
by any chance? Haven't tried yet but I expect this might break bpftool's
build when COMPAT_NEED_REALLOCARRAY is set, because in that case gen.c
pulls <bpf/libbpf_internal.h>, and then <tools/libc_compat.h> (through
main.h). And libc_compat.h defines reallocarray(), which
libbpf_internal.h poisons with a GCC pragma.

At least this is what I observe when trying to add your patches to the
kernel mirror, where reallocarray() is redefined unconditionally. I'm
trying to figure out if we should fix this mirror-side, or kernel-side.
(I suppose we still need this compatibility layer, Ubuntu 16.04 seems to
use Glibc 2.23).

Quentin
