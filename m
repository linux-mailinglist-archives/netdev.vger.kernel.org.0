Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA6336AA5F
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 03:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhDZBbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 21:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhDZBa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 21:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2104C6135F;
        Mon, 26 Apr 2021 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619400616;
        bh=kMA1CM3cbnfdnimBc+GZhNWNAA6x7qfdv/cRcUAsDgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l9ajjJq9sqxBXQVJjzTliIC5A6qdIW5FbQhjkiRzIleheH+17zgiH9fjK4Pr5D1YS
         X0FtXURBrfDJ/5AkZsN38O+u0RBxjDAYZvci/ihnvldAP7xbHUFraTWcEk0Wl5GOvH
         aGk4DelAE37aQyeHqXbSgKK/wmmfyNCvXMZ/PGxVVFdZj9QCdcbO6IHVAdk2OwD6LZ
         vaMS3rEIjXhMvNIv9/nq29qpLeuQlMoMvWMjtJFj12ZEbwMiA6EUV/D01OPip/lsWT
         cyz+0UJiWPfYHMYKmtsmCEitdqYruasG5DmLBn7Plm721mmTe4yQ4QOQN7GscdfvVe
         bX3Px8tExv1Zw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18F686094F;
        Mon, 26 Apr 2021 01:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8152: remove some bit operations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940061609.7794.12561749260438717374.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 01:30:16 +0000
References: <1394712342-15778-362-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-362-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 24 Apr 2021 14:09:03 +0800 you wrote:
> Remove DELL_TB_RX_AGG_BUG and LENOVO_MACPASSTHRU flags of rtl8152_flags.
> They are only set when initializing and wouldn't be change. It is enough
> to record them with variables.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next] r8152: remove some bit operations
    https://git.kernel.org/netdev/net-next/c/9c68011bd7e4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


