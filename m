Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E862E31A686
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhBLVG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:06:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231564AbhBLVG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 16:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613163932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VkCFWgsVdbCJFgmn7lqkOYZrSO4z9ILv0OvVw1jaBIk=;
        b=bJj2v+nEvQ5LY+gMUbsVlO+0u4JeeZJkphR9o7tmLkzFw7NBzaPlB2uWhoZEfvwcQDdmKD
        7ZaMAPVFt4MCfWbZbxIPKUBr37n43/nzOvLKdPaWe87uTW1S6T04s5h27pMr0dt+sC9Exd
        ZRIZ21O7PqRfF64LlYB8Dyyro9Yk0Dk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-i34ecyWmOuWSWyRXTzGdiw-1; Fri, 12 Feb 2021 16:05:28 -0500
X-MC-Unique: i34ecyWmOuWSWyRXTzGdiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CDB801965;
        Fri, 12 Feb 2021 21:05:27 +0000 (UTC)
Received: from krava (unknown [10.40.193.141])
        by smtp.corp.redhat.com (Postfix) with SMTP id 747535C277;
        Fri, 12 Feb 2021 21:05:25 +0000 (UTC)
Date:   Fri, 12 Feb 2021 22:05:23 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, jolsa@kernel.org
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: add /libbpf to .gitignore
Message-ID: <YCbtk70AX14hjsyn@krava>
References: <20210212010053.668700-1-sdf@google.com>
 <CAEf4BzZ60LNPpWL6z566hCCF1JkJC=-nZpqg7JQGaHp0rJYGhg@mail.gmail.com>
 <CAKH8qBuRvmW6wyGR4_8xRNY9Bhm-eMN-duKGp14X8ejk1gvsDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuRvmW6wyGR4_8xRNY9Bhm-eMN-duKGp14X8ejk1gvsDw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:56:29AM -0800, Stanislav Fomichev wrote:
> On Fri, Feb 12, 2021 at 11:48 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Feb 11, 2021 at 5:07 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > There is what I see after compiling the kernel:
> >
> > typo: This?
> Yes, sure.
> 
> 
> > >  # bpf-next...bpf-next/master
> > >  ?? tools/bpf/resolve_btfids/libbpf/
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> >
> > Jiri,
> >
> > Is this
> >
> > Fixes: fc6b48f692f8 ("tools/resolve_btfids: Build libbpf and libsubcmd
> > in separate directories")
> >
> > ?
> >
> > Do we need similar stuff for libsubcmd (what's that, btw?)
> It's probably not needed because it has only .o files in there (.o are
> ignored in the root .gitignore).
> I assume libbpf/ has an issue because there is bpf_helper_defs.h in
> that libbpf/ directory.
> Not sure why it was removed in fc6b48f692f8 rather than being prefixed
> with libbpf/ directory.
> I'll leave it up to Jiri to comment.

you're right, thanks for the fix

jirka

> 
> 
> > >  tools/bpf/resolve_btfids/.gitignore | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
> > > index 25f308c933cc..16913fffc985 100644
> > > --- a/tools/bpf/resolve_btfids/.gitignore
> > > +++ b/tools/bpf/resolve_btfids/.gitignore
> > > @@ -1,2 +1,3 @@
> > >  /fixdep
> > >  /resolve_btfids
> > > +/libbpf/
> > > --
> > > 2.30.0.478.g8a0d178c01-goog
> > >
> 

