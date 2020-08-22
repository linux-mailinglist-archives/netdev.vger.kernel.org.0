Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A422924E8DD
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgHVQeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 12:34:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38276 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgHVQeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 12:34:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9WT2-00AlKV-4c; Sat, 22 Aug 2020 18:34:08 +0200
Date:   Sat, 22 Aug 2020 18:34:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [EXT] Re: [net-next v4 1/6] net: marvell: prestera: Add driver
 for Prestera family ASIC devices
Message-ID: <20200822163408.GG2347062@lunn.ch>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li>
 <20200814082054.GD17795@plvision.eu>
 <20200814120536.GA26106@earth.li>
 <20200814122744.GF17795@plvision.eu>
 <20200814131815.GA2238071@lunn.ch>
 <20200820083131.GA28129@plvision.eu>
 <BN6PR18MB1587EB225C6B80BF35A44EBFBA5A0@BN6PR18MB1587.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR18MB1587EB225C6B80BF35A44EBFBA5A0@BN6PR18MB1587.namprd18.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:00:21AM +0000, Mickey Rachamim wrote:

> > ASIC device specific handling is serviced by the firmware, current
> > driver's logic does not have PP specific code and relies on the FW
> > ABI which is PP-generic, and it looks like this how it should work
> > for boards with other ASICs, of course these boards should follow
> > the Marvell's Switchdev board design.  >
>
> All Marvell Prestera (DX) devices are all based on CPSS SDK. This is one SDK 
> and one build procedure that enables the Prestera driver to support all devices. 
> This unified support enables us (and our customers) to have one SW 
> implementation that will support variety of Prestera devices in same build/real-time 
> execution. 
> This approach also lead us with the implementation of the Prestera Switchdev drivers.
> As having detailed familiarity (20Y) with Marvell Prestera old/current/future devices - 
> this approach will be kept strictly also on the future.

So if i understand this correctly, the compatibility is not to
Prestera, but to the firmware running on the Prestera? You want to
express a compatibility to the ABI this firmware supports for the
switchdev driver to use?

	  Andrew
