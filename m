Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631B9480586
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 02:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhL1BnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 20:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhL1BnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 20:43:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25F8C06173E;
        Mon, 27 Dec 2021 17:43:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 167186117D;
        Tue, 28 Dec 2021 01:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F37C36AE7;
        Tue, 28 Dec 2021 01:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640655784;
        bh=tm2ezZym6nmRnMFof2gET1bE3Gm3gtZFjJBuqcI1dVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GpwoqgL3hN+CpF+au5xOM7La9VTu0aFYJ3Ys6SPZYna4fXuZJiSrx2hlzUiMqW9c+
         JjDISMTXh+N0JUjt2CTJ+uX9MsYyafmITaM6ijFMO7moC+6OW1JhU/LlNtmaBtdf/P
         N7kgyybkEsviIrx5FWdOEBKWlqj8bNmiJiPd67v6qlSVScJ1wGjD90SVhl8VBlG9lQ
         t/hlsUx496uH1Fd/+U9TPnULK74z/+6TLLdaRIPHSoyJukiY3/H3EODB78L9MGcFuT
         8WNs6Qk5eY6BI/4MvrHrKf/W5xPWLUKsxDkFVswdJEGrFziUTFMXP+tNN3uY1wYfV5
         pteFO/mhw5u4w==
Date:   Mon, 27 Dec 2021 17:43:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v7 0/2] net: ethernet: mtk_soc_eth: implement Clause 45
 MDIO access
Message-ID: <20211227174302.79379151@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <Ycpj/cEdjb0BMrny@makrotopia.org>
References: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
        <YcpVmlb1jFavCBpS@makrotopia.org>
        <YcpVtjykiS7mgtT5@makrotopia.org>
        <Ycpj/cEdjb0BMrny@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 01:10:21 +0000 Daniel Golle wrote:
> As it turned out some clean-up would be needed, first address return
> value and type of mdio read and write functions in mtk_eth_soc and
> generally clean up and unify both functions.
> Then add support to access Clause 45 phy registers.
> 
> Both commits are tested on the Bananapi BPi-R64 board having MediaTek
> MT7531BE DSA gigE switch using clause 22 MDIO and Ubiquiti UniFi 6 LR
> access point having Aquantia AQR112C PHY using clause 45 MDIO.
> 
> v7: remove unneeded variables and order OR-ed call parameters
> v6: further clean up functions and more cleanly separate patches
> v5: fix wrong variable name in first patch covered by follow-up patch
> v4: clean-up return values and types, split into two commits
> v3: return -1 instead of 0xffff on error in _mtk_mdio_write
> v2: use MII_DEVADDR_C45_SHIFT and MII_REGADDR_C45_MASK to extract
>     device id and register address. Unify read and write functions to
>     have identical types and parameter names where possible as we are
>     anyway already replacing both function bodies.

Please stop reposting this series (1) so often; (2) as a flat response
to an old version. You are completely confusing patch series detection,
at least in patchwork.

Try git send-email and please allow at least 12 hours between postings
for reviewers to comment.
