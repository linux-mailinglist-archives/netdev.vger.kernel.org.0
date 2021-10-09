Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B910D427A4C
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhJIMwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232978AbhJIMwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D22D36103B;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633783807;
        bh=vxExelt3SPlL3Bg5Ln497i8Mbip8xZgyks5GBzLo2Tc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ltqxrpf1O+6JKpltP2NH0z2w3/gQf9sOUJpYiIjfX3OfHSLMGSEhsh4Or+rzrm6C/
         CA9XfRobVor4Y8qOsR61Cv07Lb/6FIxgImeUBqRIizHnqHaT4ssODHLukGLgznUgXX
         xTViTUspAJ+SKUEqgi+KS0dFEy+eB43OXqO79DH2jNDx/3WZT+TR66PBnQ2vNujW5f
         Cy/X3EcCRHYg+hB/krDy2ZAEp+t+B9wfucEjLsgd29BVMinSHOSeErhKRuZlSVYJBo
         L5cG8POMlf2P5RBw7FdPewDw850Aise+U/Bb77LfOaCF0T/4hzQhHJmKrJuEF0ibwO
         dur55cwr2l9Jg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C77B060A88;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Fix missing error code in qed_slowpath_start()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163378380781.3217.1943547973029351858.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 12:50:07 +0000
References: <1633766966-115907-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1633766966-115907-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  9 Oct 2021 16:09:26 +0800 you wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'rc'.
> 
> Eliminate the follow smatch warning:
> 
> [...]

Here is the summary with links:
  - qed: Fix missing error code in qed_slowpath_start()
    https://git.kernel.org/netdev/net/c/a5a14ea7b4e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


