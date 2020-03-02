Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB6B175202
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCBDFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:05:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgCBDFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:05:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25DDF13D68CE4;
        Sun,  1 Mar 2020 19:05:01 -0800 (PST)
Date:   Sun, 01 Mar 2020 19:05:00 -0800 (PST)
Message-Id: <20200301.190500.946623747700619111.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, michael@walle.cc
Subject: Re: [PATCH net] net: phy: avoid clearing PHY interrupts twice in
 irq handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
References: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Mar 2020 19:05:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 1 Mar 2020 21:36:09 +0100

> On all PHY drivers that implement did_interrupt() reading the interrupt
> status bits clears them. This means we may loose an interrupt that
> is triggered between calling did_interrupt() and phy_clear_interrupt().
> As part of the fix make it a requirement that did_interrupt() clears
> the interrupt.
> 
> The Fixes tag refers to the first commit where the patch applies
> cleanly.
> 
> Fixes: 49644e68f472 ("net: phy: add callback for custom interrupt handler to struct phy_driver")
> Reported-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thanks.
