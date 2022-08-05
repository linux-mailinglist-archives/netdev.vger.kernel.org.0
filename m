Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0F58A798
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 10:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbiHEIAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 04:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiHEIAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 04:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FAB260B
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 01:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74F54616D8
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 08:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCA82C433D6;
        Fri,  5 Aug 2022 08:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659686414;
        bh=eAl9+tN3zKJE1up6oX5TzOJGsARArZzViyesqr+k9E8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ajaqV+CaUw8MC8EVv9g2gj25l0R1U6xzm0/MdWVEQsmMwkcsp20aotS4fpqXxqob6
         /VjWU3duJPcoP4Y7czDQB9fCn+mGIXdRkjtBo4tsYUUHvVIphnFkZrOvhYNxHAs+TF
         /hmnKBqsLInUjkfTCVRQFgGLGm1LrCkzan/6gu4T2Rxnlpy9MzwBmi26hRbsmYX++n
         nHg+ppGKKwYS8TOyGrDRVnyjhqw+G+bt76bdC5BdxLyHt4upZIHHJQyM7dxFPe1DPi
         ekpPCPY6NnmLpX3vU9wWZXdog73srzde3+r4IHi9zrEv9OorGKC2X2i0YcwrGh7z7B
         O384Aij5ML/4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4E5FC43140;
        Fri,  5 Aug 2022 08:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mptcp: Fixes for mptcp cleanup/close and a selftest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165968641473.31624.9455539276558516892.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Aug 2022 08:00:14 +0000
References: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, fw@strlen.de, dcaratti@redhat.com,
        mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 Aug 2022 17:21:24 -0700 you wrote:
> Patch 1 fixes an issue with leaking subflow sockets if there's a failure
> in a CGROUP_INET_SOCK_CREATE eBPF program.
> 
> Patch 2 fixes a syzkaller-detected race at MPTCP socket close.
> 
> Patch 3 is a fix for one mode of the mptcp_connect.sh selftest.
> 
> [...]

Here is the summary with links:
  - [net,1/3] mptcp: move subflow cleanup in mptcp_destroy_common()
    https://git.kernel.org/netdev/net/c/c0bf3c6aa444
  - [net,2/3] mptcp: do not queue data on closed subflows
    https://git.kernel.org/netdev/net/c/c886d70286bf
  - [net,3/3] selftests: mptcp: make sendfile selftest work
    https://git.kernel.org/netdev/net/c/df9e03aec3b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


