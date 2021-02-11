Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB13E318A62
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhBKMWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:22:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231665AbhBKMTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:19:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613045853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ozgmNa0s/jCCWPiNNn97SiT5a4Tuwh+Z12DZS0v6G/c=;
        b=Br+uh5quLvmnZ8dqyoMB3x2SJOg4MdTW7H/OwxOeIb3SNZYNFYIIuoO8aYbWptpuZg/ydv
        aDwuFDfpXf7uWItvw35Y7DLTH9DAXdulqyiIxjGV85IpEWRUIkwEU7bV8Z1+8TZHBW3Gzl
        3avokzHKmqXKnb1kkm/kbgYBjtD5KvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-n8LZrXUAM7yA5NszzYeHyA-1; Thu, 11 Feb 2021 07:17:29 -0500
X-MC-Unique: n8LZrXUAM7yA5NszzYeHyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A88A85C87E;
        Thu, 11 Feb 2021 12:17:27 +0000 (UTC)
Received: from krava (unknown [10.40.195.165])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4FE955D9E8;
        Thu, 11 Feb 2021 12:17:23 +0000 (UTC)
Date:   Thu, 11 Feb 2021 13:17:22 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
Message-ID: <YCUgUlCDGTS85MCO@krava>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86>
 <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
 <20210210180215.GA2374611@ubuntu-m3-large-x86>
 <YCQmCwBSQuj+bi4q@krava>
 <CAEf4BzbwwtqerxRrNZ75WLd2aHLdnr7wUrKahfT7_6bjBgJ0xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbwwtqerxRrNZ75WLd2aHLdnr7wUrKahfT7_6bjBgJ0xQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:26:28AM -0800, Andrii Nakryiko wrote:

SNIP

> > > > Can't reproduce it. It works in all kinds of variants (relative and
> > > > absolute O=, clean and not clean trees, etc). Jiri, please check as
> > > > well.
> > > >
> > >
> > > Odd, this reproduces for me on a completely clean checkout of bpf-next:
> > >
> > > $ git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
> > >
> > > $ cd bpf-next
> > >
> > > $ make -s O=build distclean
> > > ../../scripts/Makefile.include:4: *** O=/tmp/bpf-next/build/tools/bpf/resolve_btfids does not exist.  Stop.
> > >
> > > I do not really see how this could be environment related. It seems like
> > > this comes from tools/scripts/Makefile.include, where there is no
> > > guarantee that $(O) is created before being used like in the main
> > > Makefile?
> >
> > right, we need to handle the case where tools/bpf/resolve_btfids
> > does not exist, patch below fixes it for me
> >
> > jirka
> >
> 
> Looks good to me, please send it as a proper patch to bpf-next.
> 
> But I'm curious, why is objtool not doing something like that? Is it
> not doing clean at all? Or does it do it in some different way?

yes, it's not connected to global make clean

> 
> >
> > ---
> > diff --git a/Makefile b/Makefile
> > index 159d9592b587..ce9685961abe 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1088,8 +1088,14 @@ endif
> >
> >  PHONY += resolve_btfids_clean
> >
> > +resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
> > +
> > +# tools/bpf/resolve_btfids directory might not exist
> > +# in output directory, skip its clean in that case
> >  resolve_btfids_clean:
> > -       $(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> > +ifneq (,$(wildcard $(resolve_btfids_O)))
> 
> nit: kind of backwards, usually it's in a `ifneq($var,)` form

ok

thanks,
jirka

