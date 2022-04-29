Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852FD5154D0
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380374AbiD2Tnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380372AbiD2Tne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:43:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05D3205FC;
        Fri, 29 Apr 2022 12:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 830166118F;
        Fri, 29 Apr 2022 19:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E62EDC385A7;
        Fri, 29 Apr 2022 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651261213;
        bh=8Gm/sQflVpRRENHPWvy4rbuw1D2BbVEEUkqIZOebixk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NuDHV13rHTsltDA7rnEH+kO7qIqhJG1Diu0o8cwsh7fR8pWuG8LF3f7aQpf+ukpIW
         W0TQambQ9gkHCG7ZACgtwgNCeKjcnKeIHOQJrfrxpa2nOjVzBv3x2QMiGFhftLtxMA
         7cbXOBbMqcY1O1/UImEU1nzxCw5vqkDcLaU4fkvwQeq9Mo+JZBIO8jq90A1Ij4+p7q
         S5xUlyyYcZwMDId/eRSBOgJHRUIu5ErVCLeDsm9rd2s/iopo8ISle0Th/R07FME82x
         8w9RI0BGaWCgROIFiRQuk/NcnhC+yRJXz21d2yAv7EfZy0mby49I8iR43F113L3tgX
         fmhSn8YHXdYcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC39CEAC09C;
        Fri, 29 Apr 2022 19:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] can: isotp: remove re-binding of bound socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165126121283.7558.15534576695235848293.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Apr 2022 19:40:12 +0000
References: <20220429125612.1792561-2-mkl@pengutronix.de>
In-Reply-To: <20220429125612.1792561-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net, stable@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Apr 2022 14:56:08 +0200 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> As a carry over from the CAN_RAW socket (which allows to change the CAN
> interface while mantaining the filter setup) the re-binding of the
> CAN_ISOTP socket needs to take care about CAN ID address information and
> subscriptions. It turned out that this feature is so limited (e.g. the
> sockopts remain fix) that it finally has never been needed/used.
> 
> [...]

Here is the summary with links:
  - [net,1/5] can: isotp: remove re-binding of bound socket
    https://git.kernel.org/netdev/net/c/72ed3ee9fa0b
  - [net,2/5] can: grcan: grcan_close(): fix deadlock
    https://git.kernel.org/netdev/net/c/47f070a63e73
  - [net,3/5] can: grcan: use ofdev->dev when allocating DMA memory
    https://git.kernel.org/netdev/net/c/101da4268626
  - [net,4/5] can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
    https://git.kernel.org/netdev/net/c/1e93ed26acf0
  - [net,5/5] can: grcan: only use the NAPI poll budget for RX
    https://git.kernel.org/netdev/net/c/2873d4d52f7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


