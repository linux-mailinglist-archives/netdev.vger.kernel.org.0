Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C443119FA
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhBFDZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:25:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231614AbhBFDOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 22:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612581180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xUKlzfaqzcrZX9Jou9TWKJ3SWAsPMjreuBXZeEJsvzk=;
        b=GGx9euQ2xrBhmU0Nowr8/bUG4DZmlOaianla4wgaRFI6hRSo4cM1wF7xWPoWzfQgreEOEc
        orpNVEcU53a6vGWXo/X+s2sDggxruNu6HmW8JuCELlsXXpwZgIcxPxd1AcNiwVIsbBELbb
        ECArhPHb2wZxd12DiY5UhbK+rJ/5lkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-HAuGLb3tOru0DHiUeehCGQ-1; Fri, 05 Feb 2021 19:00:43 -0500
X-MC-Unique: HAuGLb3tOru0DHiUeehCGQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 271D3100A61E;
        Sat,  6 Feb 2021 00:00:41 +0000 (UTC)
Received: from krava (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0CFA119718;
        Sat,  6 Feb 2021 00:00:37 +0000 (UTC)
Date:   Sat, 6 Feb 2021 01:00:37 +0100
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
Message-ID: <YB3cJSiXCGB5vuT+@krava>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <CAEf4Bzao-9wNdHxGu1mMhSie78FyWno-RYJM6_Jay8s=hyUWJg@mail.gmail.com>
 <YB3HlQRKBWKqlYZG@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YB3HlQRKBWKqlYZG@krava>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 11:32:57PM +0100, Jiri Olsa wrote:
> On Fri, Feb 05, 2021 at 02:27:08PM -0800, Andrii Nakryiko wrote:
> > On Fri, Feb 5, 2021 at 4:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > resolve_btfids tool is used during the kernel build,
> > > so we should clean it on kernel's make clean.
> > >
> > > v2 changes:
> > >   - add Song's acks on patches 1 and 4 (others changed) [Song]
> > >   - add missing / [Andrii]
> > >   - change srctree variable initialization [Andrii]
> > >   - shifted ifdef for clean target [Andrii]
> > >
> > > thanks,
> > > jirka
> > >
> > >
> > 
> > FYI, your patch #2 didn't make it into the mailing list (see [0]). So
> > maybe wait for a bit and if it doesn't arrive, re-submit?
> > 
> >   [0] https://patchwork.kernel.org/user/todo/netdevbpf/?series=428711&delegate=121173&state=*
> 
> hum and lore shows just 1 and 4
>   https://lore.kernel.org/bpf/20210205124020.683286-1-jolsa@kernel.org/
> 
> I'll check and resent later 

it arrived

jirka

