Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09A33B697D
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbhF1UMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232527AbhF1UMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:12:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A59A61CC4;
        Mon, 28 Jun 2021 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624911004;
        bh=mLeKWVJZAYEvuqZ2Od+0+PNnbfAb3kwqUipu6hnCOe8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fXC5GCkkQLY/P/QE8GLV2vXLfpaUzrDzdyYrhWOGvL5gOsIfWj0MwEAo+BqaKCAHA
         Xrdni3KTyj7aqzqKfVNiyeF7AsooZ3+Sn5stjTOXq2ePmOR6BqM222uq7hvLBxONh/
         ZEqwxd8I4rynE5Mquo3NLIvnuVYyMZQIQzZvneACD4rqT1PbpQiPstvIwRDN53qG9s
         5QswVXcQD9CunWRjmQ3pUHFQ35OR4YKoo2n48v+ODOqW9UfqX6hBtqWHRfVjDJsJE8
         U/MlFL3Fg51ww/TNzRK1kClIZPYvD/5nz2xI+vdHjRPFs1Ap1nFskHQILNtHtFV89t
         6gZLkeaxMZcuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F301B60CD0;
        Mon, 28 Jun 2021 20:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: fix warning in tcindex_alloc_perfect_hash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491100399.2562.3036606234492787494.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:10:03 +0000
References: <20210625202348.24560-1-paskripkin@gmail.com>
In-Reply-To: <20210625202348.24560-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 25 Jun 2021 23:23:48 +0300 you wrote:
> Syzbot reported warning in tcindex_alloc_perfect_hash. The problem
> was in too big cp->hash, which triggers warning in kmalloc. Since
> cp->hash comes from userspace, there is no need to warn if value
> is not correct
> 
> Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> Reported-and-tested-by: syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: sched: fix warning in tcindex_alloc_perfect_hash
    https://git.kernel.org/netdev/net/c/3f2db250099f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


