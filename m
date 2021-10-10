Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F7D428087
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhJJKmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhJJKmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 035B961054;
        Sun, 10 Oct 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633862407;
        bh=NWz8SStrzap85knxX/CeBbT4xNkDVgh9YlBq/EdPtuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HXdZca8eulzXZaXmW1Ne4woej2qKT9TGNgDANxaZ/0QeLjCBt5ylfC4RftL4bEV7T
         Z9SPzqPFXgMUHyt4FXekqNI9qE57oMAm6j+BPdgWtHrndDC6hL3gF3+QovUq2CC1cO
         5ucZWNXj4DxzzcgOZPnBJ8j4NKrBbNSx+nzUB5B6k1/Yq536eieLRCLf27BsecwIui
         ZK8Pl9SONk1hSYyz65Orc24qNLvjb0VDgJmWrliZn6kI08iQVl+yrJCuM6rOmm50KS
         4dZ35aE7rvmRXvfCESiXbxkZvfYvTmEFMJsvBUGaeTVzFGruBuRYQsTSVsL3bAxLl8
         WnS+usDx475+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E5F0A609EF;
        Sun, 10 Oct 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][net-next] virtio_net: skip RCU read lock by checking
 xdp_enabled of vi
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163386240693.21532.10618861075698217422.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Oct 2021 10:40:06 +0000
References: <1633771963-6746-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1633771963-6746-1-git-send-email-lirongqing@baidu.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  9 Oct 2021 17:32:43 +0800 you wrote:
> networking benchmark shows that __rcu_read_lock and
> __rcu_read_unlock takes some cpu cycles, and we can avoid
> calling them partially in virtio rx path by check xdp_enabled
> of vi, and xdp is disabled most of time
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - [net-next] virtio_net: skip RCU read lock by checking xdp_enabled of vi
    https://git.kernel.org/netdev/net-next/c/6213f07cb542

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


