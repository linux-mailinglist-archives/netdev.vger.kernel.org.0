Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD7736E0C9
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 23:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhD1VLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 17:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232064AbhD1VK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 17:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DB72613CE;
        Wed, 28 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619644210;
        bh=vEC5okH+Mq4hQI/b1zyZKruGp1G5tHXLo7WdYFdAUNA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NTLaWAvt5A8TP0T0xw2OXyB9bfK/88ZOsocYKbqvOtHDcG5WBpwV/Lo2AgBk2TXiT
         6HFMItzCKC+TE4+YpLzjiBWQpEi9x26cev96Ln1aN4+f7jFnH+QKqk9TmBtlkyGPhO
         Exd7uLbZsMY3jWj1gFFFVSQCjmUpGxhmciK1sVOq0bN5ezmP91DyyZ3Svu8pI9LFiD
         JfIhOgabNsTyjrPZFCoW6hWmAJXZqPmK0vkDFMdhbKsUfQbG4klrTFUcd3MMftOLxE
         P1rJqHHCNSV1FEkbkFNUs0I4nr9dzEmlMbeL7mAK38NbMpV6M6cftOgGlb8OaotrHq
         jeiD9CNxrRS8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1128960A3A;
        Wed, 28 Apr 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: dsa: ksz: Make reg_mib_cnt a u8 as it never
 exceeds 255
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161964421006.17892.589586233736680474.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Apr 2021 21:10:10 +0000
References: <20210428120010.337959-1-colin.king@canonical.com>
In-Reply-To: <20210428120010.337959-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        marex@denx.de, Tristram.Ha@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Apr 2021 13:00:10 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the for-loop in ksz8_port_init_cnt is causing a static
> analysis infinite loop warning with the comparison of
> mib->cnt_ptr < dev->reg_mib_cnt. This occurs because mib->cnt_ptr
> is a u8 and dev->reg_mib_cnt is an int and the analyzer determines
> that mib->cnt_ptr potentially can wrap around to zero if the value
> in dev->reg_mib_cnt is > 255. However, this value is never this
> large, it is always less than 256 so make reg_mib_cnt a u8.
> 
> [...]

Here is the summary with links:
  - [next] net: dsa: ksz: Make reg_mib_cnt a u8 as it never exceeds 255
    https://git.kernel.org/netdev/net-next/c/12c2bb96c3f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


