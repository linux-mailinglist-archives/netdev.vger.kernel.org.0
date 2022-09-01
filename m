Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653A85A913A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiIAHvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbiIAHv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B789FAA5
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 00:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9142461D91
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 07:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDDF4C433D6;
        Thu,  1 Sep 2022 07:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662018616;
        bh=Jdm4wIvxcAs2vsXIVt3HzCAIsv4aK+TM3u1Nc5cU5+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bpvpIIk/DCWHd2uBaJQuFT/CBe5hcJ+NfN2iYWYg7a3G9ukYFZrsYulX7gNkTo//U
         RXuzwNu99fX7cpP1AUvJD5PxL3YMn3UEmU04t2pDZYW8aEQHYaeSBOFqEj5oKUEksN
         Kk2BPRgcwOamDkNNnbgagf7wBTnYqYYcRBnjGi8PcQFFmK/Ass7JgiP5j3oEujNZsR
         P89DeVC5mDfZU7Xn4/DOZbc4JwxvNOWXQdLNVDsXFO7pjMHcixCgvOYlS+o4cit/DU
         5HVD5nqnT6eXE0VrFKzj7F4QRZZNQRkEPOmCM24XmPXYhBUkjiXeO4wBuNC9sHyYw8
         /rLOVfOiXkcvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7A26E924D9;
        Thu,  1 Sep 2022 07:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH V6] octeontx2-pf: Add egress PFC support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166201861581.13579.14972919288562660670.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 07:50:15 +0000
References: <20220830120304.158060-1-sumang@marvell.com>
In-Reply-To: <20220830120304.158060-1-sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 30 Aug 2022 17:33:04 +0530 you wrote:
> As of now all transmit queues transmit packets out of same scheduler
> queue hierarchy. Due to this PFC frames sent by peer are not handled
> properly, either all transmit queues are backpressured or none.
> To fix this when user enables PFC for a given priority map relavant
> transmit queue to a different scheduler queue hierarcy, so that
> backpressure is applied only to the traffic egressing out of that TXQ.
> 
> [...]

Here is the summary with links:
  - [net-next,V6] octeontx2-pf: Add egress PFC support
    https://git.kernel.org/netdev/net-next/c/99c969a83d82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


