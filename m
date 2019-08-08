Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BED786852
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 19:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfHHRx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 13:53:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38180 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfHHRx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 13:53:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id u190so5866705qkh.5;
        Thu, 08 Aug 2019 10:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xoH9X66fQxN3/0X6u8sNCKLkjzTbBPvI5qg5x8INf1M=;
        b=Pbil9io9lG2KkoRshTzMdNhPl/qbUDYIqjjzCV6AATtdH4nHZ/trnMQNpLnMUtjzcK
         oC4s1yvbswg9lU6r7r1DGJHXzBexgCxdFkG1gMZUbUH93pPiKW5EixAuPdOtgjv+TEC2
         BoaEltjQMNIdpmGh+uF6tcGgPs7WztSAU0UnaOURoT7j0jYxicTadOWF7SuTM8+R86pl
         V1qorNQgmPGB8a8y3M1ttf2UISlrsyAlEiN3Eysfr4aO5B1K8i5xPTVhQrs7H0Ubcq5D
         6zM5/EQ7iROo56n1Tn4ZErW8I4JP+LVXgIsdynucdePSoylMhAvLZwFSEZHeAhJ+l5o8
         MyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xoH9X66fQxN3/0X6u8sNCKLkjzTbBPvI5qg5x8INf1M=;
        b=RvJnkoob4t55qNALQYchoUqNI3sVzlAa7i2qakUlLGhjwqUVxm7RuGrWUdspNbqEUQ
         xuFKvXBWNfaKXxK7qydLoCTurUyYRh+gzrEAHDu9XN/GxqFe9c0iyGIAA+dwIx4Epa4M
         qcdVLfjuUFnN+hOB6YvaUngeTZcM3XUvRjMNOug7Wkz8tSreFmah0+TCKEFiv2pmuLyo
         M9wJe1MUtpwgxX02IZ2SREa2bF1xtYtaMTabCfY6wMwefBL19vkYrUv/U7ZvMwSB1GbT
         OMRcHscaIt8Rj4xfVLAjF4jV06pcoTmWZrX+XJEL0uEXHm9KtpDuwYeN5Koes5DGt6W+
         e93g==
X-Gm-Message-State: APjAAAUTVTObLuEVa22bOHP3fBJhZ7GGIIN19uPvNpLi8/mcQ+fuQPaj
        anaug1X6XC9SdCf55RMod6HIWRqsTkuFDsuZzlXCH0Nhjpx9YBZb
X-Google-Smtp-Source: APXvYqx2WTyZIdhLIOpOtXZxLT6l56xOae4Jhpqhkxg/IXTmTsBgNOG4nGFQaH2tUBToJpAgx4KlO9o/hFSkh2PcA2Y=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr15253235qke.449.1565286835355;
 Thu, 08 Aug 2019 10:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190808003215.1462821-1-andriin@fb.com> <89a6e282-0250-4264-128d-469be99073e9@fb.com>
 <20190808060812.GA25150@kroah.com>
In-Reply-To: <20190808060812.GA25150@kroah.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Aug 2019 10:53:44 -0700
Message-ID: <CAEf4BzaWtumTrc7h1t3w8hA1L8mVo2Cm0B+eLSe4eSghFAu3iw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] btf: expose BTF info through sysfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 11:08 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 08, 2019 at 04:24:25AM +0000, Yonghong Song wrote:
> >
> >
> > On 8/7/19 5:32 PM, Andrii Nakryiko wrote:
> > > Make .BTF section allocated and expose its contents through sysfs.
>
> Was this original patch not on bpf@vger?  I can't find it in my
> archive.  Anyway...
>
> > > /sys/kernel/btf directory is created to contain all the BTFs present
> > > inside kernel. Currently there is only kernel's main BTF, represented as
> > > /sys/kernel/btf/kernel file. Once kernel modules' BTFs are supported,
> > > each module will expose its BTF as /sys/kernel/btf/<module-name> file.
>
> Why are you using sysfs for this?  Who uses "BTF"s?  Are these debugging
> images that only people working on developing bpf programs are going to
> need, or are these things that you are going to need on a production
> system?

We need it in production system. One immediate and direct use case is
BPF CO-RE (Compile Once - Run Everywhere), which aims to allow to
pre-compile BPF applications (even those that read internal kernel
structures) using any local kernel headers, and then distribute and
run them in binary form on all target production machines without
dependencies on kernel headers and having Clang on target machine to
compile C to BPF IR. Libbpf is doing all those adjustments/relocations
based on kernel's actual BTF. See [0] for a summary and slides, if you
curious to learn more.

  [0] http://vger.kernel.org/bpfconf2019.html#session-2

