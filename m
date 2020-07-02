Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B816621174A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgGBAjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgGBAjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 20:39:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7EBF20748;
        Thu,  2 Jul 2020 00:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593650379;
        bh=P8fZ7wLIZb9XIEuk9wytaWAOS7o0sAtIG3fEl3xQ+UY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d1SwKu/dTkBR/3Le9LuFt11WHL0+10LqBBfTLaDxStfwKbGKlemVHGDtBp9sQMrMu
         z96XjcEW2qbWQe/NO1mvw/vSyWi1vwrbPL/Hn7U4c/0RHMXRQfr+6cuDD/yr/2VHKv
         PcMBF2v5q2xkfxBpdXcL6Yyg1rFZ28cgx9POVupo=
Date:   Wed, 1 Jul 2020 17:39:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH RESEND net-next v3 2/3] net: enetc: Initialize SerDes
 for SGMII and USXGMII protocols
Message-ID: <20200701173937.2fa5b3e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200701213433.9217-3-michael@walle.cc>
References: <20200701213433.9217-1-michael@walle.cc>
        <20200701213433.9217-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Jul 2020 23:34:32 +0200 Michael Walle wrote:
> ENETC has ethernet MACs capable of SGMII, 2500BaseX and USXGMII. But in
> order to use these protocols some SerDes configurations need to be
> performed. The SerDes is configurable via an internal PCS PHY which is
> connected to an internal MDIO bus at address 0.
> 
> This patch basically removes the dependency on bootloader regarding
> SerDes initialization.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

This does not build

../drivers/net/ethernet/freescale/enetc/enetc_pf.c:879:2: error: implicit declaration of function `devm_mdiobus_free`; did you mean `devm_mdiobus_alloc`? [-Werror=implicit-function-declaration]
  879 |  devm_mdiobus_free(dev, bus);
      |  ^~~~~~~~~~~~~~~~~
      |  devm_mdiobus_alloc
