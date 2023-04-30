Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8596F2929
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 16:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjD3OPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 10:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3OPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 10:15:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02BA171E;
        Sun, 30 Apr 2023 07:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YJtCwQvXEsgN/DAG5ktUpq5HtX6DvhAJ6ab2hmFg45Q=; b=PGkwTjefbDsRkIxZOZyAAxXYvc
        DRfxK+n+tV6/ZTbjyhSBZu5rooMxurrXu1pxh1XmlNyosfcR2WuMzNz2PXzC1jrD7Y+g5HXD9Qgz+
        my4wpqPsnUPHABpedUl0HjB3faSt4mfNAhg75u5JUK5tZWN4ODSO4OlsnoRITmj/pyhQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pt7ov-00BYQq-LY; Sun, 30 Apr 2023 16:14:33 +0200
Date:   Sun, 30 Apr 2023 16:14:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bauer <mail@david-bauer.net>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/2] mt7530: register OF node for internal MDIO bus
Message-ID: <842530f0-78b9-4cfe-9469-d20b1c0b5259@lunn.ch>
References: <20230430112834.11520-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430112834.11520-1-mail@david-bauer.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 01:28:32PM +0200, David Bauer wrote:
> The MT753x switches provide a switch-internal MDIO bus for the embedded
> PHYs.
> 
> Register a OF sub-node on the switch OF-node for this internal MDIO bus.
> This allows to configure the embedded PHYs using device-tree.
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>

Hi David

Please read

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

You should put the tree in the patch subject.

Also, net-next is closed at the moment due to the merge window. Please
only post RFC patches during this time, and repost once net-next opens
again.

	Andrew
