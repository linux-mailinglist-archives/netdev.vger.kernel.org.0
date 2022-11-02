Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30656615B76
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiKBEaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKBEaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355B1D65E;
        Tue,  1 Nov 2022 21:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30EC7617ED;
        Wed,  2 Nov 2022 04:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 934F6C433C1;
        Wed,  2 Nov 2022 04:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667363417;
        bh=DOTAtTsgLfLzqU4CXbDP4d5SxYCIT5hve1EAPX2snJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c0eXAt7fTVBGQYHECQnDV019OKSgmwdA5I21xAp+zMAmv5oynpVGIMrPuGUK08x3w
         i4XOvRZ+xAPvG74pqj0JN4mXEj1/lhSaSRFuPkDCpT9nC4jYdSKyZkRxxmWxapaawC
         iXSEFhJrO4LhYmQDWCQgLtDj8KayO5gXvozjcRVG/z43Fi23roeaURZ0CfzfZBJq/M
         YyUo61KKXPmnYL+uAxNiAX7ZYHKcMNeP6I3N6qyBryOrV55oVreQO+jOKMF3aQcLfb
         2mEzeMxMjOIpvoYEJHFxN23u+vWvNYtK1VpPgb50yVXV3a0CouZxH1q049Du4y1lt3
         PaDoqO7UIp69w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7184FE270F9;
        Wed,  2 Nov 2022 04:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] net: lan966x: Fixes for when MTU is changed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166736341745.16570.10763668469393283607.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 04:30:17 +0000
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
To:     'Horatiu Vultur' <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 30 Oct 2022 22:36:33 +0100 you wrote:
> There were multiple problems in different parts of the driver when
> the MTU was changed.
> The first problem was that the HW was missing to configure the correct
> value, it was missing ETH_HLEN and ETH_FCS_LEN. The second problem was
> when vlan filtering was enabled/disabled, the MRU was not adjusted
> corretly. While the last issue was that the FDMA was calculated wrongly
> the correct maximum MTU.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net: lan966x: Fix the MTU calculation
    https://git.kernel.org/netdev/net/c/486c29223016
  - [net,v2,2/3] net: lan966x: Adjust maximum frame size when vlan is enabled/disabled
    https://git.kernel.org/netdev/net/c/25f28bb1b4a7
  - [net,v2,3/3] net: lan966x: Fix FDMA when MTU is changed
    https://git.kernel.org/netdev/net/c/872ad758f9b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


