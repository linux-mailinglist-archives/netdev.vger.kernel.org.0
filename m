Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EF41D6C77
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgEQToT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgEQToS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:44:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE57DC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:44:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5339128A2DA2;
        Sun, 17 May 2020 12:44:16 -0700 (PDT)
Date:   Sun, 17 May 2020 12:44:15 -0700 (PDT)
Message-Id: <20200517.124415.2069030851463810409.davem@davemloft.net>
To:     leon@kernel.org
Cc:     andrew@lunn.ch, kuba@kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, leonro@mellanox.com, netdev@vger.kernel.org,
        rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net] net: phy: propagate an error back to the callers
 of phy_sfp_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200517115340.78554-1-leon@kernel.org>
References: <20200517115340.78554-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:44:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Sun, 17 May 2020 14:53:40 +0300

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The compilation warning below reveals that the errors returned from
> the sfp_bus_add_upstream() call are not propagated to the callers.
> Fix it by returning "ret".
> 
> 14:37:51 drivers/net/phy/phy_device.c: In function 'phy_sfp_probe':
> 14:37:51 drivers/net/phy/phy_device.c:1236:6: warning: variable 'ret'
>    set but not used [-Wunused-but-set-variable]
> 14:37:51  1236 |  int ret;
> 14:37:51       |      ^~~
> 
> Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Applied, thank you.
