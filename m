Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCAF455B6E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344577AbhKRMYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:24:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344618AbhKRMXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 07:23:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A0765617E5;
        Thu, 18 Nov 2021 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637238008;
        bh=fKpgQlrnjpxTt90Xz/+QJ9JVWb8CRnDJHbufRV1ru04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FC7EqPE2DPO+XGiJ+iXgtXk8wQdj3RRtxOol+6+FAvrC+4XtvTANScrc3PO5MKtyN
         ChMOiRWH84V34qZjKQXp3D96Pwqh1mdJMRZ8FgEOvLcdZmXdIa1fCGUJ2BTri/C0iu
         FjaO/6+xLHXXtn6JV0GT3jFPlOqo5drCgzVPLNQhFVn5s2TDVMx09ZSwUXBakIXtt0
         UmIzV4CfOr5fwlrqupCLA3vYXJfIHYUdmpkLn5fQzLcj+HMzC3GUdYTl7jd9rVJx6+
         gmhQoB6NxuHBfU3UMnyz3seISdy0d2IVE+5Oz8pi0xuPQPcDGYJqDBn5/3D3YaFywk
         niUGgSYikNAhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 926A460A94;
        Thu, 18 Nov 2021 12:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: ocp: Fix a couple NULL vs IS_ERR() checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723800859.31618.8492377860971749879.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 12:20:08 +0000
References: <20211118112211.GF1147@kili>
In-Reply-To: <20211118112211.GF1147@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     richardcochran@gmail.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 14:22:11 +0300 you wrote:
> The ptp_ocp_get_mem() function does not return NULL, it returns error
> pointers.
> 
> Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/ptp/ptp_ocp.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net] ptp: ocp: Fix a couple NULL vs IS_ERR() checks
    https://git.kernel.org/netdev/net/c/c7521d3aa2fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


