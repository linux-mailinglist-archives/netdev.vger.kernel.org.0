Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E6E12781E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 10:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLTJ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 04:29:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbfLTJ3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 04:29:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0Zho+IwXTx7nIiyKWPWvg5wp0VQAUlZmE3ckFFsswTs=; b=PQkfGe3U52Q3dkjP3BmHOcDCjq
        C2XXAnB1YibLfJycjJIMywfCyxNqgxHt12bN4QSaRF5jsyIiqv8+jMXVAIWxFuxDvfZWJzdybX3yC
        SLq3EJXzwwol2bLfJTmylAqrnh+8mJr24a7nPNTxiT/8axkwTq1jTJLrZA4hUl0R0qgY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iiEai-0006nF-Pl; Fri, 20 Dec 2019 10:29:00 +0100
Date:   Fri, 20 Dec 2019 10:29:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "antoine.tenart@free-electrons.com" 
        <antoine.tenart@free-electrons.com>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191220092900.GB24174@lunn.ch>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
 <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220091642.GJ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220091642.GJ25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> How does this help us when we can't simply change the existing usage?
> We can update the DT but we can't free up the usage of "10gbase-kr".

Agreed. Code needs to keep on interpreting "10gbase-kr" as any 10G
link. If we ever have a true 10gbase-kr, 802.3ap, one meter of copper
and two connectors, we are going to have to add a new mode to
represent true 10gbase-kr.

	Andrew
