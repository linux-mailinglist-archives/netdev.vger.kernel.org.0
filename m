Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB3D8D23
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389956AbfJPKBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbfJPKBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 06:01:49 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 100D510C092B;
        Wed, 16 Oct 2019 10:01:49 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B85C919C70;
        Wed, 16 Oct 2019 10:01:46 +0000 (UTC)
Date:   Wed, 16 Oct 2019 12:01:45 +0200
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
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>
Subject: Re: libbpf distro packaging
Message-ID: <20191016100145.GA15580@krava>
References: <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava>
 <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava>
 <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
 <20191008073958.GA10009@krava>
 <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Wed, 16 Oct 2019 10:01:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 09:14:19PM +0000, Julia Kartseva wrote:
> Hi Jiri,
> 
> systemd folks published libbpf CentOS 7 package in systemd corp repo: [1],
> so guess that proves that deps from other repo are fine.

yea, actualy got request for that:
  https://bugzilla.redhat.com/show_bug.cgi?id=1762219

jirka

> 
> Rebuild is fairly simple: [2]
> 
> [1] https://copr.fedorainfracloud.org/coprs/mrc0mmand/systemd-centos-ci/build/1053694/
> [2] https://github.com/systemd/systemd/pull/13744#issuecomment-541168076
> 
> ﻿On 10/8/19, 12:40 AM, "Jiri Olsa" <jolsa@redhat.com> wrote:
> >
> > On Mon, Oct 07, 2019 at 12:25:51AM +0000, Julia Kartseva wrote:
> > > 
> > > I wonder what are the steps to make libbpf available for CentOS {7|8} as well?
> > > One (likely the quickest) way to do that is to publish it to Fedora's EPEL [1].
> > > 
> > > I have a little concern about dependencies, namely elfutils-libelf-devel and 
> > > elfutils-devel are sourced directly by CentOS repos, e.g. [2], not sure if 
> > > dependencies from another repo are fine.
> > > 
> > > Thoughts? Thanks!
> >
> > I think that should be ok, I'll ask around and let you know
> >
> > jirka
> 
