Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366689C0BD
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 00:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfHXWbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 18:31:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54058 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfHXWbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 18:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0P9kq7rO9q6BZvVdrWv6/VLTzkv+c7sSgMh3X9sSgj4=; b=WurvjCu2wGq2loRlkOquX6nOV
        zdbMPRjNKc8M08ZT4mP9gXJewORGnh+wClTJsI0T3ZIKdOf1kwTh/M33iM3GuCmqv8UObI5DXd8i6
        pMoJRc7+NIQ0zz9wg9Vc3UFEXqRnsptRhqAuKyPr0beR7ue1hbYKqLtfX3zDv6ElvdUyDqSRWaXzC
        vSzgaFACTkfh8dSaMU77IjBEuKBONLgt5qlJkbnYIvm8pLX/lzdI28KyQ2eOSRANlzJrX6nrMDckT
        /IqRPFjoX6gEtjRMMLQmLijk8mBKXPkt291LOuMn1srN6iGr+eFAkKAhq7/kIH8ObQ1UlT5QzZs9g
        URd1ylAtA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54164)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i1eZM-0005W5-D1; Sat, 24 Aug 2019 23:31:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i1eZK-0002yi-27; Sat, 24 Aug 2019 23:31:34 +0100
Date:   Sat, 24 Aug 2019 23:31:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        sean.wang@mediatek.com, linux-mips@vger.kernel.org,
        opensource@vdorst.com, linux-mediatek@lists.infradead.org,
        john@phrozen.org, matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK and
 add support for port 5
Message-ID: <20190824223133.GH13294@shell.armlinux.org.uk>
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190822.162047.1140525762795777800.davem@davemloft.net>
 <20190823010928.GK13020@lunn.ch>
 <20190824.141803.1656753287804303137.davem@davemloft.net>
 <20190824221519.GF8251@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824221519.GF8251@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 12:15:19AM +0200, Andrew Lunn wrote:
> 65;5402;1cOn Sat, Aug 24, 2019 at 02:18:03PM -0700, David Miller wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > Date: Fri, 23 Aug 2019 03:09:28 +0200
> > 
> > > That would be Russell.
> > > 
> > > We should try to improve MAINTAINER so that Russell King gets picked
> > > by the get_maintainer script.
> > 
> > Shoule he be added to the mt7530 entry?
> 
> Hi David
> 
> No. I think we need a phylink entry. And then make use of the K: line
> format to list keywords. I hope that even though changes like this
> don't touch any files listed as being part of phylink, they will match
> the keyword and pickup Russell.

Note that phylink itself is already covered by

"SFF/SFP/SFP+ MODULE SUPPORT"

but doesn't pick up on keywords.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
