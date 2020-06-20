Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B74B20201E
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgFTDRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732271AbgFTDRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:17:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC73AC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:17:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AFD5127853C2;
        Fri, 19 Jun 2020 20:17:35 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:17:35 -0700 (PDT)
Message-Id: <20200619.201735.316521957585116259.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, jeremy.linton@arm.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] Clause 45 PHY probing improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 20:17:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Thu, 18 Jun 2020 14:45:00 +0100

> Last time this series was posted back in May, Florian reviewed the
> patches, which was the only feedback I received.  I'm now posting
> them without the RFC tag.
> 
> This series aims to improve the probing for Clause 45 PHYs.
> 
> The first four patches clean up get_phy_device() and called functions,
> updating the kernel doc, adding information about the various error
> return values.
> 
> We then provide better kerneldoc for get_phy_device(), describing what
> is going on, and more importantly what the various return codes mean.
> 
> Patch 6 adds support for probing MMDs >= 8 to check for their presence.
> 
> Patch 7 changes get_phy_c45_ids() to only set the returned
> devices_in_package if we successfully find a PHY.
> 
> Patch 8 splits the use of "devices in package" from the "mmds present".
> 
> Patch 9 expands our ID reading to cover the other MMDs.

Series applied, thanks Russell.
