Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E3518E635
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgCVDMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:12:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:12:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A3C715AC103E;
        Sat, 21 Mar 2020 20:12:24 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:12:23 -0700 (PDT)
Message-Id: <20200321.201223.902296361952119725.davem@davemloft.net>
To:     yuiko.oshino@microchip.com
Cc:     davem@devemloft.net, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: microchip_t1: add lan87xx_phy_init to
 initialize the lan87xx phy.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584472118-7193-1-git-send-email-yuiko.oshino@microchip.com>
References: <1584472118-7193-1-git-send-email-yuiko.oshino@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:12:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>
Date: Tue, 17 Mar 2020 15:08:38 -0400

> lan87xx_phy_init() initializes the lan87xx phy.
> 
> fixes: 3e50d2da5850 ("Add driver for Microchip LAN87XX T1 PHYs")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

"Fixes: " should be capitalized.

You commit message is way too terse.

> +	static const struct access_ereg_val init[] = {
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE, 0x0B, 0x000A},
> +		{PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_MISC, 0x8, 0},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x8, 0},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x10, 0x0009},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x17, 0},
> +		/* TC10 Config */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20, 0x0023},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_PCS, 0x20, 0x3C3C},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x21, 0x274F},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20, 0x80A7},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x24, 0x9110},
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20, 0x0087},
> +		/* HW Init */
> +		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x1A, 0x0300},
> +	};

What do these registers do, and what do the values programmed into them
do?

If you don't know, how can you know if this code is correct?

You must document this as much as possible.

Thank you.
