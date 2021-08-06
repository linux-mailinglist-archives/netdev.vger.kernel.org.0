Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133A93E2922
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245330AbhHFLKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245328AbhHFLKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 07:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 52DDC611CB;
        Fri,  6 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628248206;
        bh=DeksanZJAJuEFD+IWsvGh4MfBW0sx+VI60/yKXttqLs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KULod0S8Afp1+QRyPXhkekJZ1/Igf7aFRDI3982xYH03qXofYyI6RRBGd25eiI0gJ
         FVEf+MuSQ1RGatycHrkiQ1OMuxyRpI9D6dlu5JfPjvzlYA5jg2/IXU8T96Vfbxx8R+
         K/mtcrn41hrkFxw/ERhqA1Vq/XT/Oovy7i2uRWASgyPvu3DG7kHPAUWlgtgEgcsBW9
         kFk8qzekBQKZd0TNLavTkgF4eJ8u0U1Y6VpkQ3hiemvfPzWpLKN8dBYJfIygYJlRsn
         Vu05K29/jEG9IWXyyWC6X+E/scPoCnZTJrkQoGQabTSIKZ0xa4kooMbWcJozSgWUbY
         m7iu19R0fTpKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4CEB960A7C;
        Fri,  6 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: drop untagged frames on
 VLAN-aware ports without PVID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162824820631.31954.9293662469034354478.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 11:10:06 +0000
References: <20210806034713.734853-1-dqfext@gmail.com>
In-Reply-To: <20210806034713.734853-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  6 Aug 2021 11:47:11 +0800 you wrote:
> The driver currently still accepts untagged frames on VLAN-aware ports
> without PVID. Use PVC.ACC_FRM to drop untagged frames in that case.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> v1 -> v2: Avoid setting PVID to 0 on the CPU port.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: mt7530: drop untagged frames on VLAN-aware ports without PVID
    https://git.kernel.org/netdev/net-next/c/8fbebef80107

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


