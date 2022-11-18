Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FAE62F443
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbiKRMKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241602AbiKRMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD2C8FF92
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DE79B8239A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE761C43147;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668773416;
        bh=SO5Jk/bscG4i1ssG4G7HF2o9ps+CS/vYAGqEhTnOavA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ieUT0qBSe54UdKDRCVVOvwQe98kx+bV/jFPYGkCVsb01OMEdLQGrS+G7j/MePYTgH
         lSsy10zk/HqtAc5F4D3RdnzQnwsHqLa8mUvO8kf4dgM5Si27nxjd651PgbrabeH/ci
         DfkIkUrp48MNPuhAWyz8qWxMVfFiuncUyoVov9PNx3nrx/a+l8ajxf24oSBn4d6+PG
         K5wibg5Ildwp2C72Uz19AqY7KjldJlDtal+iQY1IWV9CjJhpAhMbXZANH/Dh63eoGB
         lxQP0D2nPq6NKvs5CZpDrW3TEWNzY+AyRPrJQrM9NeHTls001IGXHyKTP8n0gar1Sl
         m4TuRXp3ZXlhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD248C395F3;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix napi_disable() logic error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877341683.19277.1347953227533110184.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:10:16 +0000
References: <20221117092641.3319176-1-edumazet@google.com>
In-Reply-To: <20221117092641.3319176-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, lkp@intel.com,
        error27@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 09:26:41 +0000 you wrote:
> Dan reported a new warning after my recent patch:
> 
> New smatch warnings:
> net/core/dev.c:6409 napi_disable() error: uninitialized symbol 'new'.
> 
> Indeed, we must first wait for STATE_SCHED and STATE_NPSVC to be cleared,
> to make sure @new variable has been initialized properly.
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix napi_disable() logic error
    https://git.kernel.org/netdev/net-next/c/fd896e38e5df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


