Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9374C234F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 06:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiBXFUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 00:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiBXFUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 00:20:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C61A170D4C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 21:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C059E617F3
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 264B8C36AE3;
        Thu, 24 Feb 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645680010;
        bh=m7PoUv7oLPZ2Il8En2sdKEsd9g4qnoTecX91GqdGlBQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LeyHpxujUdfBjw1debdKMmHMOM37nvZpEwQLhIKueuqbwmGA45a0aZIpOINR7RHbF
         Ia0wMxfdmYkb1+oHzBb7vsR1BsG6L6/nl3VwzoPXIvgrcUHpJ62TcPySt0PdT8Hhv2
         ummy1dCXO2waj49b8nGadKH+xN6MuUZk/pr8Y8bkxaPEj5lOlr6wI8i5AYafnFF/6c
         1RM6Y890HZfWc7hvevGKkQT0AASbE57UaxMmiSCGVhc/rzFllpwEs1XZJIjBU4R5Pu
         LHQBFCnVUN+55+1D01orM9Gf7tvlgib33bpYv485vXeXRaoMW2aqGmxsiEFhZ2hW6i
         zNIPrkDpwjohg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09B4CEAC081;
        Thu, 24 Feb 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v2 net-next PATCH 0/2] Add ethtool support for completion queue
 event size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164568001003.3592.15842373523179006720.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 05:20:10 +0000
References: <1645555153-4932-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1645555153-4932-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sundeep.lkml@gmail.com, hkelam@marvell.com, gakula@marvell.com,
        sgoutham@marvell.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 00:09:11 +0530 you wrote:
> After a packet is sent or received by NIC then NIC posts
> a completion queue event which consists of transmission status
> (like send success or error) and received status(like
> pointers to packet fragments). These completion events may
> also use a ring similar to rx and tx rings. This patchset
> introduces cqe-size ethtool parameter to modify the size
> of the completion queue event if NIC hardware has that capability.
> A bigger completion queue event can have more receive buffer pointers
> inturn NIC can transfer a bigger frame from wire as long as
> hardware(MAC) receive frame size limit is not exceeded.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] ethtool: add support to set/get completion queue event size
    https://git.kernel.org/netdev/net-next/c/1241e329ce2e
  - [v2,net-next,2/2] octeontx2-pf: Vary completion queue event size
    https://git.kernel.org/netdev/net-next/c/68258596cbc9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


