Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C04A6DB87E
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjDHDKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDHDKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4286CC679
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 20:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C150065529
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F5B0C433EF;
        Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680923420;
        bh=uiapifrFQLVVBHm/VZbvEsqGYJYzkS2KTtix8p6V9t8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m/p4elRnELl7fDRcaJH4BEvynBwSdlCS47UPy4A/rkhKGOzlDk5ylpPqt52bxrNLZ
         bb+X8Ix2LegcdHpVurxa301THbMVj770QdHAUMt4HYHi+tK0U8V2gyK6e4Lj9HKrI3
         W6v0819ogewc6JAj4D+atAqlkylRtCBr/6Pp/rjXIbv/zizX+VTlbyXe0ctatYuYjK
         6FyyBkBFfuNMNl+jOLXEaVUXtrTOWS7f4adCZfmbnAhu/W+Eh6hB1YcyJNF2c6+GGK
         YBo9JdZfTp1MC0D2jh4h3hv+NdNMjJ7epDSX265zYbBzQe3yZ9oHRADaNdmYYglyYE
         cJ2YQAEtlT5FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE74DC395C5;
        Sat,  8 Apr 2023 03:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: stmmac: dwmac-anarion: address issues
 flagged by sparse
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092341997.22423.14580442067480061333.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 03:10:19 +0000
References: <20230406-dwmac-anarion-sparse-v1-0-b0c866c8be9d@kernel.org>
In-Reply-To: <20230406-dwmac-anarion-sparse-v1-0-b0c866c8be9d@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 06 Apr 2023 19:30:08 +0200 you wrote:
> Two minor enhancements to dwmac-anarion to address issues flagged by
> sparse.
> 
> 1. Always return struct anarion_gmac * from anarion_config_dt()
> 2. Add __iomem annotation to register base
> 
> No functional change intended.
> Compile tested only.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: stmmac: dwmac-anarion: Use annotation __iomem for register base
    https://git.kernel.org/netdev/net-next/c/9f12541d684b
  - [net-next,2/2] net: stmmac: dwmac-anarion: Always return struct anarion_gmac * from anarion_config_dt()
    https://git.kernel.org/netdev/net-next/c/51fe084b17e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


