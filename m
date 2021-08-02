Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE4C3DD2CF
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhHBJUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232670AbhHBJUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2EECD604AC;
        Mon,  2 Aug 2021 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627896005;
        bh=FR/MkZVejT+QzTPAUZXRZTYvAvh5uHDfDIhIjwR3vIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rb2CyMdHDxm+KznQLsjRAyBfL9pXIg6XnFrfiX5VUFtxLmRWlvJ7WdvOX2GK1bb3S
         AAWqiMUedmVgbLpl60qUNEQnbcDQZv5Jid58jz76EGgp7UV7lmMyB9cr08eubOc7H1
         pmky9I08Jd/qSCbnBW9dUT0V+NTULTbP95cunaFnkng4ijfyK5TggRonCekzZLBwUg
         fnK0MCb374Q9KuTrxt6tsybJzjSERqj3Mo/inqSUvredu1Fx5bBnw56GtqXjpG6Ip3
         d9w1JqekrkQY4m2UhrSlWBpXGN6RAOtbTL+jA1lW6hm8oQbEueYVbzzvOxRIwL8GpA
         LbsoT7r4WvrNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2255A60A38;
        Mon,  2 Aug 2021 09:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qede: fix crash in rmmod qede while automatic debug
 collection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162789600513.1008.14206018630278132914.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 09:20:05 +0000
References: <20210729114306.21624-1-pkushwaha@marvell.com>
In-Reply-To: <20210729114306.21624-1-pkushwaha@marvell.com>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        smalin@marvell.com, aelior@marvell.com, prabhakar.pkin@gmail.com,
        malin1024@gmail.com, palok@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Jul 2021 14:43:06 +0300 you wrote:
> A crash has been observed if rmmod is done while automatic debug
> collection in progress. It is due to a race  condition between
> both of them.
> 
> To fix stop the sp_task during unload to avoid running qede_sp_task
> even if they are schedule during removal process.
> 
> [...]

Here is the summary with links:
  - qede: fix crash in rmmod qede while automatic debug collection
    https://git.kernel.org/netdev/net/c/1159e25c1374

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


