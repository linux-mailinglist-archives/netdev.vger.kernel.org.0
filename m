Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A784B6C7AE0
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjCXJKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCXJKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442DE126DC;
        Fri, 24 Mar 2023 02:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5447629CA;
        Fri, 24 Mar 2023 09:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 393CBC433A0;
        Fri, 24 Mar 2023 09:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679649020;
        bh=ae972oHUKPYO7aotqb/5x1mmEJjW0ElmZh1vbwdIDIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WGYW7UUvC4sbld5fj8jAdBTDAhVP3UN2SMXhJgiGHpuUe9LVxbe+f4xuOsDwPrjNI
         kbewaalfAQEvz5rVRG8opEHB0z3VQx331TPsyVVRoMrJU+WkOAy2+rDLa3zIawTDvu
         MfiMC8BoCHqRYxN4frU2p2r6JRVwKukQ8RJmXu5shK/RPOz67Iy1epRZyJYXYh1Q0c
         TcGjZC7B2XbTaGmr8o/PxK6ftf3S4uOxD/CQvmcocvWV+GkgcNJbFggGEFwm73tOkv
         ewBW00pgk9t8hVsCyHJ+N6/gv+sHMVK7GgD6sD9hhVFWGsYHeBhEq8UAr4bodkgHIQ
         uICY9R47L1scw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B11BE52505;
        Fri, 24 Mar 2023 09:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: broadcom/sb1250-mac: clean up after SIBYTE_BCM1x55
 removal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964902010.16080.9931373756462367970.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:10:20 +0000
References: <20230323052101.30111-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230323052101.30111-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tsbogend@alpha.franken.de,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 06:21:01 +0100 you wrote:
> With commit b984d7b56dfc ("MIPS: sibyte: Remove unused config option
> SIBYTE_BCM1x55"), some #if's in the Broadcom SiByte SOC built-in Ethernet
> driver can be simplified.
> 
> Simplify prepreprocessor conditions after config SIBYTE_BCM1x55 removal.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> 
> [...]

Here is the summary with links:
  - ethernet: broadcom/sb1250-mac: clean up after SIBYTE_BCM1x55 removal
    https://git.kernel.org/netdev/net-next/c/c34ce2796228

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


