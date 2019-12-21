Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA881287A5
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLUFrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:47:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:47:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A8C2153D88C2;
        Fri, 20 Dec 2019 21:47:41 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:47:40 -0800 (PST)
Message-Id: <20191220.214740.386371442515944381.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, afleming@freescale.com,
        dwmw2@infradead.org, ben@decadent.org.uk
Subject: Re: [PATCH net v2] mod_devicetable: fix PHY module format
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1ii59z-0003Na-Rb@rmk-PC.armlinux.org.uk>
References: <E1ii59z-0003Na-Rb@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:47:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 19 Dec 2019 23:24:47 +0000

> When a PHY is probed, if the top bit is set, we end up requesting a
> module with the string "mdio:-10101110000000100101000101010001" -
> the top bit is printed to a signed -1 value. This leads to the module
> not being loaded.
> 
> Fix the module format string and the macro generating the values for
> it to ensure that we only print unsigned types and the top bit is
> always 0/1. We correctly end up with
> "mdio:10101110000000100101000101010001".
> 
> Fixes: 8626d3b43280 ("phylib: Support phy module autoloading")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable.
