Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D072676DE
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgILAmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgILAmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:42:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B421DC061786;
        Fri, 11 Sep 2020 17:42:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4275D12354CA0;
        Fri, 11 Sep 2020 17:25:25 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:42:11 -0700 (PDT)
Message-Id: <20200911.174211.1015381506002905995.davem@davemloft.net>
To:     Divya.Koppera@microchip.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next] net: phy: mchp: Add support for LAN8814
 QUAD PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911131844.24371-1-Divya.Koppera@microchip.com>
References: <20200911061020.22413-1-Divya.Koppera@microchip.com>
        <20200911131844.24371-1-Divya.Koppera@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:25:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Divya Koppera <Divya.Koppera@microchip.com>
Date: Fri, 11 Sep 2020 18:48:44 +0530

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

Applied, thanks.
