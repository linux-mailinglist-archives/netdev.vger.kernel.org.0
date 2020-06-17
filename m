Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB641FD390
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFQReW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:34:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgFQReW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 13:34:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlbx0-000zxA-7y; Wed, 17 Jun 2020 19:34:14 +0200
Date:   Wed, 17 Jun 2020 19:34:14 +0200
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
        netdev@vger.kernel.org, linux.cj@gmail.com
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
Message-ID: <20200617173414.GI205574@lunn.ch>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:
> From: Jeremy Linton <jeremy.linton@arm.com>

> +static const struct acpi_device_id xgmac_acpi_match[] = {
> +	{ "NXP0006", (kernel_ulong_t)NULL },

Hi Jeremy

What exactly does NXP0006 represent? An XGMAC MDIO bus master? Some
NXP MDIO bus master? An XGMAC Ethernet controller which has an NXP
MDIO bus master? A cluster of Ethernet controllers?

Is this documented somewhere? In the DT world we have a clear
documentation for all the compatible strings. Is there anything
similar in the ACPI world for these magic numbers?

Thanks
     Andrew
