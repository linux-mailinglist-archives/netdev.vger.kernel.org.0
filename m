Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBED037F319
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhEMGcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230478AbhEMGcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 02:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 976566140C;
        Thu, 13 May 2021 06:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620887468;
        bh=oUUxSFKC5Esvog88XM0Ob0aPuROiYlnR/XXefgK7lT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kB0UKNEQJ6A+GeMmTSeJV0fSXT9weoPlMiMUMPeQS3EhVZTQYY84NAteMtnxBg4nx
         BK/LwCJC1JqOGFZkErj36T4DRs5qQUq+6D6/n7ZvlFtXkHXVgElEsBrxvdmx4IVsMY
         jPpFzs/08SIzkmtUX+9rSI7WSTk0Gq2aD9gPW4Y+sE8rvsIwYSqPgeGq/o5QTcLQ7G
         8ri3Pqb2d0AJsBTsZisa1ahveRgDhamwHTU4yztJn+xy1ZO/qVAOLPtCk2hkHkM0Rj
         DT8hjfeBTRHm/WfwwGphobLUZy7PjOaUqVbpNsxHPxfdXZ2ADtywOs1jRbdBuPRDA6
         95HM7w5mycgww==
Date:   Thu, 13 May 2021 09:31:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/1] libbpf: Delete an unneeded bool conversion
Message-ID: <YJzHqFMitQ7B8weq@unreal>
References: <20210510124315.3854-1-thunder.leizhen@huawei.com>
 <CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com>
 <YJoRd4reWa1viW76@unreal>
 <CAEf4BzaYsjWh_10a4yeSVpAAwC-f=zUNANb10VN2xZ1b5dsY-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaYsjWh_10a4yeSVpAAwC-f=zUNANb10VN2xZ1b5dsY-A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 12:02:11PM -0700, Andrii Nakryiko wrote:
> On Mon, May 10, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, May 10, 2021 at 11:00:29AM -0700, Andrii Nakryiko wrote:
> > > On Mon, May 10, 2021 at 5:43 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
> > > >
> > > > The result of an expression consisting of a single relational operator is
> > > > already of the bool type and does not need to be evaluated explicitly.
> > > >
> > > > No functional change.
> > > >
> > > > Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> > > > ---
> > >
> > > See [0] and [1].
> > >
> > >   [0] https://lore.kernel.org/bpf/CAEf4BzYgLf5g3oztbA-CJR4gQ7AVKQAGrsHWCOgTtUMUM-Mxfg@mail.gmail.com/
> > >   [1] https://lore.kernel.org/bpf/CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com/
> >
> > How long do you plan to fight with such patches?
> 
> As long as necessary. There are better ways to contribute to libbpf
> than doing cosmetic changes to the perfectly correct code.

I wish you good luck with that.

My hope that, you have enough spare time to invest in rejects.

Thanks
