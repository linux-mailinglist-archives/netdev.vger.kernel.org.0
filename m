Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0455D27A418
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgI0UiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgI0UiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:38:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5414CC0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 13:38:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F13513BB09E8;
        Sun, 27 Sep 2020 13:21:29 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:38:16 -0700 (PDT)
Message-Id: <20200927.133816.2234790980234075069.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix RTL8168f/RTL8411 EPHY config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9a059f0d-4865-3f21-be39-49a2b711d0bf@gmail.com>
References: <9a059f0d-4865-3f21-be39-49a2b711d0bf@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:21:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 27 Sep 2020 19:44:29 +0200

> Mistakenly bit 2 was set instead of bit 3 as in the vendor driver.
> 
> Fixes: a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thanks.
