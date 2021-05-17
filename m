Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BAE386D8E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbhEQXLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233727AbhEQXL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 19:11:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DBA161263;
        Mon, 17 May 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621293011;
        bh=XJtsmJX7RSUFq2Gtih2GnCxhnnRYN6ksL5x+HGEIgcw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IErxXPMYTIGch1ZhWwbpE4pLZLF6yUVAByJxqrmjTS9/6Z/KVkQKZq0N/OBdgfXFu
         3iswoEL5oSZGfIevF53RGFzfpWgeDuLGT4f9bcV7Sv8jVHO4r2DfjgNufr6AXg3Vpp
         qBXa+YCS6P8Qsp8O4fNv5IOXY6q2DNkt7h/om+rR9WhjUbqV1mVEn8gI4kJkie32Mj
         NLuuNHp0zn8W/LHYb0pLqYUQ8ZR56CrIwYbRWcOOjZxXaVOJLNH7bL9hgttU9nw7lO
         gNYRButQKsqeBzglD/kr0Q9uMnVp9oANpavoo+6mhaK3FvS44bp1cGe0IjlpH0cajp
         LqnRDtWZRInMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 11BD960A35;
        Mon, 17 May 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/packet: Remove redundant assignment to ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129301106.23530.3271088943002259290.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 23:10:11 +0000
References: <1621246525-65683-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1621246525-65683-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 18:15:25 +0800 you wrote:
> Variable ret is set to '0' or '-EBUSY', but this value is never read
> as it is not used later on, hence it is a redundant assignment and
> can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> net/packet/af_packet.c:3936:4: warning: Value stored to 'ret' is never
> read [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - net/packet: Remove redundant assignment to ret
    https://git.kernel.org/netdev/net-next/c/25c55b38d85b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


