Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0377A691895
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjBJGkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBJGkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6361C5CBC2
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 22:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC00F61C03
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45768C4339B;
        Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676011218;
        bh=kc8HW2EzGfojrFqC2d63wt9cUi7yK+p1Zz8yhTGlcTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AS6CYmMduzD3LHjWMI6DuQK08HSCcurtgUQbgTHPRXmQSAhiyWVRkQko3nWg4UovN
         o5MORD7sgNeMOm6bqrPaQhMGy8CHJ2U/LiSCDzqm3iklrPZkcCujHFFUPIpz2klzNG
         OvnqE8Qm0ORsaftvw+cxcZvEfuZ4zKlDBLM4gmay8ocVkqICXGpvHYgrcYL1A+qcdz
         nipfGocaetKzjLX6iIFO+Ayu5DqKOV3e3IlXc/+GRY88LamCqVgkJmygHvICuC5qXn
         7PYDsFqTbnblVZUWpnnyfRPp4sNFP54sgdTtp0lAaKk3IzspVqQA3xRlxDvgQjZ7lo
         xaPsimHLrAUPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28D28E21EC7;
        Fri, 10 Feb 2023 06:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bgmac: fix BCM5358 support by setting correct flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601121816.3411.17826140741171534776.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 06:40:18 +0000
References: <20230208091637.16291-1-zajec5@gmail.com>
In-Reply-To: <20230208091637.16291-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bcm-kernel-feedback-list@broadcom.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rafal@milecki.pl,
        jdmason@kudzu.us
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 10:16:37 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Code blocks handling BCMA_CHIP_ID_BCM5357 and BCMA_CHIP_ID_BCM53572 were
> incorrectly unified. Chip package values are not unique and cannot be
> checked independently. They are meaningful only in a context of a given
> chip.
> 
> [...]

Here is the summary with links:
  - [net] net: bgmac: fix BCM5358 support by setting correct flags
    https://git.kernel.org/netdev/net/c/d61615c366a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


