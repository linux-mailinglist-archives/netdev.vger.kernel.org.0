Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14570520A9C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiEJBYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiEJBYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:24:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CDA20F74F
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9196159A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE22AC385C5;
        Tue, 10 May 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652145613;
        bh=Od6vAGEyJiXWKpnwccBQP6cf2NBdgPw/Knw3zhm9jJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ks+EN1/1lPO4voYOxCYLwfu2jK6n/YuwewXpHUOw6aP04nXJJnyuV9IN791V/IF+8
         12deUAM4/URupZITVhQGP20NfAEIRYECSgjDFVT0b37yI3OOKyryjTClW3/Xt37IN1
         m7bo9exXKkInd38XiLeVcvHzk7E84DEAfHFdFWNVRsJz4F03BJnwEG6KuAJvg4YkwO
         MHvEVguffqWujhwUbEauDrF4Kq2sXRVGuRJJNwxJGX2CjYTUfWNDy60KpF8xl0huKh
         0x5vU6F8Kv5rW+X3Jh7ZpFuOicO8LjGsaB6wlGFZflQVR/8ID1SVhixN00pld+Rom7
         5oKEz+vXCj+2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF54EF03928;
        Tue, 10 May 2022 01:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: flush switchdev workqueue on bridge join error
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214561284.15844.17878033905343844644.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 01:20:12 +0000
References: <20220507134550.1849834-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220507134550.1849834-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  7 May 2022 16:45:50 +0300 you wrote:
> There is a race between switchdev_bridge_port_offload() and the
> dsa_port_switchdev_sync_attrs() call right below it.
> 
> When switchdev_bridge_port_offload() finishes, FDB entries have been
> replayed by the bridge, but are scheduled for deferred execution later.
> 
> However dsa_port_switchdev_sync_attrs -> dsa_port_can_apply_vlan_filtering()
> may impose restrictions on the vlan_filtering attribute and refuse
> offloading.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: flush switchdev workqueue on bridge join error path
    https://git.kernel.org/netdev/net/c/630fd4822af2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


