Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F914B1161
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbiBJPKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:10:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiBJPKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:10:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8881128;
        Thu, 10 Feb 2022 07:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68C94B825A2;
        Thu, 10 Feb 2022 15:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09063C340E5;
        Thu, 10 Feb 2022 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644505809;
        bh=q+gksobdVllBizaU4JoEszexKoKBza5OZEuxtNIDAu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nw5anLzBGa8/CZfveQN0oY0blfGH5NQxLXUDl9ANX+eBaEZ7w0ykvpRFnACGsLv5D
         VxoQmLM3TT4WMFv8CH9l2ZzXuCzf3pRkPi0PCezk3vR78bG5fQ9URvny3D2U3K8kmS
         AmKCMjFTqvyF7Y5fdGU50hoAAKaBnXeibl6Fp3KYrVoGMoe1bwKvpcseMZfgLj6cN6
         v2QJHvzoDxwBTUuNlr7ExiGwyJENfKb81x1Ixo1UOLfpbWN4k8GsLzmjYQSOiXJQPv
         zyvJOS2faYd1HbUIgKf+IQjParD3UT0BvUrLHVRdrVG7Y3kY0qAobEYXKKif5Q32RF
         TgZd+pgfHTVHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DEC83E5D084;
        Thu, 10 Feb 2022 15:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: Align the dma and coherent dma masks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450580890.354.9508904598156837461.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:10:08 +0000
References: <20220209094325.8525-1-harini.katakam@xilinx.com>
In-Reply-To: <20220209094325.8525-1-harini.katakam@xilinx.com>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, andrei.pistirica@microchip.com,
        kuba@kernel.org, Conor.Dooley@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        mstamand@ciena.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 9 Feb 2022 15:13:25 +0530 you wrote:
> From: Marc St-Amand <mstamand@ciena.com>
> 
> Single page and coherent memory blocks can use different DMA masks
> when the macb accesses physical memory directly. The kernel is clever
> enough to allocate pages that fit into the requested address width.
> 
> When using the ARM SMMU, the DMA mask must be the same for single
> pages and big coherent memory blocks. Otherwise the translation
> tables turn into one big mess.
> 
> [...]

Here is the summary with links:
  - net: macb: Align the dma and coherent dma masks
    https://git.kernel.org/netdev/net/c/37f7860602b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


