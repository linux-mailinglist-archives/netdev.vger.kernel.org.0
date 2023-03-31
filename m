Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EAC6D19AD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjCaIU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjCaIUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1D3B44C
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C28E1B82CF4
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89491C433A7;
        Fri, 31 Mar 2023 08:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680250817;
        bh=WrLxVmZLD+qxnksn+do+n12nRjE94Yc5u+f+/6ROeyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EsQepvYkdk2S54RBhfv9lBljcEt9vI/QYGb39digruXKB17eh2Baeni3hyGT7tLnf
         z4/E5rG3mEobqNj32CkPg1Sdj27DuwS757/t/miZ1jpmk9fsdoQAopQxl3PMqKIkkZ
         JTbuxFZwluSaDFLmlmdVePKmVH9sHbPZNvC3UUuhCXYamtgRIAlwcl7fk4sh4Uy56H
         ksSH9RwyDABLqMMceAD+1hlyHj3zcx7TTjNX82t7ijRhAFzAssd3p6UfGZ78LC6228
         ARjsK75jxj4cl2/ZQmTqURZSK2wT4MvKyZfHlhBi8Pi/+aR80E0VW9BSUwVitePdHT
         Hcwm4BzyK0MSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74371C73FE2;
        Fri, 31 Mar 2023 08:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next] tcp: Refine SYN handling for PAWS.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168025081746.23963.3556017879967087708.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:20:17 +0000
References: <20230329201348.79003-1-kuniyu@amazon.com>
In-Reply-To: <20230329201348.79003-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org,
        kerneljasonxing@gmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 29 Mar 2023 13:13:48 -0700 you wrote:
> Our Network Load Balancer (NLB) [0] has multiple nodes with different
> IP addresses, and each node forwards TCP flows from clients to backend
> targets.  NLB has an option to preserve the client's source IP address
> and port when routing packets to backend targets. [1]
> 
> When a client connects to two different NLB nodes, they may select the
> same backend target.  Then, if the client has used the same source IP
> and port, the two flows at the backend side will have the same 4-tuple.
> 
> [...]

Here is the summary with links:
  - [v3,net-next] tcp: Refine SYN handling for PAWS.
    https://git.kernel.org/netdev/net-next/c/ee05d90d0ac7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


