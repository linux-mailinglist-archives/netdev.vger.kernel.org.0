Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5B39AE0D
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhFCWbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhFCWbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A670261406;
        Thu,  3 Jun 2021 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759404;
        bh=NfYPPsPVECCx4+iGfWanwziApyixyx840dVXaXBwifA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MKdJhjKjQWxiYl/E5gFWzZI6wcVxejwXZnf1aNV1TFhtxpjjUBaIndCReu281jGNo
         jFB/4BeTmWx/XQ+Zs8J+rIUqd9Vxxd8pY8MzeTfyMt/dfsHVwl4IvpVY58YuEwt2a8
         YLcSmyUPWP5bvm8n6i/RvwPvjl6hNkbL0Wme5YQ6ScsNKMbeUWtQ71aTxO0f2oHY87
         Vu5MwxPWz9G2r6Zz86rJWJPs+E+DivcXJbi9/GO6Tp63nA4L5tRekArnisVEL+Kksk
         MQjOLpYmSnr2oUJkwlmwdcQ8YsLp6qkFb23awp6BS6yUrwt8DOsFuQElP1EuCGWhTd
         QKetBsXv/Bp9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 98F4D60BCF;
        Thu,  3 Jun 2021 22:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: Fix KASAN: slab-out-of-bounds Read in
 fib6_nh_flush_exceptions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940462.8870.18433133891688800912.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:04 +0000
References: <20210603073258.1186722-1-lixiaoyan@google.com>
In-Reply-To: <20210603073258.1186722-1-lixiaoyan@google.com>
To:     Coco Li <lixiaoyan@google.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Jun 2021 07:32:58 +0000 you wrote:
> Reported by syzbot:
> HEAD commit:    90c911ad Merge tag 'fixes' of git://git.kernel.org/pub/scm..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> dashboard link: https://syzkaller.appspot.com/bug?extid=123aa35098fd3c000eb7
> compiler:       Debian clang version 11.0.1-2
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in fib6_nh_get_excptn_bucket net/ipv6/route.c:1604 [inline]
> BUG: KASAN: slab-out-of-bounds in fib6_nh_flush_exceptions+0xbd/0x360 net/ipv6/route.c:1732
> Read of size 8 at addr ffff8880145c78f8 by task syz-executor.4/17760
> 
> [...]

Here is the summary with links:
  - [net] ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions
    https://git.kernel.org/netdev/net/c/821bbf79fe46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


