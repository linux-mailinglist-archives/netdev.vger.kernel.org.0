Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C342E9E94
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 21:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbhADUIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 15:08:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbhADUIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 15:08:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwW96-00G1Lb-GN; Mon, 04 Jan 2021 21:08:04 +0100
Date:   Mon, 4 Jan 2021 21:08:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH V2 2/2] net: ks8851: Register MDIO bus and the internal
 PHY
Message-ID: <X/N1pH7vCJTZi8uA@lunn.ch>
References: <20210104123017.261452-1-marex@denx.de>
 <20210104123017.261452-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104123017.261452-2-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 01:30:17PM +0100, Marek Vasut wrote:
> The KS8851 has a reduced internal PHY, which is accessible through its
> registers at offset 0xe4. The PHY is compatible with KS886x PHY present
> in Micrel switches, except the PHY ID Low/High registers are swapped.
> Register MDIO bus so this PHY can be detected and probed by phylib.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> To: netdev@vger.kernel.org

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
