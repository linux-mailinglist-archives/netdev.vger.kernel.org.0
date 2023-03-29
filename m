Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1AF6CEF56
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjC2Q2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjC2Q2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:28:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6FA423F;
        Wed, 29 Mar 2023 09:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+jXKHUtknIYsW5onYdVNmhni/4ffvAb6VEdjSV93nTE=; b=ozxBKntl/ns+qAe7u20tANVKv9
        YIlNEYw9i1spyxcvKMyhffdh1Ie71kiyuTFQlms0H0sUa6nlJXM1NFr3+kYxuLyKpJakw6wo4mcct
        d0GQEsZv9t5QstfXFsQxvX6f6km9k4dK+s+pp9sF2/Zs9af/2rD0YzkP0Xl9U8T0BXek=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phYf8-008mVT-W7; Wed, 29 Mar 2023 18:28:38 +0200
Date:   Wed, 29 Mar 2023 18:28:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next v3 06/15] net: dsa: mt7530: move
 p5_intf_modes() function to mt7530.c
Message-ID: <38703034-8977-495c-aadd-ea93d13395da@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <98fc2eec00985854010e3d0d16ba7f4c924ab49f.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98fc2eec00985854010e3d0d16ba7f4c924ab49f.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:58:35PM +0100, Daniel Golle wrote:
> In preparation of splitting mt7530.c into a driver for MDIO-connected
> as well as MDIO-accessed built-in switches on one hand and MMIO-accessed
> built-in switches move the p5_inft_modes() function from mt7530.h to
> mt7530.c. The function is only needed there and will trigger a compiler
> warning about a defined but unused function otherwise when including
> mt7530.h in the to-be-introduced bus-specific drivers.

The other way to avoid the warning is to mark it inline. The compiler
will not warn than. But this solution is also good.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
