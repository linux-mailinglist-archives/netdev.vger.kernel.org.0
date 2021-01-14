Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5352F6E93
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbhANWtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:49:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbhANWtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:49:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0BQM-000eFG-Hy; Thu, 14 Jan 2021 23:49:02 +0100
Date:   Thu, 14 Jan 2021 23:49:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: ar803x: disable extended next page bit
Message-ID: <YADKXlEvv632wKlQ@lunn.ch>
References: <E1kzSdb-000417-FJ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kzSdb-000417-FJ@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:59:43PM +0000, Russell King wrote:
> This bit is enabled by default and advertises support for extended
> next page support.  XNP is only needed for 10GBase-T and MultiGig
> support which is not supported. Additionally, Cisco MultiGig switches
> will read this bit and attempt 10Gb negotiation even though Next Page
> support is disabled. This will cause timeouts when the interface is
> forced to 100Mbps and auto-negotiation will fail. The interfaces are
> only 1000Base-T and supporting auto-negotiation for this only requires
> the Next Page bit to be set.
> 
> Taken from:
> https://github.com/SolidRun/linux-stable/commit/7406c5244b7ea6bc17a2afe8568277a8c4b126a9
> and adapted to mainline kernels by rmk.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
