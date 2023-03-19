Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA8E6C02CC
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 16:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjCSPa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 11:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCSPaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 11:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA805E191
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 08:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DCDFB80C01
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 15:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32976C4339B;
        Sun, 19 Mar 2023 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679239817;
        bh=okIUoYJP8y5bZxRr/+hPDWaRGoYcuY1eo8LGEMjTFSo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lnKVmit56zawKi9CLtDzMybU2diKHA1lxXx3AU987AwTVg+qrenimPRKDNPY77kqN
         teamLnNUTbP9181H1LHkiAMpGsZpyVYfN2QBNvHBLBTVBqjCbkINTOpAZTdznWg2w2
         3rgipGdym9vfiLNEDYEPbGqevUII5CjXJK7RA5gZA6N6S48s8Pb7rOpAMUdNRDWtte
         Cghq7BVWzRfBxJH1TO+llQZRIe/szbcc/A1+ky2muWZEGtp0Ms41fXYB5tfVwMo12h
         PJoeETxO1Dxypj9mFKv5KL7UyOFjvVZocSwcib2VoSxvA9RWpIU5iCEL+TAP9NE29O
         gP/RtZD+tfnEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19097E2A03A;
        Sun, 19 Mar 2023 15:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: core_thermal: Fix fan speed in maximum cooling
 state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167923981709.9440.6818651030993497762.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 15:30:17 +0000
References: <573c8b3049fadb8b7353986427aeee915cf182f3.1679065970.git.petrm@nvidia.com>
In-Reply-To: <573c8b3049fadb8b7353986427aeee915cf182f3.1679065970.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        jiri@mellanox.com, vadimp@mellanox.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 16:32:59 +0100 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The cooling levels array is supposed to prevent the system fans from
> being configured below a 20% duty cycle as otherwise some of them get
> stuck at 0 RPM.
> 
> Due to an off-by-one error, the last element in the array was not
> initialized, causing it to be set to zero, which in turn lead to fans
> being configured with a 0% duty cycle in maximum cooling state.
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: core_thermal: Fix fan speed in maximum cooling state
    https://git.kernel.org/netdev/net/c/6d206b1ea9f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


