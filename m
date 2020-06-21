Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E55D202890
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 06:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgFUEiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 00:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFUEiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 00:38:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14349C061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 21:38:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78B4A1274B2EA;
        Sat, 20 Jun 2020 21:38:49 -0700 (PDT)
Date:   Sat, 20 Jun 2020 21:38:47 -0700 (PDT)
Message-Id: <20200620.213847.529525562656594896.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] Marvell mvpp2 improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620092047.GR1551@shell.armlinux.org.uk>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 21:38:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sat, 20 Jun 2020 10:20:47 +0100

> This series primarily cleans up mvpp2, but also fixes a left-over from
> 91a208f2185a ("net: phylink: propagate resolved link config via
> mac_link_up()").
> 
> Patch 1 introduces some port helpers:
>   mvpp2_port_supports_xlg() - does the port support the XLG MAC
>   mvpp2_port_supports_rgmii() - does the port support RGMII modes
> 
> Patch 2 introduces mvpp2_phylink_to_port(), rather than having repeated
>   open coding of container_of().
> 
> Patch 3 introduces mvpp2_modify(), which reads-modifies-writes a
>   register - I've converted the phylink specific code to use this
>   helper.
> 
> Patch 4 moves the hardware control of the pause modes from
>   mvpp2_xlg_config() (which is called via the phylink_config method)
>   to mvpp2_mac_link_up() - a change that was missed in the above
>   referenced commit.
> 
> v2: remove "inline" in patch 2.

Series applied, thanks Russell.
