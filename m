Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B001689B4E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbjBCOQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjBCOPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:15:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8F223C69;
        Fri,  3 Feb 2023 06:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mIdkNxO2PeXN7NX9iwQvrkcNhH067wYy3ILLQ43S/uM=; b=QZobhosZ4yaMophkOzFpD7hj7p
        OqAIkeCRiLM7CaRAuQlph4lwXS0Vv7DPUNg9O3LMXeQd+AkYkF8vooNbv5inpAEpBOH7a71W+TSvp
        R79YAm9vlFdHaQfINpolWtu7r+aB0Ozq0sgJmqGVe8nMfmvf8fPzzrqJPM/NhL7+fGew=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNwph-0040Y3-40; Fri, 03 Feb 2023 15:14:29 +0100
Date:   Fri, 3 Feb 2023 15:14:29 +0100
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
Subject: Re: [PATCH 7/9] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <Y90Wxb8iuCRo06yr@lunn.ch>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <30f3ff512a2082ba4cf58bf6098f2ed776051976.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f3ff512a2082ba4cf58bf6098f2ed776051976.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> index 6e7e6c346a3e..cf65646656e9 100644
> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -18,6 +18,12 @@ config PCS_LYNX
>  	  This module provides helpers to phylink for managing the Lynx PCS
>  	  which is part of the Layerscape and QorIQ Ethernet SERDES.
>  
> +config PCS_MTK
> +	tristate
> +	help
> +	  This module provides helpers to phylink for managing the LynxI PCS
> +	  which is part of MediaTek's SoC and Ethernet switch ICs.

You should probably have a more specific name, for when MTK produces a
new PCS which is completely different.

Also, how similar is this LynxI PCS to the Lynx PCS?

      Andrew
