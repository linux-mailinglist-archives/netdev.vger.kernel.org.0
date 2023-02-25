Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7356A26FF
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 04:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBYDjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 22:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBYDjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 22:39:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CC511EB9;
        Fri, 24 Feb 2023 19:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A00CB81D50;
        Sat, 25 Feb 2023 03:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0BBC433D2;
        Sat, 25 Feb 2023 03:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677296348;
        bh=XXze3Sjj7WbVfvZxz/aCfOexYBYT1qmo9ERftndHi0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XlyLCQpOUmv0pbuDZj6pycEWxiVLURzT8Ovz/8nK+SoPeWZvNjD3LWJjJODUs3HfA
         Q+VXQjHhtt8qxclSpbap5iZu2tyk1uPkJiNEG5xx44PWNrcPg0tkJ2lx7PZEfyHAeI
         WercHZOXK/6rDIdfesabZVKeAC8DBV60ZbU07fcdqZU6Dfahff9ZWBwBAbQnjddiSQ
         gQQROSHd7xvfoeual5+fLENGVIzMgmHWc2SfUGjvoBLTO6EVqgCQCp0svexvyidgFz
         Y9ghtvN7+dAChNswXceDFMEIO7kl64P6GqxvBP+sardfBgeMWgQB7qJNj0aWgpErWD
         SPbDi81d9737g==
Date:   Fri, 24 Feb 2023 19:39:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Yang <leoyang.li@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        David Bauer <mail@david-bauer.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: phy: at803x: remove set/get wol callbacks
 for AR8032
Message-ID: <20230224193907.7a3b3a47@kernel.org>
In-Reply-To: <20230224225158.12229-1-leoyang.li@nxp.com>
References: <20230224225158.12229-1-leoyang.li@nxp.com>
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

On Fri, 24 Feb 2023 16:51:58 -0600 Li Yang wrote:
> Since the AR8032 part does not support wol, remove related callbacks
> from it.
> 
> Fixes: 5800091a2061 ("net: phy: at803x: add support for AR8032 PHY")
> Signed-off-by: Li Yang <leoyang.li@nxp.com>

You need to repost the entire series, please, both patches.
