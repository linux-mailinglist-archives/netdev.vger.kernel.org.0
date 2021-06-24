Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B3C3B35E6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhFXSm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhFXSmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6ABF3613FD;
        Thu, 24 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624560005;
        bh=Ra3h2qJbvIqfuq+CMwzUE7Qsa24JTt145MdIgGqL6+s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eemqxB4xZV/OzRmvAFRzxzWujSj83tfRk8xp+At97lbQUOzsYtX60q87W0SGbKoY3
         8hU4rP5AqI+3QACJ+kqr6z+OTw+864UaqfghLDnPcuC1HnhONY2AFhMM4hvmow1qid
         bmZHXufuD+6Bb3JsR2cNxXroSRzLgLI7Hei0yWgjU7y8dinMTq/oeJW4e2EVAEz9P7
         xUUrYkyKrJtLLLb9bq739/Rp3F2MSFNUeV7tvyYyOaXwYDwJHaejCEPFMel9717HT+
         vkhJsnRa0HQinNac/vnvWsbLN/84vnFG6tRB3ytsz3ypna8gb8BekRYXsIqZa2TtQl
         mSTLLyJQCNo9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5BFE9609AC;
        Thu, 24 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 00/10] Adding the Sparx5i Switch Driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456000537.7935.16966630139260402371.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 18:40:05 +0000
References: <20210624070758.515521-1-steen.hegelund@microchip.com>
In-Reply-To: <20210624070758.515521-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, madalin.bucur@oss.nxp.com,
        mark.einon@gmail.com, masahiroy@kernel.org, arnd@arndb.de,
        p.zabel@pengutronix.de, simon.horman@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 09:07:48 +0200 you wrote:
> This series provides the Microchip Sparx5i Switch Driver
> 
> The SparX-5 Enterprise Ethernet switch family provides a rich set of
> Enterprise switching features such as advanced TCAM-based VLAN and QoS
> processing enabling delivery of differentiated services, and security
> through TCAMbased frame processing using versatile content aware processor
> (VCAP). IPv4/IPv6 Layer 3 (L3) unicast and multicast routing is supported
> with up to 18K IPv4/9K IPv6 unicast LPM entries and up to 9K IPv4/3K IPv6
> (S,G) multicast groups. L3 security features include source guard and
> reverse path forwarding (uRPF) tasks. Additional L3 features include
> VRF-Lite and IP tunnels (IP over GRE/IP).
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/10] dt-bindings: net: sparx5: Add sparx5-switch bindings
    https://git.kernel.org/netdev/net-next/c/f8c63088a98b
  - [net-next,v5,02/10] net: sparx5: add the basic sparx5 driver
    https://git.kernel.org/netdev/net-next/c/3cfa11bac9bb
  - [net-next,v5,03/10] net: sparx5: add hostmode with phylink support
    https://git.kernel.org/netdev/net-next/c/f3cad2611a77
  - [net-next,v5,04/10] net: sparx5: add port module support
    https://git.kernel.org/netdev/net-next/c/946e7fd5053a
  - [net-next,v5,05/10] net: sparx5: add mactable support
    https://git.kernel.org/netdev/net-next/c/b37a1bae742f
  - [net-next,v5,06/10] net: sparx5: add vlan support
    https://git.kernel.org/netdev/net-next/c/78eab33bb68b
  - [net-next,v5,07/10] net: sparx5: add switching support
    https://git.kernel.org/netdev/net-next/c/d6fce5141929
  - [net-next,v5,08/10] net: sparx5: add calendar bandwidth allocation support
    https://git.kernel.org/netdev/net-next/c/0a9d48ad0d09
  - [net-next,v5,09/10] net: sparx5: add ethtool configuration and statistics support
    https://git.kernel.org/netdev/net-next/c/af4b11022e2d
  - [net-next,v5,10/10] arm64: dts: sparx5: Add the Sparx5 switch node
    https://git.kernel.org/netdev/net-next/c/d0f482bb06f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


