Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEF04E838D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiCZSvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiCZSvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:51:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C804D3E0CD
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 11:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AA65B80B89
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4DDFC34110;
        Sat, 26 Mar 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648320610;
        bh=bFRMKqTpsSKOTl6fhXvj4bBAG/oilZyH2I8WFf6SmBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p5sazQEpucrMjW6YkHGe9qgxbDVT+IqCKMZSI1v8/RYel6qt34JG8dGc+r8jPGjk0
         EVkvluw7oM6zcJ7vsnzoGQxX/SsZociQFSMNdyL9XpWGNEoqrm7Va0J5oJknnLQs56
         oG6leBBhNIfvAtmc4eV1N0KLibdUVabiRTa1SThNqmv2yWhUm3SUSBK+up2lK5fHWX
         XXCduf68XCB2u0GxZA950Zagc1gs3WYAP5wnPXjTV6hpmwl3c++vmr6xhgkaMtKKpE
         TYO8OmKkGUI1b9Lq1MGqEywK38TW8hMxvcTRfRRWho5pG/Gi8qsAf/zBUQ5HUgLrij
         qRXRF09DT9cYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5E94F0384A;
        Sat, 26 Mar 2022 18:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164832061067.28772.3658320511785166897.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 18:50:10 +0000
References: <20220326180234.20814-1-rdunlap@infradead.org>
In-Reply-To: <20220326180234.20814-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev, lkp@intel.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steen.hegelund@microchip.com, bjarni.jonasson@microchip.com,
        lars.povlsen@microchip.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat, 26 Mar 2022 11:02:34 -0700 you wrote:
> Fix build errors when PTP_1588_CLOCK=m and SPARX5_SWTICH=y.
> 
> arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.o: in function `sparx5_get_ts_info':
> sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
> arc-linux-ld: sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
> arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_init':
> sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
> arc-linux-ld: sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
> arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_deinit':
> sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
> arc-linux-ld: sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
> arc-linux-ld: sparx5_ptp.c:(.text+0xf38): undefined reference to `ptp_clock_unregister'
> arc-linux-ld: sparx5_ptp.c:(.text+0xf46): undefined reference to `ptp_clock_unregister'
> arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o:sparx5_ptp.c:(.text+0xf46): more undefined references to `ptp_clock_unregister' follow
> 
> [...]

Here is the summary with links:
  - net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL
    https://git.kernel.org/netdev/net/c/08be6b13db23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


