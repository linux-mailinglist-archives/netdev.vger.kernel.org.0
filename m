Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3479F3CD46E
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhGSLb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 07:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbhGSLb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 07:31:27 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9A0C061574
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 04:27:03 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ee25so23591009edb.5
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 05:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/UU/c96xB2XnsKcImXrMAG0NX8G+S47OMuRsfPPQPuI=;
        b=CK1gkwphNUpnV7qz0pEiNQPARKls7lgV4k0YhHtRviZNNNf9pduPYAm6rasO2Z4JYq
         yCfq8C7eKnhN+sLicDffhTPpp6ANXP4DqCoi59AQthWxFpsbTPcmXNQxiSf4zkbTW0pW
         K3aY/qy6QxN6TUQ+ylVmRuiz2j60u5w0PKO//4WhJzkw8/BP/YMkgXaltIlAxAr5v94A
         fKQ0wT14If3pjD//EisFpRLYUCGqpzt6ZOREOCfMTFpNyAAbyVqgTwrKeuMjTSC4anJJ
         Vb2nRPBLSF9PjEe+M0s5mDp+DlyqqAgbMhs3l4NUalgsijVHBhCBnMXqQ6NfFE39Zzyf
         K6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/UU/c96xB2XnsKcImXrMAG0NX8G+S47OMuRsfPPQPuI=;
        b=peqm1ZIc3+ZyguJCa8ioHosacTa6lxu7LEFF4CFLwvRXKmpRkDzYRdYzs1eBCOASfi
         XhmKP3P6fHsLpHup15R85aa7TI44m4M3v+B7oQS3yu6WyzqzMWG9z59GY+k2IIpEosT8
         sfuOTbXVIcrBu6xEG44BWGVzvWBgsRjNgz1eiR+FolnFTks8/n/p0L63i/ar7TAFySVo
         FaocG0FiPA0n+bmo2Sk0/J7NnE6WOcVykIv8MswIuPdk1D3cn71rFt4UkpE36vV6Z/8/
         IUc1ZEAFBXc150f/gInoFEAeeB7B0C9Pp/A1m/+LLwG+pQJPhDYDUxIb4XtLdZKKbMOQ
         AVKw==
X-Gm-Message-State: AOAM530VAnuEle0PlIWEDaV7nZWJIhqQus4wdD4Rhla7s01627o2BxU/
        9AYJmCLcgBPc3olEN7ucFEjHUbmfMAv7GB9VnDC5Mw==
X-Google-Smtp-Source: ABdhPJxzmls3MdY2v2rmmBRiXXunC11WlDfin6gHks3OmV5v5L2L+bdoxTg7/Z6IALIyVbWP7RXCTZMIZTIgJWrEzIY=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr33808453edu.221.1626696725478;
 Mon, 19 Jul 2021 05:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com> <1626362126-27775-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626362126-27775-2-git-send-email-alan.maguire@oracle.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 17:41:53 +0530
