Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEF82699B6
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgINXcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgINXce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:32:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E5BC06174A;
        Mon, 14 Sep 2020 16:32:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F0592128B2345;
        Mon, 14 Sep 2020 16:15:44 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:32:28 -0700 (PDT)
Message-Id: <20200914.163228.1898649357949030454.davem@davemloft.net>
To:     landen.chao@mediatek.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, robh+dt@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, p.zabel@pengutronix.de,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, opensource@vdorst.com, dqfext@gmail.com
Subject: Re: [PATCH net-next v5 0/6] net-next: dsa: mt7530: add support for
 MT7531
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1599829696.git.landen.chao@mediatek.com>
References: <cover.1599829696.git.landen.chao@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:15:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Landen Chao <landen.chao@mediatek.com>
Date: Fri, 11 Sep 2020 21:48:50 +0800

> This patch series adds support for MT7531.
> 
> MT7531 is the next generation of MT7530 which could be found on Mediatek
> router platforms such as MT7622 or MT7629.
> 
> It is also a 7-ports switch with 5 giga embedded phys, 2 cpu ports, and
> the same MAC logic of MT7530. Cpu port 6 only supports SGMII interface.
> Cpu port 5 supports either RGMII or SGMII in different HW SKU, but cannot
> be muxed to PHY of port 0/4 like mt7530. Due to support for SGMII
> interface, pll, and pad setting are different from MT7530.
> 
> MT7531 SGMII interface can be configured in following mode:
> - 'SGMII AN mode' with in-band negotiation capability
>     which is compatible with PHY_INTERFACE_MODE_SGMII.
> - 'SGMII force mode' without in-band negotiation
>     which is compatible with 10B/8B encoding of
>     PHY_INTERFACE_MODE_1000BASEX with fixed full-duplex and fixed pause.
> - 2.5 times faster clocked 'SGMII force mode' without in-band negotiation
>     which is compatible with 10B/8B encoding of
>     PHY_INTERFACE_MODE_2500BASEX with fixed full-duplex and fixed pause.
 ...

Series applied, thank you.
