Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75BB2646F8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 15:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgIJN11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 09:27:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbgIJN0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 09:26:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGMaO-00E4VQ-RD; Thu, 10 Sep 2020 15:26:00 +0200
Date:   Thu, 10 Sep 2020 15:26:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     madalin.bucur@oss.nxp.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, calvin.johnson@oss.nxp.com,
        kuldip.dwivedi@puresoftware.com, vikas.singh@nxp.com
Subject: Re: [PATCH] net: ethernet: freescale: Add device "fwnode" while MDIO
 bus get registered
Message-ID: <20200910132600.GE3316362@lunn.ch>
References: <1599738730-27080-1-git-send-email-vikas.singh@puresoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599738730-27080-1-git-send-email-vikas.singh@puresoftware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 05:22:10PM +0530, Vikas Singh wrote:
> For DT case, auto-probe of c45 devices with extended scanning in xgmac_mdio
> works well but scanning and registration of these devices (PHY's) fails in
> case of ACPI mainly because of MDIO bus "fwnode" is not set appropriately.
> This patch is based on https://www.spinics.net/lists/netdev/msg662173.html
> 
> This change will update the "fwnode" while MDIO bus get registered and allow
> lookup for registered PHYs on MDIO bus from other drivers while probing.

Vikas

How are you describing the MDIO bus in ACPI? Do you have a proposed
standard document for submission to UEFI?

Sorry, had to ask. Networking and ACPI is not in a good place right
now, and it will need some standardization before things get better.

	 Andrew
