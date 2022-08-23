Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57C859D9C7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 12:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbiHWKCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 06:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352627AbiHWKCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 06:02:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AB0A2612;
        Tue, 23 Aug 2022 01:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8596A61555;
        Tue, 23 Aug 2022 08:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1B53C43470;
        Tue, 23 Aug 2022 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661244615;
        bh=Lpc9iSu9482doUb6kGnjPZcPkACwQKAB2dLj5+TpHX4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rgudO6bC2vPOgAMYe2wN0YSjHxJNlrrTfUwaviS5jbrhTcgicec2wBKjfoVwV1+Al
         ExSKPohH3XnzxejXWPsASl0XRUZpzK21ptEwv91zSqlQPNa6tmfEHhVkAd2Fb1DFiI
         P1DDEAk1LdZcYDwBhtFn7CdYr3ZVReaezUBsOk3t+1kW/bpTqsSOBcU3QanCsV6GsM
         /GTHSxW55+h5Eqv5F/VKNLaS5didnuU873Fulahf7Td5WqC96ULDd7tugKnZh+/Hdz
         /nV7bcNya4MwBaUSpY+T3TU5le2i/uIGwIKOZf7Ksf9/RlFpkctV4biiVmt6m3u3nj
         3zzP5b+TwtedQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC642C0C3EC;
        Tue, 23 Aug 2022 08:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] net: sched: remove duplicate check of user rights
 in qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166124461576.6596.11359882765801739049.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 08:50:15 +0000
References: <20220819041854.83372-1-shaozhengchao@huawei.com>
In-Reply-To: <20220819041854.83372-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Fri, 19 Aug 2022 12:18:54 +0800 you wrote:
> In rtnetlink_rcv_msg function, the permission for all user operations
> is checked except the GET operation, which is the same as the checking
> in qdisc. Therefore, remove the user rights check in qdisc.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v1: incorrectly delete checking right in action
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: sched: remove duplicate check of user rights in qdisc
    https://git.kernel.org/netdev/net-next/c/ab4850819176

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


