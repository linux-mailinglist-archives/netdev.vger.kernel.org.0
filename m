Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7EA397C6B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhFAWbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhFAWbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CD1A4613AE;
        Tue,  1 Jun 2021 22:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586603;
        bh=096ixHsywqvn96S2kDkcATVb30XNLUZIcwM3ghKDjtw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lpax8HM7uiIQ/neHLrekpkQsQZd5ukF/a9i+WSYauhcLqHD/HgT50hwPO6o7uMajo
         w9RdcYlFbiwDuimBAZdGplDXQMRxeWXdigVgdG5ubTNIhayW1laNRvOA8m89rRlIdE
         8UVbWYhJMzONVPA2LIckLXKk7q1Ve56R1b9W1pQ6o03SIplM6XauX2R30bbyRTUEk8
         mKvWdv87NfE4rqb7yD87dyUrEXH+FJZZBHs4Bm3+K40WztL+OLkbRV4S61R5fqE40s
         o+llzdqsQ+i0R4aa+3Xdn1Qrq1cPyMQB0uQS7EfqorPY9wGHxBRnX3f8O8eZmseeHK
         Ny3engWh/zs/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF06E609F8;
        Tue,  1 Jun 2021 22:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] virtio-net: fix for build_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258660377.12532.14351738234949710613.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:30:03 +0000
References: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  1 Jun 2021 14:39:58 +0800 you wrote:
> #1 Fixed a serious error.
> #2 Fixed a logical error, but this error did not cause any serious consequences.
> 
> The logic of this piece is really messy. Fortunately, my refactored patch can be
> completed with a small amount of testing.
> 
> Thanks.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] virtio-net: fix for unable to handle page fault for address
    https://git.kernel.org/netdev/net/c/5c37711d9f27
  - [net,v2,2/2] virtio_net: get build_skb() buf by data ptr
    https://git.kernel.org/netdev/net/c/8fb7da9e9907

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


