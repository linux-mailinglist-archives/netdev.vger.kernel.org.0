Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1A764261B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiLEJuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiLEJuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C687F5A6;
        Mon,  5 Dec 2022 01:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32491B80E07;
        Mon,  5 Dec 2022 09:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6B35C43470;
        Mon,  5 Dec 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670233816;
        bh=kDQr1OEC5GArHftEOzi2seMnpzvIkuvodzBTdXWHJ8w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eRPW3IVVR8ctR28s+HYaBGeW7Ig5Lna643sE0bgOaNu5ucitPo1ard+l1W+G4K7QP
         jctBb8egkiT3Cr4hl8fBqX0OyuiEzpJ4XcBxRz61mraGZGG4OLr4+dOogm1KllycBc
         dBAIj6+BC4bs79S1SQVJFWfya7Z1OVROsHBYXeY5ddUUR+QEc6Q6n7ZLnXfqCO8s8m
         NqGT13YJFHWZqb9n99hmZfA6az4GmHYJsFT1zZzYRPesmmJdJcc86WBxBmllIzANBp
         ZnhgVGKYaJs0+w51xMBh+B2HFg0jV3wVj+hBfAYzSeWhdXUcpjTkiyBvJPRbYMF17x
         a/3ROEMu/ZCKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF6DAC5C7C6;
        Mon,  5 Dec 2022 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V6 1/2] net: stmmac: Power up SERDES after the PHY link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167023381671.8030.2390834995208845499.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 09:50:16 +0000
References: <20221201155844.43217-1-jonathanh@nvidia.com>
In-Reply-To: <20221201155844.43217-1-jonathanh@nvidia.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        ruppala@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 1 Dec 2022 15:58:43 +0000 you wrote:
> From: Revanth Kumar Uppala <ruppala@nvidia.com>
> 
> The Tegra MGBE ethernet controller requires that the SERDES link is
> powered-up after the PHY link is up, otherwise the link fails to
> become ready following a resume from suspend. Add a variable to indicate
> that the SERDES link must be powered-up after the PHY link.
> 
> [...]

Here is the summary with links:
  - [V6,1/2] net: stmmac: Power up SERDES after the PHY link
    https://git.kernel.org/netdev/net-next/c/a46e90101242
  - [V6,2/2] net: stmmac: tegra: Add MGBE support
    https://git.kernel.org/netdev/net-next/c/d8ca113724e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


