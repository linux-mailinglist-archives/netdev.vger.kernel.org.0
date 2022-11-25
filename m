Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F28063865F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKYJkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKYJkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E44F3057D;
        Fri, 25 Nov 2022 01:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A191C622D2;
        Fri, 25 Nov 2022 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3D43C433B5;
        Fri, 25 Nov 2022 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669369216;
        bh=fmRtuC7qoZgKz6GjmyYeShBCMrg5TxHCkd1anieLDik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sBWEVuOR3hUPlQnfARhQ1Kq91D0IsRczQqNGnED01fBcISQ5BjyjiIXtcBguDLJIz
         bV1bRAepLepSDIci7PNCBV3K/vAx1+cF/zqCdTWbFI3m5DuVlgcZW000hG4WJS/Rcd
         ChbJK+J8I5YW+syB4KBTwFSS+1TYY+6wyJxHfFlAx6dmTON0tjPh+uYCuXG+hblBYd
         L66Y0pL1tUvs36lOyC4PIKUh8bOpDHPCyf6CJ2O74lT0PNJ1MT7Dd7K1VWWdjdwFnK
         mZPY9ALlGx29oxtiXGVR2Q0vh6aOBBpG5OCqDI5XkmxCv+8acWRJ0P/dnIRNcgqS+q
         XROwVzRCjIiRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1F04E4D012;
        Fri, 25 Nov 2022 09:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH V2] octeontx2-pf: Fix pfc_alloc_status array overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936921672.2800.1777831744801624630.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 09:40:16 +0000
References: <20221123105938.2824933-1-sumang@marvell.com>
In-Reply-To: <20221123105938.2824933-1-sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        lcherian@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 16:29:38 +0530 you wrote:
> This patch addresses pfc_alloc_status array overflow occurring for
> send queue index value greater than PFC priority. Queue index can be
> greater than supported PFC priority for multiple scenarios (e.g. QoS,
> during non zero SMQ allocation for a PF/VF).
> In those scenarios the API should return default tx scheduler '0'.
> This is causing mbox errors as otx2_get_smq_idx returing invalid smq value.
> 
> [...]

Here is the summary with links:
  - [net,V2] octeontx2-pf: Fix pfc_alloc_status array overflow
    https://git.kernel.org/netdev/net/c/32b931c86d0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


