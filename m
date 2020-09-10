Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6E264570
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 13:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgIJLpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 07:45:20 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:19277 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730408AbgIJLlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 07:41:46 -0400
IronPort-SDR: 3qcDIOA38odHANc0k6VrpW2U4BJIzq6+hYeABdyt/LJKvRnDNz0rkLMMqeEBTofEeym2Vf/dHy
 bEaezqJ/3sb6ykrGcissLMvcqbOm9/fgXq1TfpGlRqFH5mZYEYH1qIKOjNFoufdakrOMK1LdDp
 Wpu7rxWtroCJb9M6LbC14186v4A5t8i5dTTxmFhYq/tHOWwxRY6V17M33Am88Oo76ypd6WQR4A
 ApVOjtSV28xL0iAreK/09XXS2wTu0Yn05nHvE+ac4o75ZLwt0pXxPabk8BLWith1sfZ4EXuDf5
 yeE=
X-IronPort-AV: E=Sophos;i="5.76,412,1592863200"; 
   d="scan'208";a="13811600"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 10 Sep 2020 13:41:08 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 10 Sep 2020 13:41:08 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 10 Sep 2020 13:41:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1599738068; x=1631274068;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MkYowvAXYOKs4O9whme3PMadA8IQAuOBhwQOPGDWPgw=;
  b=B+VTYHI9YFZn3HuDPPnBNX66dpdjcIE81mutAe50YcoDQTn8dsFjFUyQ
   hufwZcvYQ+KtQDxGPxBR812UZQZZJcFth2WUwyDfbm01/XojcUVeDweta
   DJAOTMEGt+ckrHMt8e40qEbtPNrD3D+EwfDNGSdIIDwjDp7WKqj/bwqBo
   GjqiYJQIG1QWGL6cAxkkjUmxXE8cBtnAIS0KdPH9oQIf7Dq7Igo4jfqFk
   JHWiWpiA7zSH+lZy6nNvdclflauDG92WbW7VKtz7Yx1iJ4ErhS7eknG0o
   Th64GT+X/IenbIvF1P9tWvwccQ+aaUaucTZkKs3+RG73a8hZYzVd0T9oD
   Q==;
IronPort-SDR: lEm5S8mlkC2qL9AiHnF/bkDIt4vUrYoTeQ9lYnTTmQhQVPjd332gqfE4QUyw0hsQTTrFNta8LZ
 56rCqE2gVGoOrPykD8m9jcJfXvZabILhrFvz0UfgB2hUZsI7QyI06/6OUl5h5bgVhgLdipIcZg
 RXpjHoYau3VW0xdyu5jIE6+HWeuuao0i3Gb+9PXB2rkELondTQPgKi++z6a8QLFV6Uxpm7RvVT
 NzlK6D3rwuGAO47sO5oGfgh4pZmSyPcmvwZetMnkQF3GbKIVxAlHR99Zbl8LUS6j4oJXqW/6jX
 E/Y=
X-IronPort-AV: E=Sophos;i="5.76,412,1592863200"; 
   d="scan'208";a="13811599"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 10 Sep 2020 13:41:08 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.22])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 9422B280070;
        Thu, 10 Sep 2020 13:41:08 +0200 (CEST)
Message-ID: <f98346dd0ce6974129d6725afcce51a49715fd56.camel@ew.tq-group.com>
Subject: Re: [PATCH v4 00/11] microchip: add support for ksz88x3 driver
 family
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, andrew@lunn.ch
Date:   Thu, 10 Sep 2020 13:41:06 +0200
In-Reply-To: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-03 at 07:44 +0200, Michael Grzeschik wrote:
> This series adds support for the ksz88x3 driver family to the dsa
> based ksz
> drivers. The driver is making use of the already available ksz8795
> driver and
> moves it to an generic driver for the ksz8 based chips which have
> similar
> functions but an totaly different register layout.
> 
> Andrew Lunn (1):
>   net: phy: Add support for microchip SMI0 MDIO bus
> 
> Michael Grzeschik (10):
>   dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0
>   net: tag: ksz: Add KSZ8863 tag code
>   net: dsa: microchip: ksz8795: use port_cnt where possible
>   net: dsa: microchip: ksz8795: dynamic allocate memory for
>     flush_dyn_mac_table
>   net: dsa: microchip: ksz8795: change drivers prefix to be generic
>   net: dsa: microchip: ksz8795: move register offsets and shifts to
>     separate struct
>   net: dsa: microchip: ksz8795: add support for ksz88xx chips
>   net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support
>   net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
>   dt-bindings: net: dsa: document additional Microchip KSZ8863/8873
>     switch
> 
>  .../devicetree/bindings/net/dsa/ksz.txt       |   2 +
>  .../devicetree/bindings/net/mdio-gpio.txt     |   1 +
>  drivers/net/dsa/microchip/Kconfig             |   9 +
>  drivers/net/dsa/microchip/Makefile            |   1 +
>  drivers/net/dsa/microchip/ksz8.h              |  68 ++
>  drivers/net/dsa/microchip/ksz8795.c           | 926 ++++++++++++--
> ----
>  drivers/net/dsa/microchip/ksz8795_reg.h       | 214 ++--
>  drivers/net/dsa/microchip/ksz8795_spi.c       |  64 +-
>  drivers/net/dsa/microchip/ksz8863_reg.h       | 124 +++
>  drivers/net/dsa/microchip/ksz8863_smi.c       | 204 ++++
>  drivers/net/dsa/microchip/ksz_common.h        |   2 +-
>  drivers/net/phy/mdio-bitbang.c                |   8 +-
>  drivers/net/phy/mdio-gpio.c                   |   9 +
>  include/linux/mdio-bitbang.h                  |   3 +
>  include/net/dsa.h                             |   2 +
>  net/dsa/tag_ksz.c                             |  57 ++
>  16 files changed, 1275 insertions(+), 419 deletions(-)
>  create mode 100644 drivers/net/dsa/microchip/ksz8.h
>  create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
>  create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c
> 

Hello Michael,

I've given this series a spin on a TQ-Systems ARM64 board with a
KSZ8863 switch connected via SMI (rebased onto kernel 5.4.y), and
everything seems to work as expected. Feel free to CC me for the next
revision of the series, so I can add my Tested-by.

Kind regards,
Matthias

