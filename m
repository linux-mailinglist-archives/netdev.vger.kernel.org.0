Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D9B2646BD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgIJNQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 09:16:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55004 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbgIJNMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 09:12:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGMNH-00E4Mp-KE; Thu, 10 Sep 2020 15:12:27 +0200
Date:   Thu, 10 Sep 2020 15:12:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, calvin.johnson@oss.nxp.com,
        kuldip.dwivedi@puresoftware.com, madalin.bucur@oss.nxp.com,
        vikas.singh@nxp.com
Subject: Re: [PATCH v2] net: Phy: Add PHY lookup support on MDIO bus in case
 of ACPI probe
Message-ID: <20200910131227.GC3316362@lunn.ch>
References: <1599738183-26957-1-git-send-email-vikas.singh@puresoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599738183-26957-1-git-send-email-vikas.singh@puresoftware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 05:13:03PM +0530, Vikas Singh wrote:
> The function referred to (of_mdiobus_link_mdiodev()) is only built when
> CONFIG_OF_MDIO is enabled, which is again, a DT specific thing, and would
> not work in case of ACPI.

Vikas

How are you describing the MDIO bus in ACPI? Do you have a proposed
standard document for submission to UEFI?

	 Andrew
