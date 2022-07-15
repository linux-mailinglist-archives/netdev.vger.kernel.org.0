Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38CD575FCA
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiGOLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiGOLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C81B85FBD;
        Fri, 15 Jul 2022 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3E74B82B46;
        Fri, 15 Jul 2022 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C530C341C8;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657883414;
        bh=mGE/HM+veDHotiSgM1jxrcojqkZr0cRHNOIPIdNLF+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MEkM8HFw6IpUHv+MlY/N4aq1Q2crRj6mty3ukWFif0dw5u94iq3Z61ZQRwRU/0AR4
         +zP2XFePpYNNMfdOntOpb6NIagyWa4EGCjYurGM7HkRH9EVetEkTqykuytnL//YrFu
         p5p7iPCYom690W9qSK7xc8+kF/KaSGNQAsCHaBaWCGJs+4T0m+fFXzYC5ESrr6OGm2
         ZtwYC/PEYSL0gPxN0Cdwo8z7h71g+UQEIKdjbjIWTHkwwdPPglPY175MwoyKWA2kR/
         IHrnW9wbC35F07DgD22vIUW6TsgjYIM6PqiyVZ04YwA8lTbtru7Jj1GNbrTggTl0rb
         /tcFJOCcinYdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FB25E45230;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: sch_cbq: Delete unused delay_timer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165788341419.15583.12654886663403136630.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 11:10:14 +0000
References: <20220713204051.32551-1-yepeilin.cs@gmail.com>
In-Reply-To: <20220713204051.32551-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        peilin.ye@bytedance.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cong.wang@bytedance.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Jul 2022 13:40:51 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> delay_timer has been unused since commit c3498d34dd36 ("cbq: remove
> TCA_CBQ_OVL_STRATEGY support").  Delete it.
> 
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: sch_cbq: Delete unused delay_timer
    https://git.kernel.org/netdev/net-next/c/88b3822cdf2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


