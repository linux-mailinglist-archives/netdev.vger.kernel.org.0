Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165FBB4183
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391129AbfIPUDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:03:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfIPUDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:03:11 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C563153F4749;
        Mon, 16 Sep 2019 13:03:07 -0700 (PDT)
Date:   Mon, 16 Sep 2019 22:03:06 +0200 (CEST)
Message-Id: <20190916.220306.1827006815405824208.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, f.fainelli@gmail.com, hkallweit1@gmail.com,
        andrew@lunn.ch, mkubecek@suse.cz
Subject: Re: [PATCH v5 0/2] ethtool: implement Energy Detect Powerdown
 support via phy-tunable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190916073526.24711-1-alexandru.ardelean@analog.com>
References: <20190916073526.24711-1-alexandru.ardelean@analog.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 13:03:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Mon, 16 Sep 2019 10:35:24 +0300

> This changeset proposes a new control for PHY tunable to control Energy
> Detect Power Down.
> 
> The `phy_tunable_id` has been named `ETHTOOL_PHY_EDPD` since it looks like
> this feature is common across other PHYs (like EEE), and defining
> `ETHTOOL_PHY_ENERGY_DETECT_POWER_DOWN` seems too long.
>     
> The way EDPD works, is that the RX block is put to a lower power mode,
> except for link-pulse detection circuits. The TX block is also put to low
> power mode, but the PHY wakes-up periodically to send link pulses, to avoid
> lock-ups in case the other side is also in EDPD mode.
>     
> Currently, there are 2 PHY drivers that look like they could use this new
> PHY tunable feature: the `adin` && `micrel` PHYs.
> 
> This series updates only the `adin` PHY driver to support this new feature,
> as this chip has been tested. A change for `micrel` can be proposed after a
> discussion of the PHY-tunable API is resolved.

Series applied.
