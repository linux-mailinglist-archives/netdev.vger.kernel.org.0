Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8D227A401
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgI0UXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgI0UXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:23:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16BEC0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 13:23:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3938D13BAFAC8;
        Sun, 27 Sep 2020 13:07:04 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:23:48 -0700 (PDT)
Message-Id: <20200927.132348.488807653840442383.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, bgolaszewski@baylibre.com, andrew@lunn.ch,
        hkallweit1@gmail.com, david.daney@cavium.com
Subject: Re: [PATCH] mdio: fix mdio-thunder.c dependency & build error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5aecbd3f-a489-0738-8249-5e08a6f2766f@infradead.org>
References: <5aecbd3f-a489-0738-8249-5e08a6f2766f@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:07:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 26 Sep 2020 21:33:43 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build error by selecting MDIO_DEVRES for MDIO_THUNDER.
> Fixes this build error:
> 
> ld: drivers/net/phy/mdio-thunder.o: in function `thunder_mdiobus_pci_probe':
> drivers/net/phy/mdio-thunder.c:78: undefined reference to `devm_mdiobus_alloc_size'
> 
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied to 'net' and queued up for -stable, thanks.
