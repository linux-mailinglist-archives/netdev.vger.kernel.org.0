Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AA735FCFC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhDNVKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229808AbhDNVKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D65B8611CC;
        Wed, 14 Apr 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618434609;
        bh=c106hnZHefLX82S6EolHaaHO+d7VJpL0N4Tu1k32mX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oWtgArVe6cy6HAih5agv5W5ymfdK7BElEfUCM5EgnUKw7/FaMWlv2JuGb9k32melJ
         af7tPMkNPJ7sqIfY6HGOpsxfXE7587WwOat18B7LK5BgHtqhfHPHkHE2UTYJEhbHHC
         3kxML/tiDcfa0U42Df9O31gqlMbm2MWXzMgU/oa3b/wZs9hRp6lZW2WRpEQPTDH/je
         1dkl2uOF5qFqnV3bg7I2e39wd4cALKpbgA3lBfSQBhHi2H+TccZuwr57aSMtGN9ijg
         ttO67nNc3byHgEOFUbE1k5PudbMj8yKX68AlCaCQs6YcafluHTKF5VvM4oHpXDvxiD
         7bHCKL3kFTLpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8D8260CD5;
        Wed, 14 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: fix the restore of cmp registers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843460981.4219.5111613632965767089.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:10:09 +0000
References: <20210414112029.86857-1-claudiu.beznea@microchip.com>
In-Reply-To: <20210414112029.86857-1-claudiu.beznea@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 14:20:29 +0300 you wrote:
> Commit a14d273ba159 ("net: macb: restore cmp registers on resume path")
> introduces the restore of CMP registers on resume path. In case the IP
> doesn't support type 2 screeners (zero on DCFG8 register) the
> struct macb::rx_fs_list::list is not initialized and thus the
> list_for_each_entry(item, &bp->rx_fs_list.list, list) loop introduced in
> commit a14d273ba159 ("net: macb: restore cmp registers on resume path")
> will access an uninitialized list leading to crash. Thus, initialize
> the struct macb::rx_fs_list::list without taking into account if the
> IP supports type 2 screeners or not.
> 
> [...]

Here is the summary with links:
  - net: macb: fix the restore of cmp registers
    https://git.kernel.org/netdev/net/c/a714e27ea8bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


