Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D66821F580
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGNOyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgGNOyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:54:33 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CC5C061755;
        Tue, 14 Jul 2020 07:54:32 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h22so23104449lji.9;
        Tue, 14 Jul 2020 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=216BVYRg8fMC6Xf6ygu+rllfsyrRcDfyiKujR0K+mPc=;
        b=kHn32CLzrOuwZLpk9ERwy/KM5lLUSKQtzBVSbwI7cwwIJOwWVWQ1WRnZUupQiaAh+4
         DXrU78MEiWX5Nn69pfoLFrgGROUtuhMLL+2Yz5waSsAXTlQfuEbJnrZvWGWq4wPK+Luc
         w/ctvc/JWEMxg6FA2Eu0R+NrQotMjuCB0ZJs4AbZ5JH63g7R4BopCiz7yU0zCjFX8PdK
         wLZWwaKFQUOgDEIDRgYv/x0XL0XzVz5qwFBDyjdM+rdKuX9/3B4cWpDYDpuAzux0+kDS
         nSBAZbYwV2tNnW6DGz/aEr4V2jZN5R2ulV9mim3JiACheMgdvSlbwgSLQGJSxWkEf/SY
         Zcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=216BVYRg8fMC6Xf6ygu+rllfsyrRcDfyiKujR0K+mPc=;
        b=oSdy0UQAlPpLUOPdsE8fn6cmdSMUvnFfXEQJ6Ja2ngOj9uTjEwTih383+TAcTx81lt
         5zvx79XG0D+qBgsFY7wWeJqHcGgCz02sQTURUj0w9bYUp1Ni989LL72SekW+XptvLnn5
         TMN+fKTwleQxzTN6DcJvxNUUDsWKAcjW6erNzxxAyiCT2F+OZs07g9rC7YfD1PnWpDDb
         4kFuL2ZltNJiKI4mwiPW4kcjQdrJsGAHofWnOijvRsAHpePDdgArB9GzvBD/jq8E/cQZ
         MN+Ww7NWz4MdHG0Rbh6reRJQOZAiMvMOg9Jz75rzgUkLAwpeUr4LVT0miH7eqh9/sQet
         pFjQ==
X-Gm-Message-State: AOAM5335b1Gp7lJnlxiw8DPCV+nQCX8XTrUB05Xcg1PmFPCcuAAij3ss
        dSfxQiDMwJ7Rsj37WZuxPebkC+cuD1kk5V4j3to=
X-Google-Smtp-Source: ABdhPJwvDlbXhunIifVYskbFQ4VOYcKsNoELAbvbr9PR3SRQtrnJlZfWV2AxivvpGz7ke4f0LHdCvAWZ3MtxuBvyLNg=
X-Received: by 2002:a2e:9a4d:: with SMTP id k13mr2633091ljj.283.1594738471100;
 Tue, 14 Jul 2020 07:54:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200714121608.58962d66@canb.auug.org.au> <20200714090048.GG183694@krava>
 <20200714203341.4664dda3@canb.auug.org.au> <20200714104702.GH183694@krava> <20200714111545.GI183694@krava>
In-Reply-To: <20200714111545.GI183694@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jul 2020 07:54:19 -0700
Message-ID: <CAADnVQJsh3BTD4D4fBzaJ9_YdmWf0ftHNrj7RM1m3m5QcBU0gw@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 4:15 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jul 14, 2020 at 12:47:02PM +0200, Jiri Olsa wrote:
> > On Tue, Jul 14, 2020 at 08:33:41PM +1000, Stephen Rothwell wrote:
> >
> > SNIP
> >
> > > > diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> > > > index 948378ca73d4..a88cd4426398 100644
> > > > --- a/tools/bpf/resolve_btfids/Makefile
> > > > +++ b/tools/bpf/resolve_btfids/Makefile
> > > > @@ -16,6 +16,20 @@ else
> > > >    MAKEFLAGS=--no-print-directory
> > > >  endif
> > > >
> > > > +# always use the host compiler
> > > > +ifneq ($(LLVM),)
> > > > +HOSTAR  ?= llvm-ar
> > > > +HOSTCC  ?= clang
> > > > +HOSTLD  ?= ld.lld
> > > > +else
> > > > +HOSTAR  ?= ar
> > > > +HOSTCC  ?= gcc
> > > > +HOSTLD  ?= ld
> > > > +endif
> > > > +AR       = $(HOSTAR)
> > > > +CC       = $(HOSTCC)
> > > > +LD       = $(HOSTLD)
> > > > +
> > > >  OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
> > > >
> > > >  LIBBPF_SRC := $(srctree)/tools/lib/bpf/
> > > >
> > >
> > > Thanks for the quick response.  However, in the mean time the bpf-next
> > > tree has been merged into the net-next tree, so these fixes will be
> > > needed there ASAP.
> >
> > I just posted it
>
> ugh, you said net-next..
>
> David, do you need me to repost with net-next tag?
>   https://lore.kernel.org/bpf/20200714102534.299280-1-jolsa@kernel.org/T/

NO. The fixes must go into bpf-next first.
