Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D45E7C94
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiIWOLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiIWOKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:10:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BA7EE677
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 07:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41493B835C9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09246C433D6;
        Fri, 23 Sep 2022 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663942217;
        bh=2XQblwQOIx1y1nzqRy6xLcBViHjKbVGvJqHUgEqb6bU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NICiDc/rGxSq57tf89MMBMrUtYqI074TuUs1Ujp35Rf1xehg292uwZRWTE2tqKvT7
         Ll6gzbghdNLjH+uRzyEaYJaYOHRl0ctpPPRnHfNDcP75ZCRie/qac+bW+yZwl1UFdh
         bHgJCTcD8/n5/+b8AS7yDErKgZ/3RIv2OiI4/SfWnpDlN/uo6KzVqWTmYV94dQ1xtI
         IgU/5/3EtvuteNVATEJInKmk5/rqqewttTytKpDn6KATSSH6N2eBlOautKFbX2ry6/
         dIUir4SdD0fASRIhMZD6jE+v4hEMijZ7B6a4GIlRP3NULIkHNvkuhRYFGJW2M4RBiC
         BsMDXbg9GZmEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7F3EE4D03B;
        Fri, 23 Sep 2022 14:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: macsec: remove the preparation phase when
 offloading operations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166394221694.18573.1133791210451449421.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 14:10:16 +0000
References: <20220921135118.968595-1-atenart@kernel.org>
In-Reply-To: <20220921135118.968595-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        sundeep.lkml@gmail.com, saeedm@nvidia.com, liorna@nvidia.com,
        dbogdanov@marvell.com, mstarovoitov@marvell.com,
        irusskikh@marvell.com, sd@queasysnail.net, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 15:51:11 +0200 you wrote:
> Hello,
> 
> It was reported[1] the 2-step phase offloading of MACsec operations did
> not fit well and device drivers were mostly ignoring the first phase
> (preparation). In addition the s/w fallback in case h/w rejected an
> operation, which could have taken advantage of this design, never was
> implemented and it's probably not a good idea anyway (at least
> unconditionnally). So let's remove this logic which only makes the code
> more complex for no advantage, before there are too many drivers
> providing MACsec offloading.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: phy: mscc: macsec: make the prepare phase a noop
    https://git.kernel.org/netdev/net-next/c/920d998e5322
  - [net-next,2/7] net: atlantic: macsec: make the prepare phase a noop
    https://git.kernel.org/netdev/net-next/c/135435f90b94
  - [net-next,3/7] net: macsec: remove the prepare phase when offloading
    https://git.kernel.org/netdev/net-next/c/854c9181738f
  - [net-next,4/7] net: phy: mscc: macsec: remove checks on the prepare phase
    https://git.kernel.org/netdev/net-next/c/6b701f4101e0
  - [net-next,5/7] net: atlantic: macsec: remove checks on the prepare phase
    https://git.kernel.org/netdev/net-next/c/27418b55f094
  - [net-next,6/7] net/mlx5e: macsec: remove checks on the prepare phase
    https://git.kernel.org/netdev/net-next/c/36c2ebced3a8
  - [net-next,7/7] net: macsec: remove the prepare flag from the MACsec offloading context
    https://git.kernel.org/netdev/net-next/c/99383f1298ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


