Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBC235E873
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346781AbhDMVko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232542AbhDMVkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 17:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B20D2613B6;
        Tue, 13 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618350012;
        bh=toVub+slEHyxpan1zl2EKjAs+n9L+DqJjmVyXdpSda8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pRV3XRV88aPlnwLClx5LDM21mdefxIbRGFcsOMAWKDGAPSf1o7HWMcUJArQ3XXTo2
         omQ7Z2UBYmJ/4VEgdmDWMtz3nLyeoWfPZMbM/epzVuNn/dfLkNcaqGX/sQ3OpMjUBS
         bAKgZugFWBnTeaINp8LqtfjdEpx90+cwvi+asWJoSAi80GbrFagrnhafBEMs9d/q64
         V1GuK22jWWyeImHuDUYrsXisI7HOHaVrq3GZpA1n6OF84dCG4EQ57enrHgZGDRNpgk
         +wx2yJOLG9rxC5gEKrr9mBBot2pLRQqzLRJSzYPRKCwgwQuIOp0m7AJtIXo8z3kOIr
         TcOoK6hf+PaXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A519609B9;
        Tue, 13 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] of: net: support non-platform devices in
 of_get_mac_address()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835001262.18297.4500601910911096840.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 21:40:12 +0000
References: <20210412174718.17382-1-michael@walle.cc>
In-Reply-To: <20210412174718.17382-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     ath9k-devel@qca.qualcomm.com, UNGLinuxDriver@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org, linux-oxnas@groups.io,
        linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, linux-staging@lists.linux.dev,
        andrew@lunn.ch, gregory.clement@bootlin.com,
        sebastian.hesselbarth@gmail.com, linux@armlinux.org.uk,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        andreas@gaisler.com, davem@davemloft.net, kuba@kernel.org,
        mripard@kernel.org, wens@csie.org, jernej.skrabec@siol.net,
        joyce.ooi@intel.com, chris.snook@gmail.com, rafal@milecki.pl,
        bcm-kernel-feedback-list@broadcom.com, f.fainelli@gmail.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        sgoutham@marvell.com, fugang.duan@nxp.com, madalin.bucur@nxp.com,
        pantelis.antoniou@gmail.com, claudiu.manoil@nxp.com,
        leoyang.li@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, hauke@hauke-m.de,
        thomas.petazzoni@bootlin.com, vkochan@marvell.com,
        tchornyi@marvell.com, mlindner@marvell.com,
        stephen@networkplumber.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, bryan.whitehead@microchip.com,
        vz@mleia.com, sergei.shtylyov@gmail.com, bh74.an@samsung.com,
        hayashi.kunihiko@socionext.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, khilman@baylibre.com, narmstrong@baylibre.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        vkoul@kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        grygorii.strashko@ti.com, w-kwok2@ti.com, m-karicheri2@ti.com,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        kvalo@codeaurora.org, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, stf_xl@wp.pl, helmut.schaa@googlemail.com,
        hkallweit1@gmail.com, robh+dt@kernel.org, frowand.list@gmail.com,
        gregkh@linuxfoundation.org, jerome.pouiller@silabs.com,
        vivien.didelot@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 12 Apr 2021 19:47:16 +0200 you wrote:
> of_get_mac_address() is commonly used to fetch the MAC address
> from the device tree. It also supports reading it from a NVMEM
> provider. But the latter is only possible for platform devices,
> because only platform devices are searched for a matching device
> node.
> 
> Add a second method to fetch the NVMEM cell by a device tree node
> instead of a "struct device".
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] of: net: pass the dst buffer to of_get_mac_address()
    https://git.kernel.org/netdev/net-next/c/83216e3988cd
  - [net-next,v4,2/2] of: net: fix of_get_mac_addr_nvmem() for non-platform devices
    https://git.kernel.org/netdev/net-next/c/f10843e04a07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


