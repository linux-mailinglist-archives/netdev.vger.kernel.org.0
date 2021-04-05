Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D87F3546DF
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhDETA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233944AbhDETAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 15:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E657F61382;
        Mon,  5 Apr 2021 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617649208;
        bh=QAYG2oDGH6IwESBp+z1+0d6mRJaFS4NTFWaTgUWc1l8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WiUH0apLyb7JKiEQU7DmYhjg+RGdXTtWJq18vZGlbhAIB1YJXn7CUZzkLbLzk5zx+
         SU0OTuAVLGzGyw5/XdcKL0tmEXNAvMqDmNeOlduhmV8gFQ/ufQM6ikTtx5zjoJUGTf
         0UMfHo5GEniiOcMX/sF4t9D5PDo1to/30V4cDGFds3QkY2eS6F4AYPWSXR7Y+WsJcm
         B4KORIxA4ZGzWdWEdEnuwQDyu/2+ZyDcOjG5zzOfLDPv3EXMnkYnCOqDTfU7nr1QFH
         Rv+GvfPuCKqVvdprr3mPw5uXO4gXiqwhLqAyu8pOUaCw2o51oP9NrZYno7tFotHMJC
         K3Ps7TN3vJ2Ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D630660A00;
        Mon,  5 Apr 2021 19:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: Use 'skb_add_rx_frag()' instead of hand coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161764920887.15280.10929018264231653068.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 19:00:08 +0000
References: <6fadc5ae05b05d9d8ab545e51ee3dcbdaa561393.1617529446.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <6fadc5ae05b05d9d8ab545e51ee3dcbdaa561393.1617529446.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  4 Apr 2021 11:45:11 +0200 you wrote:
> Some lines of code can be merged into an equivalent 'skb_add_rx_frag()'
> call which is less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> UNTESTED. Compile tested only
> 
> [...]

Here is the summary with links:
  - sfc: Use 'skb_add_rx_frag()' instead of hand coding it
    https://git.kernel.org/netdev/net-next/c/c438a801e0bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


