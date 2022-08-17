Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85C5975D6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbiHQSkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiHQSkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2359F1B6;
        Wed, 17 Aug 2022 11:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 263E96135E;
        Wed, 17 Aug 2022 18:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74B48C433D7;
        Wed, 17 Aug 2022 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660761615;
        bh=FC+hyB7LK/o5a60oWBKYC1LMF2qYGY7HqJf5s3BH7tE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NXIqrL8Da/kUrB6TH/Lirt2DLmp3EwieNg3/aKm5wQZOB9pjcFBhGnTdb3xhc2DDg
         A8XbgJxi3h7e/aOoGziO54vRk64iGxAG4GzgwkOo/Qg+sk32ZEOUJAYfygD6aVzUDn
         BFegnnpJKDpp6knp/PdjL6khNAd53gCjPcIKlbOo6XlSZWp0F6XZKqKntYuL5HGymQ
         KXgznn4MYAz7P8+DWJKLTsvWpY2vg0OSOvMXnM+gpKMRUDxxny344hWCqtumPBTrIE
         6/hFhii3+FBl98BnZjTms7kR02szDn4ohwcjiZcKEVvAo65VauUluYKtV1xKcIPdrW
         nlx18TgFpHGfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 574FFE2A04C;
        Wed, 17 Aug 2022 18:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166076161535.20898.1055751517702359437.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 18:40:15 +0000
References: <20220815175009.2681932-1-f.fainelli@gmail.com>
In-Reply-To: <20220815175009.2681932-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Aug 2022 10:50:07 -0700 you wrote:
> Hi all,
> 
> This patch series has the bcm_sf2 driver utilize PHYLINK to configure
> the CPU port link parameters to unify the configuration and pave the way
> for DSA to utilize PHYLINK for all ports in the future.
> 
> Tested on BCM7445 and BCM7278
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: bcm_sf2: Introduce helper for port override offset
    https://git.kernel.org/netdev/net-next/c/1ed26ce4850a
  - [net-next,2/2] net: dsa: bcm_sf2: Have PHYLINK configure CPU/IMP port(s)
    https://git.kernel.org/netdev/net-next/c/4d2f6dde4daa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


