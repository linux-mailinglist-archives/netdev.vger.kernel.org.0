Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4DE2190DC
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgGHTgr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jul 2020 15:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgGHTgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:36:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C03C061A0B;
        Wed,  8 Jul 2020 12:36:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6CD01276B345;
        Wed,  8 Jul 2020 12:36:46 -0700 (PDT)
Date:   Wed, 08 Jul 2020 12:36:46 -0700 (PDT)
Message-Id: <20200708.123646.545653837566811385.davem@davemloft.net>
To:     frank-w@public-files.de
Cc:     linux-mediatek@lists.infradead.org, opensource@vdorst.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix mtu warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708154634.9565-1-frank-w@public-files.de>
References: <20200708154634.9565-1-frank-w@public-files.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 12:36:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>
Date: Wed,  8 Jul 2020 17:46:34 +0200

> From: René van Dorst <opensource@vdorst.com>
> 
> in recent Kernel-Versions there are warnings about incorrect MTU-Size
> like these:
> 
> mt7530 mdio-bus:00: nonfatal error -95 setting MTU on port x
> eth0: mtu greater than device maximum
> mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA overhead
> 
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> 
> Fixes: bfcb813203 ("net: dsa: configure the MTU for switch ports")
> Fixes: 72579e14a1 ("net: dsa: don't fail to probe if we couldn't set the MTU")
> Fixes: 7a4c53bee3 ("net: report invalid mtu value via netlink extack")

In addition to the other Fixes: tag problems pointed out so far, you should
always put the Fixes: tags first, and immediately before the other tags
such as Signed-off-by: etc. and with no empty lines separating them.

Thank you.
