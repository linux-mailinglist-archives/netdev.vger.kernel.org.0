Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66B0592DA1
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiHOLAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHOLAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BDC25F
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 04:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A80B06110F
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01F37C433D7;
        Mon, 15 Aug 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660561216;
        bh=EWDVFgHYqtZwZ3sBC+Yi6kI7q2VMoM5+PWmCrHK1Etw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a01uQsOYmU9Cx49hfS2EyUvmSts+RzXbCDsMjsC4a9HdAaQLWfSpwuppTgx8hKk1L
         809GV2Zx90pvFbbH7yP8JUSg4w4XdNHiV6qm0PsVpzufcYzx9xuVL2RCDiip+OmdUK
         7sxyaH+NW/vH4jjY254rHVhSYix3I3s380NCQN2vod3ScqbOEpdP89Dea0ljdLceFt
         e72dUC+52+At+b27qIL4cPkeFjtyaspPKwPjd6PKhwykBv3hN4KEYng2t0yhckeCSf
         OY33ZUAbDZnVDgphVog5P8QzuSbH7mKCWm0UkN/ZJfvyxupnhvvwNLLN520GVlZqsY
         NUACsPfcFjRiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA4F8C4166E;
        Mon, 15 Aug 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] mlxsw: Fixes for PTP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166056121589.24739.4912105153490911323.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 11:00:15 +0000
References: <cover.1660315448.git.petrm@nvidia.com>
In-Reply-To: <cover.1660315448.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, richardcochran@gmail.com,
        mlxsw@nvidia.com
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Aug 2022 17:31:59 +0200 you wrote:
> This set fixes several issues in mlxsw PTP code.
> 
> - Patch #1 fixes compilation warnings.
> 
> - Patch #2 adjusts the order of operation during cleanup, thereby
>   closing the window after PTP state was already cleaned in the ASIC
>   for the given port, but before the port is removed, when the user
>   could still in theory make changes to the configuration.
> 
> [...]

Here is the summary with links:
  - [net,1/4] mlxsw: spectrum_ptp: Fix compilation warnings
    https://git.kernel.org/netdev/net/c/12e091389b29
  - [net,2/4] mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice
    https://git.kernel.org/netdev/net/c/a159e986ad26
  - [net,3/4] mlxsw: spectrum_ptp: Protect PTP configuration with a mutex
    https://git.kernel.org/netdev/net/c/d72fdef21f07
  - [net,4/4] mlxsw: spectrum_ptp: Forbid PTP enablement only in RX or in TX
    https://git.kernel.org/netdev/net/c/e01885c31bef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


