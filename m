Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01C8EF24F
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfKEAzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:55:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37686 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfKEAzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 19:55:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cbbQzJzdRMzNX3oXlnB8mb7Ta/8x4PDQyIRKIctjS5E=; b=J6HG4Fj3wKEJmoDjcwSqLLCcK
        WUQMHB5GhnXy3hJX2+VWqtCpMjDwz7uitUyvYxFNrXhfH7TOQ1cxMkFusxL7o0Cd1jWq3HRT2tzbk
        r0CjylSGkdLEWwdEk+sVPmswANgeOMDpS27GEehPJN3INxo/B39MEp8MXQoEzKjD6kbsnm2RVghVY
        iRKBGkhgwXcDOHL9KNBHVTapc9FKFqAkoZ3dAPvbJ5dRtWLX4Za1l6mzJmbncJ5IHxGLJHVF+6C/l
        DmR14gJ1+iPi/OHPxl8H2L+LPc6SYllRxoc0du4iclpfBaVNl1PrUyLHLUPRmddxvj0dghoTr0vJI
        CXba8yQ8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35288)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iRn8K-0002WJ-Po; Tue, 05 Nov 2019 00:55:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iRn8H-0002XV-G2; Tue, 05 Nov 2019 00:55:41 +0000
Date:   Tue, 5 Nov 2019 00:55:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 0/3] net: phy: switch to using fwnode_gpiod_get_index
Message-ID: <20191105005541.GP25745@shell.armlinux.org.uk>
References: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
 <20191105004016.GT57214@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105004016.GT57214@dtor-ws>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 04:40:16PM -0800, Dmitry Torokhov wrote:
> Hi Linus,
> 
> On Mon, Oct 14, 2019 at 10:40:19AM -0700, Dmitry Torokhov wrote:
> > This series switches phy drivers form using fwnode_get_named_gpiod() and
> > gpiod_get_from_of_node() that are scheduled to be removed in favor
> > of fwnode_gpiod_get_index() that behaves more like standard
> > gpiod_get_index() and will potentially handle secondary software
> > nodes in cases we need to augment platform firmware.
> > 
> > Linus, as David would prefer not to pull in the immutable branch but
> > rather route the patches through the tree that has the new API, could
> > you please take them with his ACKs?
> 
> Gentle ping on the series...

Given that kbuild found a build issue with patch 1, aren't we waiting
for you to produce an updated patch 1?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
