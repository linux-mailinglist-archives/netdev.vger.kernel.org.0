Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7374742F3F5
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbhJONmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239841AbhJONmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D92916115C;
        Fri, 15 Oct 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634305207;
        bh=++VYZxb1k0MdY+p0VarcfX/XIUGntHcujXiOuY3ZaQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZZsG9m8Ty033EA9CYG+OKHGBR3ICygvaFP1DpiOMLkIYaPJG0eVqMmXJmSZrvz71f
         sEdyEoqttdyjDCB6bcPBo/lHTEM43igWTqq9TISMNvW4+R3GkQ1+w4od3lgaGMacIe
         qHtKoB5YHjQrrYVZiwyIPTw/AC1BNCmbGykbluywcAW31qxQC4VETbLufjfKJyp1Es
         QcKu94sHMfeUIPMVHkWMensJmMtUkQ/PkEN0zD9E9moyP4oqyKMFCfDu1moiEAOOR4
         cpsXDg8Y8BiYWvZHJpdZs34SKIpPGybHqnZGZLlHiU9Lp4tBx/3UQrCNFU2BBgsXUW
         Z+nEhDNYsfI/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C87E8609ED;
        Fri, 15 Oct 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lan78xx: select CRC32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163430520781.23472.11375176494240682949.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 13:40:07 +0000
References: <20211015130754.12283-1-vegard.nossum@oracle.com>
In-Reply-To: <20211015130754.12283-1-vegard.nossum@oracle.com>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 15:07:54 +0200 you wrote:
> Fix the following build/link error by adding a dependency on the CRC32
> routines:
> 
>   ld: drivers/net/usb/lan78xx.o: in function `lan78xx_set_multicast':
>   lan78xx.c:(.text+0x48cf): undefined reference to `crc32_le'
> 
> The actual use of crc32_le() comes indirectly through ether_crc().
> 
> [...]

Here is the summary with links:
  - lan78xx: select CRC32
    https://git.kernel.org/netdev/net/c/46393d61a328

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


