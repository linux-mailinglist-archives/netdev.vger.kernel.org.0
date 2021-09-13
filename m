Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D29408A80
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbhIMLvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239689AbhIMLvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 07:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 91A0C60F92;
        Mon, 13 Sep 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631533806;
        bh=fibbvRJo6Io+Hu212AsznuXEnHc55QtxIWCYWgYOUac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ChN8UB5LgXmrgtnTr9Q6wLnWgVX96rj2yffjrTxf8HzGe99jYaST1Et8b18UlHMGs
         pNwbodehEhMUYn1rCgnU2Ocq7QHAjyxJCiP8Edj/vDr9I9d9Sbax5OGzfZC7PecBTM
         nPPwRS5FsNbNualpeVlA7Dz7Qxd4EOLGPyFB9kDajRg3R5orTItwizo3nxvWYRBiso
         P3RjiWLuSLJTwL636ZvX/MrjyzwbTHSoJbYQG6v0nZ65CsOA6d5WhSX+0Ts3OA76wd
         GvFTYyBDcjNQQst2Q8N8MsnZIsLRZ20vPg9+hkmhK//qKbYVjUZ+opJPymMLYe2yhk
         azpNgwqw0NmaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 83F1860A6F;
        Mon, 13 Sep 2021 11:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] tipc: increase timeout in tipc_sk_enqueue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163153380653.31987.12749028064009482079.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Sep 2021 11:50:06 +0000
References: <20210913092852.10271-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210913092852.10271-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, eric.dumazet@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 13 Sep 2021 16:28:52 +0700 you wrote:
> In tipc_sk_enqueue() we use hardcoded 2 jiffies to extract
> socket buffer from generic queue to particular socket.
> The 2 jiffies is too short in case there are other high priority
> tasks get CPU cycles for multiple jiffies update. As result, no
> buffer could be enqueued to particular socket.
> 
> To solve this, we switch to use constant timeout 20msecs.
> Then, the function will be expired between 2 jiffies (CONFIG_100HZ)
> and 20 jiffies (CONFIG_1000HZ).
> 
> [...]

Here is the summary with links:
  - [net] tipc: increase timeout in tipc_sk_enqueue()
    https://git.kernel.org/netdev/net/c/f4bb62e64c88

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


