Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828E336B1F1
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhDZKzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:55:13 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:41077 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhDZKzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:55:10 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C353C22236;
        Mon, 26 Apr 2021 12:54:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1619434464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wk++B/L7nejW/Tu85IzTL8HKq5haXmWBuSRGMq5G9Vc=;
        b=aBLItzwTpMLhnbBUfRwBioPVMyZiTU0Pj1H6UNIlRFQlCvrRQC9+sCwg7Wn5J+XsvHZln5
        Tw13ybstx1ba3ts9pwi2ty81rvOdnoEZ8zIsZqSHZ7psnqzBT46f85vFqJlTddaAXCPvqK
        P1t1rcsQHgB7iSTeBLTyQ5gE26gcAtQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Apr 2021 12:54:08 +0200
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        linux-oxnas@groups.io, linux-omap <linux-omap@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-staging@lists.linux.dev,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Larsson <andreas@gaisler.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Chris Snook <chris.snook@gmail.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        "maintainer:BROADCOM BCM7XXX ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Byungho An <bh74.an@samsung.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] of: net: fix of_get_mac_addr_nvmem() for
 non-platform devices
In-Reply-To: <CAL_JsqLrx6nFZrKiEtm2a1vDvQGG+FkpGtJCG2osM8hhGo3P=Q@mail.gmail.com>
References: <20210412174718.17382-1-michael@walle.cc>
 <20210412174718.17382-3-michael@walle.cc>
 <730d603b12e590c56770309b4df2bd668f7afbe3.camel@kernel.crashing.org>
 <8157eba9317609294da80472622deb28@walle.cc>
 <CAL_JsqLrx6nFZrKiEtm2a1vDvQGG+FkpGtJCG2osM8hhGo3P=Q@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <108f268a35843368466004f7fe5f9f88@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-04-16 17:19, schrieb Rob Herring:
> On Fri, Apr 16, 2021 at 2:30 AM Michael Walle <michael@walle.cc> wrote:
>> 
>> Am 2021-04-16 05:24, schrieb Benjamin Herrenschmidt:
>> > On Mon, 2021-04-12 at 19:47 +0200, Michael Walle wrote:
>> >>
>> >>  /**
>> >>   * of_get_phy_mode - Get phy mode for given device_node
>> >> @@ -59,15 +60,39 @@ static int of_get_mac_addr(struct device_node *np,
>> >> const char *name, u8 *addr)
>> >>  static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
>> >>  {
>> >>         struct platform_device *pdev = of_find_device_by_node(np);
>> >> +       struct nvmem_cell *cell;
>> >> +       const void *mac;
>> >> +       size_t len;
>> >>         int ret;
>> >>
>> >> -       if (!pdev)
>> >> -               return -ENODEV;
>> >> +       /* Try lookup by device first, there might be a
>> >> nvmem_cell_lookup
>> >> +        * associated with a given device.
>> >> +        */
>> >> +       if (pdev) {
>> >> +               ret = nvmem_get_mac_address(&pdev->dev, addr);
>> >> +               put_device(&pdev->dev);
>> >> +               return ret;
>> >> +       }
>> >> +
>> >
>> > This smells like the wrong band aid :)
>> >
>> > Any struct device can contain an OF node pointer these days.
>> 
>> But not all nodes might have an associated device, see DSA for 
>> example.
> 
> I believe what Ben is saying and what I said earlier is going from dev
> -> OF node is right and OF node -> dev is wrong. If you only have an
> OF node, then use an of_* function.
> 
>> And as the name suggests of_get_mac_address() operates on a node. So
>> if a driver calls of_get_mac_address() it should work on the node. 
>> What
>> is wrong IMHO, is that the ethernet drivers where the corresponding
>> board
>> has a nvmem_cell_lookup registered is calling 
>> of_get_mac_address(node).
>> It should rather call eth_get_mac_address(dev) in the first place.
>> 
>> One would need to figure out if there is an actual device (with an
>> assiciated of_node), then call eth_get_mac_address(dev) and if there
>> isn't a device call of_get_mac_address(node).
> 
> Yes, I think we're all in agreement.
> 
>> But I don't know if that is easy to figure out. Well, one could start
>> with just the device where nvmem_cell_lookup is used. Then we could
>> drop the workaround above.
> 
> Start with the ones just passing dev.of_node directly:
> 
> $ git grep 'of_get_mac_address(.*of_node)'

[..]

Before I'll try to come up with a patch for this, I'd like to get
your opinion on it.

(1) replacing of_get_mac_address(node) with eth_get_mac_address(dev)
     might sometimes lead to confusing comments like in
     drivers/net/ethernet/allwinner/sun4i-emac.c:

     /* Read MAC-address from DT */
     ret = of_get_mac_address(np, ndev->dev_addr);

     Do we live with that or should the new name somehow reflect that
     it is taken from the device tree.

(2) What do you think of eth_get_mac_address(ndev). That is, the
     second argument is missing and ndev->dev_addr is used.
     I'm unsure about it. We'd still need a second function for drivers
     which don't write ndev->dev_addr directly, but have some custom
     logic in between. OTOH it would be like eth_hw_addr_random(ndev).

-michael
