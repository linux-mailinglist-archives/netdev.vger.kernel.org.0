Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9858334CB3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhCJXkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232133AbhCJXkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A71C464FC9;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419611;
        bh=NG8oemf2WILgK0QWfh6JIQiigjC+6YpiB7AxQmJh2pI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ky/iKLFGgej4jH27Sbpi9V4EeDROfz6P90id2YdLvTdZHTzxczAHp1fBFwsNsmLJl
         IvDLd8vdLuoWQwpgt3wmsDZNCKgeq5TQpo68sZQ86saTYwdwayKVydbnYf88AY7Qcn
         M/Pp7APJH1XAn3wxHnYfjrXF4Z/sP9WKWqjvuOvKlr+TSGLyNFT95BBEpVOn14GtrR
         vfcmkW1GSsaO4V2ycndpEjas2YQGOwlfwuOqD61CicXP/a0macGJMpapFwQ7xffe+l
         KQ6qpRz/0EVVtocjRYGwUUvP+NmHDWh32IPPg+6vulYEWPbY3RxU5zFcxjB1n65Sef
         qzP/lxUn8pvVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 940A4609BB;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] macvlan: macvlan_count_rx() needs to be aware of
 preemption
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541961160.10035.4487677868180335045.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:40:11 +0000
References: <20210310095636.202881-1-eric.dumazet@gmail.com>
In-Reply-To: <20210310095636.202881-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, herbert@gondor.apana.org.au,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 01:56:36 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> macvlan_count_rx() can be called from process context, it is thus
> necessary to disable preemption before calling u64_stats_update_begin()
> 
> syzbot was able to spot this on 32bit arch:
> 
> [...]

Here is the summary with links:
  - [net] macvlan: macvlan_count_rx() needs to be aware of preemption
    https://git.kernel.org/netdev/net/c/dd4fa1dae9f4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


