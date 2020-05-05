Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBFB1C5908
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgEEOVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730604AbgEEOVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:21:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ADBC061A10;
        Tue,  5 May 2020 07:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vgLgwA2IYB8xZ+i4x2z61nR3kQ321LSxvjJp90lZwhk=; b=emwvWX7QcAOvZyEwWRtlY3u75
        YrX1Uqcns0qRJwr2MAlCIPi+uSNplwaVui1xMGOENdmL8I4P9spu4Wg9JZR987liWr7K4Cq6lnbum
        lZacolR99lTdruHc1EjyNWly0E96wof1BEtJwXJt2x0c/aGPzrmUF0c8Plw+2LUmlnn1tInPcokgV
        wJxC3v7fjOvva8xRJ/NR74yaGtk8quY9LvGwS0tX+jNMfYeHtQDUVkh3/qOhuVg5qDSxg2waIb45O
        JA6aeyCKI/Hm9AAJRA5+2a3cAakP5gMaXnONZgVJIGJMNjORsxoER52ZwVnZHJn2GtWd2zJQ712nw
        9o8G9Wdkg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:36328)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jVyRI-0002rx-5s; Tue, 05 May 2020 15:20:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jVyRC-0007Dj-U4; Tue, 05 May 2020 15:20:46 +0100
Date:   Tue, 5 May 2020 15:20:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200505142046.GI1551@shell.armlinux.org.uk>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <CAHp75VfQ_ueABUcgUUirQ7kK60CR6vMi1gP-UsdDd+UmsSE4Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfQ_ueABUcgUUirQ7kK60CR6vMi1gP-UsdDd+UmsSE4Sw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 05:15:16PM +0300, Andy Shevchenko wrote:
> On Tue, May 5, 2020 at 4:29 PM Calvin Johnson
> > +               if (sscanf(cp, "ethernet-phy-id%4x.%4x",
> > +                          &upper, &lower) == 2) {
> 
> > +                       *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> 
> How upper can be bigger than 0xfff? Same for lower.

I think your comment is incorrect here.  Four hex digits can be larger
than 0xfff.  "1000" interpreted as hex is four hex digits and larger
than 0xfff, for example.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
