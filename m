Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07D548FCBE
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 13:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiAPMaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 07:30:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33312 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiAPMaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 07:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F76F60EB3
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E118BC36AE3;
        Sun, 16 Jan 2022 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642336211;
        bh=VMEOZYgbY3cJMFGvg4hVYUrIecNODcKONNjJT7hkK40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SJThUAogk7BpQHCgmMGgQCHPzFr9TaMlqoqzAYbwv/rBKsVUWJlMifFyDbqfyUgNR
         oChi3VWb/spfZ5puilpS9sfZ1uOm50QsuCbX9UHuC3PkVDmEi3OOh/3+HEolf2Sqsv
         sQ1f9vbl1k1pEiVsHnWsyH2SKdcovFRyLU6l3V3CkkABfn5rJNTJuVEqWhxk4U5NyE
         X42EiKWPAXwb/wY5FIsy+NeQwmHzPLwaE+9KwSZRvucJGZ+siIeXfZVAuDqGJ7bbUa
         +GSyQtMjtnjFsQa/+cZrvFmkM6LvAnvFq+kTvXCl4jrh7ENwdfl7UPmO1upwGHikpM
         WqzUJ91gh45SQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8FECF60799;
        Sun, 16 Jan 2022 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ipv4: update fib_info_cnt under spinlock protection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164233621181.32546.2940878867903547273.git-patchwork-notify@kernel.org>
Date:   Sun, 16 Jan 2022 12:30:11 +0000
References: <20220116090220.2378360-1-eric.dumazet@gmail.com>
In-Reply-To: <20220116090220.2378360-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        David.Laight@ACULAB.COM, idosch@mellanox.com, jiri@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 16 Jan 2022 01:02:20 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In the past, free_fib_info() was supposed to be called
> under RTNL protection.
> 
> This eventually was no longer the case.
> 
> [...]

Here is the summary with links:
  - [v2,net] ipv4: update fib_info_cnt under spinlock protection
    https://git.kernel.org/netdev/net/c/0a6e6b3c7db6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


