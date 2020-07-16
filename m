Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D539F221A9C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGPDLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:11:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37972 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGPDLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 23:11:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvuIx-005LJ2-MX; Thu, 16 Jul 2020 05:11:27 +0200
Date:   Thu, 16 Jul 2020 05:11:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200716031127.GH1211629@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <633212c6-8cb4-9599-0086-8a8de5c45172@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <633212c6-8cb4-9599-0086-8a8de5c45172@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 08:04:36PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/15/2020 2:03 AM, Calvin Johnson wrote:
> > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > provide them to be connected to MAC.
> > 
> > An ACPI node property "mdio-handle" is introduced to reference the
> > MDIO bus on which PHYs are registered with autoprobing method used
> > by mdiobus_register().
> > 
> > Describe properties "phy-channel" and "phy-mode"
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I really would like to see an ACPI maintainer ACK this before it gets
merged. I'm not sure the current reviewers have deep enough knowledge
of ACPI to know if this is going against parts of the standard, or
philosophy of ACPI. And we are setting an ABI here, so we need to be
particularly careful.

	     Andrew
