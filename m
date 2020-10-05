Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52F2283368
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgJEJg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:36:29 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2954 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbgJEJg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 05:36:27 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 094B3ABD20918B3B41D5;
        Mon,  5 Oct 2020 10:36:23 +0100 (IST)
Received: from localhost (10.52.124.175) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 5 Oct 2020
 10:36:21 +0100
Date:   Mon, 5 Oct 2020 10:34:36 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Rob Herring <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Baolin Wang" <baolin.wang7@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Vinod Koul" <vkoul@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        <linux-clk@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-spi@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-hwmon@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <openipmi-developer@lists.sourceforge.net>,
        <linux-leds@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-mips@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-remoteproc@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: Another round of adding missing
 'additionalProperties'
Message-ID: <20201005093436.00004913@Huawei.com>
In-Reply-To: <20201002234143.3570746-1-robh@kernel.org>
References: <20201002234143.3570746-1-robh@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.124.175]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Oct 2020 18:41:43 -0500
Rob Herring <robh@kernel.org> wrote:

> Another round of wack-a-mole. The json-schema default is additional
> unknown properties are allowed, but for DT all properties should be
> defined.
> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Baolin Wang <baolin.wang7@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-clk@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-spi@vger.kernel.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-hwmon@vger.kernel.org
> Cc: linux-iio@vger.kernel.org
> Cc: openipmi-developer@lists.sourceforge.net
> Cc: linux-leds@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-mips@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Hi Rob,

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # for iio


However, one of these made me wonder if the binding was simply wrong...
(definitely highlights why we should have additionalProperties: false
where ever possible).

...


> diff --git a/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml b/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
> index abd8d25e1136..4c1c083d0e92 100644
> --- a/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
> +++ b/Documentation/devicetree/bindings/iio/imu/invensense,icm42600.yaml
> @@ -47,11 +47,17 @@ properties:
>    vddio-supply:
>      description: Regulator that provides power to the bus
>  
> +  spi-max-frequency: true
> +  spi-cpha: true
> +  spi-cpol: true

It isn't completely unheard of for a device to operate in multiple SPI modes, but
it does seem to be fairly unusual.  I took a look at the datasheet and at least
from the provided timing diagrams, these are both required in SPI mode.

http://invensense.tdk.com/wp-content/uploads/2020/09/DS-000292-ICM-42605-v1.5.pdf

That doesn't make the binding wrong as such, but we could be tighter in checking this!

I'll add this to my list to take a closer look at sometime soonish.

Thanks.

Jonathan

> +
>  required:
>    - compatible
>    - reg
>    - interrupts
>  
> +additionalProperties: false
> +
>  examples:
>    - |

