Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661F457AB40
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiGTBAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiGTBAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF2E2A
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50DFD61721
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8BEEC341CE;
        Wed, 20 Jul 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658278813;
        bh=eznlbhHnBSqzI+iCCt2cNxHK8+0WWamAzsLFTbYZ4X0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FWAAIVvLcbJlZMksru9w+rXp3RE5b3vdZ0sOyaCtJKxjwawqhkzUveKsnfRwOYCpj
         3sYe4Jh4IGwjxZGjl01iv2bezUPk4EqQYGwWoGZ6K8auSTbVdu1ZcS8MQJh899u+pq
         uZVKzfGq3u7a9LoNpt/u3AAsTPVgbAEJSN7ggmcgy5n7k33MFCkM4TBhyzvJf2396+
         vWNwJgnP+Rm7WvzjOlRDK0R1lhWJawJmpoGX+7L7AE1hXYDdsNhW08Xo8aj9HPRtQj
         YYftBxKbD+3hEaZBrwed8c157E9i6KCfbBDDFUL8WI/4H/mOMPdngMKv+jyZeLOm7Q
         faFFcCC2g9zgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A43FE451B0;
        Wed, 20 Jul 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-07-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165827881356.21433.5825241131111257864.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 01:00:13 +0000
References: <20220718180109.4114540-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220718180109.4114540-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sasha.neftin@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 18 Jul 2022 11:01:06 -0700 you wrote:
> This series contains updates to igc driver only.
> 
> Kurt Kanzenbach adds support for Qbv schedules where one queue stays open
> in consecutive entries.
> 
> Sasha removes an unused define and field.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igc: Lift TAPRIO schedule restriction
    https://git.kernel.org/netdev/net-next/c/a5fd39464a40
  - [net-next,2/3] igc: Remove MSI-X PBA Clear register
    https://git.kernel.org/netdev/net-next/c/fb24f341c7b9
  - [net-next,3/3] igc: Remove forced_speed_duplex value
    https://git.kernel.org/netdev/net-next/c/6ac0db3f2bf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


