Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8768E812
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 07:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjBHGKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 01:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjBHGKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 01:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6976E3C2AC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 22:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B84AB81AC8
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A96AAC433D2;
        Wed,  8 Feb 2023 06:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675836619;
        bh=WyJlBC5lm89gaSbO+TZXjIpb9Dq8ScRAIt8sg1RkTSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y45nuTFjnbDyghvBHfwZNW9J4ZuqkpX0+1bN2beCDheTbJaHNW0x/lq8NI72TwK0z
         8U6Kgo6L2+E837xk661rvx74N6kKOEdf9Hbstv2KVrp5RIokMhHzVZCkMcJxhfus/I
         4B0wucehMqeoomHlOvY/eViTmQXK7rmSUEC8qlLqXJnOriY5hzgNZVd3EeWtQCu5fA
         r81p7eltNohYjUcSVJSlQ0/z1TgvbqD0qe60vWSn5MLubFyvNx+gWa57cswSpGkHJ/
         AN11GggdogmMJJZLJnttysm2aQqL6GIOAkxYxNTVKZlh7j51QcqHKzYHF0Vv+1Cdvd
         KO2NboZ2ipQ1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E7C2E50D62;
        Wed,  8 Feb 2023 06:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/5][pull request] Intel Wired LAN Driver Updates
 2023-02-06 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583661951.4518.3475924362565986323.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 06:10:19 +0000
References: <20230206232934.634298-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230206232934.634298-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon,  6 Feb 2023 15:29:29 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Ani removes WQ_MEM_RECLAIM flag from workqueue to resolve
> check_flush_dependency warning.
> 
> Michal fixes KASAN out-of-bounds warning.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/5] ice: Do not use WQ_MEM_RECLAIM flag for workqueue
    https://git.kernel.org/netdev/net/c/4d159f7884f7
  - [net,v2,2/5] ice: fix out-of-bounds KASAN warning in virtchnl
    https://git.kernel.org/netdev/net/c/b2dbde3ad44f
  - [net,v2,3/5] ice: Fix disabling Rx VLAN filtering with port VLAN enabled
    https://git.kernel.org/netdev/net/c/c793f8ea15e3
  - [net,v2,4/5] ice: Fix off by one in ice_tc_forward_to_queue()
    https://git.kernel.org/netdev/net/c/3f4870df1b15
  - [net,v2,5/5] ice: switch: fix potential memleak in ice_add_adv_recipe()
    https://git.kernel.org/netdev/net/c/4a606ce68426

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


