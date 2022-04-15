Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1350316D
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356186AbiDOVxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355324AbiDOVxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:53:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96636F4AB
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD7BB82984
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5ABB6C385AC;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650059413;
        bh=S/5czjLFeXZyeqnWnrC5VBkTbc2L069C4YBgM3bQtMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jS9YWnqlRHw3BJeSt4TvUYDf6QkMfPYHbms0nlh3JmqIoBFnW4gCYtJExA2YTHzdR
         LajJ7X9x3cyChYsFcVKKTkX8+4skxK9y2W+YDXKQMMWOpwIHHwulHdJZV+L5FJKzV+
         4Ng8OLtF+vHDJE8hDo4VIOK4d2Qeo/Xvh517fLMEWc1eWO5CWvymlcPscMRDqcpWaj
         qyaX/sjYODMDYiiCECvO6Yis/zMEH/APzECT++AZikJluEFzMFm/j8BO0RGkbxLNhY
         8Wl9x7+v6X0AH6vq4dBMxU4P8f/QJRiPOgqpPBevPUJMcA9uwmc6kSpaxjIFPcv47H
         OpRex0nqerDFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 411AFEAC09C;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005941326.21261.8176132098810046591.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:50:13 +0000
References: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 13 Apr 2022 10:08:10 -0700 you wrote:
> This series contains updates to igc and e1000e drivers.
> 
> Sasha removes waiting for hardware semaphore as it could cause an
> infinite loop and changes usleep_range() calls done under atomic
> context to udelay() for igc. For e1000e, he changes some variables from
> u16 to u32 to prevent possible overflow of values.
> 
> [...]

Here is the summary with links:
  - [net,1/4] igc: Fix infinite loop in release_swfw_sync
    https://git.kernel.org/netdev/net/c/907862e9aef7
  - [net,2/4] igc: Fix BUG: scheduling while atomic
    https://git.kernel.org/netdev/net/c/c80a29f0fe9b
  - [net,3/4] igc: Fix suspending when PTM is active
    https://git.kernel.org/netdev/net/c/822f52e7efdc
  - [net,4/4] e1000e: Fix possible overflow in LTR decoding
    https://git.kernel.org/netdev/net/c/04ebaa1cfdda

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


