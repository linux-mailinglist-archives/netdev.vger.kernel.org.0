Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0256AF5E
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbiGHAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGHAUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1160F6EEA1;
        Thu,  7 Jul 2022 17:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A238A625FA;
        Fri,  8 Jul 2022 00:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFA2AC341D1;
        Fri,  8 Jul 2022 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657239614;
        bh=xr331W5Ea/ycBBI8aMRJXuRpjaog4l4hqCjwl3e4p0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A/rue9HgG6TGNfqlsk1bmfUtjBTY3WlEfkrB/odlebe1uimzQPltbkq1kU1TO8Jq1
         yILd0McT7t/Sw2PrJzSsTzulm2xByX/zvzgj+px5Xo1PWFunoqg/tFDc0rou30f0Pz
         M5EirYMC4s/6a3ChrdKeefa8etZ/6lTA1pcSaKRMWMwYCPDJCfhPnnbar/X4+wtqZd
         XJK6ukt0BVdGELEjAFW4jlBiXWgoGjz0z5FY5+J1gcwgUVC2HCY6OVlaQWI8dNonDf
         I0IMj2tbsD9Uvn6Aj0VG8eXH89eex9n/45zG+/8BSubZj1o85wsU3NL9wjwBt955o/
         mysCYXxQuA0cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBCF8E45BDC;
        Fri,  8 Jul 2022 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwc-qos: Disable split header for Tegra194
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165723961389.9316.14613536179831335249.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 00:20:13 +0000
References: <20220706083913.13750-1-jonathanh@nvidia.com>
In-Reply-To: <20220706083913.13750-1-jonathanh@nvidia.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 6 Jul 2022 09:39:13 +0100 you wrote:
> There is a long-standing issue with the Synopsys DWC Ethernet driver
> for Tegra194 where random system crashes have been observed [0]. The
> problem occurs when the split header feature is enabled in the stmmac
> driver. In the bad case, a larger than expected buffer length is
> received and causes the calculation of the total buffer length to
> overflow. This results in a very large buffer length that causes the
> kernel to crash. Why this larger buffer length is received is not clear,
> however, the feedback from the NVIDIA design team is that the split
> header feature is not supported for Tegra194. Therefore, disable split
> header support for Tegra194 to prevent these random crashes from
> occurring.
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwc-qos: Disable split header for Tegra194
    https://git.kernel.org/netdev/net/c/029c1c2059e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


