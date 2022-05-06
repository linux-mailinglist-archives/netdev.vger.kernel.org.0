Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB36951CE8B
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387910AbiEFBYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386721AbiEFBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905D5C1B
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BB8062028
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32FF1C385BA;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800015;
        bh=5/3TzEGunsp8uyvYIoB+Un3epym+QcELEGJgGMQegWI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p7ljWUhancQ3Bdc1uSHy1nqxO3mo90KFic6fZzPWJqwkv5fMPItovFQuE11kytZU+
         5333a7ZLQsTKFCxnzxdegOmSySmBuX5rpULhvXIyhy9X9TcReJMB9Slmpgoj5YAdrM
         VsyzMOS2zy9JBnPrUTxI7MZIkrNduKSqXbxFKOz1HHhCHuG507CL1Jwb9X8CX83mRU
         Fjl/tRde8Rh3PnDbhTgkE3htowoOiIj2ysTT/rTgTeEMM8lMfWiCUlOwvyuzGPadZx
         OTJQitcJKXOrf60nha2m6xoDXvp33oGEI2jku1vNShhMf6PttwXrlY7r57WJuk9WTp
         SWvEcM0iMz4zA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1729AF03874;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: align SO_RCVMARK required privileges with
 SO_MARK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001509.16316.15609623458805904840.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:15 +0000
References: <20220504095459.2663513-1-eyal.birger@gmail.com>
In-Reply-To: <20220504095459.2663513-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, asml.silence@gmail.com, aahringo@redhat.com,
        weiwan@google.com, fw@strlen.de, yangbo.lu@nxp.com,
        tglx@linutronix.de, dsahern@kernel.org, lnx.erin@gmail.com,
        mkl@pengutronix.de, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 12:54:59 +0300 you wrote:
> The commit referenced in the "Fixes" tag added the SO_RCVMARK socket
> option for receiving the skb mark in the ancillary data.
> 
> Since this is a new capability, and exposes admin configured details
> regarding the underlying network setup to sockets, let's align the
> needed capabilities with those of SO_MARK.
> 
> [...]

Here is the summary with links:
  - [net-next] net: align SO_RCVMARK required privileges with SO_MARK
    https://git.kernel.org/netdev/net-next/c/1f86123b9749

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


