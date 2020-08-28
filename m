Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D5B255BF9
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgH1OH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgH1OHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 10:07:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7712C061264;
        Fri, 28 Aug 2020 07:07:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C0AE12843129;
        Fri, 28 Aug 2020 06:51:04 -0700 (PDT)
Date:   Fri, 28 Aug 2020 07:07:49 -0700 (PDT)
Message-Id: <20200828.070749.1602254039142150524.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] Enable Fiber on DP83822 PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827134509.23854-1-dmurphy@ti.com>
References: <20200827134509.23854-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 06:51:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Thu, 27 Aug 2020 08:45:07 -0500

> The DP83822 Ethernet PHY has the ability to connect via a Fiber port.  The
> derivative PHYs DP83825 and DP83826 do not have this ability. In fiber mode
> the DP83822 disables auto negotiation and has a fixed 100Mbps speed with
> support for full or half duplex modes.
> 
> A devicetree binding was added to set the signal polarity for the fiber
> connection.  This property is only applicable if the FX_EN strap is set in
> hardware other wise the signal loss detection is disabled on the PHY.
> 
> If the FX_EN is not strapped the device can be configured to run in fiber mode
> via the device tree. All be it the PHY will not perform signal loss detection.
> 
> v2 review from a long time ago can be found here - https://lore.kernel.org/patchwork/patch/1270958/

Series applied, thank you.
