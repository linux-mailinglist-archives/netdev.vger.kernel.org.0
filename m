Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FBB2EEA28
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbhAHAKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbhAHAKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 489F02368A;
        Fri,  8 Jan 2021 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610064609;
        bh=/bl+dbUQLW5CaBdvmpIzjWmsxh0p83ugF1Vo+dLtI4U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWzA7PeycjLb4035QydEmCtOyAkyifDY/SsgqIUFsomS6J7UBqdsVuhT7C3Ddj5tR
         yY4gKO/61/At/fOU2qBQh5pD8nFZm4ERxwL54dFGACjsk2oRISOpXicVvVAPImBEvc
         H71k+VFK4S4nG8LnFBvf9yt1gV+byg5WD/iiCZfRjsRAY8aI5Ge4AAL007OIqsO05A
         ApUt982gsAZYSALR6kYs/ov7Etpc3uzON+g8PGbt+ZrDnTBKSYOfNIsqzoOJ9HGphp
         0VH8jrPkOttw9p+a7+eLmRW8Xl0uEOpG7rsWMikL6yZeiLz2hZAidvMKwfoCIMm4BL
         6vF0kUunGfpOg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3807E605AC;
        Fri,  8 Jan 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/5] dwmac-meson8b: picosecond precision RX delay support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161006460922.17100.14707302007622685350.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jan 2021 00:10:09 +0000
References: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        jianxin.pan@amlogic.com, narmstrong@baylibre.com,
        khilman@baylibre.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jbrunet@baylibre.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Jan 2021 14:42:46 +0100 you wrote:
> Hello,
> 
> with the help of Jianxin Pan (many thanks!) the meaning of the "new"
> PRG_ETH1[19:16] register bits on Amlogic Meson G12A, G12B and SM1 SoCs
> are finally known. These SoCs allow fine-tuning the RGMII RX delay in
> 200ps steps (contrary to what I have thought in the past [0] these are
> not some "calibration" values).
> 
> [...]

Here is the summary with links:
  - [v4,1/5] dt-bindings: net: dwmac-meson: use picoseconds for the RGMII RX delay
    https://git.kernel.org/netdev/net-next/c/6b5903f58df4
  - [v4,2/5] net: stmmac: dwmac-meson8b: fix enabling the timing-adjustment clock
    https://git.kernel.org/netdev/net-next/c/025822884a4f
  - [v4,3/5] net: stmmac: dwmac-meson8b: use picoseconds for the RGMII RX delay
    https://git.kernel.org/netdev/net-next/c/140ddf0633df
  - [v4,4/5] net: stmmac: dwmac-meson8b: move RGMII delays into a separate function
    https://git.kernel.org/netdev/net-next/c/7985244d10ea
  - [v4,5/5] net: stmmac: dwmac-meson8b: add support for the RGMII RX delay on G12A
    https://git.kernel.org/netdev/net-next/c/de94fc104d58

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


