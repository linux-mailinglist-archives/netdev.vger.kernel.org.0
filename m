Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41709331800
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhCHUAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231594AbhCHUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:00:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2838265208;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615233609;
        bh=gYilhKMT4uMiqPSmKpTt9npQLao11WlenqaMT8OiUgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L+U2ETbUOaxZ8GnvSr/c5aHPX5XZWPcNDjGzaTaNHU+nh0yFq7yoi+O2hSh96Og9I
         GoWsdsnpIFHQWOqYeW7w0XQ0TFK+VcU/pcHAof+A2so6pYDv0IOjCnDenMr9/PjED0
         TMwXp5IOXFAroqkD9WzjzXtkmEjn1wgooOdXFgqeP5pmkY0La0RSxHBtKhOHVENctA
         tOgOHbLzkQ0CVac12yTmYE/mlDd26utzvbYTCVHRn/yd1dNfl7j7wf7I5YtxblndsH
         psK4fsHSdK3rwXlPvbY0WnywGrHtA0PMVD1SWMiMGDGZm61H9SSOiuaPk7gs6nYl6I
         oMhxInr0nqVFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 155D0609E6;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: usb: cdc_ncm: emit dev_err on error paths
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523360908.22994.16878269283650305469.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:00:09 +0000
References: <20210306221232.3382941-1-grundler@chromium.org>
In-Reply-To: <20210306221232.3382941-1-grundler@chromium.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     oneukum@suse.com, kuba@kernel.org, roland@kernel.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  6 Mar 2021 14:12:31 -0800 you wrote:
> Several error paths in bind/probe code will only emit
> output using dev_dbg. But if we are going to fail the
> bind/probe, emit related output with "err" priority.
> 
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
>  drivers/net/usb/cdc_ncm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] net: usb: cdc_ncm: emit dev_err on error paths
    https://git.kernel.org/netdev/net/c/492bbe7f8a43

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


