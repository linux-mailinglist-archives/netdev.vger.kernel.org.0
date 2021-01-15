Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CC22F7080
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbhAOCUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732010AbhAOCUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 21:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2FA8023AC2;
        Fri, 15 Jan 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610677208;
        bh=iJT+h6QCUT6ccvJkuxKphEHsUtZCszHo7Q8pLpQLvI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dUM2AOKL3XTuUlGUFSN7bVeNxA82UjlLgdNSaITzDcAtPbqreWtLJErOVeZ/w1O7a
         O9zm0liG9rzphFU/ln69pjTPONgayUv0p2kW/j1unGHhRoo8P81MN7GW93PjgfQ/9a
         ZeN1NwiuYdPed8EQFYgbthvBbfwz7Cb3Uje0j9H+EObpfMbIrX7fDYb7Cm0nw3H8JB
         psIEGNvEUEoh2WsXuaHgrSQD76wdXiBro5U1u2vdxfbQpeZbWehpYlP5nWyTLD+VE1
         hBz1t9KDTixP3fgifuc4mYSIoHkITYzBL4W+M4ly3q4KjVqh+5+bWSEz1bmiXW5r/L
         TxvS+YRHplZbg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 244CD60593;
        Fri, 15 Jan 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ch_ipsec: Remove initialization of rxq related data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161067720814.6976.3840458375332951878.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 02:20:08 +0000
References: <20210113044302.25522-1-ayush.sawal@chelsio.com>
In-Reply-To: <20210113044302.25522-1-ayush.sawal@chelsio.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        secdev@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 13 Jan 2021 10:13:02 +0530 you wrote:
> Removing initialization of nrxq and rxq_size in uld_info. As
> ipsec uses nic queues only, there is no need to create uld
> rx queues for ipsec.
> 
> Fixes: 1b77be463929e ("crypto/chcr: Moving chelsio's inline ipsec functionality to /drivers/net")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net] ch_ipsec: Remove initialization of rxq related data
    https://git.kernel.org/netdev/net-next/c/e3a7670737ec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


