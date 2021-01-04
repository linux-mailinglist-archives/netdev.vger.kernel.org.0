Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5792E9E68
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 20:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbhADT6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 14:58:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbhADT6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 14:58:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwVyx-00G1GA-84; Mon, 04 Jan 2021 20:57:35 +0100
Date:   Mon, 4 Jan 2021 20:57:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH V2 1/2] net: phy: micrel: Add KS8851 PHY support
Message-ID: <X/NzL3809qo6jVwT@lunn.ch>
References: <20210104123017.261452-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104123017.261452-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 01:30:16PM +0100, Marek Vasut wrote:
> The KS8851 has a reduced internal PHY, which is accessible through its
> registers at offset 0xe4. The PHY is compatible with KS886x PHY present
> in Micrel switches, including the PHY ID Low/High registers swap, which
> is present both in the MAC and the switch.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> To: netdev@vger.kernel.org

Hi Marek

Please always include a 0/X patch containing a cover letter. It gets
used for the merge commit.

You should also indicate which tree this is for, by putting net-next
in the [PATCH ...] part of the subject line.

See the netdev FAQ.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
