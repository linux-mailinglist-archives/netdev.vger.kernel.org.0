Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEEE1189E8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLJNdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:33:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbfLJNdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 08:33:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XtjevayN4uCPE9VpLwJtgSoB2OMml81bphwofgYd/Do=; b=1n+vVP4ZobANSv9CF92JSs0Vzp
        OLZ9QOqeqWVLZult6N1sSsBFnTsRiRwXXTJA24x60RGIIcV1paymZTpqyIgdC2F3NMdgJusE4N8LM
        p3J7m0Bi+ZjfyPKHo6MCtt61eukGbU5dd43A46peB5p/nJfKQO3BY4/r01xlhPQZJhAs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iefdu-0004I5-Rx; Tue, 10 Dec 2019 14:33:34 +0100
Date:   Tue, 10 Dec 2019 14:33:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Milind Parab <mparab@cadence.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>
Subject: Re: [PATCH 3/3] net: macb: add support for high speed interface
Message-ID: <20191210133334.GA16369@lunn.ch>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890176-25630-1-git-send-email-mparab@cadence.com>
 <20191209113606.GF25745@shell.armlinux.org.uk>
 <BY5PR07MB651448607BAF87DC9C60F2AFD35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR07MB651448607BAF87DC9C60F2AFD35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >How has this been tested?
> >
> 
> This patch is tested in 10G fixed mode on SFP+ module. 
> 
> In our own lab, we have various hardware test platforms supporting SGMII (through a TI PHY and another build that connects to a Marvell 1G PHY), GMII (through a Marvell PHY), 10GBASE-R (direct connection to SFP+), USXGMII (currently we can emulate this using an SFP+ connection from/to our own hardware)

Are any of these PHY using C45?

    Thanks
	Andrew
