Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C8A4B9015
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbiBPSVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:21:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiBPSVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:21:06 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ADF1C559E;
        Wed, 16 Feb 2022 10:20:53 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q8so743693iod.2;
        Wed, 16 Feb 2022 10:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f2+Fjef2q4Wfo8ap15BqY5rdNJGOYzfWS8EAJDPPle8=;
        b=ghoDWAMOGwohx5pzVeo4jnabBJwVciwQETOHk7shDh4DaMjeKKNieGBKr59pICJTA9
         Mvm2ffov3Cl3dBOu2NiMkHpqSy1J940+1KW3D/WuqdIbKC2SGeQQW7sgev3E2tpSnw2B
         H7tGtsRDK7sy9IhhIEGK7o7BxTWnFHuoXIvrjDZL0gYj9ZecK+PwpM3cLC5xV6Z4VrzM
         OgdSYScBJzroX0EhpCxnegSDySp5RqDNYOVsDVTsc4/cuy1zLdzOTlTsheNNBGoJX/kJ
         LQM/IAw9J83ZIIKfioQaSK/Nx+WDCbrio1WGRk1dAYasyrmSm27U04L6xwMkQNASowTW
         1Gtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f2+Fjef2q4Wfo8ap15BqY5rdNJGOYzfWS8EAJDPPle8=;
        b=QyH+3AzKiQsdcyh0Cdj/l+qte7wX+gxYPYNr02cwDEmSGc7Es6AfTYGkUxIlHI0yyE
         hf8BfGcdYTtwvot7LY8BmY33Lzxe/yqKI3BCDVtF0AtEfjeD8NPviz4zW4mPUj9L4tJu
         vLFK+0So4sP/qeBaEvAIJZ65yAzGXlNiMIHiUfSPJs2QnFFGi5/9txBujXLrOxp8xdl5
         yhx6F8YE3Aop0NJ1kozgMRN1myZnMxJdEHUJvUNEX78gUTainG3S5KLUJmRt5bmJXUuk
         E5OVWYTpf4vjtUMiHOzWUeK7lAU3go0JKbsBvqAYcuzsZIvZbJ0IOIT8rPFC1lW7Iwck
         DcHg==
X-Gm-Message-State: AOAM531AIpknm1/L17l7T+bJPMuMsOXZWmEuxlSQtHuHCXA9k5FzaSVR
        xuNgGUkbkiK0ay25FZk8QkwD6QGmq1icsLxfGSE=
X-Google-Smtp-Source: ABdhPJzctWODNjjoy7xvGDKtb+T7xmv+eOHKam7Haa+IKf1bNOxUEPQVzvD90GgoRx85+cjEF0dxwPjhyC1MnnilRGU=
X-Received: by 2002:a5d:859a:0:b0:632:7412:eb49 with SMTP id
 f26-20020a5d859a000000b006327412eb49mr2662069ioj.63.1645035653231; Wed, 16
 Feb 2022 10:20:53 -0800 (PST)
MIME-Version: 1.0
References: <20220215225856.671072-1-mauricio@kinvolk.io> <20220215225856.671072-7-mauricio@kinvolk.io>
In-Reply-To: <20220215225856.671072-7-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Feb 2022 10:20:41 -0800
Message-ID: <CAEf4BzYdeVj8CeDpZJ1jtE8Dk9DcLXwGo8T4v43UkE8wyW1ifA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 6/7] bpftool: gen min_core_btf explanation and examples
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 2:59 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> From: Rafael David Tinoco <rafaeldtinoco@gmail.com>
>
> Add "min_core_btf" feature explanation and one example of how to use it
> to bpftool-gen man page.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  .../bpf/bpftool/Documentation/bpftool-gen.rst | 91 +++++++++++++++++++
>  1 file changed, 91 insertions(+)
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/=
bpftool/Documentation/bpftool-gen.rst
> index bc276388f432..4bf8e6447718 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> @@ -25,6 +25,7 @@ GEN COMMANDS
>
>  |      **bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FIL=
E*...]
>  |      **bpftool** **gen skeleton** *FILE* [**name** *OBJECT_NAME*]
> +|      **bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECT* [*OBJE=
CT*...]
>  |      **bpftool** **gen help**
>
>  DESCRIPTION
> @@ -149,6 +150,26 @@ DESCRIPTION
>                   (non-read-only) data from userspace, with same simplici=
ty
>                   as for BPF side.
>
> +       **bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECT* [*OBJE=
CT*...]
> +                 Generate a minimum BTF file as *OUTPUT*, derived from a=
 given
> +                 *INPUT* BTF file, containing all needed BTF types so on=
e, or
> +                 more, given eBPF objects CO-RE relocations may be satis=
fied.
> +
> +                 When kernels aren't compiled with CONFIG_DEBUG_INFO_BTF=
,
> +                 libbpf, when loading an eBPF object, has to rely in ext=
ernal

