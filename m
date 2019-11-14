Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44712FC9EE
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKNP3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:29:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKNP3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 10:29:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ElG8Ta8wnxyvEpph2Zdu0/QL/JmLef30hlFTtXPVY2w=; b=b/58ij9zk28SivK4r5tm14Hq55
        iuccP5RskD/WgI5i93dWzWsR8CMNTJ098NMLPvjZbt/6jPB7gIH3M5QmOxZ7D5p2HOpaBNNQ8aLJa
        vF7huaLIaHiyw8bLOJqBGBsmT2Ptjq11+iN+/Qc3/gy1AfDGhFpRoZHcXH0URtb6CrcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iVH3A-0004kD-8P; Thu, 14 Nov 2019 16:28:48 +0100
Date:   Thu, 14 Nov 2019 16:28:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marc Zyngier <maz@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ARM: dts: ls1021a-tsn: Use interrupts for the
 SGMII PHYs
Message-ID: <20191114152848.GR10875@lunn.ch>
References: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
 <20191114110254.32171-3-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114110254.32171-3-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 12:02:53PM +0100, Rasmus Villemoes wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> 
> Switching to interrupts offloads the PHY library from the task of
> polling the MDIO status and AN registers (1, 4, 5) every second.
> 
> Unfortunately, the BCM5464R quad PHY connected to the switch does not
> appear to have an interrupt line routed to the SoC.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
