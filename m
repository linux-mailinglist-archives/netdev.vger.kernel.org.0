Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EFA6E188C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjDNABG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDNABF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:01:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B9D3C06;
        Thu, 13 Apr 2023 17:01:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA59464282;
        Fri, 14 Apr 2023 00:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B062C433D2;
        Fri, 14 Apr 2023 00:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681430463;
        bh=nmtsqsfaRaGH4vM0/3D2DszYq1ID014TULr/B+Wk+gk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FGi0+nE7NRs4L0o6hrnO6k3V/MBZeAajkwThBwnfSHH1u0ALa/mDdfdUnuLUA0+U6
         WwbfLxzD5tUZROr2B1EYm1lMKhqnYgmH+ZmfxH3/s60nIK9cDJHFuBDUTlIZhml3R8
         6Rk3vPx68fKLwzOwYjYyTW2n8BXtOOhloxt9qHgPnuwT+koN6MS3icieXDktGgui6i
         5GaBUCQ963Akuht1Xuv50AqgMrS0imlcbz66Aq9sTcMC6xOlWdPnC6qS0Z4GjmopoC
         HuLZgI+FhmTbdLTljSw+TMLsV6n7qLlPeOHgyn9/iU5rolVw2IELpgxvsvCP30B9sR
         ZPsoAGp3Z3Vrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E27FDE29F3B;
        Fri, 14 Apr 2023 00:01:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168143046292.7886.11250032168084435124.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 00:01:02 +0000
References: <20230413192939.10202-1-daniel@iogearbox.net>
In-Reply-To: <20230413192939.10202-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 13 Apr 2023 21:29:39 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 6 non-merge commits during the last 1 day(s) which contain
> a total of 14 files changed, 205 insertions(+), 38 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-04-13
    https://git.kernel.org/netdev/net-next/c/029294d01907

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


