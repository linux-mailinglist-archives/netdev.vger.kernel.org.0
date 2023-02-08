Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FE468E80F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 07:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjBHGKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 01:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBHGKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 01:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF4D3C2AC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 22:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56EDE611BC
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACD74C4339C;
        Wed,  8 Feb 2023 06:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675836619;
        bh=qqagDldguyUHVC06rsbwCtARoJcdZsnNtxXDGrS1R9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QagX8uVI6nuU+mFiur/ULgK6spvTjxGVc9vzsdY3UD95NMimdTP9kuYWI6CTRjY8M
         HST+kUpcnU2Ere+1tMIyTgAQndrsusrLAzBrmIYlLMkhIfwOW1iATzHQ3czbiJqquT
         J5kGGXpCIThdSIFXmOoHOnstd6lW5Ly0FebnNsqoychvlHVEFGeW4Aj9+izPuUo/yK
         OTuIS2vGqy9TiYnTUCMfUie2cy/WtpC7kHuHkr6+7HbpO3umYEgHDO7ZeWXgiJMhyf
         LQCnf5lilbJ73gzvKqgZt2pkb5FxBaTXoEQYxU94ADQoIQs2i/L5codJ9x3tvveCVx
         aqvvj71xWoKew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B537E4D032;
        Wed,  8 Feb 2023 06:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igc: Add ndo_tx_timeout support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583661955.4518.5333003318228284218.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 06:10:19 +0000
References: <20230206235818.662384-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230206235818.662384-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sasha.neftin@intel.com,
        netdev@vger.kernel.org, naamax.meir@linux.intel.com
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

On Mon,  6 Feb 2023 15:58:18 -0800 you wrote:
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> On some platforms, 100/1000/2500 speeds seem to have sometimes problems
> reporting false positive tx unit hang during stressful UDP traffic. Likely
> other Intel drivers introduce responses to a tx hang. Update the 'tx hang'
> comparator with the comparison of the head and tail of ring pointers and
> restore the tx_timeout_factor to the previous value (one).
> 
> [...]

Here is the summary with links:
  - [net,1/1] igc: Add ndo_tx_timeout support
    https://git.kernel.org/netdev/net/c/9b275176270e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


