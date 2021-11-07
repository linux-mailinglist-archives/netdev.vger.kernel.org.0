Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE5144754D
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhKGTmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:42:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhKGTmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:42:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E1E7561242;
        Sun,  7 Nov 2021 19:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636314007;
        bh=bglsuVdqj8f23guaavbdLfeWF7HdbbORB1qHLe7JmDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cNOhniUe5He2UEksNhEgAVaJTxzDIUeIMzIVYsTWddGL4MYBgLEnHZgbCNTynyK3j
         7L3NloxOVm2BW+efbtNZH+vFFmy+K+fh3Q/zYtweq/NxOo2i0AbzWbvH0Zxeo36BFA
         fel7eisDHrecpEFW19jDqj4ZJ3MPNfdM+4/oO9fNdf95Ot2v2eH7CiUY3ukpcXSgdn
         TYlptEygNSiueZtDrqC5zv/DpF8TWlAqTX+hkxqPSHqRt3qMy2POmmSTLT9zlMrJpL
         Y8y+HUcTgWfcdepkwNLL16mVCaOPuwg1kWLunWSjshYSwHLIR21no/O5VUxanLLJP5
         GoDpjy4F5VkgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D431560A6B;
        Sun,  7 Nov 2021 19:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: marvell: prestera: fix hw structure laid out
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631400786.18215.4158190574888211586.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:40:07 +0000
References: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, taras.chornyi@plvision.eu,
        mickeyr@marvell.com, serhiy.pshyk@plvision.eu, andrew@lunn.ch,
        arnd@arndb.de, geert@linux-m68k.org, dkirjanov@suse.de,
        linux@roeck-us.net, vmytnyk@marvell.com, tchornyi@marvell.com,
        davem@davemloft.net, kuba@kernel.org, vkochan@marvell.com,
        yevhen.orlov@plvision.eu, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 18:49:24 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> The prestera FW v4.0 support commit has been merged
> accidentally w/o review comments addressed and waiting
> for the final patch set to be uploaded. So, fix the remaining
> comments related to structure laid out and build issues.
> 
> [...]

Here is the summary with links:
  - [net,v4] net: marvell: prestera: fix hw structure laid out
    https://git.kernel.org/netdev/net/c/e1464db5c57e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


