Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71ADF84F7
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKLANY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:13:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKLANY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:13:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA25C154005EF;
        Mon, 11 Nov 2019 16:13:22 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:13:21 -0800 (PST)
Message-Id: <20191111.161321.2035661843791881410.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: sfp: fix sfp_bus_put() kernel documentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iTnp5-0004rn-Ah@rmk-PC.armlinux.org.uk>
References: <E1iTnp5-0004rn-Ah@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 16:13:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 10 Nov 2019 14:04:11 +0000

> The kbuild test robot found a problem with htmldocs with the recent
> change to the SFP interfaces.  Fix the kernel documentation for
> sfp_bus_put() which was missing an '@' before the argument name
> description.
> 
> Fixes: 727b3668b730 ("net: sfp: rework upstream interface")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied to net-next.

Please mark the target tree in your Subj, thank you :-)
