Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435563DBDB5
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhG3RaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhG3RaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 74F4460F94;
        Fri, 30 Jul 2021 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627666205;
        bh=+4AR6+L+9FJzJpRZl0fSUCsjn1T35YpuwAk2Segv+AI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jg8N+gvXNP+j+X9AzmjIn8b9Fa1cXmHRB8Zu/sLaMqy6szja1+QKT/s65rdW54U2c
         5Ea4knqdCKvMKXNRmCEv+RpZtQtbX7tGEBW4T7U+acqAiqVM/NqTBn/9Cd5bT/tOyj
         so3/qxWqVH+q5Id14xuGb6Md/zDkOo412jRRjCxlqfqT4dIhVbEOyTgtAmhSRiCrbY
         6R+5VpNzlDPiAITW1QuG61NwVse20uv0fxvd/lp2BxcYDY33LAYjR2zpJRe6e9n6oq
         +EE2kfX4IZbB8KiVIjC2BLrrBFdi1mduLfEuC2oinbovLADuU7Hn6ZKyIGzT3cizGP
         Nl3GxqIdUoAXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FB3560A85;
        Fri, 30 Jul 2021 17:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: netlink: Remove unused function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162766620545.25024.14544985558943001137.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Jul 2021 17:30:05 +0000
References: <20210729074854.8968-1-yajun.deng@linux.dev>
In-Reply-To: <20210729074854.8968-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 15:48:54 +0800 you wrote:
> lockdep_genl_is_held() and its caller arm not used now, just remove them.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/linux/genetlink.h | 23 -----------------------
>  net/netlink/genetlink.c   |  8 --------
>  2 files changed, 31 deletions(-)

Here is the summary with links:
  - net: netlink: Remove unused function
    https://git.kernel.org/netdev/net-next/c/bc830525615d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


