Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FB86E0603
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDMEaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjDMEaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7003A19AD
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B6BB63B65
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 672F0C4339B;
        Thu, 13 Apr 2023 04:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681360218;
        bh=8Zo3C51+Y9rBEE9dfs9mhpIbexWMbWjBOO4/nD4uiD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pl6J6ksGFhdepcVLNVi01C97TPn0FGxE39zi1UfEH2a14q7HrxzKI8p5vYTJ435jw
         XDksIj787MGZgxc+rRo9gkEFcGZBNFG5SVny8J9HBDDihEWapS97TCmMU4rugh8JZ1
         cXrdvA4nsAPKBMHaTuydySUhCIhHPtswggo83ks+oab1Bme0OGABLXEQhWkkUD37c/
         Y6WfIY5o6D3NeXZxmOYEegqmQxR73V11ShlC1+hgAEe00tyXB2oftRl0mXKPWXMqcX
         adeu5hVKhRc7nNK9BBlVOUx6/fp25r/8YpB7owiey4B1PDsfBIyMLhyp2G4jCucyTo
         0Az6A4qe2J56g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C138E5244C;
        Thu, 13 Apr 2023 04:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168136021829.16838.13251103753658514690.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 04:30:18 +0000
References: <20230411074319.24133-1-martin@strongswan.org>
In-Reply-To: <20230411074319.24133-1-martin@strongswan.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     kuba@kernel.org, liuhangbin@gmail.com, gnault@redhat.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Apr 2023 09:43:19 +0200 you wrote:
> The commits referenced below allows userspace to use the NLM_F_ECHO flag
> for RTM_NEW/DELLINK operations to receive unicast notifications for the
> affected link. Prior to these changes, applications may have relied on
> multicast notifications to learn the same information without specifying
> the NLM_F_ECHO flag.
> 
> For such applications, the mentioned commits changed the behavior for
> requests not using NLM_F_ECHO. Multicast notifications are still received,
> but now use the portid of the requester and the sequence number of the
> request instead of zero values used previously. For the application, this
> message may be unexpected and likely handled as a response to the
> NLM_F_ACKed request, especially if it uses the same socket to handle
> requests and notifications.
> 
> [...]

Here is the summary with links:
  - [net] rtnetlink: Restore RTM_NEW/DELLINK notification behavior
    https://git.kernel.org/netdev/net/c/59d3efd27c11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


