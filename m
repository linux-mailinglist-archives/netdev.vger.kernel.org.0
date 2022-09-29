Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917C85EF03B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiI2IUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiI2IUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C0424F07
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D2F6B823AE
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E380CC433C1;
        Thu, 29 Sep 2022 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664439615;
        bh=rFFcrfCdK+q9vsgxmmET8bY5dhuGqmTxaxAkBMjWqNA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T5UJZFTL96hitsrvgnlv9KC/0Jf5fTyI2M/sbBCNtkM7qsn7Vc7+nQjtQv7Izj/X8
         XJZv/3rd2HNa2ByQjzoEuu07pS2Z5t1+pIuZ04XQfAcIFcuGm4CIcUKxnXfReL/KIs
         nk01K9baw2wC1pAt0Er5CUtZxa7kPn6DX7PtiJjmHpN6065fMXwo2dolEilzwHdMHv
         6ynI6KkGkeaxNOgasniD6dOzEiPAtE1ExZ4Ly6ycQNKO7zcyG0clDmVtjhJOaLnoyT
         VFAvLiYyDEpFPI2V+Xy3EHam3YFAyyXAOi96cqPA+Uqay9I4JQOvkDJXMtUKpYt/30
         4iGMlz0wZBTUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB17CC395DA;
        Thu, 29 Sep 2022 08:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: liquidio: Remove unused struct lio_trusted_vf_ctx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166443961582.8877.8988815279933529183.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 08:20:15 +0000
References: <20220927133940.104181-1-yuancan@huawei.com>
In-Reply-To: <20220927133940.104181-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Sep 2022 13:39:40 +0000 you wrote:
> After commit 6870957ed5bc("liquidio: make soft command calls synchronous"), no
> one use struct lio_trusted_vf_ctx, so remove it.
> 
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 -----
>  1 file changed, 5 deletions(-)

Here is the summary with links:
  - net: liquidio: Remove unused struct lio_trusted_vf_ctx
    https://git.kernel.org/netdev/net-next/c/01c617d73f84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


