Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC1D3F72DB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbhHYKVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235904AbhHYKUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A6CE6121E;
        Wed, 25 Aug 2021 10:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886809;
        bh=O6J+rHSYQXPSx/jFP12S7IvB9F9Rnmxsu4WHal3JfBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mfiF8rnrwSWnhZtl9cutMWs9KS7pJmd5V9UXYRN7mQojIGUEEj0CjoJiCAksH2gGc
         0sDQfSJWbdZVGaAccmXKEPWlqwXymTc75x25Dr4Zbwo2jHo5zu2jcKU3EodtTt5pzN
         EBkEO6WZoa0Oq3VXCkcN/aIepZDFzn8J8SZjOYmlkGI83HD1hQpk04xBbxomNsGd2L
         6r1jWY+NYUBDYDYSKBHb/ii6+h3gTq0INasryEjUcAGQhuEicTYTnaeiZsC7hTtX9i
         jxutHwxzd62N4hM7uryPV6HPGZ0IQo4zWVqcr4J3dlmXpEuvpcbdm2gxOAPeCEHHBg
         DbZMJ33tFlJpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1121960A12;
        Wed, 25 Aug 2021 10:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988680906.8958.16937803471017689459.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:20:09 +0000
References: <20210824165253.1691315-1-dqfext@gmail.com>
In-Reply-To: <20210824165253.1691315-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 00:52:52 +0800 you wrote:
> The driver was relying on dsa_slave_vlan_rx_add_vid to add VLAN ID 0. After
> the blamed commit, VLAN ID 0 won't be set up anymore, breaking software
> bridging fallback on VLAN-unaware bridges.
> 
> Manually set up VLAN ID 0 to fix this.
> 
> Fixes: 06cfb2df7eb0 ("net: dsa: don't advertise 'rx-vlan-filter' when not needed")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mt7530: manually set up VLAN ID 0
    https://git.kernel.org/netdev/net-next/c/1ca8a193cade

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


