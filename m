Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570AC27180F
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgITVLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITVLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:11:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D191C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:11:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAA5313BC86B3;
        Sun, 20 Sep 2020 13:54:51 -0700 (PDT)
Date:   Sun, 20 Sep 2020 14:11:38 -0700 (PDT)
Message-Id: <20200920.141138.1924369814484557562.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: rtl8366: Skip PVID setting if not
 requested
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918222954.210207-1-linus.walleij@linaro.org>
References: <20200918222954.210207-1-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 13:54:51 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Sat, 19 Sep 2020 00:29:54 +0200

> We go to lengths to determine whether the PVID should be set
> for this port or not, and then fail to take it into account.
> Fix this oversight.
> 
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.
