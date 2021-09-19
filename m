Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAF1410B3E
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhISLVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230394AbhISLVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28D8F6127A;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632050409;
        bh=GFuBb8jeLo4ZFDR8a5L/gzcKPFTKzvG9UpzJQAskWs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PKQPyI8B6gTZqJ2/t/IDWA6LS9bjW4zwrwM3T3b3tMylWw4W4KlJ3B6IYJYxU+t6g
         0dT7FXCRoeglVqYLsvbJeauFpCQ5S4kNxesm3a4zKF0LAwO8Jc/2DYyBzIX7qHwhYO
         zl1hK6dPyWE7tsp/j5hzqYyWJXCf3n+P8FxM6UjkkdXGM4/7effGomwYeQWpzvNztx
         jOgwXR0xASiR25cZWjYTrOu7vW60POe/J3lHcCSydmlte6LLpGEdvb7q1EBh9Dd/LX
         O6CyVBVy535KipGE76cOI3jkPM0BLhqMQMVn6F3Qu57tulnWqjMwNc5FZ6TQPYcBxi
         IT3mo9mMcrHig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B48960A3A;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] virtio-net: fix pages leaking when building skb in big
 mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205040910.14261.17888342837389121003.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:20:09 +0000
References: <20210917083406.75602-1-jasowang@redhat.com>
In-Reply-To: <20210917083406.75602-1-jasowang@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 16:34:06 +0800 you wrote:
> We try to use build_skb() if we had sufficient tailroom. But we forget
> to release the unused pages chained via private in big mode which will
> leak pages. Fixing this by release the pages after building the skb in
> big mode.
> 
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] virtio-net: fix pages leaking when building skb in big mode
    https://git.kernel.org/netdev/net/c/afd92d82c9d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


