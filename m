Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5058458D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiG1SKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiG1SKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEE41274F;
        Thu, 28 Jul 2022 11:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30E3FB824D5;
        Thu, 28 Jul 2022 18:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB1B3C433D7;
        Thu, 28 Jul 2022 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659031813;
        bh=xRpoizgvv4lZkhCa22vbs/t1Tpir9PIfJgTZUZjcgxQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tv/tURLnlVWIVkb7C4O7obejDAe31fC9py0fQlGfFpTl9IRUGS9QDfVgqRb8OKvN7
         TSlAg69s8sycGzM6JpT9laNXGTLwudktLh5dWQjOj0bj64zNkqyiazJSW6eLWyNHeT
         Rr6FjZUYy24MrB/NVuLkLOPUbGnViGsYgOzZ6umJAKV4cgs1aBZqka/TJqiZifA0s4
         dZ1iedZ7QmGMOnMmpyrTicV8myfDZeu3NcqNWDLaLhSjrPknji3oJv3wlGe6NU6Blm
         cmnmg4dJq3E5uLbsH70xZz3n3CQG/3jvNgjv1ZYYpiraLGdb8SUnUNnMtZaDLraaJI
         ieQrLOZLbeoXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0D54C43144;
        Thu, 28 Jul 2022 18:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165903181378.2291.14998545126043413404.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 18:10:13 +0000
References: <20220728013307.656257-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220728013307.656257-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Jul 2022 09:33:07 +0800 you wrote:
> Change net device's MTU to smaller than IPV6_MIN_MTU or unregister
> device while matching route. That may trigger null-ptr-deref bug
> for ip6_ptr probability as following.
> 
> =========================================================
> BUG: KASAN: null-ptr-deref in find_match.part.0+0x70/0x134
> Read of size 4 at addr 0000000000000308 by task ping6/263
> 
> [...]

Here is the summary with links:
  - [net,v3] ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr
    https://git.kernel.org/netdev/net/c/85f0173df35e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


