Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC913B272
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 19:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgANS5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 13:57:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANS5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 13:57:24 -0500
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C07D914F3950B;
        Tue, 14 Jan 2020 10:57:23 -0800 (PST)
Date:   Tue, 14 Jan 2020 10:57:19 -0800 (PST)
Message-Id: <20200114.105719.753752043779060717.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Added IRQ print to
 phylink_bringup_phy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200112173539.18503-1-f.fainelli@gmail.com>
References: <20200112173539.18503-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 10:57:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 12 Jan 2020 09:35:38 -0800

> The information about the PHY attached to the PHYLINK instance is useful
> but is missing the IRQ prints that phy_attached_info() adds.
> phy_attached_info() is a bit long and it would not be possible to use
> phylink_info() anyway.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks.
