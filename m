Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8309C5BBA17
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 21:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiIQTU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 15:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIQTUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 15:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2040313FBB;
        Sat, 17 Sep 2022 12:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B5361162;
        Sat, 17 Sep 2022 19:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC630C4347C;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663442421;
        bh=7z02HwYE97MzqoXLBWv5kfYTPI36tjd0pf5FzY/Q0ZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UIXL1eVEKM8OEp7+aveAkhJHQ7dlDf4AcDiAULGrf2FngwEvzRiL+tfn3otbY1RKr
         Vktd1YSj75OwkpQscvmrThDb4m2bthFY/cH2UfyK6MtLOav/mu6/Ekj27yA0v2OO+W
         9pMaKLztwWkaMw0WlMWHEx9WeiFsINomsxw+Ss7ht93y2evo9xkzEHSFDGinjPP1Ok
         J1mGhRwMIywYZ1KYH84AXVuetk45FI6uW5y+qn4STynQM1bQycCn8AoS+bDNgqoU5a
         a7uhUI2OYVYdOkARkYqqHKSFJwlOqMjIPN3t14WG7nBpuaOy/pwE08GyM4Msb2Yk7Y
         hpCKfnUx5xGwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF021C73FFD;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/4] Add PTP support for CN10K silicon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166344242177.31603.2337871573726752416.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Sep 2022 19:20:21 +0000
References: <20220910075416.22887-1-naveenm@marvell.com>
In-Reply-To: <20220910075416.22887-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com
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
by David S. Miller <davem@davemloft.net>:

On Sat, 10 Sep 2022 13:24:12 +0530 you wrote:
> This patchset adds PTP support for CN10K silicon, specifically
> to workaround few hardware issues and to add 1-step mode.
> 
> Patchset overview:
> 
> Patch #1 returns correct ptp timestamp in nanoseconds captured
>          when external timestamp event occurs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] octeontx2-af: return correct ptp timestamp for CN10K silicon
    https://git.kernel.org/netdev/net-next/c/a8025e7946a2
  - [net-next,2/4] octeontx2-pf: Add support for ptp 1-step mode on CN10K silicon
    https://git.kernel.org/netdev/net-next/c/2958d17a8984
  - [net-next,3/4] octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon
    https://git.kernel.org/netdev/net-next/c/2ef4e45d99b1
  - [net-next,4/4] octeontx2-af: Initialize PTP_SEC_ROLLOVER register properly
    https://git.kernel.org/netdev/net-next/c/85a5f9638313

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


