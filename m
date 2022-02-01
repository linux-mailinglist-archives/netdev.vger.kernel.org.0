Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFF44A66B3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiBAU5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242670AbiBAU5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:57:51 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E58BC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:57:51 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o30-20020a05600c511e00b0034f4c3186f4so2982579wms.3
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eR2Mb81Uzw7DmorSfGv9kkqmMO2Jny5dCS0Z4jWCMXw=;
        b=l4/wTGwEIRuMVAIR7nUukbL4NlbCNvDS6lEpH5okLsxOmbAxEsBH9p0r0fITRburza
         l0v2aki3r2Iw8PcWZnt4M6dXf9wa+mV4co1xd4V6SwpE37N5/zub7tIDLdEfSkZJfk66
         hm+iXadxZQPpQcyekMGaJzglm6M0mBd/cyCA8+BsCi7ORBD3N2LeTDHsZywc6WA4dYER
         uqqCkQVavGR8PPPC8Jf9k7xzhr0yfWf78eKWTOWwJJsew21WUv+gma1atVo+nDL+jipc
         CKl3d4pG+80ZOYDlIglbC7OyfIIwLOg4sDhdwnjVygbo+25QplpiFC7cga9PSX/OZ+wu
         KhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eR2Mb81Uzw7DmorSfGv9kkqmMO2Jny5dCS0Z4jWCMXw=;
        b=PQPZCsW3OC02X4wpZUduiPzQOt5EmGD75VP1lUJ2AAL6u0hZ3X/k+j6hu3zm+9PLSf
         DMgJRFUr06t0Rm9zxUJCCggAWwj/L9R/XfPVhDXybTgZYTeFsy1oHSN96RfDzRahN5OR
         alNbJGiMRVn3JwM4H7Cl8m8mVWq6kGI/W/sJDrtGpMjApoAQ6n59z2jGYlT1qc5sZG4G
         8na4loD4UKHVeP3rLsGld2zUWvNhMhTH0YGHzdzVwmo7NT1WbiWmUegzzoPrsxgMu3P9
         pdjWxBkZ+XGpkumZD7a7evyIXarA784NOQ8tgvLmaesh5GMuHgRLM1hMy/9dQpOdY5R4
         GQkw==
X-Gm-Message-State: AOAM533SmTeMKXoNlrzyunLo6htRP6cnEoOUaR+wm1PcLVFsbZVkT49+
        P5sNgKMuwmbA4MfQRFZAgoqlPg==
X-Google-Smtp-Source: ABdhPJwK5GSSeUqrlZmwi6J1zqn8wGFOLY/N+jqqBxz+/evagetwm3/+8QcD1Vtpj5cYXPBJUZUQAA==
X-Received: by 2002:a05:600c:20d3:: with SMTP id y19mr3360656wmm.1.1643749069847;
        Tue, 01 Feb 2022 12:57:49 -0800 (PST)
Received: from [192.168.1.8] ([149.86.72.139])
        by smtp.gmail.com with ESMTPSA id o21sm2942469wmh.36.2022.02.01.12.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 12:57:49 -0800 (PST)
Message-ID: <2a0371dc-19c0-3e2b-8b31-b9d3c942ec4f@isovalent.com>
Date:   Tue, 1 Feb 2022 20:57:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v5 8/9] bpftool: gen min_core_btf explanation and
 examples
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
 <20220128223312.1253169-9-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220128223312.1253169-9-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-28 17:33 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> From: Rafael David Tinoco <rafaeldtinoco@gmail.com>
> 
> Add "min_core_btf" feature explanation and one example of how to use it
> to bpftool-gen man page.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>

Thanks for this, and for the bash completion!

> ---
>  .../bpf/bpftool/Documentation/bpftool-gen.rst | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> index bc276388f432..7aa3c29c2da0 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> @@ -25,6 +25,7 @@ GEN COMMANDS
>  
>  |	**bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
>  |	**bpftool** **gen skeleton** *FILE* [**name** *OBJECT_NAME*]
> +|	**bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECTS(S)*
>  |	**bpftool** **gen help**
>  
>  DESCRIPTION
> @@ -149,6 +150,24 @@ DESCRIPTION
>  		  (non-read-only) data from userspace, with same simplicity
>  		  as for BPF side.
>  
> +	**bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECT(S)*
> +		  Given one, or multiple, eBPF *OBJECT* files, generate a
> +		  smaller BTF file, in the *OUTPUT* directory, to each existing

“directory” -> “directory or file”?

> +		  BTF files in the *INPUT* directory, using the same name.

(same)

Regarding INPUT/OUTPUT I would try to remain generic in the first
paragraph, and explodes below into more cases, like you did in the
following paragraph.

“If *INPUT* is a file...”

“If *INPUT* is a directory...”

Also for OUTPUT (I don't think this doc mentions that OUTPUT can be a
simple file, by the way).

