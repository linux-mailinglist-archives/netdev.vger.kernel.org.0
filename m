Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083A55A3325
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345116AbiH0AaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiH0AaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDE2DABB6
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 17:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48E8061C7A
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9971AC433B5;
        Sat, 27 Aug 2022 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661560215;
        bh=RCom2lOgxRaJC5B6BvQmo9dOz5EEMpwksdeLwtWIkRg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rhysnn8blyGyFxfqRZzno7JFVfUKthrCMQDT7/fSIVd5+rb3tQ+1q20brLiEoDCrS
         g4pNkCv4Xjdd7xvx7D0usbgGn1lLfOtNpyUfO5Q2OEOqV6OVIhVRpDn6DNGCJ5e/ua
         1h8iww+dJqxGuaOZXEEZHG/PxQ0LZ0/FkxUjUWQz6YD8b1vRENH9zm/xj3G+lXSSxM
         JxJ4+WyXpKWr41MOlXjYuLeTc9wvhNOKWw0m0Pqafe/sgkPUXBUA7+dc9VkNl1KUBJ
         VbNugRKqL1Gf8CJoGS47FUzg0/x5AVyeZgrmy+CaBpL1srgS1o16RScfNqYzq/IwrH
         XsHQjYM6+M8KQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77634C0C3EC;
        Sat, 27 Aug 2022 00:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: fix handling uneven length packets in manual
 extraction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156021548.1708.15271126076547206527.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 00:30:15 +0000
References: <20220825084955.684637-1-casper.casan@gmail.com>
In-Reply-To: <20220825084955.684637-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        bjarni.jonasson@microchip.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 25 Aug 2022 10:49:55 +0200 you wrote:
> Packets that are not of length divisible by 4 (e.g. 77, 78, 79) would
> have the checksum included up to next multiple of 4 (a 77 bytes packet
> would have 3 bytes of ethernet checksum included). The check for the
> value expects it in host (Little) endian.
> 
> Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: fix handling uneven length packets in manual extraction
    https://git.kernel.org/netdev/net/c/7498a457ecf7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


