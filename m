Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27356B56C0
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 01:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjCKAdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 19:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCKAcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 19:32:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78116140880
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 16:31:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6C57CE2B53
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 00:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACCBEC4339B;
        Sat, 11 Mar 2023 00:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678494617;
        bh=6LTt2nEwlFtx4vLFtDToP2glfhY4r3OCvCwKaN+X96s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T/b2l0r1K1/n641DRWUCWABnUKrexY7E+bt8/MAnWK+3TdDFb+vioPw6hIzdRuVpv
         gaomOa40m4m1eELVKk5e0dju4A9ixdtA2wNFHzPK8RDMuYYeSZQyQ0gthrJuuUIbb6
         2NqB7F8kJkrtPPkIoHlJpirWlWF9E1gtyjFLK25uBZvtZx5xvx8d9MIecNQqlXNn/j
         qmYKAasaiOnjElerSp51OzrKXGcj8WB8gnRQbDFYs5LMFnulgPPflRVL68+E4vco1J
         FWF6gklAhTZuyEKVUn1oWO8dL0v3Ni+G4uwDwDojLOnxUbPZWhblZJOfJ90zBmPnd0
         VRiXxYdNkvKpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 890DCE61B66;
        Sat, 11 Mar 2023 00:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvpp2: Defer probe if MAC address source is not
 yet ready
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167849461755.17032.13638100422486547595.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 00:30:17 +0000
References: <20230307192927.512757-1-miquel.raynal@bootlin.com>
In-Reply-To: <20230307192927.512757-1-miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 20:29:27 +0100 you wrote:
> NVMEM layouts are no longer registered early, and thus may not yet be
> available when Ethernet drivers (or any other consumer) probe, leading
> to possible probe deferrals errors. Forward the error code if this
> happens. All other errors being discarded, the driver will eventually
> use a random MAC address if no other source was considered valid (no
> functional change on this regard).
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvpp2: Defer probe if MAC address source is not yet ready
    https://git.kernel.org/netdev/net-next/c/cc4342f60f1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


