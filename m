Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461D969E28E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 15:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbjBUOkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 09:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjBUOke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 09:40:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3D02B63E;
        Tue, 21 Feb 2023 06:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5E90B80EF7;
        Tue, 21 Feb 2023 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65439C433EF;
        Tue, 21 Feb 2023 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676990417;
        bh=98RTAS5I3GOhN4YHxK4PZb4nfDpKcjj1Kgt+v1jX2YE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VnTFAdH6m0SOIgkzc/UBLhbL/8w1d6ubvNlR0nVQazVbn7ik5yn+ehDbbBVzV3Ef7
         Z3LWo7iDwZ8iiTpux43sbXYnRTFL8ma8OlPEICfB9jGBhVqpJxwTbxMP4au/fSey6L
         3Jh8pOw7FTrVbajybSuxwzXp4ZScjvlo2liL4P59dgzBueZNFkNkiP4XhiG2to2uh0
         nL9pyr2GE6XF39HeGw1pd8NI5QQQdCR7oolZNk+LcNhQDqPBmfpkyACLYNyqSsi2FZ
         VjT3FmEJu+4fmJzFX1dGoGgtA/+jKSSHWqd4OH/oh9S2e8/Sx8HNY/72X3fHrIfJQd
         CI06grkC27V/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F16FC43158;
        Tue, 21 Feb 2023 14:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net] sefltests: netdevsim: wait for devlink instance after
 netns removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167699041732.3034.4066968173144089634.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 14:40:17 +0000
References: <20230220132336.198597-1-jiri@resnulli.us>
In-Reply-To: <20230220132336.198597-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        amirtz@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 20 Feb 2023 14:23:36 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> When devlink instance is put into network namespace and that network
> namespace gets deleted, devlink instance is moved back into init_ns.
> This is done as a part of cleanup_net() routine. Since cleanup_net()
> is called asynchronously from workqueue, there is no guarantee that
> the devlink instance move is done after "ip netns del" returns.
> 
> [...]

Here is the summary with links:
  - [net] sefltests: netdevsim: wait for devlink instance after netns removal
    https://git.kernel.org/netdev/net/c/f922c7b1c1c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


