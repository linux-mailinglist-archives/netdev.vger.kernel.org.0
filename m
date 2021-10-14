Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC942DD2D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhJNPEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhJNPD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 11:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1935860E78;
        Thu, 14 Oct 2021 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634223607;
        bh=cBcq/7Gl7Z9Farp0yd98KOXeGQ3tVK2MxmatTBtBraM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gYgGH1MbPiz28lGgmA7dJyg0qSoC5/6rqr+OQhs30fSYWA2n/fdaKfQ2/yoIAIRve
         s0qYs1XacCFNJs6PtcLUb//NqTzT+9cH3RjEqejubaTSS+5n+23dHbG7DaYMpxmrYz
         dkLl5wdetzwfc5vhvrZMp+AukXaMcjjypJcK1pKR3jcB6M42FiSCSEVQaDi//U6ORg
         SLLj/4JWeVOANV+MKZhRJPDEAC28BzJgjJJtgopQA2qIq+kBteqTUgikS96sBfAxi2
         SjwatujhLfLB5xsVSJKfpvQ6JULP8juE3fF30Qv/PDVbeA+5cXApBrxuF+UNcrSBaG
         Aqlfxgsicizqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 085EC60A6D;
        Thu, 14 Oct 2021 15:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: Update the devicetree documentation path of imx
 fec driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163422360702.15607.2692244335903528851.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 15:00:07 +0000
References: <20211014110214.3254-1-caihuoqing@baidu.com>
In-Reply-To: <20211014110214.3254-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Oct 2021 19:02:14 +0800 you wrote:
> Change the devicetree documentation path
> to "Documentation/devicetree/bindings/net/fsl,fec.yaml"
> since 'fsl-fec.txt' has been converted to 'fsl,fec.yaml' already.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
> *resend +Cc others.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: Update the devicetree documentation path of imx fec driver
    https://git.kernel.org/netdev/net/c/ea142b09a639

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


