Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15172F2534
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbhALBAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbhALBAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 20:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 35C8822D70;
        Tue, 12 Jan 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610413209;
        bh=bYtbgE+aVOHp7OLJ1ah06SMQVfQ829eGmmMaFY3FJiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LOl+iqEx2X4bhsbJbNYMsSvJb+gsIADhxpNAYoO+kMzG6oNXtfJUzGmBuwWxzkvCj
         I8OvJ7uH4XObmeQ1UOFpv60EytWxzrX1ZnPGI5U29LGd/JLW/a4hDQrotx6Ja1LVhM
         eAA0Rx6NQPJpfd6iyVbFsU3P2bjEn5MMOEECodKeKUbGpK4SxNfCdTqNk3WJvVGPSH
         0ePvvLRM9wNM6U088EM7O1iydAGg8OpXPNyhfcCbSka9HNMx/Y/x5xlB5u5dZQHRVF
         k5BR7TcYJDAhMdMaAS3IOVqlcMQ2NQAU5EHMNYWSE+ldfkzu91bIdv7JBB2DfHgxsC
         vbcGFGyffEHXw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2986360354;
        Tue, 12 Jan 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] r8169: improve jumbo configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041320916.15587.539634124247141136.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 01:00:09 +0000
References: <1dd337a0-ff5a-3fa0-91f5-45e86c0fce58@gmail.com>
In-Reply-To: <1dd337a0-ff5a-3fa0-91f5-45e86c0fce58@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 9 Jan 2021 22:59:08 +0100 you wrote:
> Small improvements to jumbo configuration.
> 
> Heiner Kallweit (2):
>   r8169: align RTL8168e jumbo pcie read request size with vendor driver
>   r8169: tweak max read request size for newer chips also in jumbo mtu
>     mode
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] r8169: align RTL8168e jumbo pcie read request size with vendor driver
    https://git.kernel.org/netdev/net-next/c/2007317e15cd
  - [net-next,2/2] r8169: tweak max read request size for newer chips also in jumbo mtu mode
    https://git.kernel.org/netdev/net-next/c/5e00e16cb989

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


