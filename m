Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B112185A05
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 05:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgCOEOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 00:14:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgCOEOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 00:14:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB1CD123CD917;
        Sat, 14 Mar 2020 21:14:20 -0700 (PDT)
Date:   Sat, 14 Mar 2020 21:14:20 -0700 (PDT)
Message-Id: <20200314.211420.1995254896805899563.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        cooldavid@cooldavid.org, sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        rmk+kernel@armlinux.org.uk, mcroce@redhat.com,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, mlindner@marvell.com,
        stephen@networkplumber.org, christopher.lee@cspi.com,
        manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        nic_swsd@realtek.com, hkallweit1@gmail.com, bh74.an@samsung.com,
        romieu@fr.zoreil.com
Subject: Re: [PATCH net-next 00/15] ethtool: consolidate irq coalescing -
 part 5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313040803.2367590-1-kuba@kernel.org>
References: <20200313040803.2367590-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 21:14:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 12 Mar 2020 21:07:48 -0700

> Convert more drivers following the groundwork laid in a recent
> patch set [1] and continued in [2], [3], [4]. The aim of the effort
> is to consolidate irq coalescing parameter validation in the core.
> 
> This set converts further 15 drivers in drivers/net/ethernet.
> One more conversion sets to come.
> 
> [1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
> [2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/
> [3] https://lore.kernel.org/netdev/20200310021512.1861626-1-kuba@kernel.org/
> [4] https://lore.kernel.org/netdev/20200311223302.2171564-1-kuba@kernel.org/

Series applied, thanks Jakub.
