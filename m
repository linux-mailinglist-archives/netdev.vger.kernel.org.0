Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DA7609F0E
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJXKa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJXKaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0B931DEF
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85308611DE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6F9DC43141;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666607419;
        bh=ai6z823b0G/TUEUZOfcO6d/2MYgy4Oz76tJ+jahceNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U6QnNRxUv/gnxf0rhER25b3BlRDMXyktN6KYtfHj/MuQ6a/AbldifZHg1wSX6zn4l
         75isqEwmu9BO6dfLSM1WomzM5pIMkaabNVmfRQaA/4GpPiZmw5K4u5rl/VhAX4UQVv
         tjpd7FkldjI3WqMRIwVfpMT02qO0rqNb6Wf62cz2P/whuVCq6ETpOEda2dA5Miwhw9
         YXgJ6VaqC/sYkRMUpd5QXedZEzQwmvVK2A5Uze5AYRox0KtMbV0vKKJIoXjAdtVGPU
         3PXH6ygF/AHIWYxK52OT4GM8Z2ibDXOxeZtv0wj+eYFxBvOzO3pTdF/0seWLbm344q
         5uascItrZgigA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAA77E4D005;
        Mon, 24 Oct 2022 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] udp: avoid false sharing on receive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660741981.18313.518994743736905929.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 10:30:19 +0000
References: <cover.1666287924.git.pabeni@redhat.com>
In-Reply-To: <cover.1666287924.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, mptcp@lists.linux.dev, dsahern@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuniyu@amazon.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 19:48:50 +0200 you wrote:
> Under high UDP load, the BH processing and the user-space receiver can
> run on different cores.
> 
> The UDP implementation does a lot of effort to avoid false sharing in
> the receive path, but recent changes to the struct sock layout moved
> the sk_forward_alloc and the sk_rcvbuf fields on the same cacheline:
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: introduce and use custom sockopt socket flag
    https://git.kernel.org/netdev/net-next/c/a5ef058dc4d9
  - [net-next,v2,2/2] udp: track the forward memory release threshold in an hot cacheline
    https://git.kernel.org/netdev/net-next/c/8a3854c7b8e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


