Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A642271171
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 01:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgISXzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 19:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgISXzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 19:55:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0634BC061755;
        Sat, 19 Sep 2020 16:55:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57B5B12354C8F;
        Sat, 19 Sep 2020 16:38:23 -0700 (PDT)
Date:   Sat, 19 Sep 2020 16:55:09 -0700 (PDT)
Message-Id: <20200919.165509.1849134246491027600.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] 100base Fx link modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918191453.13914-1-dmurphy@ti.com>
References: <20200918191453.13914-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 16:38:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Fri, 18 Sep 2020 14:14:50 -0500

> As per patch https://lore.kernel.org/patchwork/patch/1300241/ the link
> modes for 100base FX full and half duplex modes did not exist.  Adding these
> link modes to the core and ethtool allow devices like the DP83822, DP83869 and
> Broadcomm PHYs to properly advertise the correct mode for Fiber 100Mbps.
> 
> Corresponding user land ethtool patches are available but rely on these patches
> to be applied first.

Series applied, thank you.
