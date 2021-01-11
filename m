Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808042F1FB6
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389284AbhAKTqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730411AbhAKTqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:46:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F8EC22BEF;
        Mon, 11 Jan 2021 19:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610394331;
        bh=njUGXtKyYiq72a/q8rXJcidO+FS+ACj/DEj+uKmxeXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=trib7jUSgiyKXunuLQ1P0Rg5E110OU6FziStA377xxHrKpJdyz9yVvTjyNEg53fL/
         ZPQCccOYJcU0pyYm+nhCM+setnXLoOZtV+YNMzrV8KwlfWTCOzAbWOQP8SwbJJsNe5
         vmfLLZbngTfw+e187Bw3SAWjCZuccVGr4uvKdL0ZPnP+pL3p+qxuba9VHgXslKjYx2
         /u4fDCFkH5VC2nsX02dEKz/iXrmVhZ+wwyAAaYmaazecf3xH+54qlgZOaQmjI5woxa
         4sDQX00vPIMJ1Zd3Ew5h/Q7BYeahRC4jx987Xutr/WtKqJqL4PKRFJobs5gd3ZMKd3
         ShNi7ZWBu2trg==
Date:   Mon, 11 Jan 2021 11:45:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Joe Perches <joe@perches.com>, davem@davemloft.net,
        netdev@vger.kernel.org, corbet@lwn.net,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Subject: Re: [PATCH net 6/9] MAINTAINERS: mtk-eth: remove Felix
Message-ID: <20210111114530.030a4983@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <21afd8f4-fce4-65af-4b14-7a461e8a504f@nbd.name>
References: <20210111052759.2144758-1-kuba@kernel.org>
        <20210111052759.2144758-7-kuba@kernel.org>
        <c5d10d66321ee8b58263d6d9fce6c34e99d839e8.camel@perches.com>
        <20210111094137.0ead3481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <21afd8f4-fce4-65af-4b14-7a461e8a504f@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 20:21:23 +0100 Felix Fietkau wrote:
> On 2021-01-11 18:41, Jakub Kicinski wrote:
> > On Sun, 10 Jan 2021 21:45:46 -0800 Joe Perches wrote: =20
> >> On Sun, 2021-01-10 at 21:27 -0800, Jakub Kicinski wrote: =20
> >> > Drop Felix from Mediatek Ethernet driver maintainers.
> >> > We haven't seen any tags since the initial submission.   =20
> >> [] =20
> >> > diff --git a/MAINTAINERS b/MAINTAINERS   =20
> >> [] =20
> >> > @@ -11165,7 +11165,6 @@ F:	Documentation/devicetree/bindings/dma/mtk=
-*
> >> > =C2=A0F:	drivers/dma/mediatek/
> >> > =C2=A0
> >> >=20
> >> > =C2=A0MEDIATEK ETHERNET DRIVER
> >> > -M:	Felix Fietkau <nbd@nbd.name>
> >> > =C2=A0M:	John Crispin <john@phrozen.org>
> >> > =C2=A0M:	Sean Wang <sean.wang@mediatek.com>
> >> > =C2=A0M:	Mark Lee <Mark-MC.Lee@mediatek.com>   =20
> >>=20
> >> I think your script is broken as there are multiple subdirectories
> >> for this entry and  =20
> >=20
> > Quite the opposite, the script intentionally only counts contributions
> > only to the code under the MAINTAINERS entry. People lose interest and
> > move on to working on other parts of the kernel (or maybe were never
> > that interested in maintaining something in the first place?).=20
> >=20
> > We want to list folks who are likely to give us reviews.
> >  =20
> >> Felix is active. =20
> >=20
> > Which I tried to state in the commit message as well :) =20
> Sorry for the delayed response. I'm going to submit a bunch of work on
> this driver in the near future.
> The patches have already been written, just need a bit more time for
> testing/review.

Great, I'll drop this patch from the series.=20

Thanks!
