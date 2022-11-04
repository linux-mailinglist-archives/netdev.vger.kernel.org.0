Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94B1618FBF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiKDFAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiKDFA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D627D20F50
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 22:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CC29620B2
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 612F3C4315F;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667538027;
        bh=L6pGhT4K1VahEFtueGJCgnf8u+IzStsSlBQ3uVCR6sI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i/5JdLsNvTCTx7CfN0Cnna3/b7aupU1z11GKQKJBxEXYOYJZt4SUdQX3W6Iu90xBF
         IbEVdMe3/VpRoFQ5f+ibuUHEpGYAcNWrsJ8jmMVUge66R/oojU5V7jav/LgWLtRQYW
         4O5qX3fKtVgD2tbghBsovQ84BkqBZHA3pveRrxBBMiTY75tL+cey8oufrxI2ef1VIO
         24ZJ/Hy8FKa6Yh7U7jytoYsLkb214akrwrbXfkPTElX8j/MDQ+Y97DwIqXcCeMvlrZ
         z+UeaBE88Zd/zuz0VyUhUe6gDnBeAmhsuuS1X0nvvCfyMWnCLD7xMqzvjkZ1NDD4XH
         XZw7ROk46i74g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27EF1E5256D;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] bridge: Add MAC Authentication Bypass (MAB)
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753802715.27738.6160625606606714662.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 05:00:27 +0000
References: <20221101193922.2125323-1-idosch@nvidia.com>
In-Reply-To: <20221101193922.2125323-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  1 Nov 2022 21:39:20 +0200 you wrote:
> Patch #1 adds MAB support in the bridge driver. See the commit message
> for motivation, design choices and implementation details.
> 
> Patch #2 adds corresponding test cases.
> 
> Follow-up patchsets will add offload support in mlxsw and mv88e6xxx.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] bridge: Add MAC Authentication Bypass (MAB) support
    https://git.kernel.org/netdev/net-next/c/a35ec8e38cdd
  - [net-next,2/2] selftests: forwarding: Add MAC Authentication Bypass (MAB) test cases
    https://git.kernel.org/netdev/net-next/c/4a331d346996

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


