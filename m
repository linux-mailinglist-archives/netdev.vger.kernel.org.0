Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E480D28A219
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgJJWys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731360AbgJJTMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:12:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF5122472;
        Sat, 10 Oct 2020 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602352624;
        bh=qCkIXS8ZsPa/miTSH/dO+gBtGrLl0bKkccWoe6NRsxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zakQ0exw5bsUlHg/AvMbE0bT/JkNFlEFa9mfuBE6s/p/m5kg5YBHcV7wEMYqDXT2B
         aKe81E6e0VZyVOml5MTVMhMNdWoF5j4bPZKKlGJhUScgGQjdxJefTW/6VmArHoC3yy
         A9oe1V8SwONlHtgVc4wlFb3uRksZkGZrem3f2d3w=
Date:   Sat, 10 Oct 2020 10:57:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        robh+dt@kernel.org, Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [net-next PATCH v1] net: phy: Move of_mdio from drivers/of to
 drivers/net/mdio
Message-ID: <20201010105702.729a2bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
References: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 20:17:06 +0530 Calvin Johnson wrote:
> Better place for of_mdio.c is drivers/net/mdio.
> Move of_mdio.c from drivers/of to drivers/net/mdio
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

Applied, thank you.
