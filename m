Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DA3293CA
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbhCAVf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:35:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244063AbhCAVat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E2E0F60233;
        Mon,  1 Mar 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614634207;
        bh=omtG+7mo69ei2OYE6UwIMpnkQejszK7aniuze9Izd+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L/tIjXR3I+VaPaBybj7dOFS+cngb+14Lah0DTuAKQ1GyBTi/npyWfvq0AItiChOCr
         E9Ruryv+I2XfVXtU1ueiN4i9AwUNjHvhJfLcEc8iC/FogjMRPWihCRI7p1bGmak55v
         PFKYV6ioMZqQeB0h4CLzBTS4BoWFLga6tbxRms4zjJU4wpePPXWH+VIH2bGO+O+9dG
         hhhM45iWev0N/sdCFiprF3WUHaPbv8+LgkEjCimh9FdOf7F78UqCFFUDwmBXMZmYa+
         hH39BMRv2R41OpJe16sXHBwHRd5/6qHITHlcZzkvkD83g7zZs9W9z/opOT94rk61//
         3mEyem89BQGTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D2A0060C26;
        Mon,  1 Mar 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] Fix TRSCER masks in the Ether driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463420785.14233.15454498386680107579.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:30:07 +0000
References: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru>
In-Reply-To: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 28 Feb 2021 23:24:16 +0300 you wrote:
> Here are 3 patches against DaveM's 'net' repo. I'm fixing the TRSCER masks in
> the driver to match the manuals...
> 
> [1/3] sh_eth: fix TRSCER mask for SH771x
> [2/3] sh_eth: fix TRSCER mask for R7S72100
> [3/3] sh_eth: fix TRSCER mask for R7S9210

Here is the summary with links:
  - [net,1/3] sh_eth: fix TRSCER mask for SH771x
    https://git.kernel.org/netdev/net/c/8c91bc3d44df
  - [net,2/3] sh_eth: fix TRSCER mask for R7S72100
    https://git.kernel.org/netdev/net/c/75be7fb7f978
  - [net,3/3] sh_eth: fix TRSCER mask for R7S9210
    https://git.kernel.org/netdev/net/c/165bc5a4f30e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


