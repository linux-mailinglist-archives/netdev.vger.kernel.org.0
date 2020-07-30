Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BCE233C55
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgG3X47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgG3X47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:56:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35566C061574;
        Thu, 30 Jul 2020 16:56:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 13449126C2B42;
        Thu, 30 Jul 2020 16:40:13 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:56:57 -0700 (PDT)
Message-Id: <20200730.165657.817406443198525975.davem@davemloft.net>
To:     frank-w@public-files.de
Cc:     linux-mediatek@lists.infradead.org, landen.chao@mediatek.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v4] net: ethernet: mtk_eth_soc: fix MTU warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729081517.4026-1-frank-w@public-files.de>
References: <20200729081517.4026-1-frank-w@public-files.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:40:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>
Date: Wed, 29 Jul 2020 10:15:17 +0200

> From: Landen Chao <landen.chao@mediatek.com>
> 
> in recent kernel versions there are warnings about incorrect MTU size
> like these:
> 
> eth0: mtu greater than device maximum
> mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA overhead
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the MTU")
> Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v3->v4
>   - fix commit-message (hyphernations,capitalisation) as suggested by Russell
>   - add Signed-off-by Landen
>   - dropped wrong signed-off from rene (because previous v1/2 was from him)

Applied, thank you.
