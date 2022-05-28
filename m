Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AABB536D51
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 16:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiE1OkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 10:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiE1OkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 10:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5B417E08
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 07:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 426E460DED
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95587C34117;
        Sat, 28 May 2022 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653748811;
        bh=lKDy/nYpMOe2CHpo5ZQ22UHPCpZVR3wt+SUQNAogoP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gdTKzJt0lnW5i2GJ91I1+H67LsvJrwu52eaH6QJePlrhbiy+uJXSdkPrXjvq3akyO
         wXYGzZkIarR0dmop31hngF4T8e8eBTnsHqbV9ZVj1C8vCaZHNWhmOfCLVWmbGYjeoh
         IvtZJllnGqWWnUcZiVrT611DstODrEmihwxXEjVBbXUix24/YJIIP/W53ZthpmI4I2
         BQDT0Qv31GKKSVvVajysEfyu4obAjz8V2gFkTVkXja1JF3ewHdKXNSuAKnZxPZ8wp6
         X6GiazeVR9XAfFf4ei+hknGSx5vRjv4V6Ci+5P/wtIcYzSBI/nUGpMamIMR0gSz7u+
         XneF4LrRZsllw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7ACE7F0394B;
        Sat, 28 May 2022 14:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: NS target should accept link local address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165374881149.13902.3468751378080291217.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 14:40:11 +0000
References: <20220527064439.1837544-1-liuhangbin@gmail.com>
In-Reply-To: <20220527064439.1837544-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        jtoppins@redhat.com, eric.dumazet@gmail.com, pabeni@redhat.com,
        liali@redhat.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 27 May 2022 14:44:39 +0800 you wrote:
> When setting bond NS target, we use bond_is_ip6_target_ok() to check
> if the address valid. The link local address was wrongly rejected in
> bond_changelink(), as most time the user just set the ARP/NS target to
> gateway, while the IPv6 gateway is always a link local address when user
> set up interface via SLAAC.
> 
> So remove the link local addr check when setting bond NS target.
> 
> [...]

Here is the summary with links:
  - [net] bonding: NS target should accept link local address
    https://git.kernel.org/netdev/net/c/5e1eeef69c0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


