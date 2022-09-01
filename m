Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8568E5A8BB4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiIADA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiIADAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DFF76476;
        Wed, 31 Aug 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD43E61DE9;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F418C433D7;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662001217;
        bh=2Pjra/jZTqt377/KTIDaIK6e2GKhdlbYx5bn/nQjQKs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lcq6KIq684ywItGtWmKldRS+uGuU4QIkrPHZuINYzDKBFvb0sSZQiMv9zK8/CQZE8
         635cuKNBI2D0GAkib2jsqmKBdKlWMydqyconhWnkOo6X4a9uz5E7dkLT/DPGEIn19f
         MzEgh19OtJXta40WO8X0Lq6C4pU5wZmlEmOqxhR2oEtcxtOW1aYufuJxptyn9LEmdk
         aT7eCRdUQjQLxkFIfmppNkpzcrDcKpMtB5Fpx3N9dLTZVgGL7Dpi/0O9x2U/TgdCL/
         8CwNDnRuKEAg6djGieUoiab9TKuEEsQU/lA3HmdTPRT+dxaeti0w9FZxdegghYCWZm
         Yl3Z/JLR839iQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29C96E924D6;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v3 0/2] net: sched: remove unused variables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166200121716.29714.8785191627775525930.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 03:00:17 +0000
References: <20220830092255.281330-1-shaozhengchao@huawei.com>
In-Reply-To: <20220830092255.281330-1-shaozhengchao@huawei.com>
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Aug 2022 17:22:53 +0800 you wrote:
> The variable "other" is unused, remove it.
> 
> Zhengchao Shao (2):
>   net: sched: choke: remove unused variables in struct choke_sched_data
>   net: sched: gred/red: remove unused variables in struct red_stats
> 
>  include/net/red.h     | 1 -
>  net/sched/sch_choke.c | 2 --
>  net/sched/sch_gred.c  | 3 ---
>  net/sched/sch_red.c   | 1 -
>  4 files changed, 7 deletions(-)

Here is the summary with links:
  - [net-next,v3,1/2] net: sched: choke: remove unused variables in struct choke_sched_data
    https://git.kernel.org/netdev/net-next/c/38af11717b38
  - [net-next,v3,2/2] net: sched: gred/red: remove unused variables in struct red_stats
    https://git.kernel.org/netdev/net-next/c/4516c873e3b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


