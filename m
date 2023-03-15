Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74146BA8E7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjCOHUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCOHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B715A197
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEC6461B3C
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33D99C4339B;
        Wed, 15 Mar 2023 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678864817;
        bh=cmhoInlxPl57brnClqgnRpIHEHEzQdXMgELxq3NuKrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kjgXPRV561RLSTJKZazJKV8V63LhymUZZQYpk1A/Ydta0A2i3OQbs0IFqXC3QzgOm
         yfqrhzaBnpZNFhqeWORJ8OcWWksPGkm+5d4K7T29ol5dhM0LBb9bZOK71FgGOy6BbR
         iP1U9u/FPJDy1RaXNqufBVfkNpmDj5tLXB9k9YmlWjB86vOPuAoxXtTZ3ogMEg7RZ+
         lb0J7opycZFfj9jHYH8YX7id7Zp/Hl7PNGn0TOd6YMV84eAO3TZIFq+3rdhinyKzbD
         Ziy5XSgneqyRVvFuwex+dS9cc2lRnnvLl4C6dAaUL/L3rEo5EcurHdnV6dlRVZemjR
         qcPjwuEZKDTgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19067C43161;
        Wed, 15 Mar 2023 07:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: smsc: bail out in lan87xx_read_status if
 genphy_read_status fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886481709.27791.7472125844271091388.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:20:17 +0000
References: <026aa4f2-36f5-1c10-ab9f-cdb17dda6ac4@gmail.com>
In-Reply-To: <026aa4f2-36f5-1c10-ab9f-cdb17dda6ac4@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
        davem@davemloft.net, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, patrick.trantham@fuel7.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 11 Mar 2023 19:34:45 +0100 you wrote:
> If genphy_read_status fails then further access to the PHY may result
> in unpredictable behavior. To prevent this bail out immediately if
> genphy_read_status fails.
> 
> Fixes: 4223dbffed9f ("net: phy: smsc: Re-enable EDPD mode for LAN87xx")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails
    https://git.kernel.org/netdev/net/c/c22c3bbf351e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


