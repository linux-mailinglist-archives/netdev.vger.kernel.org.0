Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C50A565216
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbiGDKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiGDKVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:21:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E736B114;
        Mon,  4 Jul 2022 03:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8210E61543;
        Mon,  4 Jul 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA442C341D1;
        Mon,  4 Jul 2022 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656930012;
        bh=TbOe3regQ+IerV+BUZvBMUiQm6J749xPXAHtp8Xd788=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FQfVuphQpPkPStxD1jw/j3T8Bi+YSE2mosehP4bhmazBPb7/zWowB+2mGmuds1jmB
         sJYWuH6bMmvwiQd/tRpBszQTlrpU6Gi/3nxubBrrcVW7nAR+0t2icfD9MpSdrniWU7
         n36iIoxhIE7Fmwq48mzQA4WYG/YQINxrq/lbXgah1Xc7XfXcCr1P9lDt5VDTxTDJbP
         ncnrWqufVrTuWshvN+oD0Q/s1UMWc4thqMMqJiaL5eCzuffvJQ1H8tGK/CzU28UgTd
         NQXsedQPQQa3EsQpBuY09rmcOJOkn5ZqnLJqku9muQinDM0EmoD0lwqOIcCy41PqfY
         EuSXJG4SpPmiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4A74E45BDA;
        Mon,  4 Jul 2022 10:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns: Fix spelling mistakes in comments.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165693001280.5222.17220848831998363632.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 10:20:12 +0000
References: <20220704093632.5111-1-jiaming@nfschina.com>
In-Reply-To: <20220704093632.5111-1-jiaming@nfschina.com>
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        renyu@nfschina.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  4 Jul 2022 17:36:32 +0800 you wrote:
> Fix spelling of 'waitting' in comments.
> remove unnecessary space of 'MDIO_COMMAND_REG 's'.
> 
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
> ---
>  drivers/net/ethernet/hisilicon/hns_mdio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: hns: Fix spelling mistakes in comments.
    https://git.kernel.org/netdev/net-next/c/874bdbfe624e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


