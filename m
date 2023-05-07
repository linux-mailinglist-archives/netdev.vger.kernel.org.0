Return-Path: <netdev+bounces-746-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3F16F97BB
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:37:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1B872810F2
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8DB179;
	Sun,  7 May 2023 08:37:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F100C7C
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 08:37:33 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E2312EAC;
	Sun,  7 May 2023 01:37:28 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-24e14a24c9dso2437771a91.0;
        Sun, 07 May 2023 01:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683448648; x=1686040648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3KiM7vm8bnjyf6McbGGRDlq1vQhpMDzuC8g+iNcmofc=;
        b=PeXXv78+gpCGlgTyIdQBNq++r5T4PROhbfhu2IpTNiP+3yapHMhCcrpQ5Kk9aPKZqV
         woCphuzEoR2IqICvpwukTv7FZbYCB/se/yK/pt6jH5YEPOwZPmPew5tdTY0+p0lCs73U
         MRML7i0xaAi3U2+fLiem572dqlfUklOPTTkIkexoURgAwVW+vhNIn8V9ezb7MVfkAnl8
         UfzBfopJ9sjb0IBz+FwOluNy5hrEI/9Xa6CLr6ca+TPuDWkVQ1owCC0hdOHaqCcjVWI3
         qlqHAndJhKsJ6qIg+VyThK82q030MkkZygeRImCnXs2TIvZ96qzFjuXSlcPkdeWkUs4n
         TyFA==
X-Gm-Message-State: AC+VfDxTeO/lmktKiTCurw6SLiLG1oIlbdeVHFrrFXW5Ue5nIzbsqSjp
	eYBemS1xEjTFXyW+lMmqvDDbeeeAqMX8bJgfCmg=
X-Google-Smtp-Source: ACHHUZ6CP3RAxS4MiPzEnnsu81W7pBZjzi4jFjIAbaMUczyZUYfF02xSSqtxx+KjMnDdqMzPkKPgNKQs3n5xAi3rGJ8=
X-Received: by 2002:a17:90b:3881:b0:246:c097:6a17 with SMTP id
 mu1-20020a17090b388100b00246c0976a17mr7071081pjb.24.1683448647468; Sun, 07
 May 2023 01:37:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230505022317.22417-1-peter_hong@fintek.com.tw>
In-Reply-To: <20230505022317.22417-1-peter_hong@fintek.com.tw>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Sun, 7 May 2023 17:37:14 +0900
Message-ID: <CAMZ6RqKD1X=mo3LiH37XLAuVWCMF-BoJkcfw7Hc_rYZQQ4nFAQ@mail.gmail.com>
Subject: Re: [PATCH V6] can: usb: f81604: add Fintek F81604 support
To: "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
Cc: wg@grandegger.com, mkl@pengutronix.de, michal.swiatkowski@linux.intel.com, 
	Steen.Hegelund@microchip.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, frank.jungclaus@esd.eu, 
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org, 
	netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Peter,

Thanks for the v6. I added two nitpicks. It is up to you where you
want or not to fix those. Aside from that, it looks good.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Le ven. 5 mai 2023 =C3=A0 11:25, Ji-Ze Hong (Peter Hong)
<peter_hong@fintek.com.tw> a =C3=A9crit :
>
> This patch adds support for Fintek USB to 2CAN controller.
>
> Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> ---
> Changelog:
> v6:
>         1. Remove non-used define and change constant mask to GENMASK().
>         2. Move some variables declaration from function start to block s=
tart.
>         3. Move some variables initization into declaration.
>         4. Change variable "id" in f81604_start_xmit() only for CAN ID us=
age.
>
> v5:
>         1. Change all u8 *buff to struct f81604_int_data/f81604_can_frame=
.
>         2. Change all netdev->dev_id to netdev->dev_port.
>         3. Remove over design for f81604_process_rx_packet(). This device=
 only
>            report a frame at once, so the f81604_process_rx_packet() are =
reduced
>            to process 1 frame.
>
> v4:
>         1. Remove f81604_prepare_urbs/f81604_remove_urbs() and alloc URB/=
buffer
>            dynamically in f81604_register_urbs(), using "urbs_anchor" for=
 manage
