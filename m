Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECE931C434
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBOXKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhBOXKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A17E964DF0;
        Mon, 15 Feb 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613430607;
        bh=Cb4cKOI0sapXrrl14zPFqj5ElqW4HGuxtbxed4hTgpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LwKAukORbwsDhlRDbFbwLuae9bpidylacR+WrCTVyBrqj5apizuoeb2dThJjLcCap
         eXjgDl5rr1wdukW2zEhHoAgJh9yt5/QKL4Heibi0zNYiYy/gGgXzJRBN4WCnpDWpsV
         wh3A/tO1gclISwLoVF9nt/XDh34bNvHzcttoAaJ0Y82k58atmKqTSFhKSsAj9BLFAm
         6MIA+Z7YRGNZS5vpb+MTbzkXPo61jQKI/XA6q/O84NhHTw2wgKyBKQgHqrZgYHPkXo
         01pp7oew6up8eJ7bkynkDCdaOLz6QBanXllK1QI/Nx72F1lz4Pe+GYI+MeDG2jzuLu
         Qs+a5iVzRMGWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8ED41609D9;
        Mon, 15 Feb 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343060758.5525.7785837246002682841.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:10:07 +0000
References: <20210215152438.4318-1-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20210215152438.4318-1-nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, leon@kernel.org, arnd@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 00:24:34 +0900 you wrote:
> Hi,
> 
> This series is the ethernet driver for Toshiba's ARM SoC, Visconti[0].
> This provides DT binding documentation, device driver, MAINTAINER files,
> and updates to DT files.
> 
> Best regards,
>   Nobuhiro
> 
> [...]

Here is the summary with links:
  - [v4,1/4] dt-bindings: net: Add DT bindings for Toshiba Visconti TMPV7700 SoC
    https://git.kernel.org/netdev/net-next/c/e6a395061c3e
  - [v4,2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
    https://git.kernel.org/netdev/net-next/c/b38dd98ff8d0
  - [v4,3/4] MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
    https://git.kernel.org/netdev/net-next/c/df53e4f48e8d
  - [v4,4/4] arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet controller
    https://git.kernel.org/netdev/net-next/c/ec8a42e73432

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


