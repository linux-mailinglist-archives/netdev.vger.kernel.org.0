Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFBA20EEB0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgF3Glu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:41:50 -0400
Received: from condef-02.nifty.com ([202.248.20.67]:37176 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgF3Glt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:41:49 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2020 02:41:48 EDT
Received: from conssluserg-01.nifty.com ([10.126.8.80])by condef-02.nifty.com with ESMTP id 05U6VLE1009899;
        Tue, 30 Jun 2020 15:31:21 +0900
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 05U6UgIb011232;
        Tue, 30 Jun 2020 15:30:42 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 05U6UgIb011232
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1593498643;
        bh=hWw/PnfkqdzxZlXBfdr5ZsRULyy797gdejQ+pX6AzaU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZhAbYh7zx1kczWaedEG6cKzY69GueVLOcznv9ldVPHTsWHek3NL2YwuGkV7kFDLGb
         rQ5l8dVh5CvsJuOb1srMpPqZWRgRMoK9XMkZ+kR8BOisxy5RRixhan8Di1eMdS70DG
         eXQL+diXuQWzA+yu+sapyFhsvHF+sDUGvy0dwyOe4lFIey6+M+3iBzGbIEMBOiJsv5
         pBK5sCVtscl3TgYquXJkI/OjtavekrEye92GSHIP/NYQ2KuOvgWq8W2KHHerjjRxJ0
         bUo+IVFBqiZNVhF17AEz79MgMIj/ZkC4gM/aET2SMUSqSNo7cOdqmefnUN+yB7YAVx
         jHxb8KRPbWGUw==
X-Nifty-SrcIP: [209.85.222.51]
Received: by mail-ua1-f51.google.com with SMTP id z47so6122322uad.5;
        Mon, 29 Jun 2020 23:30:42 -0700 (PDT)
X-Gm-Message-State: AOAM5325Udae0HlR72Y6pRI2WvJ7cLJfoiMJc/1E7rjJpBkfJAtOedQ1
        gG6+3TxHQwzkxEoWy7dJZ5cRf6wxdqQgm/irAKA=
X-Google-Smtp-Source: ABdhPJw4WXNDTVroElfgeqLVDMNI7bd4mrYrp5LWdLRuCY5G094o1kEYH5ERVBEamOeUfiHOcfZYY7koTqlFDLQ6t3M=
X-Received: by 2002:ab0:156d:: with SMTP id p42mr13408863uae.121.1593498641294;
 Mon, 29 Jun 2020 23:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200423073929.127521-1-masahiroy@kernel.org> <20200423073929.127521-5-masahiroy@kernel.org>
 <20200608115628.osizkpo76cgn2ci7@lion.mk-sys.cz>
In-Reply-To: <20200608115628.osizkpo76cgn2ci7@lion.mk-sys.cz>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 30 Jun 2020 15:30:04 +0900
X-Gmail-Original-Message-ID: <CAK7LNARGKCyWbfWUOX3nLLOBS3gi1QU3acdXLPVK4C+ErMDLpA@mail.gmail.com>
Message-ID: <CAK7LNARGKCyWbfWUOX3nLLOBS3gi1QU3acdXLPVK4C+ErMDLpA@mail.gmail.com>
Subject: Re: [PATCH 04/16] net: bpfilter: use 'userprogs' syntax to build bpfilter_umh
To:     Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal, Alexei,

On Mon, Jun 8, 2020 at 8:56 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Thu, Apr 23, 2020 at 04:39:17PM +0900, Masahiro Yamada wrote:
> > The user mode helper should be compiled for the same architecture as
> > the kernel.
> >
> > This Makefile reuses the 'hostprogs' syntax by overriding HOSTCC with CC.
> >
> > Now that Kbuild provides the syntax 'userprogs', use it to fix the
> > Makefile mess.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > Reported-by: kbuild test robot <lkp@intel.com>
> > ---
> >
> >  net/bpfilter/Makefile | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> > index 36580301da70..6ee650c6badb 100644
> > --- a/net/bpfilter/Makefile
> > +++ b/net/bpfilter/Makefile
> > @@ -3,17 +3,14 @@
> >  # Makefile for the Linux BPFILTER layer.
> >  #
> >
> > -hostprogs := bpfilter_umh
> > +userprogs := bpfilter_umh
> >  bpfilter_umh-objs := main.o
> > -KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> > -HOSTCC := $(CC)
> > +user-ccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> >
> > -ifeq ($(CONFIG_BPFILTER_UMH), y)
> > -# builtin bpfilter_umh should be compiled with -static
> > +# builtin bpfilter_umh should be linked with -static
> >  # since rootfs isn't mounted at the time of __init
> >  # function is called and do_execv won't find elf interpreter
> > -KBUILD_HOSTLDFLAGS += -static
> > -endif
> > +bpfilter_umh-ldflags += -static
> >
> >  $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh
>
> Hello,
>
> I just noticed that this patch (now in mainline as commit 8a2cc0505cc4)
> drops the test if CONFIG_BPFILTER_UMH is "y" so that -static is now
> passed to the linker even if bpfilter_umh is built as a module which
> wasn't the case in v5.7.
>
> This is not mentioned in the commit message and the comment still says
> "*builtin* bpfilter_umh should be linked with -static" so this change
> doesn't seem to be intentional. Did I miss something?
>
> Michal Kubecek

I was away for a while from this because I saw long discussion in
"net/bpfilter: Remove this broken and apparently unmaintained"


Please let me resume this topic now.


The original behavior of linking umh was like this:
  - If CONFIG_BPFILTER_UMH=y, bpfilter_umh was linked with -static
  - If CONFIG_BPFILTER_UMH=m, bpfilter_umh was linked without -static



Restoring the original behavior will add more complexity because
now we have CONFIG_CC_CAN_LINK and CONFIG_CC_CAN_LINK_STATIC
since commit b1183b6dca3e0d5

If CONFIG_BPFILTER_UMH=y, we need to check CONFIG_CC_CAN_LINK_STATIC.
If CONFIG_BPFILTER_UMH=m, we need to check CONFIG_CC_CAN_LINK.
This would make the Kconfig dependency logic too complicated.


To make it simpler, I'd like to suggest two options.



Idea 1:

  Always use -static irrespective of whether
  CONFIG_BPFILTER_UMH is y or m.

  Add two more lines to clarify this
  in the comment in net/bpfilter/Makefile:

  # builtin bpfilter_umh should be linked with -static
  # since rootfs isn't mounted at the time of __init
  # function is called and do_execv won't find elf interpreter.
  # Static linking is not required when bpfilter is modular, but
  # we always pass -static to keep the 'depends on' in Kconfig simple.



Idea 2:

   Allow umh to become only modular,
   and drop -static flag entirely.

   If you look at net/bpfilter/Kconfig,
   BPFILTER_UMH already has 'default m'.
   So, I assume the most expected use-case
   is modular.

   My suggestion is to replace 'default m' with 'depends on m'.

   config BPFILTER_UMH
           tristate "bpfilter kernel module with user mode helper"
           depends on CC_CAN_LINK
           depends on m

   Then BPFILTER_UMH will be restricted to either m or n.
   Link umh dynamically because we can expect rootfs
   is already mounted for the module case.






Comments are appreciated.


-- 
Best Regards
Masahiro Yamada
