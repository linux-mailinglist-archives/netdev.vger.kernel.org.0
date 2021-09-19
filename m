Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EC4410B56
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhISLvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231466AbhISLvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6284C61268;
        Sun, 19 Sep 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632052207;
        bh=ComAMMGuJQJEhC0LzKm5dX7oKih/blEy79qTprwCFho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bthcNXbXUrYiaQDbBmjfxW9rz7cC1RcHYyQdq+C5dPLUxwzlUAjMCIWIQyjyjzz5y
         ru+nLeBGMQwkbJtm79/aTCUk+AS5vjkh9EaIqFJAvcspXArYRvN+PLl5+JJpVBjNJ3
         8fND+TFcfLlb+MaJ0Wd0di+9LQ1iQgP2i2TMyH8Bg97Ibc5m3RfRyouw8WrzhnuyLl
         6AHbI7JoYF35C+AoOnPx1uLcK4C9fBG3I/bM0FGaiXGtgjmgE2DzMXkejvOakSjk9A
         u+fP+p0yZRY0koAa7jr/iIcsoVrHKsSbA1Xy34mWQG3O0Vz4lCQsHlQMBkHK1HZupq
         QPqQxvwRvgRuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5172260A2A;
        Sun, 19 Sep 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] virtio_net: use netdev_warn_once to output warn when
 without enough queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205220732.27306.11268526915086415647.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:50:07 +0000
References: <20210918060615.8508-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210918060615.8508-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 18 Sep 2021 14:06:15 +0800 you wrote:
> This warning is output when virtnet does not have enough queues, but it
> only needs to be printed once to inform the user of this situation. It
> is not necessary to print it every time. If the user loads xdp
> frequently, this log appears too much.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net-next] virtio_net: use netdev_warn_once to output warn when without enough queues
    https://git.kernel.org/netdev/net-next/c/9ce4e3d6d856

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


