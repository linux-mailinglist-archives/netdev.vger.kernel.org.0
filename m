Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3EB3C3628
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 20:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhGJSnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 14:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhGJSnZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 14:43:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9247D6127C;
        Sat, 10 Jul 2021 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625942439;
        bh=m3dQK1UTjaPc+RAve8DbmXK800U8ovxVw4MNl5eOsEE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l6cVdS2JeE0ExM6+8OM76ZZc7yDa2TiNHk2udVQ/z8FdyaH8FlTi8kXRbBMflz1sV
         h78taD30eEDk9GbW+/xHov3RSS+b64I005h1oRgdcmytMgYr5baDXwmC8Kv8zyxmg/
         o39ZQwb3REYrU3T+AWYeLYq3N3jm0FAw9TIr6IDva/R6l6MIfPeZDMZpaqhSM2EK+R
         eX2fXPTWCGH6Hv5dcSDnNJC7CfDIS2lqeo0cBJ+ab6VVc1iKi+KIZugHMJv+1+xi/E
         RHLj+2+0Yg150NyTjp8bNUrVUczluAo4uKnB4SrImNXE7eVkNhD3Ae4w7ze7fIEds0
         /b+fCFtq45TIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 86E9460A38;
        Sat, 10 Jul 2021 18:40:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] virtio_net: check virtqueue_add_sgs() return
 value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162594243954.26140.15070860345823566477.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Jul 2021 18:40:39 +0000
References: <1625887969-39804-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1625887969-39804-1-git-send-email-wangyunjian@huawei.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, dingxiaoxiong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 10 Jul 2021 11:32:49 +0800 you wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> As virtqueue_add_sgs() can fail, we should check the return value.
> 
> Addresses-Coverity-ID: 1464439 ("Unchecked return value")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] virtio_net: check virtqueue_add_sgs() return value
    https://git.kernel.org/netdev/net/c/222722bc6ebf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


