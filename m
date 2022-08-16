Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EBF595332
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiHPG6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHPG6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:58:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF86F1CB17A
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 20:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA68EB815D5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C98EC433C1;
        Tue, 16 Aug 2022 03:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660618814;
        bh=Yt1+TFv3XyUTJcvzDnRkhNBZAZrrpAeyw7+Dzpy4648=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nghcAVJB7z5wtyrhKa8Xz68mu9Dn3a4T27AKy1ghQmlWoxEuBjJsWuC2DVKKL05eZ
         Boz6lF5lqapWycgWWlBP9SLMq5lHVkZK9JQiYV05ZqKFfqjoqan/mEU1ClzW5k9HFI
         KidAN5HPJNqI9rNp1h6UjzEwAGXWwbNoMomRtFyaX1G7rH7xkDF1F/pCxKG/VhKcBu
         FgkZ5nIv0s6VCtoTbZbzjQvv8Y8OvLYHI1iuMDvrSa8ro8dyxygPcVQYSl+Thj1nME
         L6rGlZoLKXeOqbkGDigyS+h4VktS56DHs1Uc7Xyo0JL3tIth4Oola/tCytRM6mJctk
         L7v1uHHhp32/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A1B6E2A051;
        Tue, 16 Aug 2022 03:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: moxa: pass pdev instead of ndev to DMA functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166061881429.6837.4839693513113568636.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Aug 2022 03:00:14 +0000
References: <20220812171339.2271788-1-saproj@gmail.com>
In-Reply-To: <20220812171339.2271788-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        paskripkin@gmail.com, davem@davemloft.net, pabeni@redhat.com,
        f.fainelli@gmail.com
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

On Fri, 12 Aug 2022 20:13:39 +0300 you wrote:
> dma_map_single() calls fail in moxart_mac_setup_desc_ring() and
> moxart_mac_start_xmit() which leads to an incessant output of this:
> 
> [   16.043925] moxart-ethernet 92000000.mac eth0: DMA mapping error
> [   16.050957] moxart-ethernet 92000000.mac eth0: DMA mapping error
> [   16.058229] moxart-ethernet 92000000.mac eth0: DMA mapping error
> 
> [...]

Here is the summary with links:
  - [v2] net: moxa: pass pdev instead of ndev to DMA functions
    https://git.kernel.org/netdev/net/c/3a12df22a8f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


