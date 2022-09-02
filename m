Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23A35AADBA
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiIBLcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbiIBLbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:31:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C0A2E6BB
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 04:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CF2BB82A74
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 11:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6C32C4347C;
        Fri,  2 Sep 2022 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662118217;
        bh=yjV37ull43DoYjx0CQIQ/zWPx1JJ5rC3+tzArI/2kk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IgNGAnZZyjPEPQMIIg9CBuzjLo+Ha8jJLl8tlYj3l1/hv079yD2wk17iiYizFaOuI
         uCnJr0bD+O8XVHeSBXSk/z8mtF23XqGRJ1CyQ3WCcBAYv/sRCmlzC4YeA7HRi69sLp
         fVhv/uwP/SqOOloUE5U/YQklbfsAii++Me/3NLjChE029cZ3x4056niaQvT4U0OGMy
         vThgI3NhJ/bm7zOkNqfutp0anpC1722cEpll2LSRLirEcJUJQan6X4UXj2qSUSImMO
         q9OX7HCMDRAdq0OUwfkp+jfGtl8b3KwLmxxlJhc/Q7spicqpnScbsocl0/Vm9q5fZd
         SbDHatg+xrCmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD0A5E924E4;
        Fri,  2 Sep 2022 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bql: add more documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166211821782.29115.595912736821808211.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 11:30:17 +0000
References: <20220831184427.119855-1-edumazet@google.com>
In-Reply-To: <20220831184427.119855-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 31 Aug 2022 18:44:27 +0000 you wrote:
> Add some documentation for netdev_tx_sent_queue() and
> netdev_tx_completed_queue()
> 
> Stating that netdev_tx_completed_queue() must be called once
> per TX completion round is apparently not obvious for everybody.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bql: add more documentation
    https://git.kernel.org/netdev/net-next/c/977f1aa5e4d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


