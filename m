Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367471DF1E8
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgEVWg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVWg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:36:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513D6C061A0E;
        Fri, 22 May 2020 15:36:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0F6412738EE0;
        Fri, 22 May 2020 15:36:54 -0700 (PDT)
Date:   Fri, 22 May 2020 15:36:53 -0700 (PDT)
Message-Id: <20200522.153653.998395486877096103.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     corbet@lwn.net, matthias.bgg@gmail.com, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com, kuba@kernel.org,
        arnd@arndb.de, fparent@baylibre.com, hkallweit1@gmail.com,
        edwin.peer@broadcom.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        stephane.leprovost@mediatek.com, pedro.tsai@mediatek.com,
        andrew.perepech@mediatek.com, bgolaszewski@baylibre.com
Subject: Re: [PATCH 0/5] net: provide a devres variant of register_netdev()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520114415.13041-1-brgl@bgdev.pl>
References: <20200520114415.13041-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:36:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 20 May 2020 13:44:10 +0200

>   net: ethernet: mtk_eth_mac: use devm_register_netdev()

This patch doesn't apply to net-next.

Neither the source file drivers/net/ethernet/mediatek/mtk_eth_mac.c,
nor the function mtk_mac_probe() even exist in the net-next GIT
tree.