Message-ID: <CA+G9fYtqga+zMop8Ae3+fa1ENP2T8fwfFfwWmvfRWZSYB7cPDw@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 1/3] libbpf: BTF dumper support for typed data
To:     Alan Maguire <alan.maguire@oracle.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Jul 2021 at 20:46, Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Add a BTF dumper for typed data, so that the user can dump a typed
> version of the data provided.
>
> The API is
>
> int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
>                              void *data, size_t data_sz,
>                              const struct btf_dump_type_data_opts *opts);
>
> ...where the id is the BTF id of the data pointed to by the "void *"
> argument; for example the BTF id of "struct sk_buff" for a
> "struct skb *" data pointer.  Options supported are
>
>  - a starting indent level (indent_lvl)
>  - a user-specified indent string which will be printed once per
>    indent level; if NULL, tab is chosen but any string <= 32 chars
>    can be provided.
>  - a set of boolean options to control dump display, similar to those
>    used for BPF helper bpf_snprintf_btf().  Options are
>         - compact : omit newlines and other indentation
>         - skip_names: omit member names
>         - emit_zeroes: show zero-value members
>
> Default output format is identical to that dumped by bpf_snprintf_btf(),
> for example a "struct sk_buff" representation would look like this:
>
> struct sk_buff){
>         (union){
>                 (struct){
>                         .next = (struct sk_buff *)0xffffffffffffffff,
>                         .prev = (struct sk_buff *)0xffffffffffffffff,
>                 (union){
>                         .dev = (struct net_device *)0xffffffffffffffff,
>                         .dev_scratch = (long unsigned int)18446744073709551615,
>                 },
>         },
> ...
>
> If the data structure is larger than the *data_sz*
> number of bytes that are available in *data*, as much
> of the data as possible will be dumped and -E2BIG will
> be returned.  This is useful as tracers will sometimes
> not be able to capture all of the data associated with
> a type; for example a "struct task_struct" is ~16k.
> Being able to specify that only a subset is available is
> important for such cases.  On success, the amount of data
> dumped is returned.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/btf.h      |  19 ++
>  tools/lib/bpf/btf_dump.c | 819 ++++++++++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.map |   1 +
>  3 files changed, 834 insertions(+), 5 deletions(-)

<trim>

> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 5dc6b517..929cf93 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c


Following perf build errors noticed on i386 and arm 32-bit architectures on
linux next 20210719 tag with gcc-11.

metadata:
--------------
   git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
   git_short_log: 08076eab6fef ( Add linux-next specific files for 20210719 )
   toolchain: gcc-11
   target_arch: arm and i386


> +static void btf_dump_int128(struct btf_dump *d,
> +                           const struct btf_type *t,
> +                           const void *data)
> +{
> +       __int128 num = *(__int128 *)data;


btf_dump.c: In function 'btf_dump_int128':
btf_dump.c:1559:9: error: expected expression before '__int128'
 1559 |         __int128 num = *(__int128 *)data;
      |         ^~~~~~~~
btf_dump.c:1561:14: error: 'num' undeclared (first use in this function)
 1561 |         if ((num >> 64) == 0)
      |              ^~~
btf_dump.c:1561:14: note: each undeclared identifier is reported only
once for each function it appears in
btf_dump.c: At top level:
btf_dump.c:1568:17: error: '__int128' is not supported on this target
 1568 | static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
      |                 ^~~~~~~~
btf_dump.c: In function 'btf_dump_bitfield_get_data':
btf_dump.c:1576:18: error: '__int128' is not supported on this target
 1576 |         unsigned __int128 num = 0, ret;
      |                  ^~~~~~~~
btf_dump.c: In function 'btf_dump_bitfield_check_zero':
btf_dump.c:1608:9: error: expected expression before '__int128'
 1608 |         __int128 check_num;
      |         ^~~~~~~~
btf_dump.c:1610:9: error: 'check_num' undeclared (first use in this function)
 1610 |         check_num = btf_dump_bitfield_get_data(d, t, data,
bits_offset, bit_sz);
      |         ^~~~~~~~~
btf_dump.c: In function 'btf_dump_bitfield_data':
btf_dump.c:1622:18: error: '__int128' is not supported on this target
 1622 |         unsigned __int128 print_num;
      |                  ^~~~~~~~
btf_dump.c: In function 'btf_dump_dump_type_data':
btf_dump.c:2212:34: error: '__int128' is not supported on this target
 2212 |                         unsigned __int128 print_num;
      |                                  ^~~~~~~~


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

reference build link,
build: https://builds.tuxbuild.com/1vWeCpIox9EoV35c80bwOvU9nbb/
config: https://builds.tuxbuild.com/1vWeCpIox9EoV35c80bwOvU9nbb/config


steps to reproduce:
---------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch arm --toolchain gcc-11
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1vWeCpIox9EoV35c80bwOvU9nbb/config


--
Linaro LKFT
https://lkft.linaro.org
