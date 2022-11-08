Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4DE62080A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 05:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiKHEKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 23:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiKHEKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 23:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08F625CD;
        Mon,  7 Nov 2022 20:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 584906144F;
        Tue,  8 Nov 2022 04:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3762C43142;
        Tue,  8 Nov 2022 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667880615;
        bh=Okz4AndrMaGPGWOfifC0xnphrFtUS+K0Slc2lmtcsSg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iedRLKkyGZ/FX2wA8qAGf0JbXjSNqYxF0NxnslEHjMN3zZuzeJkQ4NcSyuUsdaHMS
         wbnIEop04xtC3P4SC5AOA3PK4wW/14CwXjDHgnLTpjGD79A5pcW0ewKDt+jzKD4SvU
         32xnTSw0LGt11Jxm+TD4XmwMNVRiTBYBsWPTQgFNKnMzU08uYduZAYpwm/H0zJv/su
         KHjgVQOCaA/sG1DZhTCnXVT1n2Q2+6X9XVOia9na8cu0ZNrDeepSLuy/XEnPhJcdcL
         WxGhnUr99iOcNqILYoUUWP8mjU47RSHe8NkrExFxFEN6LzlB1SBiRt7/D8oo/oVVgT
         F99ghhy00c7mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E2E0C41672;
        Tue,  8 Nov 2022 04:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: txgbe: Fix two bugs in
 txgbe_calc_eeprom_checksum
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166788061557.1355.8749947132220755596.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 04:10:15 +0000
References: <20221105080722.20292-1-yuehaibing@huawei.com>
In-Reply-To: <20221105080722.20292-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 5 Nov 2022 16:07:20 +0800 you wrote:
> Fix memleak and unsigned comparison bugs in txgbe_calc_eeprom_checksum
> 
> YueHaibing (2):
>   net: txgbe: Fix memleak in txgbe_calc_eeprom_checksum()
>   net: txgbe: Fix unsigned comparison to zero in
>     txgbe_calc_eeprom_checksum()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: txgbe: Fix memleak in txgbe_calc_eeprom_checksum()
    https://git.kernel.org/netdev/net-next/c/a068d33e542f
  - [net-next,2/2] net: txgbe: Fix unsigned comparison to zero in txgbe_calc_eeprom_checksum()
    https://git.kernel.org/netdev/net-next/c/5e2ea7801fac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


