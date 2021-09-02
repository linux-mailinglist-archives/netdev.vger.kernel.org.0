Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684683FEDB7
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344250AbhIBMZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 08:25:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234098AbhIBMZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 08:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QN4nsexmXXWGS2EzckSq8fXL9yNrhwoxsF46pjuQIC4=; b=CpJKFvxVzDXQIrqsTvRSf3zQsW
        XibWQvvRrFM0m7YjfqgfdNBFEbOmCtMPCvksNZYzga73MKQBvwZS+w8GPkjyLmnvucAXl9hVGo+QW
        y7+Y7cwsvjtz+PFQfC5VLqwQO+zD+xztMCDN85Wqq/kUe/gsd+SAIMM3ln8iYFhKvyzA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLllE-004zjA-Tl; Thu, 02 Sep 2021 14:24:04 +0200
Date:   Thu, 2 Sep 2021 14:24:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <YTDCZN/WKlv9BsNG@lunn.ch>
References: <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901105611.y27yymlyi5e4hys5@skbuf>
 <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901132547.GB22278@shell.armlinux.org.uk>
 <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902083224.GC22278@shell.armlinux.org.uk>
 <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902104943.GD22278@shell.armlinux.org.uk>
 <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Emm, @andrew@lunn.ch, Andrew is much familiar with FEC, and PHY maintainers,
> Could you please help put insights here if possible?

All the boards i have either have an Ethernet Switch connected to the
MAC, or a Micrel PHY. None are setup for WoL, since it is not used in
the use case of these boards.

I think you need to scatter some printk() in various places to confirm
what is going on. Where is the WoL implemented: MAC or PHY, what is
suspended or not, etc.

    Andrew
