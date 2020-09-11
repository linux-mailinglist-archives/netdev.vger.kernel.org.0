Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8138F26679C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgIKRpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:45:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgIKMcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 08:32:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGiDx-00EE2T-1x; Fri, 11 Sep 2020 14:32:17 +0200
Date:   Fri, 11 Sep 2020 14:32:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] net: phy: mchp: Add support for LAN8814 QUAD
 PHY
Message-ID: <20200911123217.GA3390477@lunn.ch>
References: <20200909093419.32102-1-Divya.Koppera@microchip.com>
 <20200911061020.22413-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911061020.22413-1-Divya.Koppera@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 11:40:20AM +0530, Divya Koppera wrote:
> LAN8814 is a low-power, quad-port triple-speed (10BASE-T/100BASETX/1000BASE-T)
> Ethernet physical layer transceiver (PHY). It supports transmission and
> reception of data on standard CAT-5, as well as CAT-5e and CAT-6, unshielded
> twisted pair (UTP) cables.
> 
> LAN8814 supports industry-standard QSGMII (Quad Serial Gigabit Media
> Independent Interface) and Q-USGMII (Quad Universal Serial Gigabit Media
> Independent Interface) providing chip-to-chip connection to four Gigabit
> Ethernet MACs using a single serialized link (differential pair) in each
> direction.
> 
> The LAN8814 SKU supports high-accuracy timestamping functions to
> support IEEE-1588 solutions using Microchip Ethernet switches, as well as
> customer solutions based on SoCs and FPGAs.
> 
> The LAN8804 SKU has same features as that of LAN8814 SKU except that it does
> not support 1588, SyncE, or Q-USGMII with PCH/MCH.
> 
> This adds support for 10BASE-T, 100BASE-TX, and 1000BASE-T,
> QSGMII link with the MAC.
> 
> Signed-off-by: Divya Koppera<divya.koppera@microchip.com>

Hi Divya

I don't think V1 got merged. So you need to squash this into V1, so
you still add the new PHY, but without these callbacks.

    Andrew