>
> I ask as maybe debugfs is the best place for this if they are not needed
> on production systems.
>
>
> > >
> > > Current approach relies on a few pieces coming together:
> > > 1. pahole is used to take almost final vmlinux image (modulo .BTF and
> > >     kallsyms) and generate .BTF section by converting DWARF info into
> > >     BTF. This section is not allocated and not mapped to any segment,
> > >     though, so is not yet accessible from inside kernel at runtime.
> > > 2. objcopy dumps .BTF contents into binary file and subsequently
> > >     convert binary file into linkable object file with automatically
> > >     generated symbols _binary__btf_kernel_bin_start and
> > >     _binary__btf_kernel_bin_end, pointing to start and end, respectively,
> > >     of BTF raw data.
> > > 3. final vmlinux image is generated by linking this object file (and
> > >     kallsyms, if necessary). sysfs_btf.c then creates
> > >     /sys/kernel/btf/kernel file and exposes embedded BTF contents through
> > >     it. This allows, e.g., libbpf and bpftool access BTF info at
> > >     well-known location, without resorting to searching for vmlinux image
> > >     on disk (location of which is not standardized and vmlinux image
> > >     might not be even available in some scenarios, e.g., inside qemu
> > >     during testing).
> > >
> > > Alternative approach using .incbin assembler directive to embed BTF
> > > contents directly was attempted but didn't work, because sysfs_proc.o is
> > > not re-compiled during link-vmlinux.sh stage. This is required, though,
> > > to update embedded BTF data (initially empty data is embedded, then
> > > pahole generates BTF info and we need to regenerate sysfs_btf.o with
> > > updated contents, but it's too late at that point).
> > >
> > > If BTF couldn't be generated due to missing or too old pahole,
> > > sysfs_btf.c handles that gracefully by detecting that
> > > _binary__btf_kernel_bin_start (weak symbol) is 0 and not creating
> > > /sys/kernel/btf at all.
> > >
> > > v1->v2:
> > > - allow kallsyms stage to re-use vmlinux generated by gen_btf();
> > >
> > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > Cc: Sam Ravnborg <sam@ravnborg.org>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >   kernel/bpf/Makefile     |  3 +++
> > >   kernel/bpf/sysfs_btf.c  | 52 ++++++++++++++++++++++++++++++++++++++
> > >   scripts/link-vmlinux.sh | 55 +++++++++++++++++++++++++++--------------
> > >   3 files changed, 91 insertions(+), 19 deletions(-)
> > >   create mode 100644 kernel/bpf/sysfs_btf.c
>
> First rule, you can't create new sysfs files without a matching
> Documentation/ABI/ set of entries.  Please do that for the next version
> of this patch so we can properly check to see if what you are
> documenting lines up with the code.  Otherwise we just have to guess as
> to what the entries you are creating actually do.

Yep, sure, I wasn't aware, will add in v3.

>
> > >
> > > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > > index 29d781061cd5..e1d9adb212f9 100644
> > > --- a/kernel/bpf/Makefile
> > > +++ b/kernel/bpf/Makefile
> > > @@ -22,3 +22,6 @@ obj-$(CONFIG_CGROUP_BPF) += cgroup.o
> > >   ifeq ($(CONFIG_INET),y)
> > >   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
> > >   endif
> > > +ifeq ($(CONFIG_SYSFS),y)
> > > +obj-$(CONFIG_DEBUG_INFO_BTF) += sysfs_btf.o
> > > +endif
> > > diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
> > > new file mode 100644
> > > index 000000000000..ac06ce1d62e8
> > > --- /dev/null
> > > +++ b/kernel/bpf/sysfs_btf.c
> > > @@ -0,0 +1,52 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Provide kernel BTF information for introspection and use by eBPF tools.
> > > + */
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/kobject.h>
> > > +#include <linux/init.h>
> > > +
> > > +/* See scripts/link-vmlinux.sh, gen_btf() func for details */
> > > +extern char __weak _binary__btf_kernel_bin_start[];
> > > +extern char __weak _binary__btf_kernel_bin_end[];
> > > +
> > > +static ssize_t
> > > +btf_kernel_read(struct file *file, struct kobject *kobj,
> > > +           struct bin_attribute *bin_attr,
> > > +           char *buf, loff_t off, size_t len)
> > > +{
> > > +   memcpy(buf, _binary__btf_kernel_bin_start + off, len);
> > > +   return len;
> > > +}
> > > +
> > > +static struct bin_attribute btf_kernel_attr __ro_after_init = {
> > > +   .attr = {
> > > +           .name = "kernel",
> > > +           .mode = 0444,
> > > +   },
> > > +   .read = btf_kernel_read,
> > > +};
>
> BIN_ATTR_RO()?

Ok, will use that.

>
> > > +
> > > +static struct bin_attribute *btf_attrs[] __ro_after_init = {
> > > +   &btf_kernel_attr,
> > > +   NULL,
> > > +};
> > > +
> > > +static struct attribute_group btf_group_attr __ro_after_init = {
> > > +   .name = "btf",
> > > +   .bin_attrs = btf_attrs,
> > > +};
> > > +
> > > +static int __init btf_kernel_init(void)
> > > +{
> > > +   if (!_binary__btf_kernel_bin_start)
> > > +           return 0;
> > > +
> > > +   btf_kernel_attr.size = _binary__btf_kernel_bin_end -
> > > +                          _binary__btf_kernel_bin_start;
> > > +
> > > +   return sysfs_create_group(kernel_kobj, &btf_group_attr);
>
> You are nesting directories here without a "real" kobject in the middle.
> Are you _sure_ you want to do that?  It's going to get really tricky
> later on based on your comments above about creating multiple files in
> that directory over time once "modules" are allowed.

My thinking was that when we have BTF for modules, I'll need to do
some code adjustments anyway, at which point it will be more clear how
we want to structure that. But I can add explicit kobject as static
variable right now, no problems. Later on we probably will just switch
it to be exported, so that modules can self-register/unregister their
BTFs autonomously.

>
> thanks,
>
> greg k-h
