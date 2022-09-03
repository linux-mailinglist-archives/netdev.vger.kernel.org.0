Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549055ABD0B
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiICEai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiICEa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:30:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540B45247C;
        Fri,  2 Sep 2022 21:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02262B82E4F;
        Sat,  3 Sep 2022 04:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BFA2C43146;
        Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662179421;
        bh=tN+3zRncE7twLqJ5NW2sKENvMd6q7hOV7QdZTdSn+Wc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i640zx3laGJPv+9KumrljLzG3bkWinnRc/TYsES+9LlbCRzjfOMfMnb0Dgr7cRL9l
         Us6HYvjwyT9BKTShiNhaROT2d3b6yV3Ilap2EP8N4KLC35HKfuVd2eXm0Dv2gztu07
         Zp7oNnz75EdetqSgNfqYk+qUhdHOXLYdo7dl5Nxxezl8sWRr2818ozABEZhGtPxT8S
         h6mMhXDcoMEHP9oxeXntFclrAUN5crU4UNZv6ilGx47/kc2CAM2QXzvoOT0Jao6Okg
         Et56zA6Thvcsvw2jy69n/8X9T55BMh55KpY6s44amYs6qn6T4MGjpgE7DxEADgyJFj
         TdmfBY8WFlECA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 474E7C73FE2;
        Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] net/sched: cls_api: remove redundant 0 check in
 tcf_qevent_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217942128.8630.8197729532993033664.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:30:21 +0000
References: <20220901011617.14105-1-shaozhengchao@huawei.com>
In-Reply-To: <20220901011617.14105-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 1 Sep 2022 09:16:17 +0800 you wrote:
> tcf_qevent_parse_block_index() never returns a zero block_index.
> Therefore, it is unnecessary to check the value of block_index in
> tcf_qevent_init().
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/cls_api.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net-next,v2] net/sched: cls_api: remove redundant 0 check in tcf_qevent_init()
    https://git.kernel.org/netdev/net-next/c/2e5fb3223261

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


