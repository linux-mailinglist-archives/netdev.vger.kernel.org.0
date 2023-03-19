Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D3D6C00A5
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 12:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCSLAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 07:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCSLAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 07:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680D023136;
        Sun, 19 Mar 2023 04:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D512B80B47;
        Sun, 19 Mar 2023 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6034C433A4;
        Sun, 19 Mar 2023 11:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223617;
        bh=g2weutI+6uy/L5m4qv4YNsC5LmTmc5aTx5U/SHQAyiw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eFvhwjI/g+XYjsyM5MTRLUKdcvApyPJDzEYCvrkwBapw5cmfYyMgm/k8ZrXkRbSVG
         UhpriASOhK3UYsL4Zx5GSUV2jVCta9E1tUvxoxtDrZztfLYke7SuMtUHOjM0RCv56Y
         mucF5IFanmHudLPtc7by990CMFlVW2nqjRpoNYUPW/rPWirRsyaeLX+f4JKSLSCQ/L
         V3wNBatlUw5qvzR8xI7+MFrKX2BDfXeIksN+WAcynFaSR+cnM6V4UqZ/2UUQaawc04
         dnI6Vt/E53TuWrqvQFYbeKPfBrCyk6bW2915TpzXPyt7UDwqSXyWc892fJ4rxpYTOs
         THJfqSAb28RfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5719E21EE9;
        Sun, 19 Mar 2023 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: macb: Reset TX when TX halt times out
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922361780.26931.16867093451689950393.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 11:00:17 +0000
References: <20230317113943.24294-1-harini.katakam@amd.com>
In-Reply-To: <20230317113943.24294-1-harini.katakam@amd.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@amd.com,
        harinikatakamlinux@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 17:09:43 +0530 you wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Reset TX when halt times out i.e. disable TX, clean up TX BDs,
> interrupts (already done) and enable TX.
> This addresses the issue observed when iperf is run at 10Mps Half
> duplex where, after multiple collisions and retries, TX halts.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: macb: Reset TX when TX halt times out
    https://git.kernel.org/netdev/net-next/c/72abf2179969

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


