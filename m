Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8F66239E2
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiKJCkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiKJCkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:40:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDF713EAD;
        Wed,  9 Nov 2022 18:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3882FB82062;
        Thu, 10 Nov 2022 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEB1BC433D7;
        Thu, 10 Nov 2022 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668048014;
        bh=yrsGQQL1q+GBNKW7AMNQYw3Mlguuo+PD9a5PiSGG0kM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m47KIj8K98+UnShqojg3+ANKHyZ7J2M2l5dM/1nVrfrHTPohFMPfb2prTFmrdsSVD
         ErMT1+K+uni1aJ9eh0H9gk6ed5MrOeHYs7jxrm4PChzClABC4s0+C4PnGo7F+fnFJw
         JMK53yzECJBVabJsuHr6PUBWs+MW9Z92L8vKtaeq3LgQt/UJg/bx2N6hNQMWV7uLKg
         Aq9+NVFT7XOqXHCzt+wwb9SyqAdCvo6UK+CaynGb8Ep7cTar+bHDi+HQNWUsStoEQd
         YyNv5lmWml7/Xsf7lJXYGJCLTPgtS9GQbeCbM9gBNHzulaOscnz5Z27+WsSAQa/vsw
         /JEKwSOmzJEXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A55B1C395F7;
        Thu, 10 Nov 2022 02:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: cpsw: disable napi in cpsw_ndo_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166804801465.842.8389256583880399963.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 02:40:14 +0000
References: <20221109011537.96975-1-shaozhengchao@huawei.com>
In-Reply-To: <20221109011537.96975-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, grygorii.strashko@ti.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, chi.minghao@zte.com.cn,
        mkl@pengutronix.de, wsa+renesas@sang-engineering.com,
        ardb@kernel.org, yangyingliang@huawei.com, mugunthanvnm@ti.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 9 Nov 2022 09:15:37 +0800 you wrote:
> When failed to create xdp rxqs or fill rx channels in cpsw_ndo_open() for
> opening device, napi isn't disabled. When open cpsw device next time, it
> will report a invalid opcode issue. Fix it. Only be compiled, not be
> tested.
> 
> Fixes: d354eb85d618 ("drivers: net: cpsw: dual_emac: simplify napi usage")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: cpsw: disable napi in cpsw_ndo_open()
    https://git.kernel.org/netdev/net/c/6d47b53fb3f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


