Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992DC4AF2BF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiBINaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiBINaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:30:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A10C061355
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC1C619B9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5686C340EE;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644413411;
        bh=sEMCnOtRbVFj9HtY90xiri+jJGn67VU7dbYmemq8GCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gUDZFcSCd/3NERnfP1jwfZaSZCfREBMLQSdf122KiZXxNE4t8iWuoltc9eZWYRs5T
         hvGIsAGEntd/amClCjxesZSh+3SrD6KQ9fWd5K3Jyv7xM6JZNEBz1cevtBUxfJEK8o
         mq3BHdCHhjT8p9xzlM7SWW9vzqq5ksbxXMGxNxKqqLkwG5LAKdvJbz8ZkRtN8an0mF
         nIkdH/o1WWcfvzsy+AZF9hS6FrX+Sf0gHP2a+On90AilwtUR7tiwcb02ZpvHK6Hefb
         gGeK1gpF3qcHlKZH08Lv6q9fwJkQn+Plhs+poBh3Y3TyaQJ5t2nfcU/qICQSiK/yfp
         V4P5nd3c1uVSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 921C9E5D07D;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] dpaa2-eth: add support for software TSO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441341159.22778.17109100885682489320.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:30:11 +0000
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        youri.querry_1@nxp.com, leoyang.li@nxp.com
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
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 11:23:28 +0200 you wrote:
> This series adds support for driver level TSO in the dpaa2-eth driver.
> 
> The first 5 patches lay the ground work for the actual feature:
> rearrange some variable declaration, cleaning up the interraction with
> the S/G Table buffer cache etc.
> 
> The 6th patch adds the actual driver level software TSO support by using
> the usual tso_build_hdr()/tso_build_data() APIs and creates the S/G FDs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] dpaa2-eth: rearrange variable declaration in __dpaa2_eth_tx
    https://git.kernel.org/netdev/net-next/c/035dd64de948
  - [net-next,2/7] dpaa2-eth: allocate a fragment already aligned
    https://git.kernel.org/netdev/net-next/c/8378a7910d14
  - [net-next,3/7] dpaa2-eth: extract the S/G table buffer cache interaction into functions
    https://git.kernel.org/netdev/net-next/c/ae3b08177529
  - [net-next,4/7] dpaa2-eth: use the S/G table cache also for the normal S/G path
    https://git.kernel.org/netdev/net-next/c/a4218aef7c86
  - [net-next,5/7] dpaa2-eth: work with an array of FDs
    https://git.kernel.org/netdev/net-next/c/a4ca448e8bfe
  - [net-next,6/7] dpaa2-eth: add support for software TSO
    https://git.kernel.org/netdev/net-next/c/3dc709e0cd47
  - [net-next,7/7] soc: fsl: dpio: read the consumer index from the cache inhibited area
    https://git.kernel.org/netdev/net-next/c/86ec882f59a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


