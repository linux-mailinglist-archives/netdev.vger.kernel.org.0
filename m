Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F40140F476
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 11:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhIQJBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 05:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230245AbhIQJB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 05:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A70961152;
        Fri, 17 Sep 2021 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631869207;
        bh=LlNRo9ulpDw2goO0z3N84Oc0AcbkbY2skOFc1MyH03o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CXsBB25DFyPM4+/sEVaUJr+Fdz8x6KUYNBlKKhCnxAXQOZwIc8pqd+JSYLfDDb/df
         WNJz5zmOCdTz6J9bSy5d0ZBjBDi9mJEONHb6Og/q8duaLwLPV/yyTCdV+3nZiyd3Ms
         jZW2UXZvM2JLRhXEAYqISQHVy9HzU7epnwuBQkABHtm06Ew4NHJGHPb/f4IovKqI6W
         JraaD0hOOGh9zDTg26yYvSxUy2EjcmNS3pWUZZgxMfen2fExJ5cyyyXnWswYbFVIM9
         F/xZxGzhCKhnmK5uHddoN/pR3uqorzvnhn4gqE2VOeqVOx8uoi27uVVPlBvi39024O
         m2SPqFr6hUTbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B11D609AD;
        Fri, 17 Sep 2021 09:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: netsec: Make use of the helper function dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163186920710.22982.10637790677738130064.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 09:00:07 +0000
References: <20210916073729.9163-1-caihuoqing@baidu.com>
In-Reply-To: <20210916073729.9163-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 15:37:29 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and the error value
> gets printed.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: netsec: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/61524e43abad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


