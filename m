Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DD9C9CE0
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 13:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbfJCLKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 07:10:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbfJCLKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 07:10:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCF02302C086;
        Thu,  3 Oct 2019 11:10:32 +0000 (UTC)
Received: from krava (unknown [10.43.17.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E1F85D9DC;
        Thu,  3 Oct 2019 11:10:30 +0000 (UTC)
Date:   Thu, 3 Oct 2019 13:10:29 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>
Subject: Re: libbpf distro packaging
Message-ID: <20191003111029.GC23291@krava>
References: <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com>
 <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava>
 <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava>
 <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava>
 <A273A3DB-C63E-488F-BB0C-B7B2AB6D99BE@fb.com>
 <8B38D651-7F77-485F-A054-0519AF3A9243@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8B38D651-7F77-485F-A054-0519AF3A9243@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 03 Oct 2019 11:10:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 12:50:08AM +0000, Julia Kartseva wrote:
> Hi Jiri, 
> 
> v0.0.5 is out: [1] which brings questions regarding further maintenance 
> of rpm. 
> Who'll maintain the most recent version of rpm up-to-date? 

I will do that on fedora/rhel side now

> Are you looking into making the procedure automated and do you need any 
> help from the side of libbpf devs if so? In particular, we can have the *.spec file
> in GH mirror synchronized with the most recent tag so you can take it from the 
> mirror along with tarball.

some notification of new tag/sync would be great

the spec file update is not a big deal because I need to do its
changelog update anyway.. but I can put the fedora rpm spec in
GH repo for reference, I will do a pull request for that

jirka

> Thanks! 
> 
> [1] https://github.com/libbpf/libbpf/releases/tag/v0.0.5
> 
> ﻿On 9/30/19, 11:18 AM, "Julia Kartseva" <hex@fb.com> wrote:
> 
> > Thank you Jiri, that's great news.
> >
> > > On 9/30/19, 4:13 AM, "Jiri Olsa" <jolsa@redhat.com> wrote:
> > >
> > > heya,
> > > FYI we got it through.. there's libbpf-0.0.3 available on fedora 30/31/32
> > > I'll update to 0.0.5 version as soon as there's the v0.0.5 tag available
> 
> 
> 
