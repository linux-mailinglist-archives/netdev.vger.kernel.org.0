Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4039F8E4
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfH1DsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:48:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1DsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:48:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09F09153BA50F;
        Tue, 27 Aug 2019 20:48:22 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:48:21 -0700 (PDT)
Message-Id: <20190827.204821.340435873815704705.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        nelson.chang@mediatek.com, matthias.bgg@gmail.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -next] net: mediatek: remove set but not used
 variable 'status'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826013118.22720-1-maowenan@huawei.com>
References: <20190824.142158.1506174328495468705.davem@davemloft.net>
        <20190826013118.22720-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:48:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Mon, 26 Aug 2019 09:31:18 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> drivers/net/ethernet/mediatek/mtk_eth_soc.c: In function mtk_handle_irq:
> drivers/net/ethernet/mediatek/mtk_eth_soc.c:1951:6: warning: variable status set but not used [-Wunused-but-set-variable]
> 
> Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied to net-next.
