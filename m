Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644A13ED181
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbhHPKAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhHPKAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA8B86108D;
        Mon, 16 Aug 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629108006;
        bh=9PW43dBvziydwvrdsNo5u6DZpPb4Wkfh/+7oYsIxLcw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kenoFo+zYRkP+qws6tjdzuVi5X0rgp+39BH6vKhawaXPi3v4BAUnBHaXis8a/Lqyj
         ypyJ8FUtQEeEU0zxazyQI9mwoy/kWi1XrQ/EPVWqH1knGyhMgvztK/Kxf6uEvV20rK
         yb74N+JCBdHRsC8QPKWR/kJKq9FD6kdp8/J5PURix/QF5l60XvRybwZ34CjX3JJbCs
         LNbCVxRZvV6udETvxkUnCsWmxlk+w30rjJqvJzkpfkM6ONn0vRyQ1AktWbvzlvG7vr
         AwZlMsLGTB44c4znej2iVWXEBYY9rYTvF6Hzu8B0+cH50yofv9V8+KD5aQ2WRB2aDe
         oZ8rrmajxbVYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A956660976;
        Mon, 16 Aug 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/3] net: mdio: Add IPQ MDIO reset related function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910800668.17833.16780539766199955250.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:00:06 +0000
References: <20210812100642.1800-1-luoj@codeaurora.org>
In-Reply-To: <20210812100642.1800-1-luoj@codeaurora.org>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, agross@kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        robert.marko@sartura.hr, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Aug 2021 18:06:39 +0800 you wrote:
> This patch series add the MDIO reset features, which includes
> configuring MDIO clock source frequency and indicating CMN_PLL that
> ethernet LDO has been ready, this ethernet LDO is dedicated in the
> IPQ5018 platform.
> 
> Specify more chipset IPQ40xx, IPQ807x, IPQ60xx and IPQ50xx supported by
> this MDIO driver.
> 
> [...]

Here is the summary with links:
  - [v3,1/3] net: mdio: Add the reset function for IPQ MDIO driver
    https://git.kernel.org/netdev/net-next/c/23a890d493e3
  - [v3,2/3] MDIO: Kconfig: Specify more IPQ chipset supported
    https://git.kernel.org/netdev/net-next/c/c76ee26306b2
  - [v3,3/3] dt-bindings: net: Add the properties for ipq4019 MDIO
    https://git.kernel.org/netdev/net-next/c/2a4c32e767ad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


