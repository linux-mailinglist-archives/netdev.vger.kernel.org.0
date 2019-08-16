Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608999076E
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfHPSDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 14:03:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46428 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfHPSDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 14:03:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id m3so2709949pgv.13
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 11:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Kz/XOyz7LZ0pcUiL3uYqVXSGf72BjYZb+6cd6xy5cA=;
        b=VssH97Aa1l5+/qAKrdEV2xBU0FSV5oqLPtio7jR0gHpBsIjF0+Xds6ulGNhQ+VtpCc
         GuSSVmASgP4mwjk/Dd15Ke1AV9sY9OfFoEZsM1OIBajZMouxpYfTS5KVNqifD1GnQhD7
         8AexrzxK9CwKKJFLhRi5ftO60HJrpUyGh/Z3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Kz/XOyz7LZ0pcUiL3uYqVXSGf72BjYZb+6cd6xy5cA=;
        b=VDh0+SM7eYXWbEIRb23t4EXSD9xSmWkv4D9HGkxGKTg9TI9c19QUo5Ub8r4e5xWJGZ
         PZwLHTyADp3bX7SmUVoza5qFRMIdFjxJIjCIHpWoMoCLDVFLZgc2lg9ziFT0jJ1imRXf
         2zgB4nrvaItqpv5/97spVtHBFSVSQ/WItaYlXT94ZjhnBJ/M5NSLL83ApV5HL75Pl8yC
         +2PJsZakwa92IW+xaBzVVRoR5SvNkLcuWzoKudq3EGYmrjp0nqlveLNS7aMicBB0n7+W
         8ASonTu1gMHzgJpLwPSZK70Adgd7ro+MFrETKkLybe2E3l0zXJU1r7yyiT1CJF/KLYqv
         xatQ==
X-Gm-Message-State: APjAAAVXKznspaC2B3FiHMmj7zoHSu8c0vsqVfjOu+AKOX1Hr2s7yUbr
        uvfBtNY7ed0nX2zJ9pGVILl4Pw==
X-Google-Smtp-Source: APXvYqxSlv62Xa3cqpk6BDBCnRroF7ZbQBXX0NszVmMx/QCm1xioP5tJe2sDAo/jhKWeeJwvhj+jJQ==
X-Received: by 2002:a17:90a:17e2:: with SMTP id q89mr8579319pja.8.1565978609675;
        Fri, 16 Aug 2019 11:03:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j10sm6515262pfn.188.2019.08.16.11.03.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Aug 2019 11:03:28 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:03:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: linux-next: manual merge of the net-next tree with the kbuild
 tree
Message-ID: <201908161101.31674596CC@keescook>
References: <20190816124143.2640218a@canb.auug.org.au>
 <CAEf4BzY9dDZF-DBDmuQQz0Rcx3DNGvQn_GLr0Uar1PAbAf2iig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY9dDZF-DBDmuQQz0Rcx3DNGvQn_GLr0Uar1PAbAf2iig@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 10:21:29PM -0700, Andrii Nakryiko wrote:
> On Thu, Aug 15, 2019 at 7:42 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> >
> > Today's linux-next merge of the net-next tree got a conflict in:
> >
> >   scripts/link-vmlinux.sh
> >
> > between commit:
> >
> >   e167191e4a8a ("kbuild: Parameterize kallsyms generation and correct reporting")
> >
> > from the kbuild tree and commits:
> >
> >   341dfcf8d78e ("btf: expose BTF info through sysfs")
> >   7fd785685e22 ("btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vmlinux")
> >
> > from the net-next tree.
> >
> > I fixed it up (I think - see below) and can carry the fix as necessary.
> 
> Thanks, Stephen! Looks good except one minor issue below.
> 
> > This is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >
> > --
> > Cheers,
> > Stephen Rothwell
> >
> > diff --cc scripts/link-vmlinux.sh
> > index 2438a9faf3f1,c31193340108..000000000000
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@@ -56,11 -56,10 +56,11 @@@ modpost_link(
> >   }
> >
> >   # Link of vmlinux
> > - # ${1} - optional extra .o files
> > - # ${2} - output file
> > + # ${1} - output file
> > + # ${@:2} - optional extra .o files
> >   vmlinux_link()
> >   {
> >  +      info LD ${2}
> 
> This needs to be ${1}.
> 
> >         local lds="${objtree}/${KBUILD_LDS}"
> >         local objects
> >
> > @@@ -139,18 -149,6 +150,18 @@@ kallsyms(
> >         ${CC} ${aflags} -c -o ${2} ${afile}
> >   }
> >
> >  +# Perform one step in kallsyms generation, including temporary linking of
> >  +# vmlinux.
> >  +kallsyms_step()
> >  +{
> >  +      kallsymso_prev=${kallsymso}
> >  +      kallsymso=.tmp_kallsyms${1}.o
> >  +      kallsyms_vmlinux=.tmp_vmlinux${1}
> >  +
> > -       vmlinux_link "${kallsymso_prev}" ${kallsyms_vmlinux}
> > ++      vmlinux_link ${kallsyms_vmlinux} "${kallsymso_prev}" ${btf_vmlinux_bin_o}

Good cleanup on the "optional .o files" reordering! With your ordering
change, I think the ""s around ${kallsymso_prev} here are no longer needed
(which makes it read a bit more nicely).

> >  +      kallsyms ${kallsyms_vmlinux} ${kallsymso}
> >  +}
> >  +
> >   # Create map file with all symbols from ${1}
> >   # See mksymap for additional details
> >   mksysmap()
> > @@@ -228,8 -227,14 +240,15 @@@ ${MAKE} -f "${srctree}/scripts/Makefile
> >   info MODINFO modules.builtin.modinfo
> >   ${OBJCOPY} -j .modinfo -O binary vmlinux.o modules.builtin.modinfo
> >
> > + btf_vmlinux_bin_o=""
> > + if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> > +       if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
> > +               btf_vmlinux_bin_o=.btf.vmlinux.bin.o
> > +       fi
> > + fi
> > +
> >   kallsymso=""
> >  +kallsymso_prev=""
> >   kallsyms_vmlinux=""
> >   if [ -n "${CONFIG_KALLSYMS}" ]; then
> >
> > @@@ -268,11 -285,8 +287,7 @@@
> >         fi
> >   fi
> >
> > - vmlinux_link "${kallsymso}" vmlinux
> > -
> > - if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> > -       gen_btf vmlinux
> > - fi
> >  -info LD vmlinux
> > + vmlinux_link vmlinux "${kallsymso}" "${btf_vmlinux_bin_o}"

And, I think, also not here for either trailing argument.

> >
> >   if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
> >         info SORTEX vmlinux

-Kees

-- 
Kees Cook
