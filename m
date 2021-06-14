Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702E63A6691
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhFNMbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:31:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35498 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233688AbhFNMbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=C3gVMNgv3QFV6kT9Tj8SiXcV01tGcl2RhYwDoXAZyso=; b=xi/L6VMktaFjOIoU36uFAcjGPQ
        mCVw7U1wSzPPu4Nx2qFAe1zIZuASXTWUEmPn+tWbfPP51A0mUqE/B3kUaWGj+7h6gERwHuwO1CR4k
        8FQTqFVxZ/2jy+wX3t+DWcW+BbkhM/FhP21NW5aSaNmjjHnlpyxWCRdyml9nwTa5nPxE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsliJ-009JqM-UG; Mon, 14 Jun 2021 14:29:11 +0200
Date:   Mon, 14 Jun 2021 14:29:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/3] net: phy: nxp-c45-tja11xx: demote the "no
 PTP support" message to debug
Message-ID: <YMdLl3QPPzXMU++J@lunn.ch>
References: <20210614121849.437119-1-olteanv@gmail.com>
 <20210614121849.437119-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614121849.437119-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 03:18:47PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1110 switch integrates these PHYs, and they do not have support
> for timestamping. This message becomes quite overwhelming:
> 
> [   10.056596] NXP C45 TJA1103 spi1.0-base-t1:01: the phy does not support PTP
> [   10.112625] NXP C45 TJA1103 spi1.0-base-t1:02: the phy does not support PTP
> [   10.167461] NXP C45 TJA1103 spi1.0-base-t1:03: the phy does not support PTP
> [   10.223510] NXP C45 TJA1103 spi1.0-base-t1:04: the phy does not support PTP
> [   10.278239] NXP C45 TJA1103 spi1.0-base-t1:05: the phy does not support PTP
> [   10.332663] NXP C45 TJA1103 spi1.0-base-t1:06: the phy does not support PTP
> [   15.390828] NXP C45 TJA1103 spi1.2-base-t1:01: the phy does not support PTP
> [   15.445224] NXP C45 TJA1103 spi1.2-base-t1:02: the phy does not support PTP
> [   15.499673] NXP C45 TJA1103 spi1.2-base-t1:03: the phy does not support PTP
> [   15.554074] NXP C45 TJA1103 spi1.2-base-t1:04: the phy does not support PTP
> [   15.608516] NXP C45 TJA1103 spi1.2-base-t1:05: the phy does not support PTP
> [   15.662996] NXP C45 TJA1103 spi1.2-base-t1:06: the phy does not support PTP
> 
> So reduce its log level to debug.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
