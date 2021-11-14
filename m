Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A93344F7E0
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 13:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbhKNMdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 07:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235762AbhKNMdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 07:33:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D61961167;
        Sun, 14 Nov 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636893008;
        bh=VRW//e/OK1aaeK32aJi0FY+CyuAIer9W5OfdpqhjIhU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D2cwTKBvj3P74uTosRePVr2YKO767QDOKoaBBELE2Sjl71NqPHjobqDlCDqww+LdY
         Lqmot5p+o7sbp69Vq4uB6UdJda2bkm7ck1k1226ee07NNjOec2UDI+EChpKmuqm72S
         r5gDHQ9KTpkBszZ3erwkXZolfVaGLNkLGGAW8YMfiB9IVSDCgc6ZnE8xTGGvvgblP4
         +9xGMkxppXH9Bd5Nj3Qwlq9H1iD7QooFU1FoQImFaztKTXw78aInhEAzh61SMtCJwA
         bPB9U6P4FIBkdD+9wwhowob/z1dvZ6I08KAR8a1IzJhQ/JaOByMXXMd6rq85DvFSIV
         m9hXwx2IXBC7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 26E4F609D7;
        Sun, 14 Nov 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] ipv4: Remove duplicate assignments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163689300815.19604.493676864151812604.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Nov 2021 12:30:08 +0000
References: <20211111092047.159905-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211111092047.159905-1-luo.penghao@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo.penghao@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Nov 2021 09:20:47 +0000 you wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> there is a same action when the variable is initialized
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [linux-next] ipv4: Remove duplicate assignments
    https://git.kernel.org/netdev/net-next/c/0de3521500cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


