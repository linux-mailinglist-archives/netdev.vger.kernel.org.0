Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3E83DBE98
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 20:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhG3S7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 14:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG3S7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 14:59:53 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D61C061765;
        Fri, 30 Jul 2021 11:59:47 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id w17so17554899ybl.11;
        Fri, 30 Jul 2021 11:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZFbeNfI2nU7AsW9qEfUHsMABOtgY/7Lryi50VSLFBQk=;
        b=gybo7tEyqQcQ7+j69DYO1K52mO3ZbmLSvptgOMmNFc2hn73E+VkRJ9XlBWoDJyTGeY
         CsvSxHkVaHmQi4i0yfPocHd/seNC4aWUSPNjISk1Py0lxBoNaytjwTeo2OgFXydr2vIh
         wAp7Tn+qyV965G063rB46h0a1VDA4oddbrLSFGiB64MRaShGhOokUyVEwBEhBCH0zu9a
         lBLnAl00UypUl5ghqkiE9/3kecewpJokInmBleAdYIYgtiMGwv0pzh8VH4DqzzhXZVzI
         iMBTs6Vmk2Q6/iGGfkaoC69jumo04d2z+w6NbGgytgpe3s700Z8c6Eqxxpfz10OYYzl8
         vZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZFbeNfI2nU7AsW9qEfUHsMABOtgY/7Lryi50VSLFBQk=;
        b=sAJQgy0St9Mv0x4apab3QXGJkeWM43fmz6cS1btzK09KA7bKHW+xXoXFprfarptpA3
         ERpqg5+p8jtpSg98B/f2tFhpixvGG0yMNALV0U/Z6XpA6AjlO5PwX+nIeUmy0Z11UFln
         RYGGV5A8KgbUPNGlwyEwlpqwR1Q6MvcUDE/QBFGY9hBu5iPPlRJ2r+d6TKBHw572uiFT
         iaZX6qx3ZQHVTTPSwISkYdgBQyrZnrcqwGHYGIFs+MgkUgQMRC4ii8QPsVH7PN/vjAYd
         xeEjg8oLjXD77QquEffz+fqCdKCFALbPFgOy8Us3vkM4GsExm1b1KTfujMSbFHckoG4F
         uQkw==
X-Gm-Message-State: AOAM532bodPA3m74f75IzLZbOGD4PNZRuS2/lKJAQMpn7rWtH1w1op0Q
        Uj63f87M81LetB3ApnEGGKn0RKI4/Cihe8gdKpw=
X-Google-Smtp-Source: ABdhPJyUqPcCffoNBAOSVIjIdNI1o4U7sC5tJplKic0uWzpy+5mdzHWXS4HQkQtijgoFzwnlH9e6xRvIcNdqZWJFJvk=
X-Received: by 2002:a25:9942:: with SMTP id n2mr5220346ybo.230.1627671586877;
 Fri, 30 Jul 2021 11:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162932.30365-1-quentin@isovalent.com> <20210729162932.30365-7-quentin@isovalent.com>
In-Reply-To: <20210729162932.30365-7-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 11:59:35 -0700
Message-ID: <CAEf4Bzb+s0f6ybq+qARTpe1wa2dOD_gweBd0kQAYh3cyx=N5mQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/7] tools: bpftool: document and add bash
 completion for -L, -B options
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> The -L|--use-loader option for using loader programs when loading, or
> when generating a skeleton, did not have any documentation or bash
> completion. Same thing goes for -B|--base-btf, used to pass a path to a
> base BTF object for split BTF such as BTF for kernel modules.
>
> This patch documents and adds bash completion for those options.
>
> Fixes: 75fa1777694c ("tools/bpftool: Add bpftool support for split BTF")
> Fixes: d510296d331a ("bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.")
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
> Note: The second example with base BTF in the BTF man page assumes that
> dumping split BTF when objects are passed by id is supported. Support is
> currently pending review in another PR.
> ---

Not anymore :)

[...]

