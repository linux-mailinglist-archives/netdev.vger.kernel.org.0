Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6AB65110F
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiLSRPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiLSRPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9331F44;
        Mon, 19 Dec 2022 09:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4146B6108E;
        Mon, 19 Dec 2022 17:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AA6C433EF;
        Mon, 19 Dec 2022 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671470145;
        bh=sfoj+z+/KgSaC2QLeTBWe4LDJAxz4o4w3GPXQmLL12g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nn5uAx170Brn2qFFchmhxW1qTFRz5A/rSuyc2PZspsHkj+/pv1KHN6nWL5huJEKpS
         j1MZdbPCSu7tCQdxCSrQyg3EaPqfjANuvQSeUoTPGStRqBOYIrp9/DiRXeSu45zlN4
         Bsu9112AP39XWmz6Yzw2a6Qv1UB9mBEl4FgW0UkPtU4+65Sviqu12+nkrt0TeWqQOF
         3hvjOogTn08e4GgDkCOzWN7L7k0nyTvmEe3gPBL/f7HktJ4dCfM9foDMmwAKp+zpyk
         ZzVtTHSpTlYhFII+6vSxJbHapL43uKWEcwVppzrxrNgNyoR/eJV40Ra+JSpo9IdBbe
         YA0UoZSV6ERaQ==
Date:   Mon, 19 Dec 2022 09:15:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v7 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <20221219091544.695aa814@kernel.org>
In-Reply-To: <Y52Vp+xMSUS2CgJe@gvm01>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
        <20221216204538.75ee3846@kernel.org>
        <Y52Vp+xMSUS2CgJe@gvm01>
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

On Sat, 17 Dec 2022 11:10:47 +0100 Piergiorgio Beruto wrote:
> > # Form letter - net-next is closed
> > 
> > We have already submitted the networking pull request to Linus
> > for v6.2 and therefore net-next is closed for new drivers, features,
> > code refactoring and optimizations. We are currently accepting
> > bug fixes only.
> > 
> > Please repost when net-next reopens after Jan 2nd.
> > 
> > RFC patches sent for review only are obviously welcome at any time.  
>
> Hello Jakub, sorry for asking dumb questions, but what exactly "RFC"
> means? I understand you cannot accept new submissions at this time, but
> does this means the patchset I just submitted can still be reviewd so
> they are ready for integration on Jan 2nd?

Yes, exactly. You can keep posting new versions, to get reviews and get
the code ready for merging once net-next re-opens. Once net-next
re-opens you'll need to repost (it'd be too much work for us to keep
track of all "pending" work during the shutdown).

By the RFC I mean - change the [PATCH net-next] to [RFC net-next] or
[PATCH RFC net-next] if you post during shutdown, so that we know that
you know that the patches can't be merged _right now_.
