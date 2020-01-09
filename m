Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960431360E1
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAITQw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Jan 2020 14:16:52 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:59229 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgAITQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:16:52 -0500
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 6E53C240003;
        Thu,  9 Jan 2020 19:16:45 +0000 (UTC)
Date:   Thu, 9 Jan 2020 20:16:44 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <vkoul@kernel.org>,
        <eugen.hristev@microchip.com>, <jic23@kernel.org>,
        <knaack.h@gmx.de>, <lars@metafoo.de>, <pmeerw@pmeerw.net>,
        <mchehab@kernel.org>, <lee.jones@linaro.org>,
        <richard.genoud@gmail.com>, <radu_nicolae.pirea@upb.ro>,
        <tudor.ambarus@microchip.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <wg@grandegger.com>, <mkl@pengutronix.de>, <a.zummo@towertech.it>,
        <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rtc@vger.kernel.org>
Subject: Re: [PATCH 07/16] dt-bindings: atmel-nand: add
 microchip,sam9x60-pmecc
Message-ID: <20200109201644.34c6b936@xps13>
In-Reply-To: <1578488123-26127-8-git-send-email-claudiu.beznea@microchip.com>
References: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
        <1578488123-26127-8-git-send-email-claudiu.beznea@microchip.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claudiu,

Claudiu Beznea <claudiu.beznea@microchip.com> wrote on Wed, 8 Jan 2020
14:55:14 +0200:

> Add microchip,sam9x60-pmecc to DT bindings documentation.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  Documentation/devicetree/bindings/mtd/atmel-nand.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> index 68b51dc58816..3aa297c97ab6 100644
> --- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> @@ -57,6 +57,7 @@ Required properties:
>  	"atmel,at91sam9g45-pmecc"
>  	"atmel,sama5d4-pmecc"
>  	"atmel,sama5d2-pmecc"
> +	"microchip,sam9x60-pmecc"
>  - reg: should contain 2 register ranges. The first one is pointing to the PMECC
>         block, and the second one to the PMECC_ERRLOC block.
>  

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

Thanks,
Miquèl
