Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2351E3134
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbgEZV3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389025AbgEZV3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:29:43 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BE9C061A0F;
        Tue, 26 May 2020 14:29:42 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id dh1so10191725qvb.13;
        Tue, 26 May 2020 14:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GUKVFk/6zg8e24EMsItEJum+6uy8m8KoXWjqefEDVIg=;
        b=i7s5LM8BREgS3PAf1BOwkR81AyFmy4jAcxKXExtgtSzwVvBmTlF88JD8aPwew1dVZv
         FSKExR82mtRVBmz9N8dD+il6B1UwKdu+P+PiB1BYbSE1BIXIyvDPRTImhrXJB6pu/e8c
         eLTKzQcohp3pxXbtV0CLVRcTF2eXO8z2dmmWN+bRNfl1lLF8pHSah6BvIxtSpT+70nbQ
         R8pqWsRDM57jkL9zT28mvPYAoND7Vz31tS8U3y7kH1rR+hoHr4UGhR6P/Hq/3XpoFVQR
         cKwuIH66wpH1xHbsLsTX+sppP7dMLDDwLXP6S28QIczaMRcVmimDhbWYe2Oh8jk7xoRK
         1nmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GUKVFk/6zg8e24EMsItEJum+6uy8m8KoXWjqefEDVIg=;
        b=LUltgkXFMqLivWoUwXJfO8YVjX6am1c+OGVfYd99ioNJ+emLqmAIHTwyyei8Z67K/x
         b9L7ThGDaXRIlTXPGJqLEoyV/QPw4dl+E8u/tJckvph+DUuAJFP9/dzg4REO0N2QPR8d
         CIYc+CNwaperKyresVJ9fhaQvfWPWBwE+A+HiocoqglzXjFjNaUsuaPs2vImtIgJczsY
         kNI0nhxZgCq2ts44IYsvJnqesyDP+BoARbQS+HVfhbM4wt/ezyTWQStVXzteQ+Uj3Epd
         b/YkSLweYHzD8JBDdJVmcdLc/23+UM71OwceHXtetRK9AeZYRqbT3I0oSvm+A/Z7eU3L
         GSYw==
X-Gm-Message-State: AOAM530ExV6ATpzPsDZwnPqRNr0Wc362ccQV3mlViVYgPZGpCT3v2Mlg
        rp6+OFatVb1BOP3xV8Gtu4FoflsHRmOGMg/vpUk=
X-Google-Smtp-Source: ABdhPJyqAxP0EiYGoXZPYVeXHvGV+gzu/9say0vy0n2jmLdALsOUlDji1Y88fuqltWa69vLKQh8+Foaivvy2KSCPUSE=
X-Received: by 2002:ad4:588c:: with SMTP id dz12mr22217780qvb.196.1590528582079;
 Tue, 26 May 2020 14:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
 <48c47712-bba1-3f53-bbeb-8a7403dab6db@iogearbox.net> <5ecc4d3c78c9e_718d2b15b962e5b845@john-XPS-13-9370.notmuch>
 <CAEf4BzZ0b_UyxzyE-8+3oWSieutWov1UuVJ5Ugpn0yx8qeYNrA@mail.gmail.com> <5ecd8135d7ab4_35792ad4115a05b8d@john-XPS-13-9370.notmuch>
In-Reply-To: <5ecd8135d7ab4_35792ad4115a05b8d@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 14:29:31 -0700
Message-ID: <CAEf4Bzb7e=dpv7hP4SfLARpkDw1uTAeASRHEp9gBuK1Od=sqaA@mail.gmail.com>
Subject: Re: [bpf-next PATCH v5 1/5] bpf, sk_msg: add some generic helpers
 that may be useful from sk_msg
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 1:51 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Mon, May 25, 2020 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Daniel Borkmann wrote:
> > > > On 5/24/20 6:50 PM, John Fastabend wrote:
> > > > > Add these generic helpers that may be useful to use from sk_msg programs.
> > > > > The helpers do not depend on ctx so we can simply add them here,
> > > > >
> > > > >   BPF_FUNC_perf_event_output
> > > > >   BPF_FUNC_get_current_uid_gid
> > > > >   BPF_FUNC_get_current_pid_tgid
> > > > >   BPF_FUNC_get_current_comm
> > > >
> > > > Hmm, added helpers below are what you list here except get_current_comm.
> > > > Was this forgotten to be added here?
> > >
> > > Forgot to update commit messages. I dropped it because it wasn't clear to
> > > me it was very useful or how I would use it from this context. I figure we
> > > can add it later if its needed.
> >
> > But it's also not harmful in any way and is in a similar group as
> > get_current_pid_tgid. So let's add it sooner rather than later. There
> > is no cost in allowing this, right?
> >
>
> It shouldn't cost anything only thing is I have code that runs the other
> three that has been deployed, at least into a dev environment, so I know
> its useful and works.
>
> How about we push it as a follow up? I can add it and do some cleanups
> on the CHECK_FAILs tonight.

Sure, no worries, works for me.

>
> Thanks,
> John
