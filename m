Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37C557730F
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 03:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiGQBmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 21:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiGQBmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 21:42:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB961B79B;
        Sat, 16 Jul 2022 18:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pxLtEH6tpw7Sv+7IwACboiErEsBk3U/dKmQVdf2JRE8=; b=SXGFWucFyNSzFoZLxj6A5Ffjnd
        1y8Lh3rDJzV0DShWunGNndwlrJuu6JEwztIZlVydLvaNJzlrF5HNFbxqlmOBaS396z4HWs9ILDDSv
        Dsf2a8mmuARZK9SjjLK64RrPpcfIv+RxlUsfHT4XNvdIgT5Gbz7GwBC2E/LdUjWTw3zQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCtIt-00AapI-7L; Sun, 17 Jul 2022 03:42:39 +0200
Date:   Sun, 17 Jul 2022 03:42:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 14/47] net: phy: aquantia: Add support for
 rate adaptation
Message-ID: <YtNpD/BJqgXvbt9J@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-15-sean.anderson@seco.com>
 <YtMFljr/I7UtSr+y@lunn.ch>
 <55276de5-85dc-d668-e9db-b0b8248dd47d@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55276de5-85dc-d668-e9db-b0b8248dd47d@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> /* The following registers all have similar layouts; first the registers... */
> #define VEND1_GLOBAL_CFG_10M				0x0310
> ...
> /* ... and now the fields */
> #define VEND1_GLOBAL_CFG_RATE_ADAPT			GENMASK(8, 7)

O.K, that will also help prevent the misunderstanding i had.

     Andrew
