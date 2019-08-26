Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666489C992
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbfHZGmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbfHZGmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 02:42:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA99D8CF1AB;
        Mon, 26 Aug 2019 06:42:38 +0000 (UTC)
Received: from krava (ovpn-204-184.brq.redhat.com [10.40.204.184])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2572B600C4;
        Mon, 26 Aug 2019 06:42:35 +0000 (UTC)
Date:   Mon, 26 Aug 2019 08:42:35 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Julia Kartseva <hex@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: libbpf distro packaging
Message-ID: <20190826064235.GA17554@krava>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
 <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com>
 <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava>
 <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Mon, 26 Aug 2019 06:42:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 04:00:01PM +0000, Alexei Starovoitov wrote:
> On 8/23/19 2:22 AM, Jiri Olsa wrote:
> > btw, the libbpf GH repo tag v0.0.4 has 0.0.3 version set in Makefile:
> > 
> >    VERSION = 0
> >    PATCHLEVEL = 0
> >    EXTRAVERSION = 3
> > 
> > current code takes version from libbpf.map so it's fine,
> > but would be great to start from 0.0.5 so we don't need to
> > bother with rpm patches.. is 0.0.5 planned soon?
> 
> Technically we can bump it at any time.
> The goal was to bump it only when new kernel is released
> to capture a collection of new APIs in a given 0.0.X release.
> So that libbpf versions are synchronized with kernel versions
> in some what loose way.
> In this case we can make an exception and bump it now.

I see, I dont think it's worth of the exception now,
the patch is simple or we'll start with 0.0.3

jirka
