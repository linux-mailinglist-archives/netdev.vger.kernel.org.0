Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C74464F798
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 05:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiLQEsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 23:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLQEsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 23:48:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75422291;
        Fri, 16 Dec 2022 20:48:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28851B81E87;
        Sat, 17 Dec 2022 04:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78051C433EF;
        Sat, 17 Dec 2022 04:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671252489;
        bh=InCQkDx4bTocWJ1hE/TxI2ywxvpsXXxtkV5HFgLNXZw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kZRyauRBB9p7YLFetUmOKm/NH84Pdk2DgLgiT6IWj8bJWMGkdzRm6CNBlT7WIfBp7
         QDpa4TGZLt63PsH5URim+Gq+eGTvrVOcCkuSqhM4cgL9vnMv2/HCZ5xT5wkJodzOn7
         JmsPzdCDD3Amd7Onit66z8yv9hJs3F0SHP7eDGNp8P50bpVosXpeU9QSIk9O2z6Yks
         XImEjCHm3zeBEqDj5Hg2JAr7/+DyKN0G1PQiPvJkiSHaud9JMhTOOJTgKYDf4A1sCN
         6YFGePlVr2Hr+6uwFZxafcagwh1QsrYnYmyIIOO3Gu5mXX9ZYTMW3XMLCS2CPD5RfC
         dZK9VuXyJwnLA==
Date:   Fri, 16 Dec 2022 20:48:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v7 net-next 2/5] drivers/net/phy: add the link modes for
 the 10BASE-T1S Ethernet PHY
Message-ID: <20221216204808.4299a21e@kernel.org>
In-Reply-To: <fb30ee5dae667a5dfb398171263be7edca6b6b87.1671234284.git.piergiorgio.beruto@gmail.com>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
        <fb30ee5dae667a5dfb398171263be7edca6b6b87.1671234284.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Dec 2022 01:48:33 +0100 Piergiorgio Beruto wrote:
> +const int phy_basic_t1s_p2mp_features_array[2] = {
> +	ETHTOOL_LINK_MODE_TP_BIT,
> +	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> +};
> +EXPORT_SYMBOL_GPL(phy_basic_t1s_p2mp_features_array);

Should this be exported? It's not listed in the header.
