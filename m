Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B9B171247
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgB0IPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:15:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56420 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726999AbgB0IPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:15:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582791335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7o/p8pDDttSiLBZgxQ9UIjGFY27nTgqHuXNlOOnP6Q0=;
        b=S5B4xWCUT/7IFMrm1fOLHU0gM7/W0TYWK1+4QH0FzIsa8CzRZvKQHGfM1awfdittH3t1lA
        MT/zj1y93gxyB0YoGYReSE5XaaotXkOLPXjB+NrK0DqIHUZU5EDewexa2eLHuwlJ+wz3Yb
        NMm8d/TKiY0lgh4sd5BS2r7B4IsGzzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-wqSCsniaN3GE-JPbLaa2HQ-1; Thu, 27 Feb 2020 03:15:31 -0500
X-MC-Unique: wqSCsniaN3GE-JPbLaa2HQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EE1C107B7D7;
        Thu, 27 Feb 2020 08:15:29 +0000 (UTC)
Received: from krava (ovpn-204-93.brq.redhat.com [10.40.204.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7894E101D487;
        Thu, 27 Feb 2020 08:15:25 +0000 (UTC)
Date:   Thu, 27 Feb 2020 09:15:22 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 05/18] bpf: Add lnode list node to struct bpf_ksym
Message-ID: <20200227080902.GB34774@krava>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-6-jolsa@kernel.org>
 <CAPhsuW6NCwxW2qQCFcA3qGOeyd=qz0ZHQGUidWfO-oXeen0r2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6NCwxW2qQCFcA3qGOeyd=qz0ZHQGUidWfO-oXeen0r2g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 02:51:14PM -0800, Song Liu wrote:
> On Wed, Feb 26, 2020 at 5:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding lnode list node to 'struct bpf_ksym' object,
> > so the symbol itself can be chained and used in other
> > objects like bpf_trampoline and bpf_dispatcher.
> >
> > Changing iterator to bpf_ksym in bpf_get_kallsym.
> >
> > The ksym->start is holding the prog->bpf_func value,
> > so it's ok to use it in bpf_get_kallsym.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> nit: I think we should describe this as "move lnode list node to
> struct bpf_ksym".

true, will change

thanks,
jirka

