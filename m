Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E966643FF8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiLFJkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiLFJkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:40:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D391AD99;
        Tue,  6 Dec 2022 01:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BE34B818D8;
        Tue,  6 Dec 2022 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0C90C433C1;
        Tue,  6 Dec 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670319615;
        bh=gdFXTkz+vhzdqsLWe2zuYI5oIBjzDu4Or2RTciBZ7BM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fs2wwHiY2OYCWLyGjEfMZVwnVsWYq9RBYHa+6d2Nlhot66FAPfWnt0//SGD0DiU9e
         Wk3xFZhLYgv9h36YKn3grItq2ApFnxnASHkBKalDPG9vsE42AjaAcSITOyw2ODJmHg
         c6RTcbL+PDmf8iWhWG1SgX4BhvQ4f2uWOpe2j7uKkf3nZ0M56bJS0/63EEvtV1WP/H
         Gg6uG2B8jJ8UoukkfZmyAKQDAoYRghYJ5YxH9/1AMumbwa10s5KmQH9GktDeTCUT1O
         balM/CjZ1B6p2lfFCLS0G2kyiU47jHcufidd/CN1Sipm69hTrFtJqxXdHkO2I4DqFQ
         gXIk+gOobyxdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B8BEE21EFD;
        Tue,  6 Dec 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: fix "snps,axi-config" node property parsing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167031961556.637.9347299924029624917.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 09:40:15 +0000
References: <20221202161739.2203-1-jszhang@kernel.org>
In-Reply-To: <20221202161739.2203-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat,  3 Dec 2022 00:17:39 +0800 you wrote:
> In dt-binding snps,dwmac.yaml, some properties under "snps,axi-config"
> node are named without "axi_" prefix, but the driver expects the
> prefix. Since the dt-binding has been there for a long time, we'd
> better make driver match the binding for compatibility.
> 
> Fixes: afea03656add ("stmmac: rework DMA bus setting and introduce new platform AXI structure")
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: stmmac: fix "snps,axi-config" node property parsing
    https://git.kernel.org/netdev/net/c/61d4f140943c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


