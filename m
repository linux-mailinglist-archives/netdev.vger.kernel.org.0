Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CC361AA1
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbhDPHao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 03:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhDPHam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 03:30:42 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F0BC061574;
        Fri, 16 Apr 2021 00:30:18 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 49EE022172;
        Fri, 16 Apr 2021 09:29:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618558211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbMduC+y8U2TnYB1yFy6DIbM598uMx2+jq28dZXHweQ=;
        b=EUtjzMP9GqVLqpUQjKAWkwn0o1sw8EWtxSv8YMRSVD0469vqt05Io1/SVJgobjz7HB/r6y
        Vjk/Jn7gR9cbQkm/qxqSnOY+yQWCWcha3iHS/TQBkEhMmvcdPKJxGg9UyvHCIIkZANcb/g
        63rLgVagJ+mEmiydqQVNecyvEgF/m50=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 16 Apr 2021 09:29:59 +0200
From:   Michael Walle <michael@walle.cc>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     ath9k-devel@qca.qualcomm.com, UNGLinuxDriver@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org, linux-oxnas@groups.io,
        linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
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
        bcm-kernel-feedback-list@broadcom.com,
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
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?J=C3=A9r=C3=B4me?= =?UTF-8?Q?_Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] of: net: fix of_get_mac_addr_nvmem() for
 non-platform devices
In-Reply-To: <730d603b12e590c56770309b4df2bd668f7afbe3.camel@kernel.crashing.org>
References: <20210412174718.17382-1-michael@walle.cc>
 <20210412174718.17382-3-michael@walle.cc>
 <730d603b12e590c56770309b4df2bd668f7afbe3.camel@kernel.crashing.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <8157eba9317609294da80472622deb28@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-04-16 05:24, schrieb Benjamin Herrenschmidt:
> On Mon, 2021-04-12 at 19:47 +0200, Michael Walle wrote:
>> 
>>  /**
>>   * of_get_phy_mode - Get phy mode for given device_node
>> @@ -59,15 +60,39 @@ static int of_get_mac_addr(struct device_node *np, 
>> const char *name, u8 *addr)
>>  static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
>>  {
>>         struct platform_device *pdev = of_find_device_by_node(np);
>> +       struct nvmem_cell *cell;
>> +       const void *mac;
>> +       size_t len;
>>         int ret;
>> 
>> -       if (!pdev)
>> -               return -ENODEV;
>> +       /* Try lookup by device first, there might be a 
>> nvmem_cell_lookup
>> +        * associated with a given device.
>> +        */
>> +       if (pdev) {
>> +               ret = nvmem_get_mac_address(&pdev->dev, addr);
>> +               put_device(&pdev->dev);
>> +               return ret;
>> +       }
>> +
> 
> This smells like the wrong band aid :)
> 
> Any struct device can contain an OF node pointer these days.

But not all nodes might have an associated device, see DSA for example.
And as the name suggests of_get_mac_address() operates on a node. So
if a driver calls of_get_mac_address() it should work on the node. What
is wrong IMHO, is that the ethernet drivers where the corresponding 
board
has a nvmem_cell_lookup registered is calling of_get_mac_address(node).
It should rather call eth_get_mac_address(dev) in the first place.

One would need to figure out if there is an actual device (with an
assiciated of_node), then call eth_get_mac_address(dev) and if there
isn't a device call of_get_mac_address(node).

But I don't know if that is easy to figure out. Well, one could start
with just the device where nvmem_cell_lookup is used. Then we could
drop the workaround above.

> This seems all backwards. I think we are dealing with bad evolution.
> 
> We need to do a lookup for the device because we get passed an of_node.
> We should just get passed a device here... or rather stop calling
> of_get_mac_addr() from all those drivers and instead call
> eth_platform_get_mac_address() which in turns calls of_get_mac_addr().
> 
> Then the nvmem stuff gets put in eth_platform_get_mac_address().
> 
> of_get_mac_addr() becomes a low-level thingy that most drivers don't
> care about.

The NVMEM thing is just another (optional) way how the MAC address
is fetched from the device tree. Thus, if the drivers have the
of_get_mac_address() call they should automatically get the NVMEM
method, too.

-michael
