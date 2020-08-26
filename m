Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5912529EC
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgHZJ0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:26:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728044AbgHZJ0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598433972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ve0BOGipvrEyZNF3unuUB8RSXRaKeLtKF9/koSApImE=;
        b=POorwIMWHQHAoFiIrpVFODHGtqDcBpcVLNOh1nAA4DWJUtABY1OqnDslaEkacwYm8FRE5W
        nxV+Hqj0m5xjrNL2lPcL5j0kj58qBBvpiCn7xvE5y+CNy8LP23SNwvRpq+1/37XRwy6cKG
        IiTGIt94IFcyxEJoyjFwOr+aDaCY89M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-a1Cydz3dOqWdIcbci1LExw-1; Wed, 26 Aug 2020 05:26:07 -0400
X-MC-Unique: a1Cydz3dOqWdIcbci1LExw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE6087309D;
        Wed, 26 Aug 2020 09:26:05 +0000 (UTC)
Received: from krava (unknown [10.40.194.188])
        by smtp.corp.redhat.com (Postfix) with SMTP id DE01F808BF;
        Wed, 26 Aug 2020 09:25:57 +0000 (UTC)
Date:   Wed, 26 Aug 2020 11:25:56 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v12 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200826092556.GA703542@krava>
References: <20200825192124.710397-1-jolsa@kernel.org>
 <20200825192124.710397-11-jolsa@kernel.org>
 <CAADnVQKtE9p22J2stAc6WuGOxkoPdzcAf5DstK6J76-x1thjZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKtE9p22J2stAc6WuGOxkoPdzcAf5DstK6J76-x1thjZA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 03:58:32PM -0700, Alexei Starovoitov wrote:
> On Tue, Aug 25, 2020 at 12:23 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -3655,7 +3668,8 @@ union bpf_attr {
> >         FN(get_task_stack),             \
> >         FN(load_hdr_opt),               \
> >         FN(store_hdr_opt),              \
> > -       FN(reserve_hdr_opt),
> > +       FN(reserve_hdr_opt),            \
> > +       FN(d_path),
> >         /* */
> 
> This is not correct. Please keep "\" at the end.
> I've missed it while applying Martin's patch.
> I've manually rebased this set due to conflict with KP's changes,
> fixed the above issue and applied.

thanks,
jirka

