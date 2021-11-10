Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A6F44C325
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhKJOnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhKJOmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:42:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C7296121F;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555208;
        bh=/kVvdB7+Jw+/dbb44MXjndhNVsEBxJUkSG3nySIN30U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tdu/FiTntS43oM5iAEDlOspnSbfSKrUCmUCLey1seL7tAdV4wRC/32C2U5IDQMkXq
         EAkClk9HBtFa6UlelmgdPOVLR/AQveUvEbnc801HiRv3CSfxpvsVdoqintwtSsXZ2Y
         c7VsUbXeV8oU6KJBNTdc4+STqx/s6ht/iaiEtAsqfW+jmGHc3uBu+tjCEzb8Qj81Vw
         08Etep2KCYPHIQsydSQNxb9J7cxLyOh+V1g/cNCyMpHiGA2rJ91hzf/j7bhOPSf1ic
         XmWMPo49B2BCbTEIOtB13qrCUZqKJ2SC4316ZghKjz6R7qmG4usAmxa0ERdzM61uTo
         QH8uDxZZ9xUEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5064660A5A;
        Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] vsock: prevent unnecessary refcnt inc for nonblocking
 connect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655520832.19242.11820946146081406943.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:40:08 +0000
References: <20211109001502.9152-1-eiichi.tsukata@nutanix.com>
In-Reply-To: <20211109001502.9152-1-eiichi.tsukata@nutanix.com>
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 Nov 2021 00:15:02 +0000 you wrote:
> Currently vosck_connect() increments sock refcount for nonblocking
> socket each time it's called, which can lead to memory leak if
> it's called multiple times because connect timeout function decrements
> sock refcount only once.
> 
> Fixes it by making vsock_connect() return -EALREADY immediately when
> sock state is already SS_CONNECTING.
> 
> [...]

Here is the summary with links:
  - [net,v2] vsock: prevent unnecessary refcnt inc for nonblocking connect
    https://git.kernel.org/netdev/net/c/c7cd82b90599

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


