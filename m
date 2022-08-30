Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB3D5A61F1
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiH3LbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiH3LaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B2C65E4;
        Tue, 30 Aug 2022 04:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869BB61552;
        Tue, 30 Aug 2022 11:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5AADC43141;
        Tue, 30 Aug 2022 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661859014;
        bh=ruXk2tsM+3zU/7j9rH8vwCINKwBg3nR3eA8tAAK1Xis=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ikk5doy/i5G3HoTWlzNrTAfGdPkRS/iHeFdCsmJvZt5Sw8tmqsum/Id/aDRgEKbat
         22mAJfKShJLm1id9GG4Vj6OaOwVWmLHUSTqYl2+kazlACncKJ6RVafFiO80CCxkMYW
         Fa6OqUIUDVS8eOGHPjcxSiPLHEmaCtDoIv4yfowxeE0tW9dJXGITaX2R9pydzJfmkr
         WSKCis1FJjJsWWGn8p6DHvZHaVa4TLrm/kH6SEOXYcJtFhCaV6WPhCxw4y+s9EAIxz
         bzE535JHvyZ6TdSDN3tgG0jthHXti2x+AP1a6hE+7Z7JzWmc7zDPDsGwZi7IeC5L58
         JenCSAwCSttmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB0DCE924D8;
        Tue, 30 Aug 2022 11:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: using TCQ_MIN_PRIO_BANDS in prio_tune()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166185901482.4860.9328248852894519712.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 11:30:14 +0000
References: <20220826041035.80129-1-shaozhengchao@huawei.com>
In-Reply-To: <20220826041035.80129-1-shaozhengchao@huawei.com>
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 26 Aug 2022 12:10:35 +0800 you wrote:
> Using TCQ_MIN_PRIO_BANDS instead of magic number in prio_tune().
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/sch_prio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sched: using TCQ_MIN_PRIO_BANDS in prio_tune()
    https://git.kernel.org/netdev/net-next/c/4b7477f0921a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


