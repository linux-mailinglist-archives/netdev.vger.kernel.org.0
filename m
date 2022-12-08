Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20F646831
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiLHEUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiLHEUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4E16A779
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 20:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6623261D79
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD2DCC433C1;
        Thu,  8 Dec 2022 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670473215;
        bh=an+6SQEmnSVH3RdSeifDvI8E79qfd5p7IaHuHOPyYeo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QhUEgxH7yfG/EDnI7rq34N7OQJHxkOJ4RTLrDt3qcHTfluQOHgbOrhw0JkK7uqP3E
         iOsT8nbYSN7Js0PR+M5oDp8t2hAw7yNyie0QBO49NUZm3gsJRhkFbsrOG3SpVf5g/8
         yym5sbMpI8tpsq8yLILmhD511THhflyUGxaG8DwugrOyo6zl071AnxH6GKIBSw895A
         /ybs0e1QcF4i0bqpIzc0lpaDG1oA8Cdy8f21CjU2a95pKEMgu1mCfCRElBBVBXEvPj
         nXhDZ9bbLsX6FT8pyQsqGuK9bk8oW2nSQ97TPyXxaP+NtR6K18qyKeAAXOkr5CJ1/w
         xzV6NjuCVFnLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91E79E4D02D;
        Thu,  8 Dec 2022 04:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: avoid use-after-free in ip6_fragment()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167047321559.25577.3034616667563524970.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 04:20:15 +0000
References: <20221206101351.2037285-1-edumazet@google.com>
In-Reply-To: <20221206101351.2037285-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+8c0ac31aa9681abb9e2d@syzkaller.appspotmail.com,
        weiwan@google.com, kafai@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  6 Dec 2022 10:13:51 +0000 you wrote:
> Blamed commit claimed rcu_read_lock() was held by ip6_fragment() callers.
> 
> It seems to not be always true, at least for UDP stack.
> 
> syzbot reported:
> 
> BUG: KASAN: use-after-free in ip6_dst_idev include/net/ip6_fib.h:245 [inline]
> BUG: KASAN: use-after-free in ip6_fragment+0x2724/0x2770 net/ipv6/ip6_output.c:951
> Read of size 8 at addr ffff88801d403e80 by task syz-executor.3/7618
> 
> [...]

Here is the summary with links:
  - [net] ipv6: avoid use-after-free in ip6_fragment()
    https://git.kernel.org/netdev/net/c/803e84867de5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


