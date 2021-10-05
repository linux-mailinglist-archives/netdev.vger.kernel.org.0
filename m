Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC72A422647
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhJEMV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234409AbhJEMV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C95A61409;
        Tue,  5 Oct 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633436407;
        bh=HWWwuOiqBjA/+5ovKN7/GFzIm4Xb/FzyiX6uRrU/lrI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZXiOYLvJKQz+bEq7rmjROy8MOTSccLx7mxR9/k0+H14MK72tW4/wxpggy9x+S5MS2
         Wecpu72ZBOx94BFbCtWMSXPJNhJoUXmSco+PDs0sNW6hIprwDIFJqBaWP+LuH9Z53v
         fZPM1cGESOjGps2g+VeI9F7L4RjRBfeH30ekmD3FqU6gi5FgnF8yRItygnR2xzsIqw
         5JAjRD9/pTSm/TlUO3lP2KtX0RfAMWj8rxxFljCw2xxri7zW9DNXBZedRRp++3kdZg
         AI+O+LuvVgUn+WaWbHGpvf9wNhUtEVPQqUunl4DLCbwDh/yhne/qT0mDq1lp+zy2yX
         fhP8S7z3fR2eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F2DBF60A1B;
        Tue,  5 Oct 2021 12:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: annotate data races around nlk->bound
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343640699.26713.1654558078502383528.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 12:20:06 +0000
References: <20211004212415.2080576-1-eric.dumazet@gmail.com>
In-Reply-To: <20211004212415.2080576-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  4 Oct 2021 14:24:15 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While existing code is correct, KCSAN is reporting
> a data-race in netlink_insert / netlink_sendmsg [1]
> 
> It is correct to read nlk->bound without a lock, as netlink_autobind()
> will acquire all needed locks.
> 
> [...]

Here is the summary with links:
  - [net] netlink: annotate data races around nlk->bound
    https://git.kernel.org/netdev/net/c/7707a4d01a64

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


