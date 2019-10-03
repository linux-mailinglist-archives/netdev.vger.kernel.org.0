Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747ECC9944
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfJCHxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 03:53:21 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34570 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbfJCHxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 03:53:20 -0400
Received: by mail-oi1-f194.google.com with SMTP id 83so1777381oii.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 00:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OjGOtM7igFnxOTkazDzEAF1mbsEsRdgokYn8LnXlxak=;
        b=0ljP/Xqkv8mT++dxL9IDYrrnXlEv9lrJP90Bahq1OBLUXK3btgYh5wyHlZssI3YurN
         pFDAkt12ppGUrER632fCfdihcSkLnFygz07D3eEGii2r2Puunq5JCKwhf/olqSyQJkhe
         y4sxSAWaYpjr9f5Wrxp90qzT0eir6UjXXj2LeikUk8mVJIBX5nJR3znXBIO9CoTmsRr6
         LkMnSa//LbiPkRtmhxr1iEvteUzvh1LjMwn00n5k+Q+R5FcGfpoYjlNwxgcL0FpK8Y1W
         tjUDW9f2sxUGKn5ZjbjT1ogyxC+SzYQbv5HTFeCum1+SvlQU5DzEXntInmz46VsYXXrg
         dQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OjGOtM7igFnxOTkazDzEAF1mbsEsRdgokYn8LnXlxak=;
        b=svL2IFrIQZq1biKN8GYqSIRPBWJP8utFto2oc5RR/KbG+hILeVhcNDpbMOQZkNj8Em
         1sKA8dFTF7NawyRkiO5gW/5ocyiYfGfcC5rRwt/Rjc2hzSWJgXwck2fxMr/DrOmlzdxC
         aHfUtGLaVJHkc5levYcKfURjGj13DoEndjp+KQZm16K9dqK25+sSjFx0ty34ltjgxrbd
         cI7O0+UFxPqb09rACbhUYJIE7roaLeVR7Fc9hjFRdU2SRcBspDssK1IUKTXKvhDeL1Th
         ANqUCOdFNY3BbkcaY/e2P50rUFOBW+M8pUhwJsB+I2nCxIaXkGFE/u6MfYinXWnBk6dd
         Toaw==
X-Gm-Message-State: APjAAAUqvuiBbhISTfGxDP6lOb43O0FF3IoDqdVDlejgm/fSRV8tuxtL
        MQHHLrTUyfUGlFc9XbV7N3WuM8yOsgkIfc3k1ehy1w==
X-Google-Smtp-Source: APXvYqz7m7kCXZYIv7j5R46VZcpbdhhoa42pgCHxxwP/titPUyQPDIy7EJgb+avLl4yWojBI9F0QLe5D/MGpfKQJ+94=
X-Received: by 2002:a54:4f8a:: with SMTP id g10mr1832202oiy.147.1570089199061;
 Thu, 03 Oct 2019 00:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <b87385b2ac6ce6c75df82062fce2976149bbaa6b.1569330078.git.mchehab+samsung@kernel.org>
