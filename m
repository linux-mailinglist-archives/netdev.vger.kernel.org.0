Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D860244F7E1
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 13:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhKNMdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 07:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235836AbhKNMdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 07:33:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 46B7E611C9;
        Sun, 14 Nov 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636893008;
        bh=KM8Xw/g9t+dzP4NyY4YRMWajkkOTzRxvGF8HLjuy7t8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=siU5F68YwtCi6JKvEo0dPtkZVUo2whhVuJHQgUFL500tc2SE5WqoekkyvnsMDNLTH
         Vb70NI732tIpDu8/FVDajgWxn36pty0z87SHJaCswqkEzu3C39bCuihKE2wW3vKlT7
         sYis+t2IGAso9v3JOnPveqORnv2DxSUbx5kYvFCbN3sKwaNlH9jJM29PwlX7xfPxoJ
         46Qd3cswuVAzkn8u4SbEwUc8Sj0swCX+TOGP+5bXKneJJTz0exy6GOELw/AdRln12F
         +h98D4ZsN+g/9j0IAVrCE4EtpC8gWPFNElpYQphBVyMHKbQgHTgaP1cLwYKvCdlmEL
         TeNh00frnumew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D6C16097A;
        Sun, 14 Nov 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] ipv4: drop unused assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163689300824.19604.1599603648864829790.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Nov 2021 12:30:08 +0000
References: <20211111091809.159707-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211111091809.159707-1-luo.penghao@zte.com.cn>
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

On Thu, 11 Nov 2021 09:18:09 +0000 you wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> The assignment in the if statement will be overwritten by the
> following statement
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [linux-next] ipv4: drop unused assignment
    https://git.kernel.org/netdev/net-next/c/ef14102914f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


