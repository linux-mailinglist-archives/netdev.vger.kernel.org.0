Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32FC64F796
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 05:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLQErE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 23:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLQEqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 23:46:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6222E1115B;
        Fri, 16 Dec 2022 20:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18BB8B81E80;
        Sat, 17 Dec 2022 04:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E824C433AC;
        Sat, 17 Dec 2022 04:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671252339;
        bh=YhguYoinvvvG/5zQFCcgah/24bq8DyjeNTEZpBTsscI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+zGGtvBivu7Qr66XCDiCcNCMZ+oGe+3q2bZCApY/Q3NG5Shqei0a4+j7EVNlHjw+
         RZnEwfO23pl+EeimQVJxdun4V6+qVdd2OdfU+d/OdIFN6B1sCclG4p5ZmOV64PrrRc
         12kufAmOjgyhXPTmfeGq56IclkNUHPIK8dc8TQt306gbtgibROsTjCpHNEgd7QZthz
         ojF/ghV9RqBtkG7Q0MVjtUIDYsU3j691vIBClGyrSMdHwlv9KgpLJCM7wTnP2nLjvy
         ZCxtv9NnVj5ZUovFQlh0jFDOptzwmRoka+RO3iVBsdzsIZlDqye15KknIjKbBMvrOW
         VkZpiGMuqtN/w==
Date:   Fri, 16 Dec 2022 20:45:38 -0800
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
Message-ID: <20221216204538.75ee3846@kernel.org>
In-Reply-To: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
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

On Sat, 17 Dec 2022 01:48:09 +0100 Piergiorgio Beruto wrote:
> This patchset adds support for getting/setting the Physical Layer 
> Collision Avoidace (PLCA) Reconciliation Sublayer (RS) configuration and
> status on Ethernet PHYs that supports it.

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd.

RFC patches sent for review only are obviously welcome at any time.
