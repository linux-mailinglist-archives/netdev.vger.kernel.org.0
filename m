Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10B0273515
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgIUVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgIUVnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:43:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77628C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 14:43:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CEBF11E49F62;
        Mon, 21 Sep 2020 14:26:33 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:43:17 -0700 (PDT)
Message-Id: <20200921.144317.1854404847613792097.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: rtl8366rb: Roof MTU for switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919220105.311483-1-linus.walleij@linaro.org>
References: <20200919220105.311483-1-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 14:26:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 20 Sep 2020 00:01:05 +0200

> The MTU setting for this DSA switch is global so we need
> to keep track of the MTU set for each port, then as soon
> as any MTU changes, roof the MTU to the biggest common
> denominator and poke that into the switch MTU setting.
> 
> To achieve this we need a per-chip-variant state container
> for the RTL8366RB to use for the RTL8366RB-specific
> stuff. Other SMI switches does seem to have per-port
> MTU setting capabilities.
> 
> Fixes: 5f4a8ef384db ("net: dsa: rtl8366rb: Support setting MTU")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

The Fixes: tag commit only exists in the net-next tree.

Please be explicit in the future about which exact GIT
tree your patch is targetting, by mentioning it in the
Subject line, f.e. "[PATCH net-next] ..."

Applied to net-next, thanks.
