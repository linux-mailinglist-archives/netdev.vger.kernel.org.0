Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115E6F903B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfKLNJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:09:51 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:33607 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfKLNJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:09:51 -0500
X-Originating-IP: 92.137.17.54
Received: from localhost (alyon-657-1-975-54.w92-137.abo.wanadoo.fr [92.137.17.54])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id A8619FF805;
        Tue, 12 Nov 2019 13:09:47 +0000 (UTC)
Date:   Tue, 12 Nov 2019 14:09:47 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
Message-ID: <20191112130947.GE3572@piout.net>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-11-olteanv@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/11/2019 14:44:18+0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The vitesse/ folder will contain drivers for switching chips derived
> from legacy Vitesse IPs (VSC family), including those produced by
> Microsemi and Microchip (acquirers of Vitesse).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/Kconfig                       | 31 +------------------
>  drivers/net/dsa/Makefile                      |  4 +--
>  drivers/net/dsa/vitesse/Kconfig               | 31 +++++++++++++++++++
>  drivers/net/dsa/vitesse/Makefile              |  3 ++
>  .../vsc73xx-core.c}                           |  2 +-
>  .../vsc73xx-platform.c}                       |  2 +-
>  .../vsc73xx-spi.c}                            |  2 +-
>  .../{vitesse-vsc73xx.h => vitesse/vsc73xx.h}  |  0
>  8 files changed, 39 insertions(+), 36 deletions(-)
>  create mode 100644 drivers/net/dsa/vitesse/Kconfig
>  create mode 100644 drivers/net/dsa/vitesse/Makefile
>  rename drivers/net/dsa/{vitesse-vsc73xx-core.c => vitesse/vsc73xx-core.c} (99%)
>  rename drivers/net/dsa/{vitesse-vsc73xx-platform.c => vitesse/vsc73xx-platform.c} (99%)
>  rename drivers/net/dsa/{vitesse-vsc73xx-spi.c => vitesse/vsc73xx-spi.c} (99%)
>  rename drivers/net/dsa/{vitesse-vsc73xx.h => vitesse/vsc73xx.h} (100%)
> 

As there are no commonalities between the vsc73xx and felix drivers,
shouldn't you simply leave that one out and have felix in the existing
microchip folder?

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
