Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFF6210C43
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgGANaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:30:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbgGANaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 09:30:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqcoh-0039RW-1J; Wed, 01 Jul 2020 15:30:23 +0200
Date:   Wed, 1 Jul 2020 15:30:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux.cj@gmail.com, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 2/3] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200701133023.GG718441@lunn.ch>
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
 <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +An example of this is show below::
> +
> +	Scope(\_SB.MCE0.PR17) // 1G
> +	{
> +	  Name (_DSD, Package () {
> +	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		 Package () {
> +		     Package (2) {"phy-channel", 1},
> +		     Package (2) {"phy-mode", "rgmii-id"},
> +		     Package (2) {"mdio-handle", Package (){\_SB.MDI0}}

Please include the MDIO device node in the example, to make it clearer
how this linking works.

It would also be good to document "phy-mode" in this file.

   Andrew