>            all rx/int URBs.
>         2. Add F81604 to MAINTAINERS list.
>         3. Change handle_clear_reg_work/handle_clear_overrun_work to sing=
le
>            clear_reg_work and using bitwise "clear_flags" to record it.
>         4. Move __f81604_set_termination in front of f81604_probe() to av=
oid
>            rarely racing condition.
>         5. Add __aligned to struct f81604_int_data / f81604_sff / f81604_=
eff.
>         6. Add aligned operations in f81604_start_xmit/f81604_process_rx_=
packet().
>         7. Change lots of CANBUS functions first parameter from struct us=
b_device*
>            to struct f81604_port_priv *priv. But remain f81604_write / f8=
1604_read
>            / f81604_update_bits() as struct usb_device* for
>            __f81604_set_termination() in probe() stage.
>         8. Simplify f81604_read_int_callback() and separate into
>            f81604_handle_tx / f81604_handle_can_bus_errors() functions.
>
> v3:
>         1. Change CAN clock to using MEGA units.
>         2. Remove USB set/get retry, only remain SJA1000 reset/operation =
retry.
>         3. Fix all numberic constant to define.
>         4. Add terminator control. (only 0 & 120 ohm)
>         5. Using struct data to represent INT/TX/RX endpoints data instea=
d byte
>            arrays.
>         6. Error message reports changed from %d to %pe for mnemotechnic =
values.
>         7. Some bit operations are changed to FIELD_PREP().
>         8. Separate TX functions from f81604_read_int_callback().
>         9. cf->can_id |=3D CAN_ERR_CNT in f81604_read_int_callback to rep=
ort valid
>            TX/RX error counts.
>         10. Move f81604_prepare_urbs/f81604_remove_urbs() from CAN open/c=
lose() to
>             USB probe/disconnect().
>         11. coding style refactoring.
>
> v2:
>         1. coding style refactoring.
>         2. some const number are defined to describe itself.
>         3. fix wrong usage for can_get_echo_skb() in f81604_write_bulk_ca=
llback().
>
>  MAINTAINERS                  |    6 +
>  drivers/net/can/usb/Kconfig  |   12 +
>  drivers/net/can/usb/Makefile |    1 +
>  drivers/net/can/usb/f81604.c | 1205 ++++++++++++++++++++++++++++++++++
>  4 files changed, 1224 insertions(+)
>  create mode 100644 drivers/net/can/usb/f81604.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f375bbf3bc80..fa573f637c2f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8058,6 +8058,12 @@ S:       Maintained
>  F:     drivers/hwmon/f75375s.c
>  F:     include/linux/f75375s.h
>
> +FINTEK F81604 USB to 2xCANBUS DEVICE DRIVER
> +M:     Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> +L:     linux-can@vger.kernel.org
> +S:     Maintained
> +F:     drivers/net/can/usb/f81604.c
> +
>  FIREWIRE AUDIO DRIVERS and IEC 61883-1/6 PACKET STREAMING ENGINE
>  M:     Clemens Ladisch <clemens@ladisch.de>
>  M:     Takashi Sakamoto <o-takashi@sakamocchi.jp>
> diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
> index 445504ababce..58fcd2b34820 100644
> --- a/drivers/net/can/usb/Kconfig
> +++ b/drivers/net/can/usb/Kconfig
> @@ -38,6 +38,18 @@ config CAN_ETAS_ES58X
>           To compile this driver as a module, choose M here: the module
>           will be called etas_es58x.
>
> +config CAN_F81604
> +        tristate "Fintek F81604 USB to 2CAN interface"
> +        help
> +          This driver supports the Fintek F81604 USB to 2CAN interface.
> +          The device can support CAN2.0A/B protocol and also support
> +          2 output pins to control external terminator (optional).
> +
> +          To compile this driver as a module, choose M here: the module =
will
> +          be called f81604.
> +
> +          (see also https://www.fintek.com.tw).
> +
>  config CAN_GS_USB
>         tristate "Geschwister Schneider UG and candleLight compatible int=
erfaces"
>         help
> diff --git a/drivers/net/can/usb/Makefile b/drivers/net/can/usb/Makefile
> index 1ea16be5743b..8b11088e9a59 100644
> --- a/drivers/net/can/usb/Makefile
> +++ b/drivers/net/can/usb/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_CAN_8DEV_USB) +=3D usb_8dev.o
>  obj-$(CONFIG_CAN_EMS_USB) +=3D ems_usb.o
>  obj-$(CONFIG_CAN_ESD_USB) +=3D esd_usb.o
>  obj-$(CONFIG_CAN_ETAS_ES58X) +=3D etas_es58x/
> +obj-$(CONFIG_CAN_F81604) +=3D f81604.o
>  obj-$(CONFIG_CAN_GS_USB) +=3D gs_usb.o
>  obj-$(CONFIG_CAN_KVASER_USB) +=3D kvaser_usb/
>  obj-$(CONFIG_CAN_MCBA_USB) +=3D mcba_usb.o
> diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
> new file mode 100644
> index 000000000000..36839140ba5f
> --- /dev/null
> +++ b/drivers/net/can/usb/f81604.c
> @@ -0,0 +1,1205 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Fintek F81604 USB-to-2CAN controller driver.
> + *
> + * Copyright (C) 2023 Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
> + */
> +#include <linux/bitfield.h>
> +#include <linux/netdevice.h>
> +#include <linux/units.h>
> +#include <linux/usb.h>
> +
> +#include <linux/can.h>
> +#include <linux/can/dev.h>
> +#include <linux/can/error.h>
> +#include <linux/can/platform/sja1000.h>
> +
> +#include <asm-generic/unaligned.h>
> +
> +/* vendor and product id */
> +#define F81604_VENDOR_ID 0x2c42
> +#define F81604_PRODUCT_ID 0x1709
> +#define F81604_CAN_CLOCK (12 * MEGA)
> +#define F81604_MAX_DEV 2
> +#define F81604_SET_DEVICE_RETRY 10
> +
> +#define F81604_USB_TIMEOUT 2000
> +#define F81604_SET_GET_REGISTER 0xA0
> +#define F81604_PORT_OFFSET 0x1000
> +#define F81604_MAX_RX_URBS 4
> +
> +#define F81604_CMD_DATA 0x00
> +
> +#define F81604_DLC_LEN_MASK GENMASK(3, 0)
> +#define F81604_DLC_EFF_BIT BIT(7)
> +#define F81604_DLC_RTR_BIT BIT(6)
> +
> +#define F81604_SFF_SHIFT 5
> +#define F81604_EFF_SHIFT 3
> +
> +#define F81604_BRP_MASK GENMASK(5, 0)
> +#define F81604_SJW_MASK GENMASK(7, 6)
> +
> +#define F81604_SEG1_MASK GENMASK(3, 0)
> +#define F81604_SEG2_MASK GENMASK(6, 4)
> +
> +#define F81604_CLEAR_ALC 0
> +#define F81604_CLEAR_ECC 1
> +#define F81604_CLEAR_OVERRUN 2
> +
> +/* device setting */
> +#define F81604_CTRL_MODE_REG 0x80
> +#define F81604_TX_ONESHOT (0x03 << 3)
> +#define F81604_TX_NORMAL (0x01 << 3)
> +#define F81604_RX_AUTO_RELEASE_BUF BIT(1)
> +#define F81604_INT_WHEN_CHANGE BIT(0)
> +
> +#define F81604_TERMINATOR_REG 0x105
> +#define F81604_CAN0_TERM BIT(2)
> +#define F81604_CAN1_TERM BIT(3)
> +
> +#define F81604_TERMINATION_DISABLED CAN_TERMINATION_DISABLED
> +#define F81604_TERMINATION_ENABLED 120
> +
> +/* SJA1000 registers - manual section 6.4 (Pelican Mode) */
> +#define F81604_SJA1000_MOD 0x00
> +#define F81604_SJA1000_CMR 0x01
> +#define F81604_SJA1000_IR 0x03
> +#define F81604_SJA1000_IER 0x04
> +#define F81604_SJA1000_ALC 0x0B
> +#define F81604_SJA1000_ECC 0x0C
> +#define F81604_SJA1000_RXERR 0x0E
> +#define F81604_SJA1000_TXERR 0x0F
> +#define F81604_SJA1000_ACCC0 0x10
> +#define F81604_SJA1000_ACCM0 0x14
> +#define F81604_MAX_FILTER_CNT 4
> +
> +/* Common registers - manual section 6.5 */
> +#define F81604_SJA1000_BTR0 0x06
> +#define F81604_SJA1000_BTR1 0x07
> +#define F81604_SJA1000_BTR1_SAMPLE_TRIPLE BIT(7)
> +#define F81604_SJA1000_OCR 0x08
> +#define F81604_SJA1000_CDR 0x1F
> +
> +/* mode register */
> +#define F81604_SJA1000_MOD_RM 0x01
> +#define F81604_SJA1000_MOD_LOM 0x02
> +#define F81604_SJA1000_MOD_STM 0x04
> +
> +/* commands */
> +#define F81604_SJA1000_CMD_CDO 0x08
> +
> +/* interrupt sources */
> +#define F81604_SJA1000_IRQ_BEI 0x80
> +#define F81604_SJA1000_IRQ_ALI 0x40
> +#define F81604_SJA1000_IRQ_EPI 0x20
> +#define F81604_SJA1000_IRQ_DOI 0x08
> +#define F81604_SJA1000_IRQ_EI 0x04
> +#define F81604_SJA1000_IRQ_TI 0x02
> +#define F81604_SJA1000_IRQ_RI 0x01
> +#define F81604_SJA1000_IRQ_ALL 0xFF
> +#define F81604_SJA1000_IRQ_OFF 0x00
> +
> +/* status register content */
> +#define F81604_SJA1000_SR_BS 0x80
> +#define F81604_SJA1000_SR_ES 0x40
> +#define F81604_SJA1000_SR_TCS 0x08
> +
> +/* ECC register */
> +#define F81604_SJA1000_ECC_SEG 0x1F
> +#define F81604_SJA1000_ECC_DIR 0x20
> +#define F81604_SJA1000_ECC_BIT 0x00
> +#define F81604_SJA1000_ECC_FORM 0x40
> +#define F81604_SJA1000_ECC_STUFF 0x80
> +#define F81604_SJA1000_ECC_MASK 0xc0
> +
> +/* ALC register */
> +#define F81604_SJA1000_ALC_MASK 0x1f
> +
> +/* table of devices that work with this driver */
> +static const struct usb_device_id f81604_table[] =3D {
> +       { USB_DEVICE(F81604_VENDOR_ID, F81604_PRODUCT_ID) },
> +       {} /* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, f81604_table);
> +
> +static const struct ethtool_ops f81604_ethtool_ops =3D {
> +       .get_ts_info =3D ethtool_op_get_ts_info,
> +};
> +
> +static const u16 f81604_termination[] =3D { F81604_TERMINATION_DISABLED,
> +                                         F81604_TERMINATION_ENABLED };
> +
> +struct f81604_priv {
> +       struct net_device *netdev[F81604_MAX_DEV];
> +};
> +
> +struct f81604_port_priv {
> +       struct can_priv can;
> +       struct net_device *netdev;
> +       struct sk_buff *echo_skb;
> +
> +       unsigned long clear_flags;
> +       struct work_struct clear_reg_work;
> +
> +       struct usb_device *dev;
> +       struct usb_interface *intf;
> +
> +       struct usb_anchor urbs_anchor;
> +};
> +
> +/* Interrupt endpoint data format:
> + *     Byte 0: Status register.
> + *     Byte 1: Interrupt register.
> + *     Byte 2: Interrupt enable register.
> + *     Byte 3: Arbitration lost capture(ALC) register.
> + *     Byte 4: Error code capture(ECC) register.
> + *     Byte 5: Error warning limit register.
> + *     Byte 6: RX error counter register.
> + *     Byte 7: TX error counter register.
> + *     Byte 8: Reserved.
> + */
> +struct f81604_int_data {
> +       u8 sr;
> +       u8 isrc;
> +       u8 ier;
> +       u8 alc;
> +       u8 ecc;
> +       u8 ewlr;
> +       u8 rxerr;
> +       u8 txerr;
> +       u8 val;
> +} __packed __aligned(4);
> +
> +struct f81604_sff {
> +       __be16 id;
> +       u8 data[CAN_MAX_DLEN];
> +} __packed __aligned(2);
> +
> +struct f81604_eff {
> +       __be32 id;
> +       u8 data[CAN_MAX_DLEN];
> +} __packed __aligned(2);
> +
> +struct f81604_can_frame {
> +       u8 cmd;
> +
> +       /* According for F81604 DLC define:
> +        *      bit 3~0: data length (0~8)
> +        *      bit6: is RTR flag.
> +        *      bit7: is EFF frame.
> +        */
> +       u8 dlc;
> +
> +       union {
> +               struct f81604_sff sff;
> +               struct f81604_eff eff;
> +       };
> +} __packed __aligned(2);
> +
> +static const u8 bulk_in_addr[F81604_MAX_DEV] =3D { 2, 4 };
> +static const u8 bulk_out_addr[F81604_MAX_DEV] =3D { 1, 3 };
> +static const u8 int_in_addr[F81604_MAX_DEV] =3D { 1, 3 };
> +
> +static int f81604_write(struct usb_device *dev, u16 reg, u8 data)
> +{
> +       int ret;
> +
> +       ret =3D usb_control_msg_send(dev, 0, F81604_SET_GET_REGISTER,
> +                                  USB_TYPE_VENDOR | USB_DIR_OUT, 0, reg,
> +                                  &data, sizeof(data), F81604_USB_TIMEOU=
T,
> +                                  GFP_KERNEL);
> +       if (ret)
> +               dev_err(&dev->dev, "%s: reg: %x data: %x failed: %pe\n",
> +                       __func__, reg, data, ERR_PTR(ret));
> +
> +       return ret;
> +}
> +
> +static int f81604_read(struct usb_device *dev, u16 reg, u8 *data)
> +{
> +       int ret;
> +
> +       ret =3D usb_control_msg_recv(dev, 0, F81604_SET_GET_REGISTER,
> +                                  USB_TYPE_VENDOR | USB_DIR_IN, 0, reg, =
data,
> +                                  sizeof(*data), F81604_USB_TIMEOUT,
> +                                  GFP_KERNEL);
> +
> +       if (ret < 0)
> +               dev_err(&dev->dev, "%s: reg: %x failed: %pe\n", __func__,=
 reg,
> +                       ERR_PTR(ret));
> +
> +       return ret;
> +}
> +
> +static int f81604_update_bits(struct usb_device *dev, u16 reg, u8 mask,
> +                             u8 data)
> +{
> +       int ret;
> +       u8 tmp;
> +
> +       ret =3D f81604_read(dev, reg, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       tmp &=3D ~mask;
> +       tmp |=3D (mask & data);
> +
> +       return f81604_write(dev, reg, tmp);
> +}
> +
> +static int f81604_sja1000_write(struct f81604_port_priv *priv, u16 reg,
> +                               u8 data)
> +{
> +       int port =3D priv->netdev->dev_port;
> +       int real_reg;
> +
> +       real_reg =3D reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET=
;
> +       return f81604_write(priv->dev, real_reg, data);
> +}
> +
> +static int f81604_sja1000_read(struct f81604_port_priv *priv, u16 reg,
> +                              u8 *data)
> +{
> +       int port =3D priv->netdev->dev_port;
> +       int real_reg;
> +
> +       real_reg =3D reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET=
;
> +       return f81604_read(priv->dev, real_reg, data);
> +}
> +
> +static int f81604_set_reset_mode(struct f81604_port_priv *priv)
> +{
> +       int ret, i;
> +       u8 tmp;
> +
> +       /* disable interrupts */
> +       ret =3D f81604_sja1000_write(priv, F81604_SJA1000_IER,
> +                                  F81604_SJA1000_IRQ_OFF);
> +       if (ret)
> +               return ret;
> +
> +       for (i =3D 0; i < F81604_SET_DEVICE_RETRY; i++) {
> +               ret =3D f81604_sja1000_read(priv, F81604_SJA1000_MOD, &tm=
p);
> +               if (ret)
> +                       return ret;
> +
> +               /* check reset bit */
> +               if (tmp & F81604_SJA1000_MOD_RM) {
> +                       priv->can.state =3D CAN_STATE_STOPPED;
> +                       return 0;
> +               }
> +
> +               /* reset chip */
> +               ret =3D f81604_sja1000_write(priv, F81604_SJA1000_MOD,
> +                                          F81604_SJA1000_MOD_RM);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return -EPERM;
> +}
> +
> +static int f81604_set_normal_mode(struct f81604_port_priv *priv)
> +{
> +       u8 tmp, ier =3D 0;
> +       u8 mod_reg =3D 0;
> +       int ret, i;
> +
> +       for (i =3D 0; i < F81604_SET_DEVICE_RETRY; i++) {
> +               ret =3D f81604_sja1000_read(priv, F81604_SJA1000_MOD, &tm=
p);
> +               if (ret)
> +                       return ret;
> +
> +               /* check reset bit */
> +               if ((tmp & F81604_SJA1000_MOD_RM) =3D=3D 0) {
> +                       priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
> +                       /* enable interrupts, RI handled by bulk-in */
> +                       ier =3D F81604_SJA1000_IRQ_ALL & ~F81604_SJA1000_=
IRQ_RI;
> +                       if (!(priv->can.ctrlmode &
> +                             CAN_CTRLMODE_BERR_REPORTING))
> +                               ier &=3D ~F81604_SJA1000_IRQ_BEI;
> +
> +                       return f81604_sja1000_write(priv, F81604_SJA1000_=
IER,
> +                                                   ier);
> +               }
> +
> +               /* set chip to normal mode */
> +               if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> +                       mod_reg |=3D F81604_SJA1000_MOD_LOM;
> +               if (priv->can.ctrlmode & CAN_CTRLMODE_PRESUME_ACK)
> +                       mod_reg |=3D F81604_SJA1000_MOD_STM;
> +
> +               ret =3D f81604_sja1000_write(priv, F81604_SJA1000_MOD, mo=
d_reg);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return -EPERM;
> +}
> +
> +static int f81604_chipset_init(struct f81604_port_priv *priv)
> +{
> +       int i, ret;
> +
> +       /* set clock divider and output control register */
> +       ret =3D f81604_sja1000_write(priv, F81604_SJA1000_CDR,
> +                                  CDR_CBP | CDR_PELICAN);
> +       if (ret)
> +               return ret;
> +
> +       /* set acceptance filter (accept all) */
> +       for (i =3D 0; i < F81604_MAX_FILTER_CNT; ++i) {
> +               ret =3D f81604_sja1000_write(priv, F81604_SJA1000_ACCC0 +=
 i, 0);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       for (i =3D 0; i < F81604_MAX_FILTER_CNT; ++i) {
> +               ret =3D f81604_sja1000_write(priv, F81604_SJA1000_ACCM0 +=
 i,
> +                                          0xFF);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return f81604_sja1000_write(priv, F81604_SJA1000_OCR,
> +                                   OCR_TX0_PUSHPULL | OCR_TX1_PUSHPULL |
> +                                           OCR_MODE_NORMAL);
> +}
> +
> +static void f81604_process_rx_packet(struct net_device *netdev,
> +                                    struct f81604_can_frame *frame)
> +{
> +       struct net_device_stats *stats =3D &netdev->stats;
> +       struct can_frame *cf;
> +       struct sk_buff *skb;
> +
> +       if (frame->cmd !=3D F81604_CMD_DATA)
> +               return;
> +
> +       skb =3D alloc_can_skb(netdev, &cf);
> +       if (!skb) {
> +               stats->rx_dropped++;
> +               return;
> +       }
> +
> +       cf->len =3D can_cc_dlc2len(frame->dlc & F81604_DLC_LEN_MASK);
> +
> +       if (frame->dlc & F81604_DLC_EFF_BIT) {
> +               cf->can_id =3D get_unaligned_be32(&frame->eff.id) >>
> +                            F81604_EFF_SHIFT;
> +               cf->can_id |=3D CAN_EFF_FLAG;
> +
> +               if (!(frame->dlc & F81604_DLC_RTR_BIT))
> +                       memcpy(cf->data, frame->eff.data, cf->len);
> +       } else {
> +               cf->can_id =3D get_unaligned_be16(&frame->sff.id) >>
> +                            F81604_SFF_SHIFT;
> +
> +               if (!(frame->dlc & F81604_DLC_RTR_BIT))
> +                       memcpy(cf->data, frame->sff.data, cf->len);
> +       }
> +
> +       if (frame->dlc & F81604_DLC_RTR_BIT)
> +               cf->can_id |=3D CAN_RTR_FLAG;
> +       else
> +               stats->rx_bytes +=3D cf->len;
> +
> +       stats->rx_packets++;
> +       netif_rx(skb);
> +}
> +
> +static void f81604_read_bulk_callback(struct urb *urb)
> +{
> +       struct f81604_can_frame *frame =3D urb->transfer_buffer;
> +       struct net_device *netdev =3D urb->context;
> +       int ret;
> +
> +       if (!netif_device_present(netdev))
> +               return;
> +
> +       if (urb->status)
> +               netdev_info(netdev, "%s: URB aborted %pe\n", __func__,
> +                           ERR_PTR(urb->status));
> +
> +       switch (urb->status) {
> +       case 0: /* success */
> +               break;
> +
> +       case -ENOENT:
> +       case -EPIPE:
> +       case -EPROTO:
> +       case -ESHUTDOWN:
> +               return;
> +
> +       default:
> +               goto resubmit_urb;
> +       }
> +
> +       if (urb->actual_length !=3D sizeof(*frame)) {
> +               netdev_warn(netdev, "URB length %u not equal to %lu\n",
> +                           urb->actual_length, sizeof(*frame));
> +               goto resubmit_urb;
> +       }
> +
> +       f81604_process_rx_packet(netdev, frame);
> +
> +resubmit_urb:
> +       ret =3D usb_submit_urb(urb, GFP_ATOMIC);
> +       if (ret =3D=3D -ENODEV)
> +               netif_device_detach(netdev);
> +       else if (ret)
> +               netdev_err(netdev,
> +                          "%s: failed to resubmit read bulk urb: %pe\n",
> +                          __func__, ERR_PTR(ret));
> +}
> +
> +static void f81604_handle_tx(struct f81604_port_priv *priv,
> +                            struct f81604_int_data *data)
> +{
> +       struct net_device *netdev =3D priv->netdev;
> +       struct net_device_stats *stats =3D &netdev->stats;
> +
> +       /* transmission buffer released */
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
> +           !(data->sr & F81604_SJA1000_SR_TCS)) {
> +               stats->tx_errors++;
> +               can_free_echo_skb(netdev, 0, NULL);
> +       } else {
> +               /* transmission complete */
> +               stats->tx_bytes +=3D can_get_echo_skb(netdev, 0, NULL);
> +               stats->tx_packets++;
> +       }
> +
> +       netif_wake_queue(netdev);
> +}
> +
> +static void f81604_handle_can_bus_errors(struct f81604_port_priv *priv,
> +                                        struct f81604_int_data *data)
> +{
> +       enum can_state can_state =3D priv->can.state;
> +       struct net_device *netdev =3D priv->netdev;
> +       struct net_device_stats *stats =3D &netdev->stats;
> +       struct can_frame *cf;
> +       struct sk_buff *skb;
> +
> +       /* Note: ALC/ECC will not auto clear by read here, must be cleare=
d by
> +        * read register (via clear_reg_work).
> +        */
> +
> +       skb =3D alloc_can_err_skb(netdev, &cf);
> +       if (skb) {
> +               cf->can_id |=3D CAN_ERR_CNT;
> +               cf->data[6] =3D data->txerr;
> +               cf->data[7] =3D data->rxerr;
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_DOI) {
> +               /* data overrun interrupt */
> +               netdev_dbg(netdev, "data overrun interrupt\n");
> +
> +               if (skb) {
> +                       cf->can_id |=3D CAN_ERR_CRTL;
> +                       cf->data[1] =3D CAN_ERR_CRTL_RX_OVERFLOW;
> +               }
> +
> +               stats->rx_over_errors++;
> +               stats->rx_errors++;
> +
> +               set_bit(F81604_CLEAR_OVERRUN, &priv->clear_flags);
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_EI) {
> +               /* error warning interrupt */
> +               netdev_dbg(netdev, "error warning interrupt\n");
> +
> +               if (data->sr & F81604_SJA1000_SR_BS)
> +                       can_state =3D CAN_STATE_BUS_OFF;
> +               else if (data->sr & F81604_SJA1000_SR_ES)
> +                       can_state =3D CAN_STATE_ERROR_WARNING;
> +               else
> +                       can_state =3D CAN_STATE_ERROR_ACTIVE;
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_BEI) {
> +               /* bus error interrupt */
> +               netdev_dbg(netdev, "bus error interrupt\n");
> +
> +               priv->can.can_stats.bus_error++;
> +               stats->rx_errors++;
> +
> +               if (skb) {
> +                       cf->can_id |=3D CAN_ERR_PROT | CAN_ERR_BUSERROR;
> +
> +                       /* set error type */
> +                       switch (data->ecc & F81604_SJA1000_ECC_MASK) {
> +                       case F81604_SJA1000_ECC_BIT:
> +                               cf->data[2] |=3D CAN_ERR_PROT_BIT;
> +                               break;
> +                       case F81604_SJA1000_ECC_FORM:
> +                               cf->data[2] |=3D CAN_ERR_PROT_FORM;
> +                               break;
> +                       case F81604_SJA1000_ECC_STUFF:
> +                               cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> +                               break;
> +                       default:
> +                               break;
> +                       }
> +
> +                       /* set error location */
> +                       cf->data[3] =3D data->ecc & F81604_SJA1000_ECC_SE=
G;
> +
> +                       /* Error occurred during transmission? */
> +                       if ((data->ecc & F81604_SJA1000_ECC_DIR) =3D=3D 0=
)
> +                               cf->data[2] |=3D CAN_ERR_PROT_TX;
> +               }
> +
> +               set_bit(F81604_CLEAR_ECC, &priv->clear_flags);
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_EPI) {
> +               if (can_state =3D=3D CAN_STATE_ERROR_PASSIVE)
> +                       can_state =3D CAN_STATE_ERROR_WARNING;
> +               else
> +                       can_state =3D CAN_STATE_ERROR_PASSIVE;
> +
> +               /* error passive interrupt */
> +               netdev_dbg(netdev, "error passive interrupt: %d\n", can_s=
tate);
> +       }
> +
> +       if (data->isrc & F81604_SJA1000_IRQ_ALI) {
> +               /* arbitration lost interrupt */
> +               netdev_dbg(netdev, "arbitration lost interrupt\n");
> +
> +               priv->can.can_stats.arbitration_lost++;
> +
> +               if (skb) {
> +                       cf->can_id |=3D CAN_ERR_LOSTARB;
> +                       cf->data[0] =3D data->alc & F81604_SJA1000_ALC_MA=
SK;
> +               }
> +
> +               set_bit(F81604_CLEAR_ALC, &priv->clear_flags);
> +       }
> +
> +       if (can_state !=3D priv->can.state) {
> +               enum can_state tx_state, rx_state;
> +
> +               tx_state =3D data->txerr >=3D data->rxerr ? can_state : 0=
;
> +               rx_state =3D data->txerr <=3D data->rxerr ? can_state : 0=
;
> +
> +               can_change_state(netdev, cf, tx_state, rx_state);
> +
> +               if (can_state =3D=3D CAN_STATE_BUS_OFF)
> +                       can_bus_off(netdev);
> +       }
> +
> +       if (priv->clear_flags)
> +               schedule_work(&priv->clear_reg_work);
> +
> +       if (skb)
> +               netif_rx(skb);
> +}
> +
> +static void f81604_read_int_callback(struct urb *urb)
> +{
> +       struct f81604_int_data *data =3D urb->transfer_buffer;
> +       struct net_device *netdev =3D urb->context;
> +       struct f81604_port_priv *priv;
> +       int ret;
> +
> +       priv =3D netdev_priv(netdev);
> +
> +       if (!netif_device_present(netdev))
> +               return;
> +
> +       if (urb->status)
> +               netdev_info(netdev, "%s: Int URB aborted: %pe\n", __func_=
_,
> +                           ERR_PTR(urb->status));
> +
> +       switch (urb->status) {
> +       case 0: /* success */
> +               break;
> +
> +       case -ENOENT:
> +       case -EPIPE:
> +       case -EPROTO:
> +       case -ESHUTDOWN:
> +               return;
> +
> +       default:
> +               goto resubmit_urb;
> +       }
> +
> +       /* handle Errors */
> +       if (data->isrc & (F81604_SJA1000_IRQ_DOI | F81604_SJA1000_IRQ_EI =
|
> +                         F81604_SJA1000_IRQ_BEI | F81604_SJA1000_IRQ_EPI=
 |
> +                         F81604_SJA1000_IRQ_ALI))
> +               f81604_handle_can_bus_errors(priv, data);
> +
> +       /* handle TX */
> +       if (priv->can.state !=3D CAN_STATE_BUS_OFF &&
> +           (data->isrc & F81604_SJA1000_IRQ_TI))
> +               f81604_handle_tx(priv, data);
> +
> +resubmit_urb:
> +       ret =3D usb_submit_urb(urb, GFP_ATOMIC);
> +       if (ret =3D=3D -ENODEV)
> +               netif_device_detach(netdev);
> +       else if (ret)
> +               netdev_err(netdev, "%s: failed to resubmit int urb: %pe\n=
",
> +                          __func__, ERR_PTR(ret));
> +}
> +
> +static void f81604_unregister_urbs(struct f81604_port_priv *priv)
> +{
> +       usb_kill_anchored_urbs(&priv->urbs_anchor);
> +}
> +
> +static int f81604_register_urbs(struct f81604_port_priv *priv)
> +{
> +       struct net_device *netdev =3D priv->netdev;
> +       struct f81604_int_data *int_data;
> +       int id =3D netdev->dev_port;
> +       struct urb *int_urb;
> +       int rx_urb_cnt;
> +       int ret;

Nitpick: your style is inconsistent. Sometimes you have a new line
before the goto or return, sometimes not.

> +       for (rx_urb_cnt =3D 0; rx_urb_cnt < F81604_MAX_RX_URBS; ++rx_urb_=
cnt) {
> +               struct f81604_can_frame *frame;
> +               struct urb *rx_urb;
> +
> +               rx_urb =3D usb_alloc_urb(0, GFP_KERNEL);
> +               if (!rx_urb) {
> +                       ret =3D -ENOMEM;
> +                       break;
> +               }
> +
> +               frame =3D kmalloc(sizeof(*frame), GFP_KERNEL);
> +               if (!frame) {
> +                       usb_free_urb(rx_urb);
> +                       ret =3D -ENOMEM;
> +                       break;

...no new line, ...

> +               }
> +
> +               usb_fill_bulk_urb(rx_urb, priv->dev,
> +                                 usb_rcvbulkpipe(priv->dev, bulk_in_addr=
[id]),
> +                                 frame, sizeof(*frame),
> +                                 f81604_read_bulk_callback, netdev);
> +
> +               rx_urb->transfer_flags |=3D URB_FREE_BUFFER;
> +               usb_anchor_urb(rx_urb, &priv->urbs_anchor);
> +
> +               ret =3D usb_submit_urb(rx_urb, GFP_KERNEL);
> +               if (ret) {
> +                       usb_unanchor_urb(rx_urb);
> +                       usb_free_urb(rx_urb);
> +
> +                       break;

...new line, ...

> +               }
> +
> +               /* Drop reference, USB core will take care of freeing it =
*/
> +               usb_free_urb(rx_urb);
> +       }
> +
> +       if (rx_urb_cnt =3D=3D 0) {
> +               netdev_warn(netdev, "%s: submit rx urb failed: %pe\n",
> +                           __func__, ERR_PTR(ret));
> +
> +               goto error;

...new line, ...

> +       }
> +
> +       int_urb =3D usb_alloc_urb(0, GFP_KERNEL);
> +       if (!int_urb) {
> +               ret =3D -ENOMEM;
> +               goto error;

...no new line.

It would be great to be consistent with a unique style.

> +       }
> +
> +       int_data =3D kmalloc(sizeof(*int_data), GFP_KERNEL);
> +       if (!int_data) {
> +               usb_free_urb(int_urb);
> +               ret =3D -ENOMEM;
> +               goto error;
> +       }
> +
> +       usb_fill_int_urb(int_urb, priv->dev,
> +                        usb_rcvintpipe(priv->dev, int_in_addr[id]), int_=
data,
> +                        sizeof(*int_data), f81604_read_int_callback, net=
dev,
> +                        1);
> +
> +       int_urb->transfer_flags |=3D URB_FREE_BUFFER;
> +       usb_anchor_urb(int_urb, &priv->urbs_anchor);
> +
> +       ret =3D usb_submit_urb(int_urb, GFP_KERNEL);
> +       if (ret) {
> +               usb_unanchor_urb(int_urb);
> +               usb_free_urb(int_urb);
> +
> +               netdev_warn(netdev, "%s: submit int urb failed: %pe\n",
> +                           __func__, ERR_PTR(ret));
> +               goto error;
> +       }
> +
> +       /* Drop reference, USB core will take care of freeing it */
> +       usb_free_urb(int_urb);
> +
> +       return 0;
> +
> +error:
> +       f81604_unregister_urbs(priv);
> +       return ret;
> +}
> +
> +static int f81604_start(struct net_device *netdev)
> +{
> +       struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +       int ret;
> +       u8 mode;
> +       u8 tmp;
> +
> +       mode =3D F81604_RX_AUTO_RELEASE_BUF | F81604_INT_WHEN_CHANGE;
> +
> +       /* Set TR/AT mode */
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
> +               mode |=3D F81604_TX_ONESHOT;
> +       else
> +               mode |=3D F81604_TX_NORMAL;
> +
> +       ret =3D f81604_sja1000_write(priv, F81604_CTRL_MODE_REG, mode);
> +       if (ret)
> +               return ret;
> +
> +       /* set reset mode */
> +       ret =3D f81604_set_reset_mode(priv);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_chipset_init(priv);
> +       if (ret)
> +               return ret;
> +
> +       /* Clear error counters and error code capture */
> +       ret =3D f81604_sja1000_write(priv, F81604_SJA1000_TXERR, 0);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_sja1000_write(priv, F81604_SJA1000_RXERR, 0);
> +       if (ret)
> +               return ret;
> +
> +       /* Read clear for ECC/ALC/IR register */
> +       ret =3D f81604_sja1000_read(priv, F81604_SJA1000_ECC, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_sja1000_read(priv, F81604_SJA1000_ALC, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_sja1000_read(priv, F81604_SJA1000_IR, &tmp);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_register_urbs(priv);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_set_normal_mode(priv);
> +       if (ret) {
> +               f81604_unregister_urbs(priv);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int f81604_set_bittiming(struct net_device *dev)
> +{
> +       struct f81604_port_priv *priv =3D netdev_priv(dev);
> +       struct can_bittiming *bt =3D &priv->can.bittiming;
> +       u8 btr0, btr1;
> +       int ret;
> +
> +       btr0 =3D FIELD_PREP(F81604_BRP_MASK, bt->brp - 1) |
> +              FIELD_PREP(F81604_SJW_MASK, bt->sjw - 1);
> +
> +       btr1 =3D FIELD_PREP(F81604_SEG1_MASK,
> +                         bt->prop_seg + bt->phase_seg1 - 1) |
> +              FIELD_PREP(F81604_SEG2_MASK, bt->phase_seg2 - 1);
> +
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
> +               btr1 |=3D F81604_SJA1000_BTR1_SAMPLE_TRIPLE;
> +
> +       ret =3D f81604_sja1000_write(priv, F81604_SJA1000_BTR0, btr0);
> +       if (ret) {
> +               netdev_warn(dev, "%s: Set BTR0 failed: %pe\n", __func__,
> +                           ERR_PTR(ret));
> +               return ret;
> +       }
> +
> +       ret =3D f81604_sja1000_write(priv, F81604_SJA1000_BTR1, btr1);
> +       if (ret) {
> +               netdev_warn(dev, "%s: Set BTR1 failed: %pe\n", __func__,
> +                           ERR_PTR(ret));
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int f81604_set_mode(struct net_device *netdev, enum can_mode mode=
)
> +{
> +       int ret;
> +
> +       switch (mode) {
> +       case CAN_MODE_START:
> +               ret =3D f81604_start(netdev);
> +               if (!ret && netif_queue_stopped(netdev))
> +                       netif_wake_queue(netdev);
> +               break;
> +
> +       default:
> +               ret =3D -EOPNOTSUPP;
> +       }
> +
> +       return ret;
> +}
> +
> +static void f81604_write_bulk_callback(struct urb *urb)
> +{
> +       struct net_device *netdev =3D urb->context;
> +
> +       if (!netif_device_present(netdev))
> +               return;
> +
> +       if (urb->status)
> +               netdev_info(netdev, "%s: Tx URB error: %pe\n", __func__,
> +                           ERR_PTR(urb->status));
> +}
> +
> +static void f81604_clear_reg_work(struct work_struct *work)
> +{
> +       struct f81604_port_priv *priv;
> +       u8 tmp;
> +
> +       priv =3D container_of(work, struct f81604_port_priv, clear_reg_wo=
rk);
> +
> +       /* dummy read for clear Arbitration lost capture(ALC) register. *=
/
> +       if (test_and_clear_bit(F81604_CLEAR_ALC, &priv->clear_flags))
> +               f81604_sja1000_read(priv, F81604_SJA1000_ALC, &tmp);
> +
> +       /* dummy read for clear Error code capture(ECC) register. */
> +       if (test_and_clear_bit(F81604_CLEAR_ECC, &priv->clear_flags))
> +               f81604_sja1000_read(priv, F81604_SJA1000_ECC, &tmp);
> +
> +       /* dummy write for clear data overrun flag. */
> +       if (test_and_clear_bit(F81604_CLEAR_OVERRUN, &priv->clear_flags))
> +               f81604_sja1000_write(priv, F81604_SJA1000_CMR,
> +                                    F81604_SJA1000_CMD_CDO);
> +}
> +
> +static netdev_tx_t f81604_start_xmit(struct sk_buff *skb,
> +                                    struct net_device *netdev)
> +{
> +       struct can_frame *cf =3D (struct can_frame *)skb->data;
> +       struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +       struct net_device_stats *stats =3D &netdev->stats;
> +       struct f81604_can_frame *frame;
> +       struct urb *write_urb;
> +       int ret;
> +
> +       if (can_dev_dropped_skb(netdev, skb))
> +               return NETDEV_TX_OK;
> +
> +       netif_stop_queue(netdev);
> +
> +       write_urb =3D usb_alloc_urb(0, GFP_ATOMIC);
> +       if (!write_urb)
> +               goto nomem_urb;
> +
> +       frame =3D kzalloc(sizeof(*frame), GFP_ATOMIC);
> +       if (!frame)
> +               goto nomem_buf;
> +
> +       usb_fill_bulk_urb(write_urb, priv->dev,
> +                         usb_sndbulkpipe(priv->dev,
> +                                         bulk_out_addr[netdev->dev_port]=
),
> +                         frame, sizeof(*frame), f81604_write_bulk_callba=
ck,
> +                         priv->netdev);
> +
> +       write_urb->transfer_flags |=3D URB_FREE_BUFFER;
> +
> +       frame->cmd =3D F81604_CMD_DATA;
> +       frame->dlc =3D cf->len;
> +
> +       if (cf->can_id & CAN_RTR_FLAG)
> +               frame->dlc |=3D F81604_DLC_RTR_BIT;
> +
> +       if (cf->can_id & CAN_EFF_FLAG) {
> +               u32 id =3D (cf->can_id & CAN_EFF_MASK) << F81604_EFF_SHIF=
T;
> +
> +               put_unaligned_be32(id, &frame->eff.id);
> +
> +               frame->dlc |=3D F81604_DLC_EFF_BIT;
> +
> +               if (!(cf->can_id & CAN_RTR_FLAG))
> +                       memcpy(&frame->eff.data, cf->data, cf->len);
> +       } else {
> +               u32 id =3D (cf->can_id & CAN_SFF_MASK) << F81604_SFF_SHIF=
T;
> +
> +               put_unaligned_be16(id, &frame->sff.id);
> +
> +               if (!(cf->can_id & CAN_RTR_FLAG))
> +                       memcpy(&frame->sff.data, cf->data, cf->len);
> +       }
> +
> +       can_put_echo_skb(skb, netdev, 0, 0);
> +
> +       ret =3D usb_submit_urb(write_urb, GFP_ATOMIC);
> +       if (ret) {
> +               netdev_err(netdev, "%s: failed to resubmit tx bulk urb: %=
pe\n",
> +                          __func__, ERR_PTR(ret));
> +
> +               can_free_echo_skb(netdev, 0, NULL);
> +               stats->tx_dropped++;
> +               stats->tx_errors++;
> +
> +               if (ret =3D=3D -ENODEV)
> +                       netif_device_detach(netdev);
> +               else
> +                       netif_wake_queue(netdev);
> +       }
> +
> +       /* let usb core take care of this urb */
> +       usb_free_urb(write_urb);
> +
> +       return NETDEV_TX_OK;
> +
> +nomem_buf:
> +       usb_free_urb(write_urb);
> +
> +nomem_urb:
> +       dev_kfree_skb(skb);
> +       stats->tx_dropped++;
> +       stats->tx_errors++;
> +       netif_wake_queue(netdev);
> +
> +       return NETDEV_TX_OK;
> +}
> +
> +static int f81604_get_berr_counter(const struct net_device *netdev,
> +                                  struct can_berr_counter *bec)
> +{
> +       struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +       u8 txerr, rxerr;
> +       int ret;
> +
> +       ret =3D f81604_sja1000_read(priv, F81604_SJA1000_TXERR, &txerr);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_sja1000_read(priv, F81604_SJA1000_RXERR, &rxerr);
> +       if (ret)
> +               return ret;
> +
> +       bec->txerr =3D txerr;
> +       bec->rxerr =3D rxerr;
> +
> +       return 0;
> +}
> +
> +/* Open USB device */
> +static int f81604_open(struct net_device *netdev)
> +{
> +       int ret;
> +
> +       ret =3D open_candev(netdev);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D f81604_start(netdev);
> +       if (ret)
> +               goto start_failed;

Here, you have a single goto. You can remove the goto and put the
clean up directly in this if block.

> +       netif_start_queue(netdev);
> +       return 0;
> +
> +start_failed:
> +       if (ret =3D=3D -ENODEV)
> +               netif_device_detach(netdev);
> +
> +       close_candev(netdev);
> +
> +       return ret;
> +}
> +
> +/* Close USB device */
> +static int f81604_close(struct net_device *netdev)
> +{
> +       struct f81604_port_priv *priv =3D netdev_priv(netdev);
> +
> +       f81604_set_reset_mode(priv);
> +
> +       netif_stop_queue(netdev);
> +       cancel_work_sync(&priv->clear_reg_work);
> +       close_candev(netdev);
> +
> +       f81604_unregister_urbs(priv);
> +
> +       return 0;
> +}
> +
> +static const struct net_device_ops f81604_netdev_ops =3D {
> +       .ndo_open =3D f81604_open,
> +       .ndo_stop =3D f81604_close,
> +       .ndo_start_xmit =3D f81604_start_xmit,
> +       .ndo_change_mtu =3D can_change_mtu,
> +};
> +
> +static const struct can_bittiming_const f81604_bittiming_const =3D {
> +       .name =3D KBUILD_MODNAME,
> +       .tseg1_min =3D 1,
> +       .tseg1_max =3D 16,
> +       .tseg2_min =3D 1,
> +       .tseg2_max =3D 8,
> +       .sjw_max =3D 4,
> +       .brp_min =3D 1,
> +       .brp_max =3D 64,
> +       .brp_inc =3D 1,
> +};
> +
> +/* Called by the usb core when driver is unloaded or device is removed *=
/
> +static void f81604_disconnect(struct usb_interface *intf)
> +{
> +       struct f81604_priv *priv =3D usb_get_intfdata(intf);
> +       int i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(priv->netdev); ++i) {
> +               if (!priv->netdev[i])
> +                       continue;
> +
> +               unregister_netdev(priv->netdev[i]);
> +               free_candev(priv->netdev[i]);
> +       }
> +}
> +
> +static int __f81604_set_termination(struct usb_device *dev, int idx, u16=
 term)
> +{
> +       u8 mask, data =3D 0;
> +
> +       if (idx =3D=3D 0)
> +               mask =3D F81604_CAN0_TERM;
> +       else
> +               mask =3D F81604_CAN1_TERM;
> +
> +       if (term)
> +               data =3D mask;
> +
> +       return f81604_update_bits(dev, F81604_TERMINATOR_REG, mask, data)=
;
> +}
> +
> +static int f81604_set_termination(struct net_device *netdev, u16 term)
> +{
> +       struct f81604_port_priv *port_priv =3D netdev_priv(netdev);
> +
> +       ASSERT_RTNL();
> +
> +       return __f81604_set_termination(port_priv->dev, netdev->dev_port,
> +                                       term);
> +}
> +
> +static int f81604_probe(struct usb_interface *intf,
> +                       const struct usb_device_id *id)
> +{
> +       struct usb_device *dev =3D interface_to_usbdev(intf);
> +       struct net_device *netdev;
> +       struct f81604_priv *priv;
> +       int i, ret;
> +
> +       priv =3D devm_kzalloc(&intf->dev, sizeof(*priv), GFP_KERNEL);
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       usb_set_intfdata(intf, priv);
> +
> +       for (i =3D 0; i < ARRAY_SIZE(priv->netdev); ++i) {
> +               ret =3D __f81604_set_termination(dev, i, 0);
> +               if (ret) {
> +                       dev_err(&intf->dev,
> +                               "Setting termination of CH#%d failed: %pe=
\n",
> +                               i, ERR_PTR(ret));
> +                       return ret;
> +               }
> +       }
> +
> +       for (i =3D 0; i < ARRAY_SIZE(priv->netdev); ++i) {
> +               struct f81604_port_priv *port_priv;
> +
> +               netdev =3D alloc_candev(sizeof(*port_priv), 1);
> +               if (!netdev) {
> +                       dev_err(&intf->dev, "Couldn't alloc candev: %d\n"=
, i);
> +                       ret =3D -ENOMEM;
> +
> +                       goto failure_cleanup;
> +               }
> +
> +               port_priv =3D netdev_priv(netdev);
> +
> +               INIT_WORK(&port_priv->clear_reg_work, f81604_clear_reg_wo=
rk);
> +               init_usb_anchor(&port_priv->urbs_anchor);
> +
> +               port_priv->intf =3D intf;
> +               port_priv->dev =3D dev;
> +               port_priv->netdev =3D netdev;
> +               port_priv->can.clock.freq =3D F81604_CAN_CLOCK;
> +
> +               port_priv->can.termination_const =3D f81604_termination;
> +               port_priv->can.termination_const_cnt =3D
> +                       ARRAY_SIZE(f81604_termination);
> +               port_priv->can.bittiming_const =3D &f81604_bittiming_cons=
t;
> +               port_priv->can.do_set_bittiming =3D f81604_set_bittiming;
> +               port_priv->can.do_set_mode =3D f81604_set_mode;
> +               port_priv->can.do_set_termination =3D f81604_set_terminat=
ion;
> +               port_priv->can.do_get_berr_counter =3D f81604_get_berr_co=
unter;
> +               port_priv->can.ctrlmode_supported =3D
> +                       CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES =
|
> +                       CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTI=
NG |
> +                       CAN_CTRLMODE_PRESUME_ACK;
> +
> +               netdev->ethtool_ops =3D &f81604_ethtool_ops;
> +               netdev->netdev_ops =3D &f81604_netdev_ops;
> +               netdev->flags |=3D IFF_ECHO;
> +               netdev->dev_port =3D i;
> +
> +               SET_NETDEV_DEV(netdev, &intf->dev);
> +
> +               ret =3D register_candev(netdev);
> +               if (ret) {
> +                       netdev_err(netdev, "register CAN device failed: %=
pe\n",
> +                                  ERR_PTR(ret));
> +                       free_candev(netdev);
> +
> +                       goto failure_cleanup;
> +               }
> +
> +               priv->netdev[i] =3D netdev;
> +       }
> +
> +       return 0;
> +
> +failure_cleanup:
> +       f81604_disconnect(intf);
> +       return ret;
> +}
> +
> +static struct usb_driver f81604_driver =3D {
> +       .name =3D KBUILD_MODNAME,
> +       .probe =3D f81604_probe,
> +       .disconnect =3D f81604_disconnect,
> +       .id_table =3D f81604_table,
> +};
> +
> +module_usb_driver(f81604_driver);
> +
> +MODULE_AUTHOR("Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>");
> +MODULE_DESCRIPTION("Fintek F81604 USB to 2xCANBUS");
> +MODULE_LICENSE("GPL");
> --
> 2.17.1
>

