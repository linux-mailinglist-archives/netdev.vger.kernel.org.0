Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F38E404826
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhIIKBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232630AbhIIKBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:01:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DED2C611AF;
        Thu,  9 Sep 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631181606;
        bh=PMMPAgeIXLtsXfGbcW45EUU5EOoG+3kFRVw7qb4VMto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WKCEdd1fGBUrh6ibxJYDt2zQS1ZDkB+V064A2QD+s0fw6JU7E/FD/6HOCDTHVGWxw
         8cq/Sr1s6VvJ2nvnO4TuWm0+GR5bb82op7Ty/dSLFiUtmpvMNHksPXsEjZExvfiVjq
         vgtoFnwPiRSdEJBVpkCFELlwyYZH8yvhQlLJU7DLGDIe2mc/9Ty05IKcd3ZqI0s8Fp
         ZhVCSKOeVBv12gA+g+MN8rPds6AU+jDHkXw1vYUVOwEmA4ok3UzE7srv/EVCZq1gcX
         lG2VuLUsbcCyUC3cs5RauYEI9caTJ+VUxuElycBrXbo5G0U5BdHv5JiDqSF61z8e0L
         C1vl7ZLgq8W0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D2690609B3;
        Thu,  9 Sep 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: macb: fix use after free on rmmod
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118160685.750.14632147439062575524.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:00:06 +0000
References: <20210908190232.573178-1-ztong0001@gmail.com>
In-Reply-To: <20210908190232.573178-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas.Ferre@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  8 Sep 2021 12:02:32 -0700 you wrote:
> plat_dev->dev->platform_data is released by platform_device_unregister(),
> use of pclk and hclk is a use-after-free. Since device unregister won't
> need a clk device we adjust the function call sequence to fix this issue.
> 
> [   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_pci]
> [   31.275563] Freed by task 306:
> [   30.276782]  platform_device_release+0x25/0x80
> 
> [...]

Here is the summary with links:
  - [v2] net: macb: fix use after free on rmmod
    https://git.kernel.org/netdev/net/c/d82d5303c4c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


