Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7CE689B3D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjBCOMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjBCOMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:12:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A631EBDB;
        Fri,  3 Feb 2023 06:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+WH7VJ9ND/1v/0aCLXgBANRi0NIzyJ1wTqtN9ZDhZj0=; b=fIup/wPpDa41mxDnPJ8ns94Rbb
        a0fBPiiaSoivpGrzzPyRj4l7XDxbmD577qMeTbQM/3yw0assltKmE8T8YjqrqKaZY2jUdsKUCYJMd
        hELsL527i/b2Dhgdnjs1Ibq17La59+1+USIBHspASs2TXsyt8xJJyRysKGP3c1pMEhas=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNwc1-0040Ke-IW; Fri, 03 Feb 2023 15:00:21 +0100
Date:   Fri, 3 Feb 2023 15:00:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 1/9] net: ethernet: mtk_eth_soc: add support for MT7981
 SoC
Message-ID: <Y90TdTBPvQzV46H8@lunn.ch>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 07:00:21AM +0000, Daniel Golle wrote:
> The MediaTek MT7981 SoC comes two 1G/2.5G SGMII, just like MT7986.
> 
> In addition MT7981 comes with a built-in 1000Base-T PHY which can be
> used with GMAC1.
> 
> As many MT7981 boards make use of swapping SGMII phase and neutral, add
> new device-tree attribute 'mediatek,pn_swap' to support them.

Is this new property documented in the device tree binding?

   Andrew
