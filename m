Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247C26B0394
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCHKA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCHKAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:00:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2B236479
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 02:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80711CE1DD5
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 10:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDCF0C4339B;
        Wed,  8 Mar 2023 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678269620;
        bh=bdnka5HaD96VE/b+3u6I18/Xas+uDVjPlody+dogIro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aYCEKIIYqh8W9Q1EIsn37srpCfxbeOgrOXeTSB8bK/dqzPM7vvatohh9jY2S6SCkF
         b84fkqoT+0VaClk0qtI5F0VLBY+gKR6Cg3ucT7sQqJjYQZ/6jHwHPRXcLGTEiONNn+
         jV8Z9c2OuXXKad3TmnlS4+T79+lBsmeRgitCRy00s+ZZQPSNIWXcxlY1HVegtMzAdU
         m2AmeiOV9Z44Rb2uTr4CWyI2Z4xhroSm9BLbHrBTHA7pYgEwt7+p4LAFb47g0hhyH1
         Ai7w9+T7Niow0VO8zg/tU1y8q/iab8db8MgjfgYWyaYQvielRYWb6uiNTvWgnMp8IS
         DBi1j7TSzD9Fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7628E61B6E;
        Wed,  8 Mar 2023 10:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] r8169: disable ASPM during NAPI poll
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167826962073.12133.6381622389271772014.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 10:00:20 +0000
References: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
In-Reply-To: <b434a0ce-9a76-e227-3267-ee26497ec446@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, nic_swsd@realtek.com, netdev@vger.kernel.org,
        simon.horman@corigine.com, kai.heng.feng@canonical.com,
        holger@applied-asynchrony.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 6 Mar 2023 22:17:28 +0100 you wrote:
> This is a rework of ideas from Kai-Heng on how to avoid the known
> ASPM issues whilst still allowing for a maximum of ASPM-related power
> savings. As a prerequisite some locking is added first.
> 
> Heiner Kallweit (6):
>   r8169: use spinlock to protect mac ocp register access
>   r8169: use spinlock to protect access to registers Config2 and Config5
>   r8169: enable cfg9346 config register access in atomic context
>   r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
>   r8169: disable ASPM during NAPI poll
>   r8169: remove ASPM restrictions now that ASPM is disabled during NAPI
>     poll
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] r8169: use spinlock to protect mac ocp register access
    https://git.kernel.org/netdev/net-next/c/91c8643578a2
  - [net-next,2/6] r8169: use spinlock to protect access to registers Config2 and Config5
    https://git.kernel.org/netdev/net-next/c/6bc6c4e6893e
  - [net-next,3/6] r8169: enable cfg9346 config register access in atomic context
    https://git.kernel.org/netdev/net-next/c/59ee97c0c1a8
  - [net-next,4/6] r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
    https://git.kernel.org/netdev/net-next/c/49ef7d846d4b
  - [net-next,5/6] r8169: disable ASPM during NAPI poll
    https://git.kernel.org/netdev/net-next/c/e1ed3e4d9111
  - [net-next,6/6] r8169: remove ASPM restrictions now that ASPM is disabled during NAPI poll
    https://git.kernel.org/netdev/net-next/c/2ab19de62d67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


