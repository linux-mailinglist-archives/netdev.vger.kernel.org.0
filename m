Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A904B9815
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 06:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiBQFUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 00:20:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBQFUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 00:20:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64DF2A598B
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 21:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 512B4B817E3
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E431AC340EF;
        Thu, 17 Feb 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645075211;
        bh=owOzHGDpuVa+SlXLSKCXF77qIvYi5OlHkDeK40j6YmE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=plyyMLAcofN9GWLLcd40iiZOkMQi6czeJJb9b88RXWVHw5n8QOy1xehbLiopMwcfL
         tnlSxmDJ90aVWyoC38ThwIL6bpONw8t4Va6V2Lehq11fxObt4ZuODCf0A5Pp7HpKo8
         lmayPVmAgu5d5eEEMag6SN+pu8CYSHgGRdh4tjrxV8ea/0Bq58sIGVBAFyFlnht4SB
         G/WHO9F23979nT+UWf0GISYhDEzVcTDZM5O5lyMqmIOOpFozSDomzjNu1X9eaF83yQ
         pQs4El8Y7qf3tStWa6wPebqHVxw/TRVAAKX+QLN/OH3BkQMVeJKPpTPMtCUbcUbjk8
         iXqyz7wPLnVnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAF89E7BB09;
        Thu, 17 Feb 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: sched: limit TC_ACT_REPEAT loops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164507521082.4843.10919598398641322914.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 05:20:10 +0000
References: <20220215235305.3272331-1-eric.dumazet@gmail.com>
In-Reply-To: <20220215235305.3272331-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, syzkaller@googlegroups.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Feb 2022 15:53:05 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We have been living dangerously, at the mercy of malicious users,
> abusing TC_ACT_REPEAT, as shown by this syzpot report [1].
> 
> Add an arbitrary limit (32) to the number of times an action can
> return TC_ACT_REPEAT.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: sched: limit TC_ACT_REPEAT loops
    https://git.kernel.org/netdev/net/c/5740d0689096

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


