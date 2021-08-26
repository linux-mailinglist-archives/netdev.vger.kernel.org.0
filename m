Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEC23F8516
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbhHZKKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 06:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233880AbhHZKKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 06:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7AA28610E9;
        Thu, 26 Aug 2021 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629972606;
        bh=bRlNbWjWJdP1+itFRLbB52Xs7pco+kB/NRCXYlnJnC0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nii1y9lrl4YCUv26fY/LFrZcZxvwaERuBH0ZKw/i4nkdLgM8pHFtCA5x3nKd4wfej
         Lv+aSjx/q+cj1kN0t1KaJRkdqH0SmpqEDOkEMS8P7lD3pYmYjGhIFG/98fNyowWtEI
         NXnK0DMQUVz+ldWyl7kqdAswYVpVXoI5unOngiUy2+eRJAlRbhMR7PeM36qxcp89hy
         XBb0En7UBC7m5XPh3E91yoDzhLIgCl5h4b4wzHpOXDfdOX2lzxiARflPu4iQcf+q0g
         ST7rSCwL5AUtXnLS18kTXUjsQywxRbROcxtb/NnsOOqVINDB85+Uux47mr962NEoo1
         75kQTbXPAUTWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6CFF260A14;
        Thu, 26 Aug 2021 10:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sock: remove one redundant SKB_FRAG_PAGE_ORDER macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997260644.16360.3820820200576524198.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 10:10:06 +0000
References: <1629946187-60536-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1629946187-60536-1-git-send-email-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linuxarm@openeuler.org,
        mst@redhat.com, jasowang@redhat.com, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de, aahringo@redhat.com,
        xiangxia.m.yue@gmail.com, yangbo.lu@nxp.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 26 Aug 2021 10:49:47 +0800 you wrote:
> Both SKB_FRAG_PAGE_ORDER are defined to the same value in
> net/core/sock.c and drivers/vhost/net.c.
> 
> Move the SKB_FRAG_PAGE_ORDER definition to net/core/sock.h,
> as both net/core/sock.c and drivers/vhost/net.c include it,
> and it seems a reasonable file to put the macro.
> 
> [...]

Here is the summary with links:
  - [net-next] sock: remove one redundant SKB_FRAG_PAGE_ORDER macro
    https://git.kernel.org/netdev/net-next/c/723783d077e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


