Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A81255BB6
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgH1NzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgH1NzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:55:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E46C061264;
        Fri, 28 Aug 2020 06:55:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 335B31283CC28;
        Fri, 28 Aug 2020 06:38:25 -0700 (PDT)
Date:   Fri, 28 Aug 2020 06:55:10 -0700 (PDT)
Message-Id: <20200828.065510.243995373426508876.davem@davemloft.net>
To:     landen.chao@mediatek.com
Cc:     sean.wang@mediatek.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, opensource@vdorst.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, dqfext@gmail.com
Subject: Re: [PATCH] net: dsa: mt7530: fix advertising unsupported
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827091547.21870-1-landen.chao@mediatek.com>
References: <20200827091547.21870-1-landen.chao@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 06:38:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Landen Chao <landen.chao@mediatek.com>
Date: Thu, 27 Aug 2020 17:15:47 +0800

> 1000baseT_Half
> 
> Remove 1000baseT_Half to advertise correct hardware capability in
> phylink_validate() callback function.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>

Applied and queued up for -stablel, with Subject line spillage
fixed, thank you.
