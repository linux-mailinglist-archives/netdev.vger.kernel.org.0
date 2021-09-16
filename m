Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3077840DA27
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbhIPMlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239852AbhIPMl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 842146124D;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=bMy5jcnyDhYXJ7IbY/Xy+tdP8cT5QmMISv/iCsm7Mvs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R0IWbGBCtYLeEhEPnDXtYqWcWfvsP8Uvme/SzOQ2cytoxbnjMpM4eVJDRygegHll7
         3ER1MIx2WzBki7fUxh6almYLkzQKT+ban0mmEeychxhgGhtL3rGSE4FKaezvIT/l82
         Fa5AAJkNXNcVGu3uFPof6pq5u2jgSRibK6kPQ26LSK2EVSr3uVeNf3uySp7ZYkh9c/
         8EyUmzdB8qfldRdAGYEs5OPIWSsE/uIRnmxpODj9uwtMF+oFEeqprzBNxH7rqRWcSL
         TgiW4hN1057bQfB++W8ZompWSzOfMlNGWHYHkx9di3ZOVN5r75Tnxpqq96ShQobJxn
         YbJ/krLrklSiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 747DA60BCF;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: thunderx: Make use of the helper function
 dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600847.19379.13162897389182688013.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145843.7622-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145843.7622-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:58:42 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: thunderx: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/52583c8d8b12

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


