Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B039152AF48
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiERAkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiERAkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C050B27;
        Tue, 17 May 2022 17:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B15D16153D;
        Wed, 18 May 2022 00:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B014C3411A;
        Wed, 18 May 2022 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652834413;
        bh=r+cvWdaDqXVSVvj8chj9ewlc+5fg4WRqMVA/zjgMdKo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=scYp7xXt2sTmNcefKTZ2L4G1zIMbQCoL2XJoChahmmxQvg1ZTOXJZ54As3XxWnp14
         8EQ15GqzzziXG+mnrbhN+rPboU3wNJO5ETcMG7SMrjbssuX1+zexcA1o8YKjCUHsRI
         6sl/llkcD6AywkcC7LANRIVxylr4LHTaT+EM1tYvEyH++cbQs7IbN1zeTY5+HgYbR2
         X1KD7xcER1x9Pg5W4mGHtFCo4YCe6fmbdSVXsgMVbOjj9A+6ASLjFeNy6jmrQDrr59
         RqtNd3Og6WLEeOuApRyMcDBIYPNzSwoSkfJKSj5ulrDbOiS/9XYWVNxBUMwZHCusZC
         ig+Q1HbjjhTQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0285FF0389D;
        Wed, 18 May 2022 00:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] octeontx2-pf: Use memset_startat() helper in
 otx2_stop()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165283441300.18628.17924718677480432521.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 00:40:13 +0000
References: <20220516092337.131653-1-xiujianfeng@huawei.com>
In-Reply-To: <20220516092337.131653-1-xiujianfeng@huawei.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 16 May 2022 17:23:37 +0800 you wrote:
> Use memset_startat() helper to simplify the code, there is no functional
> change in this patch.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [-next] octeontx2-pf: Use memset_startat() helper in otx2_stop()
    https://git.kernel.org/netdev/net-next/c/76e1e5df4b7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


