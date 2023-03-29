Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE46CD219
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjC2GaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjC2GaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A33C00
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 23:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33EF061A7E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C0FAC4339B;
        Wed, 29 Mar 2023 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680071418;
        bh=+mPBkyG7ROXIiGP5j05Qq+sOT5prKcATXbgaxY8cpKU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YkdmMjNkGfIbYMIdSIjkENXod8ap7yS3eknKCCDTeouH8p4psxRoSh5hKp9xBJCTt
         lddFH9DCNg25GNZqyotelxaQnjsZswJDpnMxwMAQztIBzWD+kAu42jiaGIqO7eHE+c
         KrqyM8NmLVKoLwD8GqgOZtSulVyvhBhPAyW8GMYRqK67l2JLVDV/JDji0UhOOExvSQ
         4JQ7uqY3ZYrudahd06rrbcYS7RH+NL+eJ16isPfnTKfCeJTa/KGs11wixxRG1VzG78
         JS0wnPKX7bcY1S5QSajbQXcnxuWYsCD/6fcvyKxGVarCx3WJ4qm0aP/TcwAcC8mq55
         ET0wCP55dm2Gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A272E21EE4;
        Wed, 29 Mar 2023 06:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput regression
 with direct 1G links
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007141843.30022.119227065684030998.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 06:30:18 +0000
References: <20230324140404.95745-1-nbd@nbd.name>
In-Reply-To: <20230324140404.95745-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        daniel@makrotopia.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 24 Mar 2023 15:04:04 +0100 you wrote:
> Using the QDMA tx scheduler to throttle tx to line speed works fine for
> switch ports, but apparently caused a regression on non-switch ports.
> 
> Based on a number of tests, it seems that this throttling can be safely
> dropped without re-introducing the issues on switch ports that the
> tx scheduling changes resolved.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix tx throughput regression with direct 1G links
    https://git.kernel.org/netdev/net/c/07b3af42d8d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


