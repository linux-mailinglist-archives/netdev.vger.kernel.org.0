Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9045E700
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 06:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhKZFDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 00:03:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231262AbhKZFBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 00:01:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 118C861074;
        Fri, 26 Nov 2021 04:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637902681;
        bh=PnGWcu/XiLYTY1tgPOz0rl1I8W4zRGSltZPcpTS+LM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RnIFvgvCIWbxRtSjtrZWhPsnnlSKsee1IGTey5VpkLvF9u8DMIJ/Es7k+syX7gk4I
         FLNFtBs14sOy/izn8DUOGJPZF9xue3xq4JCkIOTOKq4kv2oJRrgGbK7Itae8tQmKFe
         90F5/muMHXsk2bcTDDqiNmRRnIDGQo7RYIH6Y89S2ACoMEMmD0oqtBSGT/9Iun2CJa
         i7me+Q/q9Car/3I9rM0RgCqGvxdsPzcTSZ9MuLYdfllvBzbXMX9k+yfF5/DFJ1rLvT
         nWWFHRrVGRXyCMncU+aGzFfHWwQz+AtDPcV9kGsIQW5dqFJXiceL3lK1KBFrV1tGj2
         qPB6eylW+cboA==
Date:   Thu, 25 Nov 2021 20:58:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP
 VF devices
Message-ID: <20211125205800.74e1b07b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+sq2CdrO-Zsf5zAj9UbAqVpKdbxeP+QoDAJ6dK2hwDmmuQQ8A@mail.gmail.com>
References: <20211125021822.6236-1-radhac@marvell.com>
        <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
        <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com>
        <20211125070812.1432d2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY3PR18MB47374C791CA6CA0E3CB4C528C6639@BY3PR18MB4737.namprd18.prod.outlook.com>
        <CA+sq2CdrO-Zsf5zAj9UbAqVpKdbxeP+QoDAJ6dK2hwDmmuQQ8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 09:44:10 +0530 Sunil Kovvuri wrote:
> > Nope, I have not accepted that. I was just too lazy to send a revert
> > after it was merged.
> 
> What is the objection here ?
> Is kernel netdev not supposed to be used with-in end-point ?

Yes.

> If customers want to use upstream kernel with-in endpoint and not
> proprietary SDK, why to impose restrictions.

Because our APIs and interfaces have associated semantics. That's
the primary thing we care about upstream. You need to use or create
standard interfaces, not come up with your own thing and retrofit it
into one of the APIs. Not jam PTP configuration thru devlink params,
or use netdevs to talk to your FW because its convenient. Trust me,
you're not the first one to come up with this idea.

Frankly if the octeontx2 team continues on its current path I think
the driver should be removed. You bring no benefit to the community
I don't see why we'd give you the time of day.
