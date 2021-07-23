Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A9B3D3DDE
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhGWQJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230393AbhGWQJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3C1DD60EB5;
        Fri, 23 Jul 2021 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627059006;
        bh=Maw2pDz5zbCE6MAg2tKnfkmkDkJ8MV+TvmEFBDQY8uc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bgq+DxgPKEY8QPCehSCYWq5Xb464GSYnESyd/qlmY854z80tfQguHiZxALcshMdqR
         +RGBhSzeyT+sUuvXJvzbhp7oHKqCwy2g1R4jKjvVomWxwq/hUU4FySqI1Gh/wOlVcK
         X4iiTN3XqxwH7vYfYXNDrbH+NkP6SPDeJW514MdNRycG5TZVw8cMunjhQ3gfm08zeV
         bTll/Vf1it5YSpQGGCoG7p4kSQnBiWYG9LAeEKwKqqk0fMoKhiCDq2mzYlRkEwVqe9
         45S2+F5tkFhrYGSTlg99BC4qA62aLQZxi5sJPGmwY6iubWnGUVjNV7lt906Ukxqh6I
         KejEz/4WCKjOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F2B860721;
        Fri, 23 Jul 2021 16:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: qrtr: fix memory leaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705900618.21133.10256385935124978429.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:50:06 +0000
References: <20210723153132.6159-1-paskripkin@gmail.com>
In-Reply-To: <20210723153132.6159-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org,
        loic.poulain@linaro.org, bjorn.andersson@linaro.org,
        xiyou.wangcong@gmail.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 18:31:32 +0300 you wrote:
> Syzbot reported memory leak in qrtr. The problem was in unputted
> struct sock. qrtr_local_enqueue() function calls qrtr_port_lookup()
> which takes sock reference if port was found. Then there is the following
> check:
> 
> if (!ipc || &ipc->sk == skb->sk) {
> 	...
> 	return -ENODEV;
> }
> 
> [...]

Here is the summary with links:
  - [v2] net: qrtr: fix memory leaks
    https://git.kernel.org/netdev/net/c/52f3456a96c0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