> @@ -73,6 +74,20 @@ OPTIONS
>  =======
>         .. include:: common_options.rst
>
> +       -B, --base-btf *FILE*
> +                 Pass a base BTF object. Base BTF objects are typically used
> +                 with BTF objects for kernel modules. To avoid duplicating
> +                 all kernel symbols required by modules, BTF objects for
> +                 modules are "split", they are built incrementally on top of
> +                 the kernel (vmlinux) BTF object. So the base BTF reference
> +                 should usually point to the kernel BTF.
> +
> +                 When the main BTF object to process (for example, the
> +                 module BTF to dump) is passed as a *FILE*, bpftool attempts
> +                 to autodetect the path for the base object, and passing
> +                 this option is optional. When the main BTF object is passed
> +                 through other handles, this option becomes necessary.
> +
>  EXAMPLES
>  ========
>  **# bpftool btf dump id 1226**
> @@ -217,3 +232,34 @@ All the standard ways to specify map or program are supported:
>  **# bpftool btf dump prog tag b88e0a09b1d9759d**
>
>  **# bpftool btf dump prog pinned /sys/fs/bpf/prog_name**
> +
> +|
> +| **# bpftool btf dump file /sys/kernel/btf/i2c_smbus**
> +| (or)
> +| **# I2C_SMBUS_ID=$(bpftool btf show -p | jq '.[] | select(.name=="i2c_smbus").id')**
> +| **# bpftool btf dump id ${I2C_SMBUS_ID} -B /sys/kernel/btf/vmlinux**
> +
> +::
> +
> +  [104848] STRUCT 'i2c_smbus_alert' size=40 vlen=2
> +          'alert' type_id=393 bits_offset=0
> +          'ara' type_id=56050 bits_offset=256
> +  [104849] STRUCT 'alert_data' size=12 vlen=3
> +          'addr' type_id=16 bits_offset=0
> +          'type' type_id=56053 bits_offset=32
> +          'data' type_id=7 bits_offset=64
> +  [104850] PTR '(anon)' type_id=104848
> +  [104851] PTR '(anon)' type_id=104849
> +  [104852] FUNC 'i2c_register_spd' type_id=84745 linkage=static
> +  [104853] FUNC 'smbalert_driver_init' type_id=1213 linkage=static
> +  [104854] FUNC_PROTO '(anon)' ret_type_id=18 vlen=1
> +          'ara' type_id=56050
> +  [104855] FUNC 'i2c_handle_smbus_alert' type_id=104854 linkage=static
> +  [104856] FUNC 'smbalert_remove' type_id=104854 linkage=static
> +  [104857] FUNC_PROTO '(anon)' ret_type_id=18 vlen=2
> +          'ara' type_id=56050
> +          'id' type_id=56056
> +  [104858] FUNC 'smbalert_probe' type_id=104857 linkage=static
> +  [104859] FUNC 'smbalert_work' type_id=9695 linkage=static
> +  [104860] FUNC 'smbus_alert' type_id=71367 linkage=static
> +  [104861] FUNC 'smbus_do_alert' type_id=84827 linkage=static

This reminded be that it would be awesome to support "format c"
use-case for dumping split BTF in a more sane way. I.e., instead of
dumping all types from base and split BTF, only dump necessary (used)
forward declarations from base BTF, and then full C dump of only new
types from the split (module) BTF. This will become more important as
people will start using module BTF more. It's an interesting add-on to
libbpf's btf_dumper functionality. Not sure how hard that would be,
but I'd imagine it shouldn't require much changes.

Just in case anyone wanted to challenge themselves with some more
algorithmic patch for libbpf (*wink wink*)...


> diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> index 709b93fe1da3..2ef2f2df0279 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> @@ -12,7 +12,8 @@ SYNOPSIS
>
>         **bpftool** [*OPTIONS*] **gen** *COMMAND*
>
> -       *OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
> +       *OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
> +               { **-L** | **--use-loader** } }
>
>         *COMMAND* := { **object** | **skeleton** | **help** }
>

[...]
