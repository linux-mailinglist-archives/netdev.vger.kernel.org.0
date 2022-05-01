Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60799516464
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347101AbiEAMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 08:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240202AbiEAMdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 08:33:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037F5CFA;
        Sun,  1 May 2022 05:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2513B80D2D;
        Sun,  1 May 2022 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F34FC385B1;
        Sun,  1 May 2022 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651408212;
        bh=JO2rWXaz1VO0+8Q8t4MBxoVTpRn6Ze8m+8FYdHuCNZ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mqanLxjMuoHBLTRBiJzKguslOljxPP6fPzWozxj3KepbrmuvJeNflGGUlXMhWdLY4
         xHNKJd/z/JC0Uz3qRgobsjsq1YYyaqMClom2VUEx4wmSCTHyWeeljWEq+/HWHyBJ8/
         NfQqGGf0KIB3yXNHdyt9kpC+YFUE3R5PC+mJiH4pkYQIvvZ5TcHYKBcJZQ8ubIHLAe
         yHnafj8NW68uQ3RP+B0BX0PUmpzIBopjn6vgsyUeecHY5SodET4s406dsffwyugein
         HGA2iB+vRrodT0gr6xVQ3NevRc88xSy5adp91K24gOD3HwOIi29o2s8bm6mTQLy8k6
         OjN+5hhsCtTkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E7B9E6D402;
        Sun,  1 May 2022 12:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] net: stmmac: disable Split Header (SPH) for Intel
 platforms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165140821218.17181.9897594388304532293.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 12:30:12 +0000
References: <20220429115807.2198448-1-tee.min.tan@linux.intel.com>
In-Reply-To: <20220429115807.2198448-1-tee.min.tan@linux.intel.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        michael.wei.hong.sit@intel.com, xiaoliang.yang_1@nxp.com,
        vee.khee.wong@linux.intel.com, pei.lee.ling@intel.com,
        bhupesh.sharma@linaro.org, mnhagan88@gmail.com, kurt@linutronix.de,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, weifeng.voon@intel.com,
        yoong.siang.song@intel.com, Ong@vger.kernel.org,
        boon.leong.ong@intel.com, tee.min.tan@intel.com,
        hong.aun.looi@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 19:58:07 +0800 you wrote:
> Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
> of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
> This SPH limitation will cause ping failure when the packets size exceed
> the MTU size. For example, the issue happens once the basic ping packet
> size is larger than the configured MTU size and the data is lost inside
> the fragmented packet, replaced by zeros/corrupted values, and leads to
> ping fail.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: stmmac: disable Split Header (SPH) for Intel platforms
    https://git.kernel.org/netdev/net/c/47f753c1108e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


