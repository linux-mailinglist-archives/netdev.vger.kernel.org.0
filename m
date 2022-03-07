Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932404CFCF6
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiCGLdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242422AbiCGLdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA94647E;
        Mon,  7 Mar 2022 03:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A60EB81113;
        Mon,  7 Mar 2022 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CC40C340F3;
        Mon,  7 Mar 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646652610;
        bh=oOilS8wzdwRV+JVghJ4kYv7I3nBqhvD7FTLRUs27lgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpVlXoGxRIXmkFPYFFiOa3duzGsojIrbbQJgjKXISej6mgFnS6gqSVfhgzxSXoK6A
         HkzkvTs5x1fgs5tz/x5z5KndtS0HYhW1Xab0Q1V/RA2AweNdXj9KtuHdzbralMMiDA
         PKcBsRLQ4gauWcHiu23AqZwcTQTAXBDfvW7tszy1kDBv9GKgI2i7iS/fDlDBsWu5vt
         F0RmWrZsbLAxfNRh42VevaDzEVtKewUC/s+Fis5R4gcaziHw78qqvvVlle9pnjV9HT
         OfV6G5bdBVXDob8qbTEn7RK96bvQhU0Ka6u3trB9mdo2tirGDg4leOjmC+oPHGkvZh
         pXrjtXULXACwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16729E7BB18;
        Mon,  7 Mar 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: qlogic: check the return value of
 dma_alloc_coherent() in qed_vf_hw_prepare()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665261008.6495.2244569719834079527.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 11:30:10 +0000
References: <20220305091411.18255-1-baijiaju1990@gmail.com>
In-Reply-To: <20220305091411.18255-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat,  5 Mar 2022 01:14:11 -0800 you wrote:
> The function dma_alloc_coherent() in qed_vf_hw_prepare() can fail, so
> its return value should be checked.
> 
> Fixes: 1408cc1fa48c ("qed: Introduce VFs")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()
    https://git.kernel.org/netdev/net/c/e0058f0fa80f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


