Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9804948090B
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhL1MUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:20:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34022 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhL1MUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52B0B611DF
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 12:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97AE8C36AE8;
        Tue, 28 Dec 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640694009;
        bh=4W93QTUVzkPiov0JVyH1MsV4CksRV9sxxkkT8C1xshg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fStJGtkby86I+73nCNEVin5a9GZh9R7AAKtm1t8whEJy4pRGBjfNtNNDeMCYxCcoA
         +0Jb5IKw3qM3xRE4ezjZ23dmdTJrIVUjs7Dr69gsInAaTKs7CR6V+vM752vZ4zt4sU
         DBzSGSCVJL/TzuKvoMQKobHplb0W8lY2NS3s7CgpTU5vQZfblOpaOv4m8fh5Xy79vw
         JJCd9q5DhFZPVN0NI3MYa+AHqSinWONjLyU3kTQGH6bxHq+SkezjttPevUfaBGMgXH
         bIJk8k/PgTnkigpvBhQj84y7+TLiMsyNwVqNQL5FvGm6v2DS+Ltj1FG8he3kxBBXxS
         7gV284vAly/eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B2DAC395E7;
        Tue, 28 Dec 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mISDN: change function names to avoid conflicts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164069400950.26128.15408818210000605872.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Dec 2021 12:20:09 +0000
References: <20211228080120.2105702-1-wolfgang9277@126.com>
In-Reply-To: <20211228080120.2105702-1-wolfgang9277@126.com>
To:     None <wolfgang9277@126.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Dec 2021 16:01:20 +0800 you wrote:
> From: wolfgang huang <huangjinhui@kylinos.cn>
> 
> As we build for mips, we meet following error. l1_init error with
> multiple definition. Some architecture devices usually marked with
> l1, l2, lxx as the start-up phase. so we change the mISDN function
> names, align with Isdnl2_xxx.
> 
> [...]

Here is the summary with links:
  - mISDN: change function names to avoid conflicts
    https://git.kernel.org/netdev/net/c/8b5fdfc57cc2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


