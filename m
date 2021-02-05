Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB931192B
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhBFC5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:57:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231390AbhBFCr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:47:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612579591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AYGGDA96ECWqQKM+EqU3BIR3anY2ge6JyymK2JmAKVg=;
        b=gTlLe4wxsef9J5ZsO4tfhM62MCoSiwIJ5cxeFk0Rg6SQi8nNbEfWvsrMXZBgJ+5dzC1dqr
        gBiSboR6iR39VCQoI8PgwMwYpX++2C5LuTcp0a4ohr4TgTn76C7klLXBDk/mKt7lhkKDC/
        a1aWxmaQmVYCTx8AmFCNCAAjOtQmpbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-b4VtmItPNTCb09moGMDoJA-1; Fri, 05 Feb 2021 17:33:00 -0500
X-MC-Unique: b4VtmItPNTCb09moGMDoJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE7F08030B7;
        Fri,  5 Feb 2021 22:32:57 +0000 (UTC)
Received: from krava (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6E42560C9C;
        Fri,  5 Feb 2021 22:32:54 +0000 (UTC)
Date:   Fri, 5 Feb 2021 23:32:53 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCHv2 bpf-next 0/4] kbuild/resolve_btfids: Invoke
 resolve_btfids clean in root Makefile
Message-ID: <YB3HlQRKBWKqlYZG@krava>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <CAEf4Bzao-9wNdHxGu1mMhSie78FyWno-RYJM6_Jay8s=hyUWJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzao-9wNdHxGu1mMhSie78FyWno-RYJM6_Jay8s=hyUWJg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 02:27:08PM -0800, Andrii Nakryiko wrote:
> On Fri, Feb 5, 2021 at 4:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > resolve_btfids tool is used during the kernel build,
> > so we should clean it on kernel's make clean.
> >
> > v2 changes:
> >   - add Song's acks on patches 1 and 4 (others changed) [Song]
> >   - add missing / [Andrii]
> >   - change srctree variable initialization [Andrii]
> >   - shifted ifdef for clean target [Andrii]
> >
> > thanks,
> > jirka
> >
> >
> 
> FYI, your patch #2 didn't make it into the mailing list (see [0]). So
> maybe wait for a bit and if it doesn't arrive, re-submit?
> 
>   [0] https://patchwork.kernel.org/user/todo/netdevbpf/?series=428711&delegate=121173&state=*

hum and lore shows just 1 and 4
  https://lore.kernel.org/bpf/20210205124020.683286-1-jolsa@kernel.org/

I'll check and resent later 

thanks,
jirka

> 
> > ---
> > Jiri Olsa (4):
> >       tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
> >       tools/resolve_btfids: Check objects before removing
> >       tools/resolve_btfids: Set srctree variable unconditionally
> >       kbuild: Add resolve_btfids clean to root clean target
> >
> >  Makefile                            |  7 ++++++-
> >  tools/bpf/resolve_btfids/.gitignore |  2 --
> >  tools/bpf/resolve_btfids/Makefile   | 44 ++++++++++++++++++++++----------------------
> >  3 files changed, 28 insertions(+), 25 deletions(-)
> >
> 

