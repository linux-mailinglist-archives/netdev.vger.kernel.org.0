Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A7E426C5C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJHOIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhJHOIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 10:08:38 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953A1C061570;
        Fri,  8 Oct 2021 07:06:42 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6A6604FEE346B;
        Fri,  8 Oct 2021 07:06:39 -0700 (PDT)
Date:   Fri, 08 Oct 2021 15:06:31 +0100 (BST)
Message-Id: <20211008.150631.1431526603282542833.davem@davemloft.net>
To:     hmz007@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, lgirdwood@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Add runtime PM support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211008102410.6535-1-hmz007@gmail.com>
References: <20211008102410.6535-1-hmz007@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 08 Oct 2021 07:06:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hmz007 <hmz007@gmail.com>
Date: Fri,  8 Oct 2021 18:24:10 +0800

> Commit 2d26f6e39afb ("fix unbalanced pm_runtime_enable warnings")
> also enables runtime PM, which affects rk3399 with power-domain.
> 
> After an off-on switch of power-domain, the GMAC doesn't work properly,
> calling rk_gmac_powerup at runtime resume fixes this issue.
> 
> Fixes: 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
> Signed-off-by: hmz007 <hmz007@gmail.com>

This patch does not apply to any of the networking trees.
