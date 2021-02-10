Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D339D31714C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhBJUZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhBJUX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 15:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 86D7F64EDA;
        Wed, 10 Feb 2021 20:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612988458;
        bh=hyh4oYnHRl0T2UHxse6hCm4A+6K6tdLmZoVhWLW90aY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dPGOHBbtXiBUL/oA83VyFDaxW758DeDHSzwLe5BiK0szUNICR93C7xVCF7jppGGGI
         8XszMTKFkov3H10sswdQxPUbHBq/gNcpFPcFAbS8AfKDanP1vt7SBK+ubi641MpBDK
         nqHw2tcWNPdKafpoaBS2Z808LhvTj+S+RhuqiCCR2s0c4F57FxAzHpP2eZbfa7VggR
         crBvfEhxvmfyLYD8IFM5hIJlRZFFqAwqK3lkyTx7kyiuiH0sAf6F5oA6gyXprqzn2U
         2jziAHP9TYziIkZ8h41YdGL9g0WrOjy82nBrfiDsMZbenmygjo6Pysp0IoIhDf4egv
         Ndtmlx2J5La7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7EDCB609E2;
        Wed, 10 Feb 2021 20:20:58 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Simplify the calculation of variables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161298845851.26937.13987525502107193203.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Feb 2021 20:20:58 +0000
References: <1612860398-102839-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612860398-102839-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        shuah@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  9 Feb 2021 16:46:38 +0800 you wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/testing/selftests/bpf/xdpxceiver.c:954:28-30: WARNING !A || A &&
> B is equivalent to !A || B.
> 
> ./tools/testing/selftests/bpf/xdpxceiver.c:932:28-30: WARNING !A || A &&
> B is equivalent to !A || B.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Simplify the calculation of variables
    https://git.kernel.org/bpf/bpf-next/c/bd2d4e6c6e9f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


