Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC6E297966
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 00:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758348AbgJWWsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 18:48:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757785AbgJWWsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 18:48:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kW5qx-003Bef-NA; Sat, 24 Oct 2020 00:48:07 +0200
Date:   Sat, 24 Oct 2020 00:48:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, ardeleanalex@gmail.com
Subject: Re: [PATCH v2 2/2] net: phy: adin: implement cable-test support
Message-ID: <20201023224807.GG745568@lunn.ch>
References: <20201022074551.11520-1-alexandru.ardelean@analog.com>
 <20201022074551.11520-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022074551.11520-2-alexandru.ardelean@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 10:45:51AM +0300, Alexandru Ardelean wrote:
> The ADIN1300/ADIN1200 support cable diagnostics using TDR.
> 
> The cable fault detection is automatically run on all four pairs looking at
> all combinations of pair faults by first putting the PHY in standby (clear
> the LINK_EN bit, PHY_CTRL_3 register, Address 0x0017) and then enabling the
> diagnostic clock (set the DIAG_CLK_EN bit, PHY_CTRL_1 register, Address
> 0x0012).
> 
> Cable diagnostics can then be run (set the CDIAG_RUN bit in the
> CDIAG_RUN register, Address 0xBA1B). The results are reported for each pair
> in the cable diagnostics results registers, CDIAG_DTLD_RSLTS_0,
> CDIAG_DTLD_RSLTS_1, CDIAG_DTLD_RSLTS_2, and CDIAG_DTLD_RSLTS_3, Address
> 0xBA1D to Address 0xBA20).
> 
> The distance to the first fault for each pair is reported in the cable
> fault distance registers, CDIAG_FLT_DIST_0, CDIAG_FLT_DIST_1,
> CDIAG_FLT_DIST_2, and CDIAG_FLT_DIST_3, Address 0xBA21 to Address 0xBA24).
> 
> This change implements support for this using phylib's cable-test support.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

For a patch series, it is normal to include a cover letter explaining
what the series as a whole does.

Also the subject should indicate which tree the patchset is for.

See the netdev FAQ.

    Andrew

