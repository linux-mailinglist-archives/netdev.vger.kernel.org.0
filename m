Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31AC251977
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgHYNXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgHYNWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:22:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5ECC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 06:22:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9977311E45768;
        Tue, 25 Aug 2020 06:05:39 -0700 (PDT)
Date:   Tue, 25 Aug 2020 06:22:25 -0700 (PDT)
Message-Id: <20200825.062225.1388243783692648750.davem@davemloft.net>
To:     daniel.gorsulowski@esd.eu
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH] net: dp83869: Fix RGMII internal delay configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
References: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 06:05:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Gorsulowski <daniel.gorsulowski@esd.eu>
Date: Tue, 25 Aug 2020 14:07:21 +0200

> The RGMII control register at 0x32 indicates the states for the bits
> RGMII_TX_CLK_DELAY and RGMII_RX_CLK_DELAY as follows:
> 
>   RGMII Transmit/Receive Clock Delay
>     0x0 = RGMII transmit clock is shifted with respect to transmit/receive data.
>     0x1 = RGMII transmit clock is aligned with respect to transmit/receive data.
> 
> This commit fixes the inversed behavior of these bits
> 
> Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
> 
> Signed-off-by: Daniel Gorsulowski <daniel.gorsulowski@esd.eu>

Please no empty lines between "Fixes:" and other tags like "Signed-off-by:",
all of the tags should be grouped together without any intervening empty
lines.

> -		val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN |
> +		val |= (DP83869_RGMII_TX_CLK_DELAY_EN |
>  			 DP83869_RGMII_RX_CLK_DELAY_EN);

Please fix up the indentation of this last line here such that the
first character is at the same column as the one after the openning
parenthesis of the previous line.
