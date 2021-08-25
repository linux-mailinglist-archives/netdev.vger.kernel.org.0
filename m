Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA36F3F72B9
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbhHYKKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238949AbhHYKKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70E7861183;
        Wed, 25 Aug 2021 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886206;
        bh=65p/TIA87p7eJYjLp0QTn1JuyKk95BTYSGbqHgZY5Qw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k7iDOMivV62EC7EAlkOReOOg+q9yvXot4CH2A7q3TTMptJ+bq63IYHWTmnWcQ3E96
         AgJnrzIdrXwvx1mVxOPiJ0iScY4sK2egYotLzkLp6IwhC/+BzCy9KAqDxK3hEUSfhE
         5QOLCu0TK9pxF4/RFTxb5lDAQeB3k0ikabURBLxAlr9AN4HRIde6CWe0S5JPtOiUaJ
         CDIDQNYml/+nC8JInsBee7hXJsf7FrQFpwXRqps6TBe7+QqtRj74kdW8pXkk6ihKIU
         B/JlBPr+1+GQy4ukz/UvgbmZO0r/0iLvjNNu2WlMkO/Cg0nFZXDyWNb4AqpcDnuTUB
         0lpK6X+uob/eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 671C360A0C;
        Wed, 25 Aug 2021 10:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] net: stmmac: fix kernel panic due to NULL pointer
 dereference of xsk_pool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988620641.3256.15807737014421094725.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:10:06 +0000
References: <20210825005529.980109-1-yoong.siang.song@intel.com>
In-Reply-To: <20210825005529.980109-1-yoong.siang.song@intel.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Aug 2021 08:55:29 +0800 you wrote:
> After free xsk_pool, there is possibility that napi polling is still
> running in the middle, thus causes a kernel crash due to kernel NULL
> pointer dereference of rx_q->xsk_pool and tx_q->xsk_pool.
> 
> Fix this by changing the XDP pool setup sequence to:
>  1. disable napi before free xsk_pool
>  2. enable napi after init xsk_pool
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: stmmac: fix kernel panic due to NULL pointer dereference of xsk_pool
    https://git.kernel.org/netdev/net/c/a6451192da26

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


