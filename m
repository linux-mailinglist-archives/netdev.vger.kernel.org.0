Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699C4397D8D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhFBAMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235293AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C22C613F0;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=gAYHZWW4kwwHt2qK0ddcmhZfQ1JRKF6JQjlzU7JhLSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i+k1Ek1Uyg1nuCsvZUwMYO2UOX7tmbSvqA4J6QSyfFvGljMJS/oCQYxQ/VW9P7CEC
         328IcSU4ePrD05mLZ+Z9TtALpSIYFN1CO+1tdhVsAEM2FOfADADt9zroBgiMLUKDSq
         dZVprSPHXFUyrnSfBp3Aa++3dGbOAHT7tZpitbRzBSYRjegWZMmHoAnwLbcPlnlykY
         K8Kct0sA3QtL+Z7/uWoD6dMQRJ9vOZjV/DQRKXH58opGkI6ESmMj/kSkCEChHc+Gwq
         Qg/2i2iFfG3JxedVl4e2ZY9x4uwqc2WnMgEVJy2FEzpjYw5ZmzHSrcquLPISeFkc0e
         S0tBf6VraqQjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6ACC560BFB;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260843.22595.7591249584461639788.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601141859.4131776-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601141859.4131776-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, narmstrong@baylibre.com,
        khilman@baylibre.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-amlogic@lists.infradead.org,
        opendmb@gmail.com, f.fainelli@gmail.com, linux@armlinux.org.uk,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:18:59 +0800 you wrote:
> informations  ==> information
> typicaly  ==> typically
> derrive  ==> derive
> eventhough  ==> even though
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/e65c27938d8e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


