Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C89221502D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgGEW03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEW02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:26:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E79C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:26:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15A78128EB36F;
        Sun,  5 Jul 2020 15:26:25 -0700 (PDT)
Date:   Sun, 05 Jul 2020 15:26:20 -0700 (PDT)
Message-Id: <20200705.152620.1918268774429284685.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH v2 net-next 0/6] PHYLINK integration improvements for
 Felix DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200704124507.3336497-1-olteanv@gmail.com>
References: <20200704124507.3336497-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jul 2020 15:26:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat,  4 Jul 2020 15:45:01 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is an overhaul of the Felix switch driver's PHYLINK operations.
> 
> Patches 1, 3, 4 and 5 are cleanup, patch 2 is adding a new feature and
> and patch 6 is adaptation to the new format of an existing phylink API
> (mac_link_up).
> 
> Changes since v1:
> - Now using phy_clear_bits and phy_set_bits instead of plain writes to
>   MII_BMCR. This combines former patches 1/7 and 6/7 into a single new
>   patch 1/6.
> - Updated commit message of patch 5/6.

Series applied, thanks.
