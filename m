Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB7BF272E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfKGFh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:37:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKGFh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:37:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30BFA1511FD4C;
        Wed,  6 Nov 2019 21:37:59 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:37:58 -0800 (PST)
Message-Id: <20191106.213758.111382006195158841.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix page read in r8168g_mdio_read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6a72148a-5ad3-6835-cfbf-974d871498e3@gmail.com>
References: <6a72148a-5ad3-6835-cfbf-974d871498e3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:37:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 6 Nov 2019 21:51:31 +0100

> Functions like phy_modify_paged() read the current page, on Realtek
> PHY's this means reading the value of register 0x1f. Add special
> handling for reading this register, similar to what we do already
> in r8168g_mdio_write(). Currently we read a random value that by
> chance seems to be 0 always.
> 
> Fixes: a2928d28643e ("r8169: use paged versions of phylib MDIO access functions")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
