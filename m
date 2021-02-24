Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E42E323D64
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhBXNJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:09:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55778 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235428AbhBXNCk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:02:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lEtnO-008E6E-IC; Wed, 24 Feb 2021 14:01:38 +0100
Date:   Wed, 24 Feb 2021 14:01:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Message-ID: <YDZOMpUYZrijdFli@lunn.ch>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Understood. Please double check ethtool callbacks work fine. People
> often forget about those when disabling clocks in .close.

The MDIO bus can also be used at any time, not just when the interface
is open. For example the MAC could be connected to an Ethernet switch,
which is managed by the MDIO bus. Or some PHYs have a temperature
sensor which is registered with HWMON when the PHY is probed.

You said you copied the FEC driver. Take a look at that, it was
initially broken in this way, and i needed to extend it when i got a
board with an Ethernet switch attached to the FEC.

      Andrew
