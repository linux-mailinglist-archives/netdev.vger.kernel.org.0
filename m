Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595531AAB8B
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393206AbgDOPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 11:12:40 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:43861 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732251AbgDOPMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 11:12:39 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 6CFA91002B624;
        Wed, 15 Apr 2020 17:12:37 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id EC70D140759; Wed, 15 Apr 2020 17:12:36 +0200 (CEST)
Date:   Wed, 15 Apr 2020 17:12:36 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V4 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
Message-ID: <20200415151236.ii5hib25eslbvmfk@wunner.de>
References: <20200415143909.wmtmud3vkkwzjv73@wunner.de>
 <ac0f7227-a4ae-b6cd-36ec-3bcb02b1adbe@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac0f7227-a4ae-b6cd-36ec-3bcb02b1adbe@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 04:51:39PM +0200, Marek Vasut wrote:
> On 4/15/20 4:39 PM, Lukas Wunner wrote:
> I reinstated the indirect access, so things did change. Besides, there
> performance for the parallel option is back where it was with the old
> driver, which is important for me.

Okay, I see.


> > We're using CONFIG_PREEMPT_RT_FULL=y.  I'm sorry for not mentioning this
> > earlier, I didn't assume it would make such a big difference but
> > apparently it does.
> 
> Do you also have the RT patch applied ?

Yes, the branch I linked to also contains the RT patches.


> > This is the branch I've tested today:
> > https://github.com/l1k/linux/commits/revpi-4.19-marek-v4
> 
> You seem to have quite a few more patches in that repository than just
> this series, some of them even touching the RPi SPI driver and it's DMA
> implementation.

Those are just the patches I mainlined, but backported to v4.19.
This branch is based on the Raspberry Pi Foundation's downstream
repository, they still ship v4.19.  Their repo has more performant
drivers for USB, SD/MMC etc. which haven't been mainlined yet.
But the SPI portion is the same as in mainline because I always
submit to mainline and let the patches percolate down to their repo.


> > > I used two different drivers -- the iMX SPI and the STM32 SPI -- I would
> > > say that if both show the same behavior, it's unlikely to be the driver.
> > 
> > Hm, so why did it work with the RasPi but not with the others?
> 
> I didn't have a chance to debug this yet.

I was just curious if those drivers don't work as well as the one
for the RasPi. :-)  That would be funny because the RasPi is generally
considered a toy in the embedded space and the platforms you've
mentioned are taken more seriously I think.

Thanks,

Lukas
