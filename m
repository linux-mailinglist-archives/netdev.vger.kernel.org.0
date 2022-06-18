Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCE75503F1
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiFRKAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiFRKAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B54527FE0
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A92D460B1F
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2E99C3411D;
        Sat, 18 Jun 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655546413;
        bh=N7/ZZI1pUW9MkPE9RhMpPEqzp2wG5k/aGq6M6gSa7ic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mzZVFAcGRva8TU12Y75HB+7KpBtcfeqQfxXhZ8L+eEIPONXYXv9Qh21Y6/Iwx7Sdv
         nYJIQPtxK0JCEWFAWj64rFZ0PDy/AoqHjNN7o+r6XBu/YI1u/hm/p9Pmpnk2KrbIA0
         P3XfIACF2UILjECNoFa+1hcP1858MccIkoV5PceAn823atT0nvoxve6m/hLCF7KMQ6
         nOKGrOQu6bj8xWwXhEMpWo7if/cW7um44xuikuQFcPb43ork+KE3/ha905bZWvrqEZ
         oOIAe5at74hLWdn5B8QK7cVp7GvalmbHLXaQQhfDGSc2osxgfjpUwxZb8lbPvxA8G4
         /dkpaR66RY0LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D832BE73856;
        Sat, 18 Jun 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ping: convert to RCU lookups, get rid of rwlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165554641288.13053.1993828248844047948.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 10:00:12 +0000
References: <20220618040415.2810867-1-eric.dumazet@gmail.com>
In-Reply-To: <20220618040415.2810867-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Jun 2022 21:04:15 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Using rwlock in networking code is extremely risky.
> writers can starve if enough readers are constantly
> grabing the rwlock.
> 
> I thought rwlock were at fault and sent this patch:
> 
> [...]

Here is the summary with links:
  - [net-next] ping: convert to RCU lookups, get rid of rwlock
    https://git.kernel.org/netdev/net-next/c/dbca1596bbb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


