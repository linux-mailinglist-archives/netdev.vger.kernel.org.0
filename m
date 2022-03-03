Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B364CC333
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbiCCQu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiCCQu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:50:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497EF1965FC
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 08:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3540616B7
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 16:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F72DC340E9;
        Thu,  3 Mar 2022 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646326210;
        bh=bXFyaEImBLcfD2R6v7XYg00dwBrOF6vrwDVZaDY+uBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mcyhq3p5c1P1rZdl3hJFx6W7lv9dCjQvrFVyDEgmvow2enxVEqHL2iZ+y+BmhX4jL
         UvtjK8i2BI+qhJryd5DdFTGooe5CFKQF1GqkuI6rY2c/dotjgqrqaI2L4ghd686K5f
         KnX4+9tfGwZBS+Q4enl8BItE1F6/4unjRWGWrN5IF7U4CPA9LzlBS006AaTelkWPGg
         EU4zOA+fbpsfgAM+oYkAXZBMAtGsbxxzbnN7r5zNkBXKThC+4xGOmaqIAQtPWy6Tlj
         KM5Z/noRYEs0K8PLznRyftnwD6HcrvMMftCLPLf7TaKQESBf3v/MynewUtdr6vWYYD
         udOiGPIhW3BMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 221FBE7BB08;
        Thu,  3 Mar 2022 16:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: make dsa_tree_change_tag_proto actually unwind
 the tag proto change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164632621013.577.14592111702310142613.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 16:50:10 +0000
References: <20220303154249.1854436-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220303154249.1854436-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Mar 2022 17:42:49 +0200 you wrote:
> The blamed commit said one thing but did another. It explains that we
> should restore the "return err" to the original "goto out_unwind_tagger",
> but instead it replaced it with "goto out_unlock".
> 
> When DSA_NOTIFIER_TAG_PROTO fails after the first switch of a
> multi-switch tree, the switches would end up not using the same tagging
> protocol.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: make dsa_tree_change_tag_proto actually unwind the tag proto change
    https://git.kernel.org/netdev/net/c/e1bec7fa1cee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


