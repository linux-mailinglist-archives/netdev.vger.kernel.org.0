Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A519842EEC4
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhJOKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhJOKcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9843C61041;
        Fri, 15 Oct 2021 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634293811;
        bh=kUEohQW10Eu1sHMeLGbhJZWFGVBPRUf0aoHV8sFGdl8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cQjgug1zPkmY9gDrWkqKqn87sy6n/ovtoV/ybwkr7l+6ZgLM2tn4I+vzoLcp+l+st
         010je+4gCQxNk2jCzVi76EUil6QHBQawU046D1GuWZcW2/6AYSfvIgAhmjM6jX5UhM
         whlpWb7emqx8O04X830puwYfSU9iiReK0LeH6p1HOY1zD9J2D6m2AIeP+FEO4Uk0V+
         XIrEd+REGkrjVkDzw5hp0BwwxMtqOnJLAAK4gVGH51heoWF0Aw6P5piMHZHxkgPcFC
         7whx0hS8QAMyrKAefH301ak6uT8Ilv2/zuVl7vwTkn23VmyYx265XHWdb9gXX2Jsow
         Jt9LBTL0n6y1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F91460A47;
        Fri, 15 Oct 2021 10:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v7 00/16] Multiple improvement for qca8337 switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429381158.2368.12093247360263703585.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:30:11 +0000
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, agross@kernel.org, bjorn.andersson@linaro.org,
        linux@armlinux.org.uk, john@phrozen.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 00:39:05 +0200 you wrote:
> This series is the final step of a long process of porting 80+ devices
> to use the new qca8k driver instead of the hacky qca one based on never
> merged swconfig platform.
> Some background to justify all these additions.
> QCA used a special binding to declare raw initval to set the swich. I
> made a script to convert all these magic values and convert 80+ dts and
> scan all the needed "unsupported regs". We find a baseline where we
> manage to find the common and used regs so in theory hopefully we don't
> have to add anymore things.
> We discovered lots of things with this, especially about how differently
> qca8327 works compared to qca8337.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,01/16] dsa: qca8k: add mac_power_sel support
    https://git.kernel.org/netdev/net-next/c/d8b6f5bae6d3
  - [net-next,v7,02/16] dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
    https://git.kernel.org/netdev/net-next/c/fdbf35df9c09
  - [net-next,v7,03/16] net: dsa: qca8k: add support for sgmii falling edge
    https://git.kernel.org/netdev/net-next/c/6c43809bf1be
  - [net-next,v7,04/16] dt-bindings: net: dsa: qca8k: Document support for CPU port 6
    https://git.kernel.org/netdev/net-next/c/731d613338ec
  - [net-next,v7,05/16] net: dsa: qca8k: add support for cpu port 6
    https://git.kernel.org/netdev/net-next/c/3fcf734aa482
  - [net-next,v7,06/16] net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6
    https://git.kernel.org/netdev/net-next/c/5654ec78dd7e
  - [net-next,v7,07/16] dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
    https://git.kernel.org/netdev/net-next/c/13ad5ccc093f
  - [net-next,v7,08/16] net: dsa: qca8k: add explicit SGMII PLL enable
    https://git.kernel.org/netdev/net-next/c/bbc4799e8bb6
  - [net-next,v7,09/16] dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
    https://git.kernel.org/netdev/net-next/c/924087c5c3d4
  - [net-next,v7,10/16] net: dsa: qca8k: add support for pws config reg
    https://git.kernel.org/netdev/net-next/c/362bb238d8bf
  - [net-next,v7,11/16] dt-bindings: net: dsa: qca8k: document support for qca8328
    https://git.kernel.org/netdev/net-next/c/ed7988d77fbf
  - [net-next,v7,12/16] net: dsa: qca8k: add support for QCA8328
    https://git.kernel.org/netdev/net-next/c/f477d1c8bdbe
  - [net-next,v7,13/16] net: dsa: qca8k: set internal delay also for sgmii
    https://git.kernel.org/netdev/net-next/c/cef08115846e
  - [net-next,v7,14/16] net: dsa: qca8k: move port config to dedicated struct
    https://git.kernel.org/netdev/net-next/c/fd0bb28c547f
  - [net-next,v7,15/16] dt-bindings: net: ipq8064-mdio: fix warning with new qca8k switch
    https://git.kernel.org/netdev/net-next/c/e52073a8e308
  - [net-next,v7,16/16] dt-bindings: net: dsa: qca8k: convert to YAML schema
    https://git.kernel.org/netdev/net-next/c/d291fbb8245d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


