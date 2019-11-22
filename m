Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DF0105EEF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 04:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKVDOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 22:14:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKVDOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 22:14:20 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4376C15102FA7;
        Thu, 21 Nov 2019 19:14:19 -0800 (PST)
Date:   Thu, 21 Nov 2019 19:14:17 -0800 (PST)
Message-Id: <20191121.191417.1339124115325210078.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        nicolas.ferre@microchip.com, thomas.petazzoni@bootlin.com,
        nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, matthias.bgg@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        radhey.shyam.pandey@xilinx.com, michal.simek@xilinx.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [CFT PATCH net-next v2] net: phylink: rename mac_link_state()
 op to mac_pcs_get_state()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
References: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 19:14:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 21 Nov 2019 00:36:22 +0000

> Rename the mac_link_state() method to mac_pcs_get_state() to make it
> clear that it should be returning the MACs PCS current state, which
> is used for inband negotiation rather than just reading back what the
> MAC has been configured for. Update the documentation to explicitly
> mention that this is for inband.
> 
> We drop the return value as well; most of phylink doesn't check the
> return value and it is not clear what it should do on error - instead
> arrange for state->link to be false.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> This is something I'd like to do to make it clearer what phylink
> expects of this function, and that it shouldn't just read-back how
> the MAC was configured.
> 
> This version drops the deeper changes, concentrating just on the
> phylink API rather than delving deeper into drivers, as I haven't
> received any feedback on that patch.
> 
> It would be nice to see all these drivers tested with this change.

I'm tempted to just apply this, any objections?
