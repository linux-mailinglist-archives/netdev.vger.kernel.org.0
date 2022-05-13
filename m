Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA955258E1
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 02:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358376AbiEMAKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 20:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358319AbiEMAKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 20:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E002854BF
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1079962097
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 00:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CE03C36AE2;
        Fri, 13 May 2022 00:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652400616;
        bh=JbS/rmpejRBSfPID7pmgrDoAQCwbtlhFbGt9yFa1HDc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q8gFJVla9kX4rU1RgWtSp2uN8bRTWdhzqBGRbG2WiVGbgWehO9NkJwI4CLYk5mXW1
         bnSvmzfn5Ggmw7Q0sjtbOqNlMz54uMxeze0JchFk7Q0R8mjJlyro5JPdM1w7gELqq8
         Mn7CNA56yTCoWBwUx4FAFBoTl53ADg4nWyJgOFq6m9FhQuJUAWEYvMuxDkQCt4nFFe
         YOoUVWyjloRVnA2SMIPfPGgIgn+/I5Gd9bSinOY/L1SnS28zFwvlrp1BhN2hc1mn81
         3GClyrSKSS/51j5W85S1yZoX3tleLYxxkrXC1oWMwVPeDqsLOIINHBXKOYiKZVHge+
         4IwIrxt49yAqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4021DF03936;
        Fri, 13 May 2022 00:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: inet: Retire port only listening_hash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165240061625.28704.9389642618042706808.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 00:10:16 +0000
References: <20220512000546.188616-1-kafai@fb.com>
In-Reply-To: <20220512000546.188616-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, kernel-team@fb.com, pabeni@redhat.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 17:05:46 -0700 you wrote:
> This series is to retire the port only listening_hash.
> 
> The listen sk is currently stored in two hash tables,
> listening_hash (hashed by port) and lhash2 (hashed by port and address).
> 
> After commit 0ee58dad5b06 ("net: tcp6: prefer listeners bound to an address")
> and commit d9fbc7f6431f ("net: tcp: prefer listeners bound to an address"),
> the TCP-SYN lookup fast path does not use listening_hash.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: inet: Remove count from inet_listen_hashbucket
    https://git.kernel.org/netdev/net-next/c/8ea1eebb49a2
  - [net-next,2/4] net: inet: Open code inet_hash2 and inet_unhash2
    https://git.kernel.org/netdev/net-next/c/e8d0059000b2
  - [net-next,3/4] net: inet: Retire port only listening_hash
    https://git.kernel.org/netdev/net-next/c/cae3873c5b3a
  - [net-next,4/4] net: selftests: Stress reuseport listen
    https://git.kernel.org/netdev/net-next/c/ec8cb4f617a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


