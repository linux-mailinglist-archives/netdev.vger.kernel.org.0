Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DC2689B35
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjBCOMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjBCOML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:12:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BC75456A;
        Fri,  3 Feb 2023 06:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=th236SFm+UL+eQbk39f4IhG2ZwNDs1NzoNO0exA4MrE=; b=tUsF8rvmnFEicbxs+BRmfthFt8
        9T1uxkqICLFJgfWWC2LFbQ93ZsmQK4n3drjzLKb/9CGXO45p69Q2zddgiBogQQsRwLJgCEGM3mxjQ
        8yqKOtQr7Fm9lERRAlrFXueIJcyyZ/jH/GkyRUXBVmopDPIXz1aoQeH3FZ8DFM1na5gI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNwlF-0040Ts-CB; Fri, 03 Feb 2023 15:09:53 +0100
Date:   Fri, 3 Feb 2023 15:09:53 +0100
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
Subject: Re: [PATCH 5/9] net: ethernet: mtk_eth_soc: fix RX data corruption
 issue
Message-ID: <Y90VsYieanKFNqO3@lunn.ch>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <96c628df0991104d255e6d4696988686387bc2ef.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96c628df0991104d255e6d4696988686387bc2ef.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 07:02:28AM +0000, Daniel Golle wrote:
> Also set bit 12 when setting up MAC MCR, as MediaTek SDK did the same
> change stating:
> "If without this patch, kernel might receive invalid packets that are
> corrupted by GMAC."[1]

Do you have any idea what this bit means? It would be nice to have a
more meaningful description.

     Andrew
