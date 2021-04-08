Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6D835805B
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 12:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhDHKNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 06:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229686AbhDHKNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 06:13:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617876770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dr01o9K3Bx3QHEmYkyavdQFTzMgpbxW4QsI0iwEohHU=;
        b=LSF0VhZZbcHYw6s7KKiVCnmon1SDfFYflWGTnS9y36bJAPao8cskLEJqskwi1HIvf8pKWk
        iGf837LQQD34WG629YKtoXWfqOOeA0bWMB5pdTEeYQ6zVfZUhoB8A5VLZ5GYElKtyZjiME
        ApUr3fP5Dz+D/2Gbc8UZeKx0ICatZa8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-SDxJKdRhM_ic3c-tYPC3qA-1; Thu, 08 Apr 2021 06:12:46 -0400
X-MC-Unique: SDxJKdRhM_ic3c-tYPC3qA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3F7010054F6;
        Thu,  8 Apr 2021 10:12:44 +0000 (UTC)
Received: from krava (unknown [10.40.195.201])
        by smtp.corp.redhat.com (Postfix) with SMTP id D2DC05D9CA;
        Thu,  8 Apr 2021 10:12:34 +0000 (UTC)
Date:   Thu, 8 Apr 2021 12:12:34 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Subject: Re: WARNING net/core/stream.c:208 when running test_sockmap
Message-ID: <YG7XEk+8ueMjJrzl@krava>
References: <YG3SuK4W/N9jqknL@krava>
 <CAM_iQpUdbsf97g8X=K7wKnGu1mmfuu7bseHdtaQ_uvo1XOmG_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUdbsf97g8X=K7wKnGu1mmfuu7bseHdtaQ_uvo1XOmG_A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 04:14:27PM -0700, Cong Wang wrote:
> On Wed, Apr 7, 2021 at 2:22 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > hi,
> > I'm getting couple of WARNINGs below when running
> > test_sockmap on latest bpf-next/master, like:
> >
> >   # while :; do ./test_sockmap ; done
> >
> > The warning is at:
> >   WARN_ON(sk->sk_forward_alloc);
> >
> > so looks like some socket allocation math goes wrong.
> 
> This one should be fixed by:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=144748eb0c445091466c9b741ebd0bfcc5914f3d
> 
> So please try the latest bpf branch.

awesome, thanks

jirka

