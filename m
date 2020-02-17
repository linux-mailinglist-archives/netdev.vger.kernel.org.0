Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D8B160912
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgBQDkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:40:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:40:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75B5A15796801;
        Sun, 16 Feb 2020 19:40:07 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:40:06 -0800 (PST)
Message-Id: <20200216.194006.251898075240263496.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] Pause updates for phylib and phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:40:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sat, 15 Feb 2020 15:48:39 +0000

> Currently, phylib resolves the speed and duplex settings, which MAC
> drivers use directly. phylib also extracts the "Pause" and "AsymPause"
> bits from the link partner's advertisement, and stores them in struct
> phy_device's pause and asym_pause members with no further processing.
> It is left up to each MAC driver to implement decoding for this
> information.
> 
> phylink converted drivers are able to take advantage of code therein
> which resolves the pause advertisements for the MAC driver, but this
> does nothing for unconverted drivers. It also does not allow us to
> make use of hardware-resolved pause states offered by several PHYs.
> 
> This series aims to address this by:
 ...
> This series has been build-tested against net-next; the boot tested
> patches are in my "phy" branch against v5.5 plus the queued phylink
> changes that were merged for 5.6.
> 
> The next series will introduce the ability for phylib drivers to
> provide hardware resolved pause enablement state.  These patches can
> be found in my "phy" branch.

Series applied to net-next, thank you.