typo: in -> on

> +                 BTF files to be able to calculate CO-RE relocations.
> +
> +                 Usually, an external BTF file is built from existing ke=
rnel
> +                 DWARF data using pahole. It contains all the types used=
 by
> +                 its respective kernel image and, because of that, is bi=
g.
> +
> +                 The min_core_btf feature builds smaller BTF files, cust=
omized
> +                 to one or multiple eBPF objects, so they can be distrib=
uted
> +                 together with an eBPF CO-RE based application, turning =
the
> +                 application portable to different kernel versions.
> +
> +                 Check examples bellow for more information how to use i=
t.
> +
>         **bpftool gen help**
>                   Print short help message.
>
> @@ -215,7 +236,9 @@ This is example BPF application with two BPF programs=
 and a mix of BPF maps
>  and global variables. Source code is split across two source code files.
>
>  **$ clang -target bpf -g example1.bpf.c -o example1.bpf.o**
> +
>  **$ clang -target bpf -g example2.bpf.c -o example2.bpf.o**
> +
>  **$ bpftool gen object example.bpf.o example1.bpf.o example2.bpf.o**
>
>  This set of commands compiles *example1.bpf.c* and *example2.bpf.c*
> @@ -329,3 +352,71 @@ BPF ELF object file *example.bpf.o*.
>    my_static_var: 7
>
>  This is a stripped-out version of skeleton generated for above example c=
ode.
> +
> +min_core_btf
> +------------
> +
> +**$ bpftool btf dump file ./5.4.0-example.btf format raw**

I dropped ./ everywhere, they are not needed and create bad impression
that they do matter

> +
> +::
> +
> +  [1] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 enco=
ding=3D(none)
> +  [2] CONST '(anon)' type_id=3D1
> +  [3] VOLATILE '(anon)' type_id=3D1
> +  [4] ARRAY '(anon)' type_id=3D1 index_type_id=3D21 nr_elems=3D2
> +  [5] PTR '(anon)' type_id=3D8
> +  [6] CONST '(anon)' type_id=3D5
> +  [7] INT 'char' size=3D1 bits_offset=3D0 nr_bits=3D8 encoding=3D(none)
> +  [8] CONST '(anon)' type_id=3D7
> +  [9] INT 'unsigned int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=
=3D(none)
> +  <long output>
> +
> +**$ bpftool btf dump file ./one.bpf.o format raw**
> +
> +::
> +
> +  [1] PTR '(anon)' type_id=3D2
> +  [2] STRUCT 'trace_event_raw_sys_enter' size=3D64 vlen=3D4
> +        'ent' type_id=3D3 bits_offset=3D0
> +        'id' type_id=3D7 bits_offset=3D64
> +        'args' type_id=3D9 bits_offset=3D128
> +        '__data' type_id=3D12 bits_offset=3D512
> +  [3] STRUCT 'trace_entry' size=3D8 vlen=3D4
> +        'type' type_id=3D4 bits_offset=3D0
> +        'flags' type_id=3D5 bits_offset=3D16
> +        'preempt_count' type_id=3D5 bits_offset=3D24
> +  <long output>
> +
> +**$ bpftool gen min_core_btf ./5.4.0-example.btf ./5.4.0-smaller.btf ./o=
ne.bpf.o**
> +
> +**$ bpftool btf dump file ./5.4.0-smaller.btf format raw**
> +
> +::
> +
> +  [1] TYPEDEF 'pid_t' type_id=3D6
> +  [2] STRUCT 'trace_event_raw_sys_enter' size=3D64 vlen=3D1
> +        'args' type_id=3D4 bits_offset=3D128
> +  [3] STRUCT 'task_struct' size=3D9216 vlen=3D2
> +        'pid' type_id=3D1 bits_offset=3D17920
> +        'real_parent' type_id=3D7 bits_offset=3D18048
> +  [4] ARRAY '(anon)' type_id=3D5 index_type_id=3D8 nr_elems=3D6
> +  [5] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 enco=
ding=3D(none)
> +  [6] TYPEDEF '__kernel_pid_t' type_id=3D8
> +  [7] PTR '(anon)' type_id=3D3
> +  [8] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED
> +  <end>
> +
> +Now, the "5.4.0-smaller.btf" file may be used by libbpf as an external B=
TF file
> +when loading the "one.bpf.o" object into the "5.4.0-example" kernel. Not=
e that
> +the generated BTF file won't allow other eBPF objects to be loaded, just=
 the
> +ones given to min_core_btf.
> +
> +::
> +
> +  struct bpf_object *obj =3D NULL;
> +
> +  DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, .btf_custom_path =3D "=
5.4.0-smaller.btf");

nit: still prefer LIBBPF_OPTS here, adjusted this piece of code a bit



> +
> +  obj =3D bpf_object__open_file("one.bpf.o", &opts);
> +
> +  ...
> --
> 2.25.1
>
