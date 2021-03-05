Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB10D32F528
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCEVKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B4A5650A7;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=veQ4ILkrPHLFTfmoLEqDHAbtpI3dGAAq/kWkHq6kMyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iTAZrzugtx7iTB6GT6M2LOWMb8QrlYI8cxe4ZOUTokyX1/RaDx8nPkW+DL1H1mERc
         NfyOwY8NmFVtj6IPQAi8eiXAPt/0PvtHX1AFhxn+LmxgWDzj+Ez2AbWWOuwyM2hhpk
         AAB8E281yw94VSNmG/IeNCUNB+BbPBX0CKSslBjtiJsYva0MZ9QSZv7UbjiS1IFLnc
         iZZeqhyVkW90EhMzFaONZI3TM1luJaxlRGsS+aD6Guun+foZReTUiWWcNSJy8AkXcc
         P/5cz9oRk0YosH+YLKT+uN+hNm4wNpbfAaDe3kTPU4i+xiPdXaeJhI9m4CD1/B0k7h
         nXOm3r0ZDp8hQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 41FE360A4C;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8169: fix r8168fp_adjust_ocp_cmd function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860926.24588.13459099357965666033.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <1394712342-15778-348-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-348-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 5 Mar 2021 17:34:41 +0800 you wrote:
> The (0xBAF70000 & 0x00FFF000) << 6 should be (0xf70 << 18).
> 
> Fixes: 561535b0f239 ("r8169: fix OCP access on RTL8117")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] r8169: fix r8168fp_adjust_ocp_cmd function
    https://git.kernel.org/netdev/net/c/abbf9a0ef884

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


