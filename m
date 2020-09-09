Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A384262858
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgIIHTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgIIHTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599635974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4/Zhf5Z+jZ436SZtx+o89mZ+e13eKs2R9HrVqMiSNpw=;
        b=cJm8cw4jENeQgto9zKC/OqMZQVDvWGu9/66bBU9uoFRD80NKUYW7FcBvJeHTW4QiU7vSGJ
        1I6/nqGaAc44t4phcrATs4eJqt9xGMxDqfk8HlY/koEMr1IXcDv6cYZXiw/EJlnp3XaLF9
        oXSs+Di0EL54CSnhol8ReXHd+tGI+fI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-vgLGSoqxNfKm1BQ10I75BA-1; Wed, 09 Sep 2020 03:19:26 -0400
X-MC-Unique: vgLGSoqxNfKm1BQ10I75BA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CFFB801AFF;
        Wed,  9 Sep 2020 07:19:24 +0000 (UTC)
Received: from krava (unknown [10.40.194.91])
        by smtp.corp.redhat.com (Postfix) with SMTP id 654945D9E8;
        Wed,  9 Sep 2020 07:19:21 +0000 (UTC)
Date:   Wed, 9 Sep 2020 09:19:20 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] perf tools: Do not use deprecated bpf_program__title
Message-ID: <20200909071920.GA1498025@krava>
References: <20200907110237.1329532-1-jolsa@kernel.org>
 <CAEf4BzZpD2mjEA2Qo2cZ4Bp01fSwZkMPFAZOSw8VvOSAqOWNsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZpD2mjEA2Qo2cZ4Bp01fSwZkMPFAZOSw8VvOSAqOWNsA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 01:11:36PM -0700, Andrii Nakryiko wrote:
> On Mon, Sep 7, 2020 at 10:57 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The bpf_program__title function got deprecated in libbpf,
> > use the suggested alternative.
> >
> > Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> Hey Jiri,
> 
> Didn't see your patch before I sent mine against bpf-next. I also
> removed some unnecessary checks there. Please see [0]. I don't care
> which one gets applied, btw.
> 
>   [0] https://patchwork.ozlabs.org/project/netdev/patch/20200908180127.1249-1-andriin@fb.com/

perfect, let's take yours with that extra check removed

thanks,
jirka

> 
> >  tools/perf/util/bpf-loader.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> > index 2feb751516ab..73de3973c8ec 100644
> > --- a/tools/perf/util/bpf-loader.c
> > +++ b/tools/perf/util/bpf-loader.c
> > @@ -328,7 +328,7 @@ config_bpf_program(struct bpf_program *prog)
> >         probe_conf.no_inlines = false;
> >         probe_conf.force_add = false;
> >
> > -       config_str = bpf_program__title(prog, false);
> > +       config_str = bpf_program__section_name(prog);
> >         if (IS_ERR(config_str)) {
> >                 pr_debug("bpf: unable to get title for program\n");
> >                 return PTR_ERR(config_str);
> > @@ -454,7 +454,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
> >         if (err) {
> >                 const char *title;
> >
> > -               title = bpf_program__title(prog, false);
> > +               title = bpf_program__section_name(prog);
> >                 if (!title)
> >                         title = "[unknown]";
> >
> > --
> > 2.26.2
> >
> 

