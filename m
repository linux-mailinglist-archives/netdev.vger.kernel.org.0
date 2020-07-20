Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E809E225533
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgGTBLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgGTBLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:11:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAA7C0619D2;
        Sun, 19 Jul 2020 18:11:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1832312848D5B;
        Sun, 19 Jul 2020 18:11:54 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:11:53 -0700 (PDT)
Message-Id: <20200719.181153.1166549843109648622.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        martin.p.rowe@gmail.com, devicetree@vger.kernel.org,
        gregory.clement@bootlin.com, kuba@kernel.org, jason@lakedaemon.net,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, sebastian.hesselbarth@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] arm64: dts: clearfog-gt-8k: fix switch link
 configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jx73g-0006mp-UI@rmk-PC.armlinux.org.uk>
References: <E1jx73g-0006mp-UI@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:11:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 19 Jul 2020 12:00:40 +0100

> The commit below caused a regression for clearfog-gt-8k, where the link
> between the switch and the host does not come up.
> 
> Investigation revealed two issues:
> - MV88E6xxx DSA no longer allows an in-band link to come up as the link
>   is programmed to be forced down. Commit "net: dsa: mv88e6xxx: fix
>   in-band AN link establishment" addresses this.
> 
> - The dts configured dissimilar link modes at each end of the host to
>   switch link; the host was configured using a fixed link (so has no
>   in-band status) and the switch was configured to expect in-band
>   status.
> 
> With both issues fixed, the regression is resolved.
> 
> Fixes: 34b5e6a33c1a ("net: dsa: mv88e6xxx: Configure MAC when using fixed link")
> Reported-by: Martin Rowe <martin.p.rowe@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable, thanks.