In-Reply-To: <b87385b2ac6ce6c75df82062fce2976149bbaa6b.1569330078.git.mchehab+samsung@kernel.org>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 3 Oct 2019 09:53:08 +0200
Message-ID: <CAMpxmJUYZ-6p_uD=ktO+mDMZ3VooRkjLBwDVDieT1gvo3474uw@mail.gmail.com>
Subject: Re: [PATCH 1/3] docs: fix some broken references
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Steve French <sfrench@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-devicetree <devicetree@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-hwmon@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wt., 24 wrz 2019 o 15:01 Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> napisa=C5=82(a):
>
> There are a number of documentation files that got moved or
> renamed. update their references.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  Documentation/devicetree/bindings/cpu/cpu-topology.txt    | 2 +-
>  Documentation/devicetree/bindings/timer/ingenic,tcu.txt   | 2 +-
>  Documentation/driver-api/gpio/driver.rst                  | 2 +-
>  Documentation/hwmon/inspur-ipsps1.rst                     | 2 +-
>  Documentation/mips/ingenic-tcu.rst                        | 2 +-
>  Documentation/networking/device_drivers/mellanox/mlx5.rst | 2 +-
>  MAINTAINERS                                               | 2 +-
>  drivers/net/ethernet/faraday/ftgmac100.c                  | 2 +-
>  drivers/net/ethernet/pensando/ionic/ionic_if.h            | 4 ++--
>  fs/cifs/cifsfs.c                                          | 2 +-
>  10 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/cpu/cpu-topology.txt b/Doc=
umentation/devicetree/bindings/cpu/cpu-topology.txt
> index 99918189403c..9bd530a35d14 100644
> --- a/Documentation/devicetree/bindings/cpu/cpu-topology.txt
> +++ b/Documentation/devicetree/bindings/cpu/cpu-topology.txt
> @@ -549,5 +549,5 @@ Example 3: HiFive Unleashed (RISC-V 64 bit, 4 core sy=
stem)
>  [2] Devicetree NUMA binding description
>      Documentation/devicetree/bindings/numa.txt
>  [3] RISC-V Linux kernel documentation
> -    Documentation/devicetree/bindings/riscv/cpus.txt
> +    Documentation/devicetree/bindings/riscv/cpus.yaml
>  [4] https://www.devicetree.org/specifications/
> diff --git a/Documentation/devicetree/bindings/timer/ingenic,tcu.txt b/Do=
cumentation/devicetree/bindings/timer/ingenic,tcu.txt
> index 5a4b9ddd9470..7f6fe20503f5 100644
> --- a/Documentation/devicetree/bindings/timer/ingenic,tcu.txt
> +++ b/Documentation/devicetree/bindings/timer/ingenic,tcu.txt
> @@ -2,7 +2,7 @@ Ingenic JZ47xx SoCs Timer/Counter Unit devicetree binding=
s
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  For a description of the TCU hardware and drivers, have a look at
> -Documentation/mips/ingenic-tcu.txt.
> +Documentation/mips/ingenic-tcu.rst.
>
>  Required properties:
>
> diff --git a/Documentation/driver-api/gpio/driver.rst b/Documentation/dri=
ver-api/gpio/driver.rst
> index 3fdb32422f8a..9076cc76d5bf 100644
> --- a/Documentation/driver-api/gpio/driver.rst
> +++ b/Documentation/driver-api/gpio/driver.rst
> @@ -493,7 +493,7 @@ available but we try to move away from this:
>    gpiochip. It will pass the struct gpio_chip* for the chip to all IRQ
>    callbacks, so the callbacks need to embed the gpio_chip in its state
>    container and obtain a pointer to the container using container_of().
> -  (See Documentation/driver-model/design-patterns.txt)
> +  (See Documentation/driver-api/driver-model/design-patterns.rst)
>
>  - gpiochip_irqchip_add_nested(): adds a nested cascaded irqchip to a gpi=
ochip,
>    as discussed above regarding different types of cascaded irqchips. The
> diff --git a/Documentation/hwmon/inspur-ipsps1.rst b/Documentation/hwmon/=
inspur-ipsps1.rst
> index 2b871ae3448f..ed32a65c30e1 100644
> --- a/Documentation/hwmon/inspur-ipsps1.rst
> +++ b/Documentation/hwmon/inspur-ipsps1.rst
> @@ -17,7 +17,7 @@ Usage Notes
>  -----------
>
>  This driver does not auto-detect devices. You will have to instantiate t=
he
> -devices explicitly. Please see Documentation/i2c/instantiating-devices f=
or
> +devices explicitly. Please see Documentation/i2c/instantiating-devices.r=
st for
>  details.
>
>  Sysfs entries
> diff --git a/Documentation/mips/ingenic-tcu.rst b/Documentation/mips/inge=
nic-tcu.rst
> index c4ef4c45aade..c5a646b14450 100644
> --- a/Documentation/mips/ingenic-tcu.rst
> +++ b/Documentation/mips/ingenic-tcu.rst
> @@ -68,4 +68,4 @@ and frameworks can be controlled from the same register=
s, all of these
>  drivers access their registers through the same regmap.
>
>  For more information regarding the devicetree bindings of the TCU driver=
s,
> -have a look at Documentation/devicetree/bindings/mfd/ingenic,tcu.txt.
> +have a look at Documentation/devicetree/bindings/timer/ingenic,tcu.txt.
> diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/=
Documentation/networking/device_drivers/mellanox/mlx5.rst
> index d071c6b49e1f..a74422058351 100644
> --- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
> +++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
> @@ -258,7 +258,7 @@ mlx5 tracepoints
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  mlx5 driver provides internal trace points for tracking and debugging us=
ing
> -kernel tracepoints interfaces (refer to Documentation/trace/ftrase.rst).
> +kernel tracepoints interfaces (refer to Documentation/trace/ftrace.rst).
>
>  For the list of support mlx5 events check /sys/kernel/debug/tracing/even=
ts/mlx5/
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 54f1286087e9..65b7d9a0a44a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3680,7 +3680,7 @@ M:        Oleksij Rempel <o.rempel@pengutronix.de>
>  R:     Pengutronix Kernel Team <kernel@pengutronix.de>
>  L:     linux-can@vger.kernel.org
>  S:     Maintained
> -F:     Documentation/networking/j1939.txt
> +F:     Documentation/networking/j1939.rst
>  F:     net/can/j1939/
>  F:     include/uapi/linux/can/j1939.h
>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ether=
net/faraday/ftgmac100.c
> index 9b7af94a40bb..8abe5e90d268 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1835,7 +1835,7 @@ static int ftgmac100_probe(struct platform_device *=
pdev)
>                 }
>
>                 /* Indicate that we support PAUSE frames (see comment in
> -                * Documentation/networking/phy.txt)
> +                * Documentation/networking/phy.rst)
>                  */
>                 phy_support_asym_pause(phy);
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net=
/ethernet/pensando/ionic/ionic_if.h
> index 5bfdda19f64d..80028f781c83 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
> @@ -596,8 +596,8 @@ enum ionic_txq_desc_opcode {
>   *                      the @encap is set, the device will
>   *                      offload the outer header checksums using
>   *                      LCO (local checksum offload) (see
> - *                      Documentation/networking/checksum-
> - *                      offloads.txt for more info).
> + *                      Documentation/networking/checksum-offloads.rst
> + *                      for more info).
>   *
>   *                   IONIC_TXQ_DESC_OPCODE_CSUM_HW:
>   *
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 2e9c7f493f99..811f510578cb 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1529,7 +1529,7 @@ init_cifs(void)
>         /*
>          * Consider in future setting limit!=3D0 maybe to min(num_of_core=
s - 1, 3)
>          * so that we don't launch too many worker threads but
> -        * Documentation/workqueue.txt recommends setting it to 0
> +        * Documentation/core-api/workqueue.rst recommends setting it to =
0
>          */
>
>         /* WQ_UNBOUND allows decrypt tasks to run on any CPU */
> --
> 2.21.0
>

For GPIO:

Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
