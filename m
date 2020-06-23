Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AED204810
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbgFWDsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgFWDsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:48:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DE0C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 20:48:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C082120F93F8;
        Mon, 22 Jun 2020 20:48:52 -0700 (PDT)
Date:   Mon, 22 Jun 2020 20:48:51 -0700 (PDT)
Message-Id: <20200622.204851.1491419501986375028.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, nbd@openwrt.org, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next] net: mtk_eth_soc: use resolved link config in
 mac_link_up()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jn15L-0006zk-5F@rmk-PC.armlinux.org.uk>
References: <E1jn15L-0006zk-5F@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 20:48:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 21 Jun 2020 15:36:39 +0100

> Convert the mtk_eth_soc driver to use the finalised link parameters in
> mac_link_up() rather than the parameters in mac_config().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
