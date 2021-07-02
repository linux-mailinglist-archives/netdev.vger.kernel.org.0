Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75EE3BA43C
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhGBTMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhGBTMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 15:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8DEFA61411;
        Fri,  2 Jul 2021 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625253003;
        bh=OxAwj1A5b0Gc7DVpEhgcyxeQLet7Bvr4dJzWS2wSIro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nQIzdrXGl/48MstWENZ/uU5b07QqvIj4Q57TTp2cNfcD+Ru6aDJBPozACUR01fsOo
         aIY77OMRsBHIL2PMwEFzjdSWtq4XUiBq3zWPcSj546x6hOBsPr/1d0gxlJjsBEBDnG
         XYVYSaHhonXu2xIVA1hjjvjsEP/Ik6WggEfUPymtjYIdMDPqdPB3A5EKtszyb6QwLE
         WnxQxQw6AtJzJ4xpfO8ccglqNwhRvPP3dqAtVdognFpI3yd5rk3wWYd8E2pavMzK2S
         0ckd4lK1heLxX15BsR91qD1qiQNCtVKbPm6IjNopPU1X1FKRgfDMPmHM0tYAqIKQVT
         TkPe7cJjrdH8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E1BE60A38;
        Fri,  2 Jul 2021 19:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/sched: act_ct: fix err check for nf_conntrack_confirm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525300351.7668.9725174727570536641.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 19:10:03 +0000
References: <1625196871-2780-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1625196871-2780-1-git-send-email-wenxu@ucloud.cn>
To:     wenxu <wenxu@ucloud.cn>
Cc:     marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, jhs@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  2 Jul 2021 11:34:31 +0800 you wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The confirm operation should be checked. If there are any failed,
> the packet should be dropped like in ovs and netfilter.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> 
> [...]

Here is the summary with links:
  - net/sched: act_ct: fix err check for nf_conntrack_confirm
    https://git.kernel.org/netdev/net/c/8955b90c3cda

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


