Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B644675122
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjATJam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjATJag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:30:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D0F95177
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8393F61ED0
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF147C4339C;
        Fri, 20 Jan 2023 09:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674207018;
        bh=fW3Nx69ktm6ZsLgfMttJiMrS+oCbE7RiCMZHUmsoBps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QW19KlG/8Oe2G8x5lC9dWhWwg3rWFBVfLgi1181RBd6iU7lg5Ek3qYMbisvp7f0/K
         JnVOwUBDQ1o7CfPRyZilTraUrY7VgVO6HadoTXMsVWmj4XoCdMWD0aRmj7X/kmQdKN
         Mtv6TEr7J9Kceo1eY8nGoW/3PxW7vGqEiEMe+RUoFMAfvBIsgNj4DGrAkC2glwJCGo
         bUYDvT2ZhUphqozEG1OtKhGnAMX1E8TYjKJ4IKvsoBcpY2wKBswyZMMRruxB801gLn
         whCJ0BSLnnr67ooIp+YfCUWJa80bVKxTKZx/r23kPNqqQZ1imNThfR43LWWCm52VO0
         PgpTuA4NJNFcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C90FDC39564;
        Fri, 20 Jan 2023 09:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/7] octeontx2-af: Miscellaneous changes for CPT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167420701881.26805.5515498713994832752.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 09:30:18 +0000
References: <20230118120354.1017961-1-schalla@marvell.com>
In-Reply-To: <20230118120354.1017961-1-schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jerinj@marvell.com,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 18 Jan 2023 17:33:47 +0530 you wrote:
> This patchset consists of miscellaneous changes for CPT.
> - Adds a new mailbox to reset the requested CPT LF.
> - Modify FLR sequence as per HW team suggested.
> - Adds support to recover CPT engines when they gets fault.
> - Updates CPT inbound inline IPsec configuration mailbox,
>   as per new generation of the OcteonTX2 chips.
> - Adds a new mailbox to return CPT FLT Interrupt info.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/7] octeontx2-af: recover CPT engine when it gets fault
    https://git.kernel.org/netdev/net/c/07ea567d84cd
  - [net-next,v3,2/7] octeontx2-af: add mbox for CPT LF reset
    https://git.kernel.org/netdev/net/c/f58cf765e8f5
  - [net-next,v3,3/7] octeontx2-af: modify FLR sequence for CPT
    https://git.kernel.org/netdev/net/c/1286c50ae9e0
  - [net-next,v3,4/7] octeontx2-af: optimize cpt pf identification
    https://git.kernel.org/netdev/net/c/9adb04ff62f5
  - [net-next,v3,5/7] octeontx2-af: restore rxc conf after teardown sequence
    https://git.kernel.org/netdev/net/c/d5b2e0a299f3
  - [net-next,v3,6/7] octeontx2-af: update cpt lf alloc mailbox
    https://git.kernel.org/netdev/net/c/c0688ec002a4
  - [net-next,v3,7/7] octeontx2-af: add mbox to return CPT_AF_FLT_INT info
    https://git.kernel.org/netdev/net/c/8299ffe3dc3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


