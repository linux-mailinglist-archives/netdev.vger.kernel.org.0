Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7E2D2FEE
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgLHQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730485AbgLHQj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 11:39:59 -0500
Date:   Tue, 8 Dec 2020 08:39:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607445559;
        bh=V3jtE5Rj0yT33lsVOmvjRycj6nIpuV8ZK/MuDRauTQ0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=SjptGkvQmdXvrgLXTuFobE+o33StNIQWJsQkGIOziv40BSejRIHxw1zHY5GpKM1ax
         x985APBL/JXGSDg9bUeounyNvzn+AQfpL1vU5oZR2HNwgKmR+PrXv1eQbFC+QR/5gR
         SIRHloJuiUHaNQ4xnZe9+wX3anCX/9pud3jAKVCwvZdK3LPzxpa0zqpkgEvpeCo+dV
         IC/EFn2tXsAHaEvF7VRVwVlnodn0UFXn2sYHyoRs9DP2/3ZQfSU1zVEcqI6PHE7Sk9
         /qQoIAdrqxyn5XfBx3y2tDu835ifbtdPuZm3NNc6At7fbmha6nS4XNkymOC/yzGmSR
         DayQn6xtiBEmg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell
 Prestera Ethernet Switch driver
Message-ID: <20201208083917.0db80132@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20201205164300.28581-1-mickeyr@marvell.com>
        <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 09:22:52 +0000 Mickey Rachamim wrote:
> > > +S:	Supported
> > > +W:	http://www.marvell.com  
> > 
> > The website entry is for a project-specific website. If you have a link to a site with open resources about the chips/driver that'd be great, otherwise please drop it. Also https is expected these days ;)  
> 
> Can I placed here the Github project link?
> https://github.com/Marvell-switching/switchdev-prestera

Yes!
