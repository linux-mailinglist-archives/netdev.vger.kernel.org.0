Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4543DCF412
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 09:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbfJHHkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 03:40:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbfJHHkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 03:40:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47B3431752A4;
        Tue,  8 Oct 2019 07:40:01 +0000 (UTC)
Received: from krava (unknown [10.40.205.107])
        by smtp.corp.redhat.com (Postfix) with SMTP id CC64519C68;
        Tue,  8 Oct 2019 07:39:58 +0000 (UTC)
Date:   Tue, 8 Oct 2019 09:39:58 +0200
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
Message-ID: <20191008073958.GA10009@krava>
References: <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com>
 <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava>
 <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava>
 <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 08 Oct 2019 07:40:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 12:25:51AM +0000, Julia Kartseva wrote:
> On 9/30/19, 4:13 AM, "Jiri Olsa" <jolsa@redhat.com> wrote:
> 
> > heya,
> > FYI we got it through.. there's libbpf-0.0.3 available on fedora 30/31/32
> > I'll update to 0.0.5 version as soon as there's the v0.0.5 tag available
> >
> > jirka
> 
> Hi Jiri,
> 
> I wonder what are the steps to make libbpf available for CentOS {7|8} as well?
> One (likely the quickest) way to do that is to publish it to Fedora's EPEL [1].
> 
> I have a little concern about dependencies, namely elfutils-libelf-devel and 
> elfutils-devel are sourced directly by CentOS repos, e.g. [2], not sure if 
> dependencies from another repo are fine.
> 
> Thoughts? Thanks!

I think that should be ok, I'll ask around and let you know

jirka
