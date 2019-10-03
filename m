Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1EB4CACCE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfJCR3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730558AbfJCR3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 13:29:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5CE41DB8;
        Thu,  3 Oct 2019 17:29:45 +0000 (UTC)
Received: from krava (ovpn-204-51.brq.redhat.com [10.40.204.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A19A60BEC;
        Thu,  3 Oct 2019 17:29:39 +0000 (UTC)
Date:   Thu, 3 Oct 2019 19:29:38 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Julia Kartseva <hex@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>
Subject: Re: libbpf distro packaging
Message-ID: <20191003172938.GA17036@krava>
References: <20190823092253.GA20775@krava>
 <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava>
 <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava>
 <A273A3DB-C63E-488F-BB0C-B7B2AB6D99BE@fb.com>
 <8B38D651-7F77-485F-A054-0519AF3A9243@fb.com>
 <20191003111029.GC23291@krava>
 <CAEf4BzamREOTYvspbg5yp1igg8pY_0MQu93Y34w1t_WT9VJXNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzamREOTYvspbg5yp1igg8pY_0MQu93Y34w1t_WT9VJXNg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 03 Oct 2019 17:29:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 09:24:21AM -0700, Andrii Nakryiko wrote:
> On Thu, Oct 3, 2019 at 4:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Oct 03, 2019 at 12:50:08AM +0000, Julia Kartseva wrote:
> > > Hi Jiri,
> > >
> > > v0.0.5 is out: [1] which brings questions regarding further maintenance
> > > of rpm.
> > > Who'll maintain the most recent version of rpm up-to-date?
> >
> > I will do that on fedora/rhel side now
> >
> > > Are you looking into making the procedure automated and do you need any
> > > help from the side of libbpf devs if so? In particular, we can have the *.spec file
> > > in GH mirror synchronized with the most recent tag so you can take it from the
> > > mirror along with tarball.
> >
> > some notification of new tag/sync would be great
> 
> Hey Jiri! You can watch Github repo for new releases, see
> https://help.github.com/en/articles/watching-and-unwatching-releases-for-a-repository.

cool, I was hoping there's something like this

thanks,
jirka

> 
> >
> > the spec file update is not a big deal because I need to do its
> > changelog update anyway.. but I can put the fedora rpm spec in
> > GH repo for reference, I will do a pull request for that
> >
> > jirka
> >
> > > Thanks!
> > >
> > > [1] https://github.com/libbpf/libbpf/releases/tag/v0.0.5
> > >
> > > ﻿On 9/30/19, 11:18 AM, "Julia Kartseva" <hex@fb.com> wrote:
> > >
> > > > Thank you Jiri, that's great news.
> > > >
> > > > > On 9/30/19, 4:13 AM, "Jiri Olsa" <jolsa@redhat.com> wrote:
> > > > >
> > > > > heya,
> > > > > FYI we got it through.. there's libbpf-0.0.3 available on fedora 30/31/32
> > > > > I'll update to 0.0.5 version as soon as there's the v0.0.5 tag available
> > >
> > >
> > >
