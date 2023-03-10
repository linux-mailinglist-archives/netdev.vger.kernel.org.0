Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72B66B375A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCJHa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCJHaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296ACED682
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3AF7B821CD
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 910DFC433A0;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678433419;
        bh=JxyzbTRuKE8ezIwn7gmzz93kuTw8aUFYQB2ufEr0ZpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LATNHYy2J0VK9DwImXFbliuLhUTnVbb1bFZxGxtoffyyRG46PWU8yRmvZ1c9FLuLq
         nudLFjCr7IZuJ8RjmmQvu6WtlqwNrCDJZPMoebz4Sx0gWJtoRMo2P9RydltXnXu/uw
         IKEl82x4L7XdWDR54BpXL3Vuez9AJIaIoJjTI/RZ14LFJaotrt5U2yX8hT1g/IkAam
         4nPgHC3LzP52cOY2q+ZF7w4VGQERzOAKRS0hZBFFhp5PRA5IVUxhIK0LlXXycg/nhu
         exoEsJ374s2xmaVGtO7pOUTqnzu2EeNLGZrGcQkJUvh+Mz7RdwRoQ3fZIBQPB9c1Ig
         aHi/IcEw93lLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7680DE270DE;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] neighbour: delete neigh_lookup_nodev as not used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843341947.20837.4090523688975379446.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:30:19 +0000
References: <eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com>
In-Reply-To: <eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        dsahern@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        razor@blackwall.org, pabeni@redhat.com, stephen@networkplumber.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 11:23:13 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> neigh_lookup_nodev isn't used in the kernel after removal
> of DECnet. So let's remove it.
> 
> Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] neighbour: delete neigh_lookup_nodev as not used
    https://git.kernel.org/netdev/net-next/c/76b9bf965c98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


