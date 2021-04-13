Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7626635D490
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 02:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbhDMA4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 20:56:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238450AbhDMA4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 20:56:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lW7LN-00GOEl-SK; Tue, 13 Apr 2021 02:55:53 +0200
Date:   Tue, 13 Apr 2021 02:55:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Larsson <andreas@gaisler.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Chris Snook <chris.snook@gmail.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
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
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 1/2] of: net: pass the dst buffer to
 of_get_mac_address()
Message-ID: <YHTsGXbbr8mkifDo@lunn.ch>
References: <20210412174718.17382-1-michael@walle.cc>
 <20210412174718.17382-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412174718.17382-2-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 07:47:17PM +0200, Michael Walle wrote:
> of_get_mac_address() returns a "const void*" pointer to a MAC address.
> Lately, support to fetch the MAC address by an NVMEM provider was added.
> But this will only work with platform devices. It will not work with
> PCI devices (e.g. of an integrated root complex) and esp. not with DSA
> ports.
> 
> There is an of_* variant of the nvmem binding which works without
> devices. The returned data of a nvmem_cell_read() has to be freed after
> use. On the other hand the return of_get_mac_address() points to some
> static data without a lifetime. The trick for now, was to allocate a
> device resource managed buffer which is then returned. This will only
> work if we have an actual device.
> 
> Change it, so that the caller of of_get_mac_address() has to supply a
> buffer where the MAC address is written to. Unfortunately, this will
> touch all drivers which use the of_get_mac_address().
> 
> Usually the code looks like:
> 
>   const char *addr;
>   addr = of_get_mac_address(np);
>   if (!IS_ERR(addr))
>     ether_addr_copy(ndev->dev_addr, addr);
> 
> This can then be simply rewritten as:
> 
>   of_get_mac_address(np, ndev->dev_addr);
> 
> Sometimes is_valid_ether_addr() is used to test the MAC address.
> of_get_mac_address() already makes sure, it just returns a valid MAC
> address. Thus we can just test its return code. But we have to be
> careful if there are still other sources for the MAC address before the
> of_get_mac_address(). In this case we have to keep the
> is_valid_ether_addr() call.
> 
> The following coccinelle patch was used to convert common cases to the
> new style. Afterwards, I've manually gone over the drivers and fixed the
> return code variable: either used a new one or if one was already
> available use that. Mansour Moufid, thanks for that coccinelle patch!
> 
> <spml>
> @a@
> identifier x;
> expression y, z;
> @@
> - x = of_get_mac_address(y);
> + x = of_get_mac_address(y, z);
>   <...
> - ether_addr_copy(z, x);
>   ...>
> 
> @@
> identifier a.x;
> @@
> - if (<+... x ...+>) {}
> 
> @@
> identifier a.x;
> @@
>   if (<+... x ...+>) {
>       ...
>   }
> - else {}
> 
> @@
> identifier a.x;
> expression e;
> @@
> - if (<+... x ...+>@e)
> -     {}
> - else
> + if (!(e))
>       {...}
> 
> @@
> expression x, y, z;
> @@
> - x = of_get_mac_address(y, z);
> + of_get_mac_address(y, z);
>   ... when != x
> </spml>
> 
> All drivers, except drivers/net/ethernet/aeroflex/greth.c, were
> compile-time tested.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>

I cannot say i looked at all the changes, but the ones i did exam
seemed O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
