Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5879169D49
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 05:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgBXE7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 23:59:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbgBXE7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 23:59:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26C301502D628;
        Sun, 23 Feb 2020 20:59:12 -0800 (PST)
Date:   Sun, 23 Feb 2020 20:59:11 -0800 (PST)
Message-Id: <20200223.205911.1667092059432885700.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        B38611@freescale.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: Avoid multiple suspends
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220233454.31514-1-f.fainelli@gmail.com>
References: <20200220233454.31514-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 20:59:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 20 Feb 2020 15:34:53 -0800

> It is currently possible for a PHY device to be suspended as part of a
> network device driver's suspend call while it is still being attached to
> that net_device, either via phy_suspend() or implicitly via phy_stop().
> 
> Later on, when the MDIO bus controller get suspended, we would attempt
> to suspend again the PHY because it is still attached to a network
> device.
> 
> This is both a waste of time and creates an opportunity for improper
> clock/power management bugs to creep in.
> 
> Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, and queued up for -stable, thanks Florian.
