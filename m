Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD65165DAE
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 13:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgBTMjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 07:39:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgBTMjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 07:39:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Rg2t+EC1mQ2AVfrTSkHTFNr69phF6jUOmBoiNMOsVuU=; b=WueVFM33XGUSLGDfIiq2G5793b
        +ByUxfQo7wtFpA3kbMAtKOUqMxIP6Dquz6fPXxnZ6ULEDqkXYiszY4TXYWfdrPl1V5Q6K3XqTl1eo
        wIVxmBVAGto2F9J4NYiDvL8ihCDjYslsnJrrPYB9kDI+An4eUEHHCMx/WoKTnWFbqLws=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j4l6U-0005pH-2i; Thu, 20 Feb 2020 13:38:54 +0100
Date:   Thu, 20 Feb 2020 13:38:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
Message-ID: <20200220123853.GH3281@lunn.ch>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
 <20200219143036.GB3390@piout.net>
 <20200220101828.GV25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220101828.GV25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks, that looks reasonable to me. I'll replace my patch with this
> one if it's appropriate for net-next when I send this series for
> merging.  However, I see most affected network driver maintainers
> haven't responded yet, which is rather disappointing.  So, thanks
> for taking the time to look at this.

Hi Russell

I suspect most maintainers are lazy. Give them a branch to pull, and
they might be more likely to test.

     Andrew
