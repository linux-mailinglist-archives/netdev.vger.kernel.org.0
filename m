Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DF5390C3E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhEYWbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231657AbhEYWbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 18:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1EACE613FA;
        Tue, 25 May 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621981811;
        bh=Hoat5UgNb2kQktQ6xl7cU6eQ2/61umKYl6Ml6lQvh4c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y2AlBieAHqNtsRA4VGiQ1lvogO65iwgr9950OFqoI0hebh/GbS9q94yZWuB7k20HS
         NI4gzlywVyO295CM87NfhTRJoVAziy+emsSgJMY4TYd92OfWouFDBzNg52HV7rlvZo
         wHhFbruqotXlXZdr+nOp5dJ44fY+ryiRFuPQW1QkAYR+Xu5RnhbGrNQ1JcJwKTYBh7
         TI6ImlxXCnmFmsJ0SiRR6A18rF5n5Y9WaHfBAim/xtzxqkP92COLqmT3hD+V0Bp7yE
         Ut0jGc1qA1UUz9y0QB51jd1J6dY399Vp3KDBvUzZX+JJhcZvhMh4R1aDAioRvsa6fs
         ++X60OHYji40g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 190A460A39;
        Tue, 25 May 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/hamradio/6pack: Fix inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198181109.18500.6883153906905606285.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:30:11 +0000
References: <1621940145-70195-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1621940145-70195-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 25 May 2021 18:55:45 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> drivers/net/hamradio/6pack.c:728 sixpack_ioctl() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net/hamradio/6pack: Fix inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/687c87adc11a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


