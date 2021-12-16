Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79DF477DDB
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241469AbhLPUvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:51:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57512 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhLPUvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:51:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72EE461F7F;
        Thu, 16 Dec 2021 20:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEAB1C36AE9;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687900;
        bh=r5wMr5uUY8+6xf4eaAkcI9HYvev3F4ejVh+OsQUArXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DIzAzjO3TP2V+9Gy4Degbb2KtFqMB9NfCl+h4L44f0AgXg4g2SOu7ojxyzrcsTR/k
         Cj5RY6/w/NFhmOh5876gsJFTIqEO8fjgP35+HzWYfkmeMW13gXi3/c40BJM0hB04ZX
         VKigWYjZqvHrdm4eYeW/l9hv+LjvKs1VHKqJ4r3XxeSSgljKvFhrWagtuu2dkFcdxh
         odnF8QMohSH240hEYk2F4tDLSVmZdg4P0OcIFLQgNMBPbGGgALD5qLzqCqgSOOKu5/
         vZfUMo/yPsSZUWuthkYPex12ANVzFzON7jlwA4pzJThFwaRIsv8cQcmZxuHMBH5Zkr
         7vWDgZOyg3Piw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C08260A0C;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] virtio_net: fix rx_drops stat for small pkts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968790063.17466.13042729723769172955.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:51:40 +0000
References: <20211216031135.3182660-1-wangwenliang.1995@bytedance.com>
In-Reply-To: <20211216031135.3182660-1-wangwenliang.1995@bytedance.com>
To:     Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Dec 2021 11:11:35 +0800 you wrote:
> We found the stat of rx drops for small pkts does not increment when
> build_skb fail, it's not coherent with other mode's rx drops stat.
> 
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> ---
>  drivers/net/virtio_net.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Here is the summary with links:
  - virtio_net: fix rx_drops stat for small pkts
    https://git.kernel.org/netdev/net/c/053c9e18c6f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


