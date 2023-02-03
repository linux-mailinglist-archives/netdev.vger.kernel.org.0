Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBDE68A5E9
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 23:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjBCWP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 17:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbjBCWPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 17:15:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB5F9AFFE;
        Fri,  3 Feb 2023 14:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/oOX3mUfZ059lIwtS2mwbC+ZjkP9jdI7GXT9///iDy0=; b=M2C6HmZVKRMsCkYXlsvoLP83qs
        1PwDGAxlT8ZgLu+Vyaeb8J0srxkoBiQgoMM5VyziAoPPM4UbZi3uNv7nLQjfOSuJWkHz8t++xrk6F
        nKcT8enxHANEeh6arXYRQvQ4lUcfioEICLvGRNYnVj+tH/3JZxwcoXozYefVhEYyq8DU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pO4Kx-0042yR-5h; Fri, 03 Feb 2023 23:15:15 +0100
Date:   Fri, 3 Feb 2023 23:15:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
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
        Florian Fainelli <f.fainelli@gmail.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 2/9] net: ethernet: mtk_eth_soc: set MDIO bus clock
 frequency
Message-ID: <Y92Hc++jn6M6AIBQ@lunn.ch>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <a613b66b4872b5f3f09544138d03d5326a8f6f8b.1675407169.git.daniel@makrotopia.org>
 <a613b66b4872b5f3f09544138d03d5326a8f6f8b.1675407169.git.daniel@makrotopia.org>
 <20230203214844.jqvhcdyuvrjf5dxg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203214844.jqvhcdyuvrjf5dxg@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Checking for valid range? There should also probably be a dt-bindings
> patch for this.

This is a common mdio property in mdio.yaml. So there should not be
any need for a driver specific dt-binding.

    Andrew
