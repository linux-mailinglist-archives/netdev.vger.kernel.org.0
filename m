Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF7D5736C0
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 15:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbiGMNAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 09:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiGMNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 09:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C9101D6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 06:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BBD461C0D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59972C341C0;
        Wed, 13 Jul 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657717215;
        bh=VmPcrwWamrkB7M/EMtyUDfVJbpKQPxyrwXtuDLy3WYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DyJNx4sJwq/kvLMCnO2CPmDIjth6r/c6SvrZTYpulMq03n8OVXldMUpiFUTl8AcPg
         ORxfWsRjNr0oMnJytipaXa+2WkuPNSEgWXqw+K8R8mDLPkgEFRX/qa5EWmAeE19UXk
         he4bOAn64V9pbk31NPhoVz7VBv8jzx+WdRjpB5yr+iErHhZntPnr8DFkEcv0wvM5Jt
         xVvdLL5ME2ZJFnFPCWlou/k8Q9ug6kST0qUqSPaj+vU9VwMsI0MN/K2DQchZtMFEhe
         v+Zm3brOrg/P9nNmv8PK+6kra+YDcS3+H1OcwGIXAggcyf/FvH9vUrfMdch5bwKqxe
         059zdnaRz3Ujg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3227DE4521F;
        Wed, 13 Jul 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v4 0/3] net: devlink: devl_* cosmetic fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771721519.13289.13441352030498760999.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 13:00:15 +0000
References: <20220712102424.2774011-1-jiri@resnulli.us>
In-Reply-To: <20220712102424.2774011-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Jul 2022 12:24:21 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Hi. This patches just fixes some small cosmetic issues of devl_* related
> functions which I found on the way.
> 
> Jiri Pirko (3):
>   net: devlink: fix unlocked vs locked functions descriptions
>   net: devlink: use helpers to work with devlink->lock mutex
>   net: devlink: move unlocked function prototypes alongside the locked
>     ones
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] net: devlink: fix unlocked vs locked functions descriptions
    https://git.kernel.org/netdev/net-next/c/1abfb265f0ac
  - [net-next,v4,2/3] net: devlink: use helpers to work with devlink->lock mutex
    https://git.kernel.org/netdev/net-next/c/7715023aa51f
  - [net-next,v4,3/3] net: devlink: move unlocked function prototypes alongside the locked ones
    https://git.kernel.org/netdev/net-next/c/277cbb6bc4bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


