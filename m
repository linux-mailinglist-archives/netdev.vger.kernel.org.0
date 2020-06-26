Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFC820B937
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgFZTRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFZTRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 15:17:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AF5C03E979;
        Fri, 26 Jun 2020 12:17:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64569120F19CC;
        Fri, 26 Jun 2020 12:17:52 -0700 (PDT)
Date:   Fri, 26 Jun 2020 12:17:51 -0700 (PDT)
Message-Id: <20200626.121751.1918257116637546551.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jbrunet@baylibre.com
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: use clk_parent_data for
 clock registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625182142.1673053-1-martin.blumenstingl@googlemail.com>
References: <20200625182142.1673053-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 12:17:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 25 Jun 2020 20:21:42 +0200

> Simplify meson8b_init_rgmii_tx_clk() by using struct clk_parent_data to
> initialize the clock parents. No functional changes intended.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Applied to net-next, thank you.
