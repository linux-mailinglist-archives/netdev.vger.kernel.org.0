Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34E56DB7FB
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 03:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjDHBaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 21:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDHBaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 21:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02393113C3;
        Fri,  7 Apr 2023 18:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 858DD64F11;
        Sat,  8 Apr 2023 01:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDB2DC4339B;
        Sat,  8 Apr 2023 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680917418;
        bh=ST49drH5XE8wAGGKdEej2JeiagrxN7qoOaHr8ZCDhFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P8nd8wivEaDG7a0Y6pCE0becZHlwy9Ggr5nXPTqVpTIzQkEtCgN6sQ4LVqRv2I307
         bjKKGfRyYppeFAisp3o3DcGLPPAFjMxNIn5vra3tzUf5XBtA0vm92uQPCrB8kIjK2y
         EaUq/3myyMCWl39+FvMleZ/qbbQee6APg157E5rOBDMB3kkY+2UnMQuXR3a00AnXUD
         Xhb0NXaxGNynj9UdCBBs3gTjZMssG0FWoI/CBcqfkDzBX7CgDQe+qXvhPH19UQLpyE
         yJUgJt+IyFNa+jRCeIrzF2CTTepVPRQAaIyuOc8N7LyRIsZy7PxDpRoG1aAqa6ydsF
         t80RtBmDClXOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1BFAC4167B;
        Sat,  8 Apr 2023 01:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-04-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168091741872.13847.5359569013775020600.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 01:30:18 +0000
References: <20230407224642.30906-1-daniel@iogearbox.net>
In-Reply-To: <20230407224642.30906-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  8 Apr 2023 00:46:42 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 4 non-merge commits during the last 11 day(s) which contain
> a total of 5 files changed, 39 insertions(+), 6 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-04-08
    https://git.kernel.org/netdev/net/c/029294d01907

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


