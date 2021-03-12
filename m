Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B081338214
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCLAKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230521AbhCLAKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 66EAD64F93;
        Fri, 12 Mar 2021 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615507809;
        bh=354DNcp9hGrTc7cWjnPEG5+BhkhaOHEUqyV9zqFuAXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GYt3vm3Jqdo6vNpE4exWanOKgteVGbj8/liUOATY/t2txhFs55orEccIg6GtgQc6Q
         xXswPf/cipRBjEy5y81aDyQP0RQoBB+CzrIhjzSoC1yIi9S4+73RElp7J9oBvZnPTZ
         auMvtk+RlcZqVUIXSVSEltiUuSVMkcwjz87eIE5Aq5bjYyLFybNKSLo6080XY77307
         aNfXPfav4lHxpK+dx+9LxanpgQAVO5ajYSVF59KJrjULhW01JNZo3hhDeS3md+ePzj
         q748DX/z1wui+Vh3pD3Ffk0s2KDfSQD0xWcK11Wi6fmd/G9dQzXbJ4Z3B0CWK0TALb
         LWkcYa10CsIdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 62A7E609E7;
        Fri, 12 Mar 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] netdevsim: fib: Remove redundant code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550780940.9767.11145967032422570746.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:10:09 +0000
References: <1615446661-67765-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1615446661-67765-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 15:11:01 +0800 you wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/netdevsim/fib.c:874:5-8: Unneeded variable: "err". Return
> "0" on line 889.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [v2] netdevsim: fib: Remove redundant code
    https://git.kernel.org/netdev/net-next/c/c53d21af674a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


