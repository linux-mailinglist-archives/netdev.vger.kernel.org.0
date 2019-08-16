Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A788FA53
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfHPFVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:21:42 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45903 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfHPFVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:21:42 -0400
Received: by mail-qt1-f194.google.com with SMTP id k13so4884244qtm.12;
        Thu, 15 Aug 2019 22:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6BgRH7uWgXm0ykwcCnyCSO3U7xukvqKpk3J2XCkWVPo=;
        b=TqCn+Vkkso2vIKA/Shpkxj3r2rinRLtPiM1y7AW9KLiB1sPE4I+AwCdOnM2AoAfZTp
         SwP+xpsHXaR/HtcFDh55UVZmht5iefN3MQGGvHp/w8gOrnxWNzepaGwLL1QJtmGqS23r
         bO2AjU3miELbzKNGUitK3HZEAnN3iS9QqFt3zOMtBrBEFOvlNmUCgaxIFmRd7SSh9IbT
         /pETUBEfROC3jLYMFin8jWxRJihPWPMQgzqStakOXs1j5XkpZsWBAKMhIBdIWHQCYIyb
         nzA3I36Weo/XwkWvsQdTeBdIn1qQxFWAKvFH9WoFCOLg+udV9zTFXrASqTaCvbMfx8B0
         oJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6BgRH7uWgXm0ykwcCnyCSO3U7xukvqKpk3J2XCkWVPo=;
        b=F0W+nMTFhjlNArxMxGQ1YEZix/tzXFsLx7Jx09Py63CyeCbgJBl0nheQtDeXzPBXAr
         /+A+sfcYbtmND2PAR3wLiTFU0PUzkI4NCBCxP7suukCserbmXI71SJsdxOzGt9QJVSG7
         dToevYJFjso1kM+k36L8YLfGgf/PKbbxhT/2CxfoWYKIulvPtCHbP6JTpKNSJvosmTjr
         npJ/UkdR9+xhNfaU47TG4S7d4Ls/2xLT5JwSG6vaqeOFkiMQ8RQHap4jZhGf+jTNG0Uj
         5PYLCl7H4XIPWcNsVCn7QbJBnZVh6YmiklkLTqLeljEqPjsft+YYw8jGfyRIT1zPnWZM
         cVxg==
X-Gm-Message-State: APjAAAVbOf3ZuiCDpFldeeBVBZPQF4A7Ed6qVy6cOTkAl4Li3nYTM2gz
        XA13qU3AH4FXLTqMcGQWfMp4hdS1jsl/hp4DKMQ=
X-Google-Smtp-Source: APXvYqzA3IkpdcaIkjY3gb084X+01cYyzaz0onoPodRabUEacOs6jo8MtaiF9GOgYUpLwwiTjiPzkGFHp44X6ufK3es=
X-Received: by 2002:a0c:e6cc:: with SMTP id l12mr674955qvn.60.1565932900638;
 Thu, 15 Aug 2019 22:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190816124143.2640218a@canb.auug.org.au>
In-Reply-To: <20190816124143.2640218a@canb.auug.org.au>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Aug 2019 22:21:29 -0700
Message-ID: <CAEf4BzY9dDZF-DBDmuQQz0Rcx3DNGvQn_GLr0Uar1PAbAf2iig@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the kbuild tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 7:42 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   scripts/link-vmlinux.sh
>
> between commit:
>
>   e167191e4a8a ("kbuild: Parameterize kallsyms generation and correct reporting")
>
> from the kbuild tree and commits:
>
>   341dfcf8d78e ("btf: expose BTF info through sysfs")
>   7fd785685e22 ("btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vmlinux")
>
> from the net-next tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary.

Thanks, Stephen! Looks good except one minor issue below.

> This is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> --
> Cheers,
> Stephen Rothwell
>
> diff --cc scripts/link-vmlinux.sh
> index 2438a9faf3f1,c31193340108..000000000000
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@@ -56,11 -56,10 +56,11 @@@ modpost_link(
>   }
>
>   # Link of vmlinux
> - # ${1} - optional extra .o files
> - # ${2} - output file
> + # ${1} - output file
> + # ${@:2} - optional extra .o files
>   vmlinux_link()
>   {
>  +      info LD ${2}

This needs to be ${1}.

>         local lds="${objtree}/${KBUILD_LDS}"
>         local objects
>
> @@@ -139,18 -149,6 +150,18 @@@ kallsyms(
>         ${CC} ${aflags} -c -o ${2} ${afile}
>   }
>
>  +# Perform one step in kallsyms generation, including temporary linking of
>  +# vmlinux.
>  +kallsyms_step()
>  +{
>  +      kallsymso_prev=${kallsymso}
>  +      kallsymso=.tmp_kallsyms${1}.o
>  +      kallsyms_vmlinux=.tmp_vmlinux${1}
>  +
> -       vmlinux_link "${kallsymso_prev}" ${kallsyms_vmlinux}
> ++      vmlinux_link ${kallsyms_vmlinux} "${kallsymso_prev}" ${btf_vmlinux_bin_o}
>  +      kallsyms ${kallsyms_vmlinux} ${kallsymso}
>  +}
>  +
>   # Create map file with all symbols from ${1}
>   # See mksymap for additional details
>   mksysmap()
> @@@ -228,8 -227,14 +240,15 @@@ ${MAKE} -f "${srctree}/scripts/Makefile
>   info MODINFO modules.builtin.modinfo
>   ${OBJCOPY} -j .modinfo -O binary vmlinux.o modules.builtin.modinfo
>
> + btf_vmlinux_bin_o=""
> + if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> +       if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
> +               btf_vmlinux_bin_o=.btf.vmlinux.bin.o
> +       fi
> + fi
> +
>   kallsymso=""
>  +kallsymso_prev=""
>   kallsyms_vmlinux=""
>   if [ -n "${CONFIG_KALLSYMS}" ]; then
>
> @@@ -268,11 -285,8 +287,7 @@@
>         fi
>   fi
>
> - vmlinux_link "${kallsymso}" vmlinux
> -
> - if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> -       gen_btf vmlinux
> - fi
>  -info LD vmlinux
> + vmlinux_link vmlinux "${kallsymso}" "${btf_vmlinux_bin_o}"
>
>   if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
>         info SORTEX vmlinux
