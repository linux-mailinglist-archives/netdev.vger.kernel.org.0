Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691C52009E7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732379AbgFSNXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:23:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31685 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731131AbgFSNXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592573030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+eZnRC4sP/SOoYZCxHIb5UovNfqBNrjgvKshfNSP+Ag=;
        b=GnYF96lRcz0gsUizCYKAoUbxHIvekcGAJqVir98YNdmCgR0aPEtxhSW5pJeFJ3WKjqu7od
        mJTUw4XZqCUD5qkErqjJBo4CYBjzm/ghl7TCXYUNSqHobAxaK4bxvd3LpwUwOFTsNdLVGz
        jCqIZgCKD9ghSBv08Gwu7ayKLD0z+YY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-lwrsy50MMM6Nhq08SMJsvQ-1; Fri, 19 Jun 2020 09:23:46 -0400
X-MC-Unique: lwrsy50MMM6Nhq08SMJsvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 197B119057DA;
        Fri, 19 Jun 2020 13:23:35 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id BA64090343;
        Fri, 19 Jun 2020 13:23:31 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:23:30 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 06/11] bpf: Do not pass enum bpf_access_type to
 btf_struct_access
Message-ID: <20200619132330.GH2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-7-jolsa@kernel.org>
 <CAEf4BzY7207CWet_csENUznXESvy9SrQnfzu0PCXmAdHUO0rJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY7207CWet_csENUznXESvy9SrQnfzu0PCXmAdHUO0rJw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 08:58:06PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > There's no need for it.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> It matches bpf_verifier_ops->btf_struct_access, though, which, I
> think, actually allows write access for some special cases. So I think
> we should keep it.

ok, will keep it

jirka

> 
> >  include/linux/bpf.h   | 1 -
> >  kernel/bpf/btf.c      | 3 +--
> >  kernel/bpf/verifier.c | 2 +-
> >  net/ipv4/bpf_tcp_ca.c | 2 +-
> >  4 files changed, 3 insertions(+), 5 deletions(-)
> >
> 
> [...]
> 

