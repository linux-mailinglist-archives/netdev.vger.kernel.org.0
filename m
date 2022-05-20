Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05DE52E22F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344608AbiETBuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbiETBuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E92CDE327
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F372861BD2
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5414CC34117;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653011413;
        bh=NIJHVTRCYRp5YYST2fxxZH6+lX1cIJ+8Q5+KfBeZTsg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N7MQ9p+tguj3GoHb60UILdj5LTC8CiPLRcrY/h7c8TYkkNzZ56JXJJDkKeFhDCfVi
         wV+E67XAXosvL0AaKphnDGeUYRcXn8GRgwF6UccrifeuhbF3Tdy2n2yf3Yqtg79ScW
         qm8N29oXgc1pG/sOiVh6KL3G1MBfsFEyRQHOuv1MZhzbSC6QLQnF/VOF/wL7dakOpi
         Uq8G4yGx5WS1eNkfRwk+wiBUVPd6yDH/Qnl/UH9zAOEPlfFlrkvbbFaHrU+/l2AFde
         5yikZ8UerAMPLIngZoTwekFc1I3NANQlUqxrzvuN/mOyExjP4MCuwzZ8s/liel3g1x
         sN3htgQ0vbS5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 386D3F03935;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Fix smatch errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165301141322.6731.3383190235145046892.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:50:13 +0000
References: <20220518195529.126246-1-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220518195529.126246-1-ricardo.martinez@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        haijun.liu@mediatek.com, ilpo.jarvinen@linux.intel.com,
        moises.veleta@intel.com, sreehari.kancharla@intel.com,
        dan.carpenter@oracle.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 12:55:29 -0700 you wrote:
> t7xx_request_irq() error: uninitialized symbol 'ret'.
> 
> t7xx_core_hk_handler() error: potentially dereferencing uninitialized 'event'.
> If the condition to enter the loop that waits for the handshake event
> is false on the first iteration then the uninitialized 'event' will be
> dereferenced, fix this by initializing 'event' to NULL.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: wwan: t7xx: Fix smatch errors
    https://git.kernel.org/netdev/net-next/c/86afd5a0e78e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


