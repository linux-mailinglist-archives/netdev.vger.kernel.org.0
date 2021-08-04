Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD823E00B5
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbhHDMAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234765AbhHDMAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 08:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2A2661040;
        Wed,  4 Aug 2021 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628078406;
        bh=zMbEjsMMn8TNP0mvzqmnpzDUld8VD46UN1l2SI3Xflw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WpL60fCJW8ilZDgCOtmMLvU6xqAlqhj1lnS6gz3aguUoZa0i7/Xja8M51gOtp6TrR
         jF3D3lv4RrvB7jFgPNtyj4sWg5irTp2toiuAt7hrfUSWFazrdxUu0r2x7rdccdAqJs
         uJCpcdRYDcZ4xWO4ImDiRVwTpt5g3w4CYE2KV1ZcGlvnC8vDUnTUcLQSyRyV415Afs
         7K36Eo7L64lsiUW7nv/1iV56PFz8Iatv6Dz+SN6p7kp4PNnGlosETNDjgr87TxTfGl
         5w8397x04Cp+MxRXqjCb6oIQ1BVX6mp1Cjg+lSxG4gJjm18g4DQmYoDMVCe4dNy+WS
         zkzSIacJji2vA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED14460A48;
        Wed,  4 Aug 2021 12:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] pktgen: Remove redundant clone_skb override
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807840596.323.9958057340127820476.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 12:00:05 +0000
References: <20210803162739.2363542-1-richardsonnick@google.com>
In-Reply-To: <20210803162739.2363542-1-richardsonnick@google.com>
To:     Nicholas Richardson <richardsonnick@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nrrichar@ncsu.edu,
        arunkaly@google.com, gustavoars@kernel.org, dev@ooseel.net,
        yebin10@huawei.com, zhudi21@huawei.com, yejune.deng@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 16:27:35 +0000 you wrote:
> From: Nick Richardson <richardsonnick@google.com>
> 
> When the netif_receive xmit_mode is set, a line is supposed to set
> clone_skb to a default 0 value. This line is made redundant due to a
> preceding line that checks if clone_skb is more than zero and returns
> -ENOTSUPP.
> 
> [...]

Here is the summary with links:
  - [v4] pktgen: Remove redundant clone_skb override
    https://git.kernel.org/netdev/net-next/c/c2eecaa193ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


