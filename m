Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDB45A261C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbiHZKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343923AbiHZKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0248413E13
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 458B0617F1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A774BC433D7;
        Fri, 26 Aug 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661511015;
        bh=mjDJOlr25Mw2Vumai+ya3y3Faw4UekwoVcXtjooQgpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JcSq6OqZJuOz7wXpGYpySGVtnB5zNHX9RGcTbtKdpao1k4OZanQzMQTgB2qL2hSt+
         v4QRNKogB82Cayestjqi/M8favgmDXaN4vm91Oes0aO3egniRPuEnBObVCt/dAXQHw
         Mebt1GlExYeL1uLMsjuky3dGLD87PQMiqUOVXcSoJRqCvJSjjm6Tzv2d2KhHSj5zOH
         ggQ+7Mz9FfW+ebVz3A7HFphJpmCzs/ULk/JLJHULlKciW/yMuSimzcHqmLGkGxD66j
         kHK97QK0a/Dktp+L/oy+ECqgWZSamEi+1YojSSl/jYb7uiSa4GGgpeY/DHYxvG6Qa4
         zS4h9tXaTLWNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B806C0C3EC;
        Fri, 26 Aug 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates
 2022-08-24 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166151101556.7212.10845119839320704605.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 10:50:15 +0000
References: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 24 Aug 2022 10:03:35 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Marcin adds support for TC parsing on TTL and ToS fields.
> 
> Anatolli adds support for devlink port split command to allow
> configuration of various port configurations.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: Add support for ip TTL & ToS offload
    https://git.kernel.org/netdev/net-next/c/4c99bc96e050
  - [net-next,2/5] ice: Add port option admin queue commands
    https://git.kernel.org/netdev/net-next/c/781f15eac0d2
  - [net-next,3/5] ice: Add additional flags to ice_nvm_write_activate
    https://git.kernel.org/netdev/net-next/c/da02ee9c220b
  - [net-next,4/5] ice: Implement devlink port split operations
    https://git.kernel.org/netdev/net-next/c/26d1c571e16a
  - [net-next,5/5] ice: Print human-friendly PHY types
    https://git.kernel.org/netdev/net-next/c/f8c74ca6d31c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


