Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1B031A681
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBLVGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:06:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhBLVGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 16:06:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613163896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g3qIn1qSnjfoN5aaYRdKn5QvyrYa2jYBaUe7hvAylkY=;
        b=BOvW/c7CwtLh6gXTAvNrO8V0X6R49L5e2CXTLeknw82FeHgs5L+qgYYHffPcIjBD7loCXu
        8odAvNHZolzlU0d0555bZYu9Obr1vFtycgBko6uz3vNiPFotdLnHn9JIrymElqvKGqt6x5
        M0me/8VCQdBym+0Zj8feEy2Lv9erfv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-W-vFUccVNYyvXImWxd0ybA-1; Fri, 12 Feb 2021 16:04:54 -0500
X-MC-Unique: W-vFUccVNYyvXImWxd0ybA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29D976EE2C;
        Fri, 12 Feb 2021 21:04:53 +0000 (UTC)
Received: from krava (unknown [10.40.193.141])
        by smtp.corp.redhat.com (Postfix) with SMTP id 822CE19811;
        Fri, 12 Feb 2021 21:04:51 +0000 (UTC)
Date:   Fri, 12 Feb 2021 22:04:50 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: add /libbpf to .gitignore
Message-ID: <YCbtcjR87iWWTVGx@krava>
References: <20210212010053.668700-1-sdf@google.com>
 <CAEf4BzZ60LNPpWL6z566hCCF1JkJC=-nZpqg7JQGaHp0rJYGhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ60LNPpWL6z566hCCF1JkJC=-nZpqg7JQGaHp0rJYGhg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:48:46AM -0800, Andrii Nakryiko wrote:
> On Thu, Feb 11, 2021 at 5:07 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > There is what I see after compiling the kernel:
> 
> typo: This?
> 
> >
> >  # bpf-next...bpf-next/master
> >  ?? tools/bpf/resolve_btfids/libbpf/
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> 
> Jiri,
> 
> Is this
> 
> Fixes: fc6b48f692f8 ("tools/resolve_btfids: Build libbpf and libsubcmd
> in separate directories")

yes

> 
> ?
> 
> Do we need similar stuff for libsubcmd (what's that, btw?)

as Stanislav said it's only .o files in there, so there's no need

it provides the parse_options functionality

jirka

> 
> >  tools/bpf/resolve_btfids/.gitignore | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
> > index 25f308c933cc..16913fffc985 100644
> > --- a/tools/bpf/resolve_btfids/.gitignore
> > +++ b/tools/bpf/resolve_btfids/.gitignore
> > @@ -1,2 +1,3 @@
> >  /fixdep
> >  /resolve_btfids
> > +/libbpf/
> > --
> > 2.30.0.478.g8a0d178c01-goog
> >
> 

