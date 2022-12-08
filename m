Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8B646841
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLHEa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHEaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:30:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F9E92A1B;
        Wed,  7 Dec 2022 20:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 362BA61D51;
        Thu,  8 Dec 2022 04:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85D3CC433D6;
        Thu,  8 Dec 2022 04:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670473821;
        bh=WB0iMmwrBqL9FFiL1qPJoUNeaNTu5aOGF/iqCnHw/rE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U1v1V2PFe8N2vzVU12Hs2XiF1jl+fSRWz9LW12UUsP661dZOUMB+vuXMbtPzhIquq
         hDUcxliLJkWcEYRbMj2FELvRh6JNwA8feeVwhP6B/atARc1hzK6FAXmb+zVQCOth+D
         GGEFX7JiWBF5jPgdpq2V6H1Uha5RwpiZwk7cIPillprVZSQB+m9WZPzTcOOBUelUVl
         xi5EX5hS1SLSgnP7NShg+5MzhlBsyKjh8nQXv4WA5xqSR60ir04NfY8RIfZwsezRfW
         mYmLURhG45soyalInf4o/pkfIyeGewPSkUeUFRIpMgeGljXMuhjsvRA05FQRjh2j2/
         e/V5kSaTip8Zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F6D3E4D02D;
        Thu,  8 Dec 2022 04:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/6] net: ethernet: ti: am65-cpsw: Fix set channel
 operation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167047382138.31977.14618117526453334378.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 04:30:21 +0000
References: <20221206094419.19478-1-rogerq@kernel.org>
In-Reply-To: <20221206094419.19478-1-rogerq@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Dec 2022 11:44:13 +0200 you wrote:
> Hi,
> 
> This contains a critical bug fix for the recently merged suspend/resume
> support [1] that broke set channel operation. (ethtool -L eth0 tx <n>)
> 
> As there were 2 dependent patches on top of the offending commit [1]
> first revert them and then apply them back after the correct fix.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/6] Revert "net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume"
    https://git.kernel.org/netdev/net-next/c/1a352596722a
  - [v5,net-next,2/6] Revert "net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume"
    https://git.kernel.org/netdev/net-next/c/1bae8fa8c4f3
  - [v5,net-next,3/6] Revert "net: ethernet: ti: am65-cpsw: Add suspend/resume support"
    https://git.kernel.org/netdev/net-next/c/1a014663e7dd
  - [v5,net-next,4/6] net: ethernet: ti: am65-cpsw: Add suspend/resume support
    https://git.kernel.org/netdev/net-next/c/24bc19b05f1f
  - [v5,net-next,5/6] net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
    https://git.kernel.org/netdev/net-next/c/1581cd8b1174
  - [v5,net-next,6/6] net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume
    https://git.kernel.org/netdev/net-next/c/020b232f79e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


