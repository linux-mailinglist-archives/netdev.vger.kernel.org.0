Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80107242CF7
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgHLQPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 12:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgHLQPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 12:15:50 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DDFC061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 09:15:49 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 4BF8A13F64E;
        Wed, 12 Aug 2020 18:15:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597248947; bh=fINj1KQOOg1lBv+U9Q0UpwCYv5ac8VsZeeVylJC0qys=;
        h=Date:From:To;
        b=qFVUKTPNWiH3+CVF8vAnab1mmrFpt1qMoxfV+gRhxL9+jXbPpOf+Jo7lB7a1eQW19
         Vl0N/HNnzKRPqlLpy+YGANKVxnGtdy4cMFFZGIFe147fQUDpJxd3SzYjT2gOFBisp/
         rUqWiEA2mmiBX7X22KPRwrjArYOGFhxEMaSYoykU=
Date:   Wed, 12 Aug 2020 18:15:46 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812181546.79a68a54@dellmb.labs.office.nic.cz>
In-Reply-To: <20200812160131.GS1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200810220645.19326-4-marek.behun@nic.cz>
        <20200811152144.GN1551@shell.armlinux.org.uk>
        <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
        <20200812150054.GP1551@shell.armlinux.org.uk>
        <20200812173716.140bed4d@dellmb.labs.office.nic.cz>
        <20200812160131.GS1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Aug 2020 17:01:31 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> That's fine, because you also have the patches further down in
> net-queue.  So, what you list above are basically not all the patches.
> 
> net: mvpp2: fill in phy interface mode bitmap
> net: mvneta: fill in phy interface mode bitmap
> net: phylink: use phy interface mode bitmaps
> net: sfp: add interface bitmap
> net: phy: add supported_interfaces to marvell10g PHYs
> net: phy: add supported_interfaces to marvell PHYs
> net: phy: add supported_interfaces to bcm84881
> net: phy: add supported_interfaces to phylib

I did not list them all, but I applied them almost all your patches
from clearfog branch to linus' master and am working on top of that
