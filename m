Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456343688E1
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhDVWKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhDVWKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 18:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B806761139;
        Thu, 22 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619129409;
        bh=i38ltWifcEG83xNsdauEPLBgjPVXBwA//ID7Zv+nbf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IJyoKfHAqWt+ENFYAqLXB9AEYQL0Th+58WG+V09/cUJtppaswUZSbCv/Sv8pJIzTe
         unt/wZYRPA/7jpBTPp3SYhC313VjuD158x0PPaM0pkh6pVTSaXQRVy4usV/cUJrxka
         qKVo/h76uJKe40yj7ebiTUxCnNt7+z4KV9Z7/e/fGPBS0or6Pfs6q8vyNMRHrVOvhu
         PHc8lHBntcTO9Y0CRYg0luYX2faOlZbeRDCOM9YxfChnFcDF57G+ZoaD2gjrVDJIS8
         JoZfi6dE+yi/b6YZmb7ION9bEPrqIdMS/PTIqjnwsVTQDiHqgTH/awv6XdToq6fkr2
         ucbWogi4xwWjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF721609AC;
        Thu, 22 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] Change phy-mode to RGMII-ID to enable delay pins
 for RTL8211E
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912940971.2979.14549137476438652466.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 22:10:09 +0000
References: <1619112709-13234-1-git-send-email-hayashi.kunihiko@socionext.com>
In-Reply-To: <1619112709-13234-1-git-send-email-hayashi.kunihiko@socionext.com>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        masami.hiramatsu@linaro.org, jaswinder.singh@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Apr 2021 02:31:47 +0900 you wrote:
> UniPhier PXs2, LD20, and PXs3 boards have RTL8211E ethernet phy, and the
> phy have the RX/TX delays of RGMII interface using pull-ups on the RXDLY
> and TXDLY pins.
> 
> After the commit bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx
> delay config"), the delays are working correctly, however, "rgmii" means
> no delay and the phy doesn't work. So need to set the phy-mode to
> "rgmii-id" to show that RX/TX delays are enabled.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
    https://git.kernel.org/netdev/net/c/9ba585cc5b56
  - [net,v2,2/2] arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
    https://git.kernel.org/netdev/net/c/dcabb06bf127

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


