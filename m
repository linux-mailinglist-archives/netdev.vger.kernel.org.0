Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C66E1287A6
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfLUFsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:48:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:48:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54009153D7134;
        Fri, 20 Dec 2019 21:48:39 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:48:38 -0800 (PST)
Message-Id: <20191220.214838.573609469370486755.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: ensure that phy IDs are correctly
 typed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1ii5A4-0003Ni-Vs@rmk-PC.armlinux.org.uk>
References: <E1ii5A4-0003Ni-Vs@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:48:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 19 Dec 2019 23:24:52 +0000

> PHY IDs are 32-bit unsigned quantities. Ensure that they are always
> treated as such, and not passed around as "int"s.
> 
> Fixes: 13d0ab6750b2 ("net: phy: check return code when requesting PHY driver module")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable.
