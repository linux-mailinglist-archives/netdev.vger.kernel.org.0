Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25DC5570CC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 04:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377337AbiFWCAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 22:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377342AbiFWCAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 22:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E12AD81
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 19:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3553261D13
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90C53C341C6;
        Thu, 23 Jun 2022 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655949613;
        bh=JjJ0ZIo4FmRVEXIBABjFxloay6N7s6I/tPMh05nqrr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jm8Sgq2UH6b5ZFnXalPchW4DNAAnRx2ZpaWam+ovyeh/z7gq8eBRabEY+6j9+lx7d
         WoUlKa+sC27AqvQM9eeGZHEmeJNe906LxL5hmwV/dxn3puQ1hKKkGLoGVcYlXyG5e4
         K438BvG2goxXUmgbQndMBEzB3fs2zzO5T3/G+vbHjIxINgVgoX/7SqIakeT16bkB1D
         Tmx7xnZyUE+DY7Zu5DMQK3tt8lCZPpVOqWgCGEECidchdF8ArwMcPyW/pR0bKvYdki
         tQqoGQdKvSxM9M7957torNGMnM/3uGW6RmmSh3a1LM/cslOUuoHsWUUsfik+icsPXq
         7xrPRpMq8Vghg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 753A2E7387A;
        Thu, 23 Jun 2022 02:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igb: Make DMA faster when CPU is active on the PCIe
 link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594961347.3273.15853143171299666029.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 02:00:13 +0000
References: <20220621221056.604304-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220621221056.604304-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, kai.heng.feng@canonical.com,
        netdev@vger.kernel.org, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jun 2022 15:10:56 -0700 you wrote:
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> Intel I210 on some Intel Alder Lake platforms can only achieve ~750Mbps
> Tx speed via iperf. The RR2DCDELAY shows around 0x2xxx DMA delay, which
> will be significantly lower when 1) ASPM is disabled or 2) SoC package
> c-state stays above PC3. When the RR2DCDELAY is around 0x1xxx the Tx
> speed can reach to ~950Mbps.
> 
> [...]

Here is the summary with links:
  - [net,1/1] igb: Make DMA faster when CPU is active on the PCIe link
    https://git.kernel.org/netdev/net/c/4e0effd9007e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


