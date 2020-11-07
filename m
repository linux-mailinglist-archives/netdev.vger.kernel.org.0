Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060022AA823
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 22:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgKGVaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 16:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGVaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 16:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604784604;
        bh=Vktu4yAXE7e/Kvcg9N+cTagizFsTswa9hf/0HBIatEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uUY7vtbV13TSkq7DcCcuWod8q/Ezdh4f1OzNQylP5d9DMgi3BlqqsT1MYkObbx+Qu
         6RAKWQKKLHBvwH0jbjUZlaBgOwFGM641bUc8HaiozV3/I4jlMLkijLAgYxe2tA34Jw
         ZEA77UZbjieshY3N5feusD7zsFnlz4tRRpFfsSQc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] net: macb: fix NULL dereference due to no pcs_config
 method
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160478460462.2415.3338273731051881056.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Nov 2020 21:30:04 +0000
References: <1604599113-2488-1-git-send-email-pthombar@cadence.com>
In-Reply-To: <1604599113-2488-1-git-send-email-pthombar@cadence.com>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Claudiu.Beznea@microchip.com, Santiago.Esteban@microchip.com,
        andrew@lunn.ch, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, harini.katakam@xilinx.com,
        michal.simek@xilinx.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 5 Nov 2020 18:58:33 +0100 you wrote:
> This patch fixes NULL pointer dereference due to NULL pcs_config
> in pcs_ops.
> 
> Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
> Link: https://lore.kernel.org/netdev/2db854c7-9ffb-328a-f346-f68982723d29@microchip.com/
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> 
> [...]

Here is the summary with links:
  - [RESEND] net: macb: fix NULL dereference due to no pcs_config method
    https://git.kernel.org/netdev/net-next/c/0012eeb370f8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


