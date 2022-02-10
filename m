Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D680D4B11E1
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243722AbiBJPkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:40:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243705AbiBJPkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:40:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFB1117
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7C53B825F8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E0BBC340F7;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507609;
        bh=3ljfFK2viOUMUnmNR8EXwBxqZN5qD7X6MiOpTX8qcN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sHwUCpMQP2wiugZtaPrah8gnROOK8K86n3XLQATcqi+ZUtf1cprdCRvEPAml0U0xv
         zknIRedDP55D2kNnEDPxgMwEeLSwYCrzzloCZFj83RxSPhq5zLZcAQAwLp4P64dnX1
         zmFgMWmmXxhH1qm2sJTF7wr9FOhTNCkr/ik5u6No4UtvuxcrSKDWCZnsPJ2Zci55zN
         1SlLg7e+ZP28EaxMLOaGxci2gStFP9kZCg9E1uu+z1piJEIEx5MqGeH1Q4CM0NpIUk
         1qHSy4RRFvYvn1I87gyDPHnAp/xUH+iPioPKDwHQeJHl0BPDNZUCV3/8Svsx/uZAlU
         eRhUY4qp8vDHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 833E6E6D4A2;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv4: Reject again rules with high DSCP values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450760952.15967.596511068493586554.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:40:09 +0000
References: <cca72292694a74c76a6e155b34a8480df2918a14.1644495285.git.gnault@redhat.com>
In-Reply-To: <cca72292694a74c76a6e155b34a8480df2918a14.1644495285.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, toke@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 13:24:51 +0100 you wrote:
> Commit 563f8e97e054 ("ipv4: Stop taking ECN bits into account in
> fib4-rules") replaced the validation test on frh->tos. While the new
> test is stricter for ECN bits, it doesn't detect the use of high order
> DSCP bits. This would be fine if IPv4 could properly handle them. But
> currently, most IPv4 lookups are done with the three high DSCP bits
> masked. Therefore, using these bits doesn't lead to the expected
> result.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv4: Reject again rules with high DSCP values
    https://git.kernel.org/netdev/net-next/c/dc513a405cad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


