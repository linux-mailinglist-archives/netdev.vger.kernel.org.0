Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EF055CC67
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiF1FVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244713AbiF1FUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:20:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E6B2BB0F;
        Mon, 27 Jun 2022 22:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CAF35CE1E21;
        Tue, 28 Jun 2022 05:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57111C3411D;
        Tue, 28 Jun 2022 05:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656393426;
        bh=xmVWOoWZhk9VF36Zkrlyh06JziflhI5QKam3v92NMvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TlVCCepDrRxZtmEXvs4LRZA3aNZ2uAYFJbUvtcR43+vNK9OATwsOgQcoKHIozHxnt
         JkRTdfsD1EB1uy/ndCKrdW2nKzq/9e7Xi+fXPiDW7tUSn1qnu0X1s3xvY9Oolmv/pM
         1Kq5ueb8cT7kVVYMhLmYHmE4AHFgRvHXK7hQFHTGGZiRbN5EUvjjb9ZKI7ZujfBtcR
         kRyHZGd7G3HkWgEFgMzbOb7+969VpZJukq/q35rVkWw9y29nck2DILB+/fOQQafyQb
         RH5yPGzTpsUolrfY5jwBcZfJiat1pjJKw9QOtA1Rf+qqJror9UPfZGJZGQVHKic4/R
         1R4AZDAQHGUkQ==
Date:   Mon, 27 Jun 2022 22:17:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next v2 1/1] net: phy: ax88772a: fix lost pause
 advertisement configuration
Message-ID: <20220627221705.0a49f3c9@kernel.org>
In-Reply-To: <20220626152703.18157-1-o.rempel@pengutronix.de>
References: <20220626152703.18157-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jun 2022 17:27:03 +0200 Oleksij Rempel wrote:
> Subject: [PATCH net-next v2 1/1] net: phy: ax88772a: fix lost pause advertisement configuration
> 
> In case of asix_ax88772a_link_change_notify() workaround, we run soft
> reset which will automatically clear MII_ADVERTISE configuration. The
> PHYlib framework do not know about changed configuration state of the
> PHY, so we need use phy_init_hw() to reinit PHY configuration.
> 
> Fixes: dde258469257 ("net: usb/phy: asix: add support for ax88772A/C PHYs")

Why net-next?
