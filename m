Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F625709A4
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 20:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiGKSAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 14:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGKSAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 14:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044827643;
        Mon, 11 Jul 2022 11:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E3E6137F;
        Mon, 11 Jul 2022 18:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E868BC341C8;
        Mon, 11 Jul 2022 18:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657562417;
        bh=opFjFQDhmxBamXMAmVZz4cx1gLgHEmCQauUWMnWCeMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e3KMjGSMtZNNSH4Q1SYkcXpzn7T20pxMdbj3zTQxs83g2cjxgFFx53l4Qt5r9nKUK
         YC/2Uc5gSnZPuen5pr5odIBK++CLQXwiAcScEBHoiDmvi0NGzBEwf68Nsf6eCV/7re
         JG3FTi9lsferj8dpY00aFH/tOE493JueABUBWb5paswa/7g2JY6Vm8I1oLdA2IDV6i
         3dBO1fgSf1EHq2vgqUkx24AH0qAwauM3Uv8mL9P9Pap8+e2+4rBi36UQ+Zxz9VFbAI
         4slb6Oao/X01Hgovu3DR3ZhfS98dvvzYfKG3Yhu+d35wSoZ8NM/5JZf47GvkCIca8p
         /777+/xB44SNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF5AFE4521F;
        Mon, 11 Jul 2022 18:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v5 00/12] octeontx2: Exact Match Table.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165756241684.27191.3816847388683645025.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jul 2022 18:00:16 +0000
References: <20220708044151.2972645-1-rkannoth@marvell.com>
In-Reply-To: <20220708044151.2972645-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 8 Jul 2022 10:11:39 +0530 you wrote:
> Exact match table and Field hash support for CN10KB silicon
> 
> ChangeLog
> ---------
>   1) V0 to V1
>      a) Removed change IDs from all patches.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/12] octeontx2-af: Use hashed field in MCAM key
    https://git.kernel.org/netdev/net-next/c/56d9f5fd2246
  - [net-next,v5,02/12] octeontx2-af: Exact match support
    https://git.kernel.org/netdev/net-next/c/b747923afff8
  - [net-next,v5,03/12] octeontx2-af: Exact match scan from kex profile
    https://git.kernel.org/netdev/net-next/c/812103edf670
  - [net-next,v5,04/12] octeontx2-af: devlink configuration support
    https://git.kernel.org/netdev/net-next/c/ef83e186855d
  - [net-next,v5,05/12] octeontx2-af: FLR handler for exact match table.
    https://git.kernel.org/netdev/net-next/c/bab9eed564ed
  - [net-next,v5,06/12] octeontx2-af: Drop rules for NPC MCAM
    https://git.kernel.org/netdev/net-next/c/3571fe07a090
  - [net-next,v5,07/12] octeontx2-af: Debugsfs support for exact match.
    https://git.kernel.org/netdev/net-next/c/87e4ea29b030
  - [net-next,v5,08/12] octeontx2: Modify mbox request and response structures
    https://git.kernel.org/netdev/net-next/c/292822e961cc
  - [net-next,v5,09/12] octeontx2-af: Wrapper functions for MAC addr add/del/update/reset
    https://git.kernel.org/netdev/net-next/c/2dba9459d2c9
  - [net-next,v5,10/12] octeontx2-af: Invoke exact match functions if supported
    https://git.kernel.org/netdev/net-next/c/d6c9784baf59
  - [net-next,v5,11/12] octeontx2-pf: Add support for exact match table.
    https://git.kernel.org/netdev/net-next/c/fa5e0ccb8f3a
  - [net-next,v5,12/12] octeontx2-af: Enable Exact match flag in kex profile
    https://git.kernel.org/netdev/net-next/c/bb67a66689e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


