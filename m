Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48671056EA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKUQXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:23:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58962 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUQXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 11:23:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=18J0FcXPU3eiXIfiPIit81Qt0qj5ssLJx5+WEYxhRys=; b=dfyxZKX18ZRaIO8vmPt8Yzuky
        SRrmV1Lvn2RQNBHxj0hUbvWt/rGFCnSa9Y4q3ct/fAv+4aHN+cMoVT/VlkKB3CFEeIgnZa3K/0Vms
        Sv/0r3lIftXcZDiooo3aLcj/NF9KXzXYMYJWqBkCTs6ts7bo3ho42LRCffA9rqfpCMyZvyuv+sGSA
        cQJca66Qe9GlvSnEB3jxyvzpKSmw6sC4ENicVrlVobhtNGuZcQ6FTy704CHlhCaRErISZsP66Mf0T
        3C9/kbS3oI6HRP17fBgaH9eH6pVJ06k9UVqRPM7naW4c5JM69TYSpCAfoleitPQJFssrPxuKNzQN1
        2L7rqcu8Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59278)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXpEf-0007ow-4J; Thu, 21 Nov 2019 16:23:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXpEb-0002s4-Kx; Thu, 21 Nov 2019 16:23:09 +0000
Date:   Thu, 21 Nov 2019 16:23:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: sfp: soft status and control support
Message-ID: <20191121162309.GZ25745@shell.armlinux.org.uk>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
 <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 03:51:07PM +0000, Ioana Ciornei wrote:
> > Subject: [PATCH net-next v2] net: sfp: soft status and control support
> > 
> > Add support for the soft status and control register, which allows TX_FAULT
> > and RX_LOS to be monitored and TX_DISABLE to be set.  We make use of this
> > when the board does not support GPIOs for these signals.
> 
> Hi Russell,
> 
> With this addition, shouldn't the following print be removed?
> 
> [    2.967583] sfp sfp-mac4: No tx_disable pin: SFP modules will always be emitting.

No, because modules do not have to provide the soft controls.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
