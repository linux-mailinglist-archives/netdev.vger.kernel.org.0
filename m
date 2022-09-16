Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07E85BA96A
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiIPJaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiIPJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BE8A3D78
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48727B824A9
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3DB7C433C1;
        Fri, 16 Sep 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663320616;
        bh=AGG/D0dZtCFhy91EQaxFU6Lha/moZDOQdRQ9U6Z7gBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SSqO3CUYvUFFA9WxR2UZ47CNDUoaRKPCOThaPV6XKavw+bNNFxwCNOq1aCrvvCwrA
         xoLhM83odgcH/38xXAQdXkhYNAgWZkkjMqy3uZ/3X2KEn5u1LqfFPhqbMo3HVfdiTq
         IeqSNoBYEIvQxBk8z7UrypElIxxxKWaXv6dU0Eusal0gwcFPihYts0T9zgKU+RK8R8
         JWcGHLtvT9i3UN0ZVhQ5exAl9vRh/UmDt2eYVcoASFlTHEBr/g0vf6p4NvsuvUwrtK
         9vvCBadVxdYb9M6WJEM6C1KKazhARNFYL4G1Gx6fPjXXRcixXCDGaUy5C4gd+ahUTG
         +YM6R9poOIQnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7309C73FFC;
        Fri, 16 Sep 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rtnetlink: advertise allmulti counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332061579.20358.18209852246485392938.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 09:30:15 +0000
References: <20220906095558.15031-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220906095558.15031-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

On Tue,  6 Sep 2022 11:55:58 +0200 you wrote:
> Like what was done with IFLA_PROMISCUITY, add IFLA_ALLMULTI to advertise
> the allmulti counter.
> The flag IFF_ALLMULTI is advertised only if it was directly set by a
> userland app.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> [...]

Here is the summary with links:
  - [net-next] rtnetlink: advertise allmulti counter
    https://git.kernel.org/netdev/net-next/c/7e6e1b57162e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


