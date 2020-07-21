Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5729B228C2F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgGUWrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUWrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:47:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01482C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:47:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2504F11E45904;
        Tue, 21 Jul 2020 15:30:45 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:47:29 -0700 (PDT)
Message-Id: <20200721.154729.1573922846524745029.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        ioana.ciornei@nxp.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, kuba@kernel.org, michael@walle.cc,
        netdev@vger.kernel.org, olteanv@gmail.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 00/14] Phylink PCS updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:30:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 21 Jul 2020 12:01:52 +0100

> This series updates the rudimentary phylink PCS support with the
> results of the last four months of development of that.  Phylink
> PCS support was initially added back at the end of March, when it
> became clear that the current approach of treating everything at
> the MAC end as being part of the MAC was inadequate.
> 
> However, this rudimentary implementation was fine initially for
> mvneta and similar, but in practice had a fair number of issues,
> particularly when ethtool interfaces were used to change various
> link properties.
> 
> It became apparent that relying on the phylink_config structure for
> the PCS was also bad when it became clear that the same PCS was used
> in DSA drivers as well as in NXPs other offerings, and there was a
> desire to re-use that code.
> 
> It also became apparent that splitting the "configuration" step on
> an interface mode configuration between the MAC and PCS using just
> mac_config() and pcs_config() methods was not sufficient for some
> setups, as the MAC needed to be "taken down" prior to making changes,
> and once all settings were complete, the MAC could only then be
> resumed.
> 
> This series addresses these points, progressing PCS support, and
> has been developed with mvneta and DPAA2 setups, with work on both
> those drivers to prove this approach.  It has been rigorously tested
> with mvneta, as that provides the most flexibility for testing the
> various code paths.
 ...

Series applied, thank you.
