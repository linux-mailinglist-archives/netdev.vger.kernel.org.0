Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3A51B529E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDWCjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgDWCjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:39:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706FCC03C1AB;
        Wed, 22 Apr 2020 19:39:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1880127AD655;
        Wed, 22 Apr 2020 19:39:07 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:39:07 -0700 (PDT)
Message-Id: <20200422.193907.1128604166633852958.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        philippe.schenker@toradex.com, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422072137.8517-1-o.rempel@pengutronix.de>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:39:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Wed, 22 Apr 2020 09:21:37 +0200

> Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid, rgmii-rxid.
> 
> This PHY has an internal RX delay of 1.2ns and no delay for TX.
> 
> The pad skew registers allow to set the total TX delay to max 1.38ns and
> the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> 1.2ns) and a minimal delay of 0ns.
> 
> According to the RGMII v1.3 specification the delay provided by PCB traces
> should be between 1.5ns and 2.0ns. The RGMII v2.0 allows to provide this
> delay by MAC or PHY. So, we configure this PHY to the best values we can
> get by this HW: TX delay to 1.38ns (max supported value) and RX delay to
> 1.80ns (best calculated delay)
> 
> The phy-modes can still be fine tuned/overwritten by *-skew-ps
> device tree properties described in:
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied, thank you.