> +
> +		  If *INPUT* is a file, then the result BTF will be saved as a
> +		  single file, with the same name, in *OUTPUT* directory.
> +
> +		  Generated BTF files will only contain the BTF types used by
> +		  the given eBPF objects.

Suggestion: I'd split here and merge the last two paragraphs on the
motivations. I would also reword them a little (“Full external BTF files
are big”: How comes? Users may not know they have all kernel symbols.
“This [...] maximized eBPF portability (CO-RE)”: What does this mean?).
Try to keep in mind that the readers for the man page are people trying
to understand how bpftool work and who barely have any idea what BTF is.

> +               Idea behind this is simple: Full
> +		  external BTF files are big. This allows customized external
> +		  BTF files generation and maximizes eBPF portability (CO-RE).
> +
> +		  This feature allows a particular eBPF project to embed
> +		  customized BTF files in order to support older kernels,
> +		  allowing code to be portable among kernels that don't support
> +		  embedded BTF files but still support eBPF.
> +
>  	**bpftool gen help**
>  		  Print short help message.
>  
> @@ -215,7 +234,9 @@ This is example BPF application with two BPF programs and a mix of BPF maps
>  and global variables. Source code is split across two source code files.
>  
>  **$ clang -target bpf -g example1.bpf.c -o example1.bpf.o**
> +
>  **$ clang -target bpf -g example2.bpf.c -o example2.bpf.o**
> +
>  **$ bpftool gen object example.bpf.o example1.bpf.o example2.bpf.o**

Good catch, thank you

>  
>  This set of commands compiles *example1.bpf.c* and *example2.bpf.c*
> @@ -329,3 +350,67 @@ BPF ELF object file *example.bpf.o*.
>    my_static_var: 7
>  
>  This is a stripped-out version of skeleton generated for above example code.
> +
> +*MIN_CORE_BTF*
> +
> +::
> +

And thanks for the example!

Note that you place everything into one literal block; this does not
follow the syntax of the rest of the document. I understand you want to
group the different commands related to min_core_btf together. To do
that, I'd suggest adding a subsection in the document:

min_core_btf
------------

**$ bpftool btf dump file ./... format raw**

::

  [1] INT ...
  [2] ...

> +  $ bpftool btf dump file ./input/5.4.0-91-generic.btf format raw
> +
> +  [1] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
> +  [2] CONST '(anon)' type_id=1
> +  [3] VOLATILE '(anon)' type_id=1
> +  [4] ARRAY '(anon)' type_id=1 index_type_id=21 nr_elems=2
> +  [5] PTR '(anon)' type_id=8
> +  [6] CONST '(anon)' type_id=5
> +  [7] INT 'char' size=1 bits_offset=0 nr_bits=8 encoding=(none)
> +  [8] CONST '(anon)' type_id=7
> +  [9] INT 'unsigned int' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> +  <long output>
> +
> +  $ bpftool btf dump file ./one.bpf.o format raw
> +
> +  [1] PTR '(anon)' type_id=2
> +  [2] STRUCT 'trace_event_raw_sys_enter' size=64 vlen=4
> +        'ent' type_id=3 bits_offset=0
> +        'id' type_id=7 bits_offset=64
> +        'args' type_id=9 bits_offset=128
> +        '__data' type_id=12 bits_offset=512
> +  [3] STRUCT 'trace_entry' size=8 vlen=4
> +        'type' type_id=4 bits_offset=0
> +        'flags' type_id=5 bits_offset=16
> +        'preempt_count' type_id=5 bits_offset=24
> +  <long output>
> +
> +  $ bpftool gen min_core_btf ./input/ ./output ./one.bpf.o
> +
> +  $ bpftool btf dump file ./output/5.4.0-91-generic.btf format raw
> +
> +  [1] TYPEDEF 'pid_t' type_id=6
> +  [2] STRUCT 'trace_event_raw_sys_enter' size=64 vlen=1
> +        'args' type_id=4 bits_offset=128
> +  [3] STRUCT 'task_struct' size=9216 vlen=2
> +        'pid' type_id=1 bits_offset=17920
> +        'real_parent' type_id=7 bits_offset=18048
> +  [4] ARRAY '(anon)' type_id=5 index_type_id=8 nr_elems=6
> +  [5] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
> +  [6] TYPEDEF '__kernel_pid_t' type_id=8
> +  [7] PTR '(anon)' type_id=3
> +  [8] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> +  <end>
> +
> +  Now, one may use ./output/5.4.0-91-generic.btf generated file as an external
> +  BTF file fed to libbpf during eBPF object opening:
> +
> +  struct bpf_object *obj = NULL;
> +  struct bpf_object_open_opts openopts = {};
> +
> +  openopts.sz = sizeof(struct bpf_object_open_opts);
> +  openopts.btf_custom_path = strdup("./output/5.4.0-91-generic.btf");
> +
> +  obj = bpf_object__open_file("./one.bpf.o", &openopts);
> +
> +  ...
> +
> +  and allow libbpf to do all needed CO-RE relocations, to "one.bpf.o" object,
> +  based on the small external BTF file.

