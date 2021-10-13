Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3399342B2C9
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 04:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhJMCmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 22:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhJMCmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 22:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E1F360F38;
        Wed, 13 Oct 2021 02:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634092810;
        bh=BfG/hOLpELMeJrrJw0w09DM+woU9VOgyQrkpY6CyVMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TVVAOey1CPDdwUH01HCruw7LCP/pstooOqwntPu0D2E62ObI+0Q5QWNLRIH7EpT87
         jCKsjhvFWwShDtRAy22TBjgt0hSXfIUIzg2FjB5yKP9uxR7QTmmrISsFf9j2bRFMaj
         ElICYqISn6ogormcqBMNkGivWehsZ8jb9C8Hqo4ZlSyTKEp+vHO9uxOR03fXks5vNh
         ylW6DB1N76dhoTNVUwZClBiwTa9NVegeNdzmtALKJdELFgqhyXU8AwaBknsKuHzDLS
         EiKnAxceBU2LDbKRk7QRfArnyvZBI2T7EIlEiK77WFKckWec7otqYKZeeBzrZqhkaF
         Ip7MXmdOrpt1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3FA9560A38;
        Wed, 13 Oct 2021 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 00/10] Felix DSA driver fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163409281025.3651.17457636920061865230.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 02:40:10 +0000
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        po.liu@nxp.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, michael@walle.cc,
        rui.sousa@nxp.com, yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 14:40:34 +0300 you wrote:
> This is an assorted collection of fixes for issues seen on the NXP
> LS1028A switch.
> 
> - PTP packet drops due to switch congestion result in catastrophic
>   damage to the driver's state
> - loops are not blocked by STP if using the ocelot-8021q tagger
> - driver uses the wrong CPU port when two of them are defined in DT
> - module autoloading is broken* with both tagging protocol drivers
>   (ocelot and ocelot-8021q)
> 
> [...]

Here is the summary with links:
  - [v2,net,01/10] net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
    https://git.kernel.org/netdev/net/c/c57fe0037a4e
  - [v2,net,02/10] net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
    https://git.kernel.org/netdev/net/c/52849bcf0029
  - [v2,net,03/10] net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
    https://git.kernel.org/netdev/net/c/9fde506e0c53
  - [v2,net,04/10] net: mscc: ocelot: deny TX timestamping of non-PTP packets
    https://git.kernel.org/netdev/net/c/fba01283d85a
  - [v2,net,05/10] net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO with the skb PTP header
    https://git.kernel.org/netdev/net/c/ebb4c6a990f7
  - [v2,net,06/10] net: dsa: tag_ocelot: break circular dependency with ocelot switch lib driver
    https://git.kernel.org/netdev/net/c/deab6b1cd978
  - [v2,net,07/10] net: dsa: tag_ocelot_8021q: break circular dependency with ocelot switch lib
    https://git.kernel.org/netdev/net/c/49f885b2d970
  - [v2,net,08/10] net: dsa: felix: purge skb from TX timestamping queue if it cannot be sent
    https://git.kernel.org/netdev/net/c/1328a883258b
  - [v2,net,09/10] net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs into BLOCKING ports
    https://git.kernel.org/netdev/net/c/43ba33b4f143
  - [v2,net,10/10] net: dsa: felix: break at first CPU port during init and teardown
    https://git.kernel.org/netdev/net/c/8d5f7954b7c8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


