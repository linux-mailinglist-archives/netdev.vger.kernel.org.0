Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2852C3ED200
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhHPKcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235802AbhHPKai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:30:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E9A161BF3;
        Mon, 16 Aug 2021 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109807;
        bh=fqvHLXDy+6V7+1cLkGAuc5j7Opy/a85tMUtGQDDJmYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EDqiCBiH9e97kmkiPmUeex0ra8Sy7wpQYXMl9tAkPj02cOm5l92VmKvkHvr+o9mnD
         lGu0Nf+WiiF2TmmozvwxZTVIgEt7CE0UFu6r/ZE3OBz05Koe26S6rxGihJeJSUWmwm
         v8Kh904OUnvbGcE37W2RM9Dbd4ydEwiKhPZbtP90/oxfYtW7t/EOAK6Zo5i38KhwrH
         fchN8El0XAPpr1cql/zFpwKElDpReRca0Duam1zYM/umhiVoSZxsrDW7dogywIXS5O
         ADeK8Z2eYjwPogZpcfymLt0HR1InSfxatwP5zNugwizPLM5CDF4vjMNbIvzD/gQLBv
         26UVKttd+hv8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2726560976;
        Mon, 16 Aug 2021 10:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] Convert ocelot to phylink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910980715.576.14134541259673944792.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:30:07 +0000
References: <20210815014748.1262458-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210815014748.1262458-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        linux@armlinux.org.uk, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, colin.foster@in-advantage.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 15 Aug 2021 04:47:46 +0300 you wrote:
> The ocelot switchdev and felix dsa drivers are interesting because they
> target the same class of hardware switches but used in different modes.
> 
> Colin has an interesting use case where he wants to use a hardware
> switch supported by the ocelot switchdev driver with the felix dsa
> driver.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: dsa: felix: stop calling ocelot_port_{enable,disable}
    https://git.kernel.org/netdev/net-next/c/46efe4efb9d1
  - [v2,net-next,2/2] net: mscc: ocelot: convert to phylink
    https://git.kernel.org/netdev/net-next/c/e6e12df625f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


