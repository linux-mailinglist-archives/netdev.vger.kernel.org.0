Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7415631AB
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiGAKkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbiGAKkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421DD7B346;
        Fri,  1 Jul 2022 03:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2985B82F86;
        Fri,  1 Jul 2022 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D85CC341D0;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656672017;
        bh=jZDSLJiO2XS5yAFTVo0likqMXXO2WLgrLvpKh5yJDC4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SDkdm66q1PsAE7lCn8NT7oevGq0E2nhqWXaXja/Bi7B3TWGOfBQQ2YZPy8ZafLP+y
         6Tewq4C40+Bljn3cSjjwYs9Vg2Ih/vuNXRbALSWW9DAya7TvRGyI3nFijqhdkshrt3
         fasAVyXXH/WcjK/PvwfT04T3tAfZZEfy1qsX4uiP6fI+hH1h31jiRo2Wvas/RD6x5W
         ezEcKEcOchgZqbsYxKoDM1RmPJCaUbAAtINzl9C5wf2Z4LFR7StMxc/jY43NIqT6JW
         wYycV3iEZOMe/jV6w5qZi2vlQrgcgPYV/fXMW8gDmG3j83AFSSDqWlCYyxOwEjxcgU
         UgmZyFZJIoD5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81A13E49BBC;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet/neterion: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667201751.26485.3561935722143641637.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 10:40:17 +0000
References: <20220630075751.21211-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220630075751.21211-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jdmason@kudzu.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Jun 2022 15:57:51 +0800 you wrote:
> Delete the redundant word 'the'.
> Delete the redundant word 'a'.
> Delete the redundant word 'frame'.
> Delete the redundant word 'is'.
> Delete the redundant word 'not'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> 
> [...]

Here is the summary with links:
  - ethernet/neterion: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/f9f108f6d985

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


