Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BA065189C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 03:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiLTCAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 21:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiLTCAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 21:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2D12BDE;
        Mon, 19 Dec 2022 18:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E37EC611CA;
        Tue, 20 Dec 2022 02:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41844C433D2;
        Tue, 20 Dec 2022 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671501618;
        bh=FB92SJH8/78WpyjWYz65ANUM0x4mULE8VcFQ1X0GBkI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AI7u4FFslaHCgeswT1cpOrWcZQJoZGWmeFrQyZ0oYBRePxYSq9bbytrB/A+WvdsuT
         undNu2nwMMgse5dvuJC4MPU2EmAqiawXNmKobrKVV2Ewp/FHB7bSrde8TBQqwrGPlR
         9rlrnweqpuG7rvxxsjvYPfK4+O4fhZ3EI2EIGxh9pntSx7K8ffNgi79arqTG9Af5dn
         U2AOcEgmQXGYCcT7dpy/LO8+emcQgPpS0q+894uNimbwSieB1BYpwjlu955xLTeyEG
         tn8KQpA8TXGm/lJGWPBzKCdHNaYY/3Du33m7SnGWe3c5RgElbOWzQnhig7YD2hrRhf
         X9vdd/ZmGTNOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E57BC41622;
        Tue, 20 Dec 2022 02:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] Documentation: devlink: add missing toc entry for
 etas_es58x devlink doc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167150161811.12144.14366546302831051201.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Dec 2022 02:00:18 +0000
References: <20221219155210.1143439-2-mkl@pengutronix.de>
In-Reply-To: <20221219155210.1143439-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, sfr@canb.auug.org.au, lkp@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon, 19 Dec 2022 16:52:08 +0100 you wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> toc entry is missing for etas_es58x devlink doc and triggers this warning:
> 
>   Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree
> 
> Add the missing toc entry.
> 
> [...]

Here is the summary with links:
  - [net,1/3] Documentation: devlink: add missing toc entry for etas_es58x devlink doc
    https://git.kernel.org/netdev/net/c/115dd5469019
  - [net,2/3] can: flexcan: avoid unbalanced pm_runtime_enable warning
    https://git.kernel.org/netdev/net/c/3bc2afcba812
  - [net,3/3] can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len
    https://git.kernel.org/netdev/net/c/f006229135b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


