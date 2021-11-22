Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE74590B2
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239726AbhKVPDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239678AbhKVPDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:03:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D61460F24;
        Mon, 22 Nov 2021 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593208;
        bh=c2R7U7jRqFbZTUnZhuIlNTuETMxlaXWH8DOuaGHeN54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t8ghqzEjbvjD5KseRkXY33XkxI+i8tMbmuaEPAe6yOMjZ1PU8tDSueFkOlKBZ4u5B
         01uFJ71GiCcqk5TI+SvVnTzatXsbQkdIfZhIbeH4rNF1F3lsy+6qOxY8dWlAwnbZ8h
         H+91EkCS6LIcY44lNNP5FyJ/SgO7CJ7QWXtYtIWD+F4jjlVTQvjProo7L2YNCaa7hc
         FBL9wSRHLC14vjoZ8hpK/u53cv/AJeYRDC/6HSr1ZO02iLcWXSxx6Aohql2FDo/dWZ
         ME8wIZmTvJzkiXbLESmwkUj0RMjuAWH/9T+fYwKSFr9mVgv+2Oc70ikOlzzVJ9zkvE
         aY8Ye5RRntqwQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 920C060A94;
        Mon, 22 Nov 2021 15:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Avoid warning of possible recursive locking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759320859.11926.10316614383509162500.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:00:08 +0000
References: <1637584373-49664-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1637584373-49664-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, syzkaller-bugs@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 20:32:53 +0800 you wrote:
> Possible recursive locking is detected by lockdep when SMC
> falls back to TCP. The corresponding warnings are as follows:
> 
>  ============================================
>  WARNING: possible recursive locking detected
>  5.16.0-rc1+ #18 Tainted: G            E
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Avoid warning of possible recursive locking
    https://git.kernel.org/netdev/net/c/7a61432dc813

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


