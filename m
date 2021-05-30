Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ECB39530E
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 23:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhE3Vbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 17:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhE3Vbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 17:31:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E794161001;
        Sun, 30 May 2021 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622410203;
        bh=mG/a8YcEyGR5ugo72A3JJe/+yK+RG2AfZlPnchqxRso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hUCZ2r8pAJeXYjbyPYJAGsrYPNvapwNH6hbLP2O7sO75/ei4N85EA9cmPtaghpkbR
         HRQOCnmXobX1V5NPLLQUJr//m9SD0OnEk6ukrieTwpVAL+m9kxdZzwMnh4JLhzV+nT
         JTKOTjjyYXCHk16b0nEuPys8MP1j9xkUXMzuF0SqYSdGoxkPSebBfDtT/2yzuyUhBT
         lz0rJ0qEz6lXlItTOHnOmWrU8eCIcpp5bw1JTFrVw2MMUmK12Sc0j83rBzhWugUmMn
         4JgFDzkyEz28Eo0v7dZjqeyGj1JkGrDpyDeA5zNebQMguRGTYRLuzBHUTb4S/Set+E
         1JJXCFAZhCglw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DBE6260C28;
        Sun, 30 May 2021 21:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next 0/2] net: dsa: qca8k: check return value of read
  functions correctly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162241020389.28062.11780687438412526586.git-patchwork-notify@kernel.org>
Date:   Sun, 30 May 2021 21:30:03 +0000
References: <20210529030439.1723306-1-yangyingliang@huawei.com>
In-Reply-To: <20210529030439.1723306-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 29 May 2021 11:04:37 +0800 you wrote:
> patch #1 - Change return type and add output parameter to make check
> return value of read  functions correctly.
> 
> patch #2 - Add missing check return value in qca8k_phylink_mac_config().
> 
> v2:
>   move 'int ret' to patch #2.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: dsa: qca8k: check return value of read functions correctly
    https://git.kernel.org/netdev/net-next/c/7c9896e37807
  - [net-next,v2,2/2] net: dsa: qca8k: add missing check return value in qca8k_phylink_mac_config()
    https://git.kernel.org/netdev/net-next/c/9fe99de01440

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


