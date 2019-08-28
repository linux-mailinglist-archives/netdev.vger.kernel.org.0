Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2309FB3A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfH1HMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbfH1HMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 03:12:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2BB218AC6E1;
        Wed, 28 Aug 2019 07:12:40 +0000 (UTC)
Received: from krava (unknown [10.43.17.33])
        by smtp.corp.redhat.com (Postfix) with SMTP id DF9885D6A7;
        Wed, 28 Aug 2019 07:12:37 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:12:37 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: libbpf distro packaging
Message-ID: <20190828071237.GA31023@krava>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
 <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com>
 <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava>
 <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava>
 <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 28 Aug 2019 07:12:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 10:30:24PM +0000, Julia Kartseva wrote:
> On 8/25/19, 11:42 PM, "Jiri Olsa" <jolsa@redhat.com> wrote:
> 
> > On Fri, Aug 23, 2019 at 04:00:01PM +0000, Alexei Starovoitov wrote:
> > > 
> > > Technically we can bump it at any time.
> > > The goal was to bump it only when new kernel is released
> > > to capture a collection of new APIs in a given 0.0.X release.
> > > So that libbpf versions are synchronized with kernel versions
> > > in some what loose way.
> > > In this case we can make an exception and bump it now.
> >
> > I see, I dont think it's worth of the exception now,
> > the patch is simple or we'll start with 0.0.3
> 
> PR introducing 0.0.5 ABI was merged:
> https://github.com/libbpf/libbpf/commit/476e158
> Jiri, you'd like to avoid patching, you can start w/ 0.0.5.
> Also if you're planning to use *.spec from libbpf as a source of truth,
> It may be enhanced by syncing spec and ABI versions, similar to
> https://github.com/libbpf/libbpf/commit/d60f568

cool, anyway I started with v0.0.3 ;-) I'll update
to latest once we are merged in

the spec/srpm is currently under Fedora review:
  https://bugzilla.redhat.com/show_bug.cgi?id=1745478

you can check it in here:
  http://people.redhat.com/~jolsa/libbpf/v2/

I think it's little different from what you have,
but not in the essential parts

jirka
