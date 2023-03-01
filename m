Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBEF6A721B
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCARa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCARaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086FB196A1
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 09:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E38CB81088
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 17:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D1F9C4339B;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677691818;
        bh=+W53ThascfwSLU4jXGwa0SUtvtiblCK3+PlVnPmf7BM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aYO+pvZVOwQCnUSeEoZRR1gd2DHaIuuHlVs3hl1WJHWdP50A/bFiE3UoTmvoBGhmE
         nlq+LU5PJzJ82D8E1o/QcJfkHemXQxbFDuQ3jcIZNlgTAlbkvjqfeBzcb/qgHstQab
         pY60nX0wwrM4pCQiiKeV3etNqxhQ4Nsc5m7g8RJdHT6/2WYOCatJLCb2PeXXa0HjYg
         +E7BAwe6U9pRqPuoXbDdQqrcl4clE+xn++D9bhZzJLCoRItaTyOtg1W34RixtUw876
         l4u/rNZe2GFPpuyWHUu8DA5mU/N4WGrfuvecrv6j/uz1dHZ0Dc5Cyia6lfwwgRHuHk
         xPvAUOt2eCn9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1944C395EC;
        Wed,  1 Mar 2023 17:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: flower: fix fl_change() error recovery path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167769181791.25108.3743440606092002176.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Mar 2023 17:30:17 +0000
References: <20230227184436.554874-1-edumazet@google.com>
In-Reply-To: <20230227184436.554874-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+baabf3efa7c1e57d28b2@syzkaller.appspotmail.com,
        syzkaller@googlegroups.com, paulb@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Feb 2023 18:44:36 +0000 you wrote:
> The two "goto errout;" paths in fl_change() became wrong
> after cited commit.
> 
> Indeed we only must not call __fl_put() until the net pointer
> has been set in tcf_exts_init_ex()
> 
> This is a minimal fix. We might in the future validate TCA_FLOWER_FLAGS
> before we allocate @fnew.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: flower: fix fl_change() error recovery path
    https://git.kernel.org/netdev/net/c/dfd2f0eb2347

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


