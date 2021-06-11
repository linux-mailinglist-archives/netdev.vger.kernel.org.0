Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDAD3A4882
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhFKSWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 14:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFKSWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 14:22:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 876A3613D3;
        Fri, 11 Jun 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623435604;
        bh=LWsrmEpBFiwVqRkvBHRZ2LGIyxOgMQr5ukqJl8CSGMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pSGsbmr4skiQus7tiD8zg/7+1pv5TcHWQ5akVSC9JdyWWxLUe0WLTEcQrrqPEH6t8
         PzMlRpP4xcr4tgkbYZizbp/c7v6AE6uVvO/2AdGLcV7/flU5NtdMH/HBu2TXgPwe+g
         4C8NCJgZ7+/KlknQr5Owk8xk7aMFwYxw2rpGH8YHq4ehBI4cTC5/4LBY9tGNBRzC5B
         VicrLFX+nuJHl8p/J9pFqkagKWlzjGMqB1ZLbjKJ/JBe7/OQ/OAeJl3krwcs8oT8ld
         pYOTUCPg7JpaW2E1jSUpRmNHBi13HaZO/ZMGjlvnc7fSGkLokssasThrb1JyM44G9i
         t7BZq9u95omxA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B97460BE1;
        Fri, 11 Jun 2021 18:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] cxgb4: bug fixes for ethtool flash ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162343560450.20873.17351540913260493190.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 18:20:04 +0000
References: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 11 Jun 2021 12:17:44 +0530 you wrote:
> This series of patches add bug fixes in ethtool flash operations.
> 
> Patch 1 fixes an endianness issue when writing boot image to flash
> after the device ID has been updated.
> 
> Patch 2 fixes sleep in atomic when writing PHY firmware to flash.
> 
> [...]

Here is the summary with links:
  - [net,1/3] cxgb4: fix endianness when flashing boot image
    https://git.kernel.org/netdev/net/c/42a2039753a7
  - [net,2/3] cxgb4: fix sleep in atomic when flashing PHY firmware
    https://git.kernel.org/netdev/net/c/f046bd0ae15d
  - [net,3/3] cxgb4: halt chip before flashing PHY firmware image
    https://git.kernel.org/netdev/net/c/6d297540f75d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


