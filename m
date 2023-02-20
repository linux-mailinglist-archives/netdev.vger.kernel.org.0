Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1008569CA36
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjBTLuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjBTLuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921F81BF5;
        Mon, 20 Feb 2023 03:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ADE060DCA;
        Mon, 20 Feb 2023 11:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96770C4339B;
        Mon, 20 Feb 2023 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676893816;
        bh=cEb6idKx9/ndMW968ttWbTsrMhBLFbqtGjnGGNzNFiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PMsWzeAdCZz1Ziqj3fsr+tTglsRvcSyE3acbMnmsoJJuKoY01iMJ2tds7Ef4rWaYG
         twRhB8i7C6F/WBW69SWzhWmaPRJrxeX5b+Um38ibxXBrl/CK3+u3I9Iolhi5ccGLj2
         3j8VHxUxbarz9eku+lSjiTz2fMy6aXcV36m+NtWYp413DBuVU9uiPuCvvIXisXcpQV
         6vcuQxJKeNd3rd7cRpPpMatfVT4om7mY7LS7S3IXo8nskjzp2TTW/AWJrq1KnooYds
         ZY8VZz4QVZg7Dd7FqbG4DamdQUX2Mo5/rxsMBZznl0f1pDl/ec8ceEox96Cu6AIFnL
         H34t72lmaIF1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7EB50C43161;
        Mon, 20 Feb 2023 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bcmgenet: Support wake-up from s2idle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689381651.15107.14601343840976421497.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 11:50:16 +0000
References: <20230217183415.3300158-1-f.fainelli@gmail.com>
In-Reply-To: <20230217183415.3300158-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 10:34:14 -0800 you wrote:
> When we suspend into s2idle we also need to enable the interrupt line
> that generates the MPD and HFB interrupts towards the host CPU interrupt
> controller (typically the ARM GIC or MIPS L1) to make it exit s2idle.
> 
> When we suspend into other modes such as "standby" or "mem" we engage a
> power management state machine which will gate off the CPU L1 controller
> (priv->irq0) and ungate the side band wake-up interrupt (priv->wol_irq).
> It is safe to have both enabled as wake-up sources because they are
> mutually exclusive given any suspend mode.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bcmgenet: Support wake-up from s2idle
    https://git.kernel.org/netdev/net-next/c/3fcdf2dfefb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


