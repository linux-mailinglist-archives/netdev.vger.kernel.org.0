Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718811E4D74
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgE0Swh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgE0Swg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:52:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA4BC08C5CA;
        Wed, 27 May 2020 11:33:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD85F128B2F5F;
        Wed, 27 May 2020 11:33:05 -0700 (PDT)
Date:   Wed, 27 May 2020 11:33:04 -0700 (PDT)
Message-Id: <20200527.113304.2239513103439192680.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, kuba@kernel.org,
        bgolaszewski@baylibre.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] mtk-star-emac: mark PM functions as
 __maybe_unused
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527133513.579367-1-arnd@arndb.de>
References: <20200527133513.579367-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:33:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 27 May 2020 15:34:45 +0200

> Without CONFIG_PM, the compiler warns about two unused functions:
> 
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1472:12: error: unused function 'mtk_star_suspend' [-Werror,-Wunused-function]
> drivers/net/ethernet/mediatek/mtk_star_emac.c:1488:12: error: unused function 'mtk_star_resume' [-Werror,-Wunused-function]
> 
> Mark these as __maybe_unused.
> 
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thank you.
