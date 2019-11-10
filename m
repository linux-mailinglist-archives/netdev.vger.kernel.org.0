Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C333F6715
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfKJDhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:37:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35584 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfKJDhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 22:37:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5001C153A7DC0;
        Sat,  9 Nov 2019 19:37:12 -0800 (PST)
Date:   Sat, 09 Nov 2019 19:36:06 -0800 (PST)
Message-Id: <20191109.193606.1613231201395518635.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: sfp: rework upstream interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iT8EL-0008QJ-Fg@rmk-PC.armlinux.org.uk>
References: <E1iT8EL-0008QJ-Fg@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 19:37:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 08 Nov 2019 17:39:29 +0000

> The current upstream interface is an all-or-nothing, which is
> sub-optimal for future changes, as it doesn't allow the upstream driver
> to prepare for the SFP module becoming available, as it is at boot.
> 
> Switch to a find-sfp-bus, add-upstream, del-upstream, put-sfp-bus
> interface structure instead, which allows the upstream driver to
> prepare for a module being available as soon as add-upstream is called.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied to net-next, thanks.
