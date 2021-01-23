Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8D301211
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbhAWBjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbhAWBjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:39:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29A5223B55;
        Sat, 23 Jan 2021 01:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611365944;
        bh=qgKJptsK1N2IK67Aym/KNaINRy2ePn8gQlRoAvYXPKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BQGFNFuihOPg5cPMADik+6SZXQzmYU47N+uy+lwUzX2X07MeBKzIqApSijsqjXxdN
         EKtnkhiFAhR4j7wZqPh0e7DdCLkYdLFiFDbVTBKjtPiitGqYOonIqmBZN9Et7jHsar
         Wpo0CaMU2TJ24WiZN7JLD2I7BQ86Hd0LQ03xvQnT8dHyd8tsM/AjdYg2YrBJ3lu5pE
         7LOgCvnf1Uitqpn7TvT2bMDEOmDW0orLHh7E5QO7rfCXOwh3gixMiWTcLIGOzrOQQn
         genmNo+c0JXxqzhv3FIS10b4zsVRy8EA9UwgfrVqietu3t3Ys3GMCCgM3YKuIfIC7H
         AYtTrfBeB4gaQ==
Date:   Fri, 22 Jan 2021 17:39:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v4 10/15] net: mdio: Add ACPI support code for
 mdio
Message-ID: <20210122173902.57af2311@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122154300.7628-11-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
        <20210122154300.7628-11-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 21:12:55 +0530 Calvin Johnson wrote:
> Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> each ACPI child node.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

ERROR: modpost: missing MODULE_LICENSE() in drivers/net/mdio/acpi_mdio.o
make[2]: *** [Module.symvers] Error 1
