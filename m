Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF3FF5B8
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfKPVJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:09:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:09:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88593151A2085;
        Sat, 16 Nov 2019 13:09:23 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:09:23 -0800 (PST)
Message-Id: <20191116.130923.2008243376048760754.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: update to use phy_support_asym_pause()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iVhqj-0007eY-8u@rmk-PC.armlinux.org.uk>
References: <E1iVhqj-0007eY-8u@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:09:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 15 Nov 2019 20:05:45 +0000

> Use phy_support_asym_pause() rather than open-coding it.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you.
