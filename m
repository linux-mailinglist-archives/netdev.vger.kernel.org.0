Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A296C9ACF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 07:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjC0FMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 01:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC0FMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 01:12:16 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750793AAA;
        Sun, 26 Mar 2023 22:12:10 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 32R5Amd8095649;
        Mon, 27 Mar 2023 13:10:48 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from localhost (192.168.1.128) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 27 Mar
 2023 13:10:49 +0800
From:   "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>,
        <michal.swiatkowski@linux.intel.com>,
        <Steen.Hegelund@microchip.com>, <mailhol.vincent@wanadoo.fr>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <frank.jungclaus@esd.eu>,
        <linux-kernel@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <hpeter+linux_kernel@gmail.com>,
        "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>
Subject: [PATCH V3] can: usb: f81604: add Fintek F81604 support
Date:   Mon, 27 Mar 2023 13:10:48 +0800
Message-ID: <20230327051048.11589-1-peter_hong@fintek.com.tw>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.128]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27528.001
X-TM-AS-Result: No-12.674800-8.000000-10
X-TMASE-MatchedRID: BzcyQBGNq9s/TqR73SoO86oXHZz/dXlxpxAd6mi1Ga3SJfGV2JAq5DB9
        ccde3hbUJDNqi6K9LCkN7pF9aYRtwJRIfjKGY4uaHlDQRrnQLaW061diBteN18iCh8yBqE+t+uB
        F2pTYODWZXky84nSt9c1PP4GttkJ78EfssfcKOWrXA3LnlKuVLF3n+beqvEXMsua3owu82VC+oA
        mvH3qvXYfoQt5MIOKLP6Cg6XciWTRaPCzml0uYFk7nLUqYrlslFIuBIWrdOePfUZT83lbkEL9Fz
        aJpEZM0ZRUjkVFROF4x0CtCS3QUqYWDz7mPxd0p9Ib/6w+1lWQpA2ExuipmWrgbJOZ434Bsi8xT
        7YmZq8ttq1lCNLu/2gUbdnO7NCE1vvHAd28bGMcgaafg6U60I/EpHaRtv5/Xnt/M15zYPUP/6m/
        bCt6ZYn4fsU2Mo5fdZ0z1YRx6t5O3zrkcqI0uiUgrT6bxTXEYQR7lWMXPA1uTXIluJLPGSwimMt
        6TSXWlEEjEhozUzdpAQTrgC+C3japewfICVJFzxvp0tuDMx3lJ0h0KLwFrgKG5P8xDq4BXfjneh
        on95VduU/zH5aXsGW+OJmpydfpyOUuWZKh7pQ8af13xqkuAAPlSepWcgdLPvAe75exuTNEjlbM9
        Cy/cBs1ITUtQv562W07vHHG/EeoNzYFS+u/Sm4ldKbZsGYatYjDXdM/x2VOJ6HF2/KHZ8HoAg3u
        1syYWuNK9gpe93N0QtWQZJqxoDBELe2nKwTwAngIgpj8eDcBZDL1gLmoa/Ep0ODI8GjvXKrauXd
        3MZDUD/dHyT/Xh7Q==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.674800-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27528.001
X-TM-SNTS-SMTP: CB22D827B264D3DA9C2A6C61835760C9ABAADB07B362930C81C2792F421979012000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 32R5Amd8095649
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for Fintek USB to 2CAN controller support.

Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
---
Changelog:
v3:
	1. Change CAN clock to using MEGA units.
	2. Remove USB set/get retry, only remain SJA1000 reset/operation retry.
	3. Fix all numberic constant to define.
	4. Add terminator control. (only 0 & 120 ohm)
	5. Using struct data to represent INT/TX/RX endpoints data instead byte
	   arrays.
	6. Error message reports changed from %d to %pe for mnemotechnic values.
	7. Some bit operations are changed to FIELD_PREP().
	8. Separate TX functions from f81604_read_int_callback().
	9. cf->can_id |= CAN_ERR_CNT in f81604_read_int_callback to report valid
	   TX/RX error counts.
	10. Move f81604_prepare_urbs/f81604_remove_urbs() from CAN open/close() to
	    USB probe/disconnect().
	11. coding style refactoring.

v2:
	1. coding style refactoring.
	2. some const number are defined to describe itself.
	3. fix wrong usage for can_get_echo_skb() in f81604_write_bulk_callback().

 drivers/net/can/usb/Kconfig  |   12 +
 drivers/net/can/usb/Makefile |    1 +
 drivers/net/can/usb/f81604.c | 1232 ++++++++++++++++++++++++++++++++++
 3 files changed, 1245 insertions(+)
 create mode 100644 drivers/net/can/usb/f81604.c

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 445504ababce..06ab92cd2ea7 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -147,4 +147,16 @@ config CAN_UCAN
 	          from Theobroma Systems like the A31-µQ7 and the RK3399-Q7
 	          (https://www.theobroma-systems.com/rk3399-q7)
 
+config CAN_F81604
+	tristate "Fintek F81604 USB to 2CAN interface"
+	help
+	  This driver supports the Fintek F81604 USB to 2CAN interface.
+	  The device can support CAN2.0A/B protocol and also support
+	  2 output pins to control external terminator (optional).
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called f81604.
+
+	  (see also https://www.fintek.com.tw).
+
 endmenu
diff --git a/drivers/net/can/usb/Makefile b/drivers/net/can/usb/Makefile
index 1ea16be5743b..9de0305a5cce 100644
--- a/drivers/net/can/usb/Makefile
+++ b/drivers/net/can/usb/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb/
 obj-$(CONFIG_CAN_MCBA_USB) += mcba_usb.o
 obj-$(CONFIG_CAN_PEAK_USB) += peak_usb/
 obj-$(CONFIG_CAN_UCAN) += ucan.o
+obj-$(CONFIG_CAN_F81604) += f81604.o
diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
new file mode 100644
index 000000000000..06cd5d95c44d
--- /dev/null
+++ b/drivers/net/can/usb/f81604.c
@@ -0,0 +1,1232 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Fintek F81604 USB-to-2CAN controller driver.
+ *
+ * Copyright (C) 2023 Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
+ */
+#include <linux/netdevice.h>
+#include <linux/usb.h>
+#include <linux/bitfield.h>
+#include <linux/units.h>
+
+#include <linux/can.h>
+#include <linux/can/dev.h>
+#include <linux/can/error.h>
+#include <linux/can/platform/sja1000.h>
+
+/* vendor and product id */
+#define F81604_VENDOR_ID 0x2c42
+#define F81604_PRODUCT_ID 0x1709
+#define F81604_CAN_CLOCK (24 * MEGA / 2)
+#define F81604_MAX_DEV 2
+#define F81604_SET_DEVICE_RETRY 100
+
+#define F81604_USB_TIMEOUT 2000
+#define F81604_SET_GET_REGISTER 0xA0
+#define F81604_PORT_OFFSET 0x1000
+
+#define F81604_BULK_SIZE 64
+#define F81604_INT_SIZE 16
+#define F81604_DATA_SIZE 14
+#define F81604_MAX_RX_URBS 4
+
+#define F81604_CMD_OFFSET 0x00
+#define F81604_CMD_DATA 0x00
+
+#define F81604_DLC_LEN_MASK 0x0f
+#define F81604_DLC_EFF_BIT BIT(7)
+#define F81604_DLC_RTR_BIT BIT(6)
+
+/* device setting */
+#define F81604_CTRL_MODE_REG 0x80
+#define F81604_TX_ONESHOT (0x03 << 3)
+#define F81604_TX_NORMAL (0x01 << 3)
+#define F81604_RX_AUTO_RELEASE_BUF BIT(1)
+#define F81604_INT_WHEN_CHANGE BIT(0)
+
+#define F81604_TERMINATOR_REG 0x105
+#define F81604_CAN0_TERM BIT(2)
+#define F81604_CAN1_TERM BIT(3)
+
+#define F81604_TERMINATION_DISABLED CAN_TERMINATION_DISABLED
+#define F81604_TERMINATION_ENABLED 120
+
+/* SJA1000 registers - manual section 6.4 (Pelican Mode) */
+#define SJA1000_MOD 0x00
+#define SJA1000_CMR 0x01
+#define SJA1000_IR 0x03
+#define SJA1000_IER 0x04
+#define SJA1000_ALC 0x0B
+#define SJA1000_ECC 0x0C
+#define SJA1000_RXERR 0x0E
+#define SJA1000_TXERR 0x0F
+#define SJA1000_ACCC0 0x10
+#define SJA1000_ACCC1 0x11
+#define SJA1000_ACCC2 0x12
+#define SJA1000_ACCC3 0x13
+#define SJA1000_ACCM0 0x14
+#define SJA1000_ACCM1 0x15
+#define SJA1000_ACCM2 0x16
+#define SJA1000_ACCM3 0x17
+#define SJA1000_MAX_FILTER_CNT 4
+
+/* Common registers - manual section 6.5 */
+#define SJA1000_BTR0 0x06
+#define SJA1000_BTR1 0x07
+#define SJA1000_BTR1_SAMPLE_TRIPLE BIT(7)
+#define SJA1000_OCR 0x08
+#define SJA1000_CDR 0x1F
+
+/* mode register */
+#define MOD_RM 0x01
+#define MOD_LOM 0x02
+#define MOD_STM 0x04
+
+/* commands */
+#define CMD_CDO 0x08
+
+/* interrupt sources */
+#define IRQ_BEI 0x80
+#define IRQ_ALI 0x40
+#define IRQ_EPI 0x20
+#define IRQ_DOI 0x08
+#define IRQ_EI 0x04
+#define IRQ_TI 0x02
+#define IRQ_RI 0x01
+#define IRQ_ALL 0xFF
+#define IRQ_OFF 0x00
+
+/* status register content */
+#define SR_BS 0x80
+#define SR_ES 0x40
+#define SR_TS 0x20
+#define SR_RS 0x10
+#define SR_TCS 0x08
+#define SR_TBS 0x04
+#define SR_DOS 0x02
+#define SR_RBS 0x01
+
+/* ECC register */
+#define ECC_SEG 0x1F
+#define ECC_DIR 0x20
+#define ECC_BIT 0x00
+#define ECC_FORM 0x40
+#define ECC_STUFF 0x80
+#define ECC_MASK 0xc0
+
+/* ALC register */
+#define ALC_MASK 0x1f
+
+/* table of devices that work with this driver */
+static const struct usb_device_id f81604_table[] = {
+	{ USB_DEVICE(F81604_VENDOR_ID, F81604_PRODUCT_ID) },
+	{} /* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, f81604_table);
+
+static const struct ethtool_ops f81604_ethtool_ops = {
+	.get_ts_info = ethtool_op_get_ts_info,
+};
+
+static const u16 f81604_termination[] = { F81604_TERMINATION_DISABLED,
+					  F81604_TERMINATION_ENABLED };
+
+struct f81604_priv {
+	struct net_device *netdev[F81604_MAX_DEV];
+	struct mutex mutex; /* for terminator setting */
+};
+
+struct f81604_port_priv {
+	struct can_priv can;
+	struct net_device *netdev;
+	struct sk_buff *echo_skb;
+
+	/* For synchronize need_clear_alc/need_clear_ecc in worker & interrupt
+	 * callback.
+	 */
+	spinlock_t lock;
+	bool need_clear_alc;
+	bool need_clear_ecc;
+
+	struct work_struct handle_clear_reg_work;
+	struct work_struct handle_clear_overrun_work;
+
+	struct usb_device *dev;
+	struct usb_interface *intf;
+
+	struct urb *int_urb;
+	u8 int_read_buffer[F81604_INT_SIZE];
+
+	struct urb *read_urb[F81604_MAX_RX_URBS];
+	u8 bulk_read_buffer[F81604_MAX_RX_URBS][F81604_BULK_SIZE];
+
+	struct urb *write_urb;
+	u8 bulk_write_buffer[F81604_DATA_SIZE];
+
+	u8 ocr;
+	u8 cdr;
+};
+
+/* Interrupt endpoint data format: SR/IR/IER/ALC/ECC/EWLR/RXERR/TXERR/VAL */
+struct f81604_int_data {
+	u8 sr;
+	u8 isrc;
+	u8 ier;
+	u8 alc;
+	u8 ecc;
+	u8 ewlr;
+	u8 rxerr;
+	u8 txerr;
+	u8 val;
+} __packed;
+
+struct f81604_sff {
+	__be16 id;
+	u8 data[CAN_MAX_DLEN];
+} __packed;
+
+struct f81604_eff {
+	__be32 id;
+	u8 data[CAN_MAX_DLEN];
+} __packed;
+
+struct f81604_bulk_data {
+	u8 cmd;
+
+	/* According for F81604 DLC define:
+	 *	#define F81604_DLC_LEN_MASK 0x0f
+	 *	#define F81604_DLC_EFF_BIT BIT(7)
+	 *	#define F81604_DLC_RTR_BIT BIT(6)
+	 */
+	u8 dlc;
+
+	union {
+		struct f81604_sff sff;
+		struct f81604_eff eff;
+	};
+} __packed;
+
+static int f81604_set_register(struct usb_device *dev, u16 reg, u8 data)
+{
+	int ret;
+
+	ret = usb_control_msg_send(dev, 0, F81604_SET_GET_REGISTER,
+				   USB_TYPE_VENDOR | USB_DIR_OUT, 0, reg,
+				   &data, sizeof(data), F81604_USB_TIMEOUT,
+				   GFP_KERNEL);
+	if (ret)
+		dev_err(&dev->dev, "%s: reg: %x data: %x failed: %pe\n",
+			__func__, reg, data, ERR_PTR(ret));
+
+	return ret;
+}
+
+static int f81604_get_register(struct usb_device *dev, u16 reg, u8 *data)
+{
+	int ret;
+
+	ret = usb_control_msg_recv(dev, 0, F81604_SET_GET_REGISTER,
+				   USB_TYPE_VENDOR | USB_DIR_IN, 0, reg, data,
+				   sizeof(*data), F81604_USB_TIMEOUT,
+				   GFP_KERNEL);
+
+	if (ret < 0)
+		dev_err(&dev->dev, "%s: reg: %x failed: %pe\n", __func__, reg,
+			ERR_PTR(ret));
+
+	return ret;
+}
+
+static int f81604_mask_set_register(struct usb_device *dev, u16 reg, u8 mask,
+				    u8 data)
+{
+	int status;
+	u8 tmp;
+
+	status = f81604_get_register(dev, reg, &tmp);
+	if (status)
+		return status;
+
+	tmp &= ~mask;
+	tmp |= (mask & data);
+
+	return f81604_set_register(dev, reg, tmp);
+}
+
+static int f81604_set_sja1000_register(struct usb_device *dev, u8 port,
+				       u16 reg, u8 data)
+{
+	int real_reg;
+
+	real_reg = reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET;
+	return f81604_set_register(dev, real_reg, data);
+}
+
+static int f81604_get_sja1000_register(struct usb_device *dev, u8 port,
+				       u16 reg, u8 *data)
+{
+	int real_reg;
+
+	real_reg = reg + F81604_PORT_OFFSET * port + F81604_PORT_OFFSET;
+	return f81604_get_register(dev, real_reg, data);
+}
+
+static int f81604_set_reset_mode(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int status, i;
+	u8 tmp;
+
+	/* disable interrupts */
+	status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_IER, IRQ_OFF);
+	if (status)
+		return status;
+
+	for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
+		status = f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+						     SJA1000_MOD, &tmp);
+		if (status)
+			return status;
+
+		/* check reset bit */
+		if (tmp & MOD_RM) {
+			priv->can.state = CAN_STATE_STOPPED;
+			return 0;
+		}
+
+		/* reset chip */
+		status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+						     SJA1000_MOD, MOD_RM);
+		if (status)
+			return status;
+	}
+
+	return -EPERM;
+}
+
+static int f81604_set_normal_mode(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	u8 mod_reg = 0x00;
+	u8 tmp, ier = 0;
+	int status, i;
+
+	for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
+		status = f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+						     SJA1000_MOD, &tmp);
+		if (status)
+			return status;
+
+		/* check reset bit */
+		if ((tmp & MOD_RM) == 0) {
+			priv->can.state = CAN_STATE_ERROR_ACTIVE;
+			/* enable interrupts, RI handled by bulk-in */
+			ier = IRQ_ALL & ~IRQ_RI;
+			if (!(priv->can.ctrlmode &
+			      CAN_CTRLMODE_BERR_REPORTING))
+				ier &= ~IRQ_BEI;
+
+			return f81604_set_sja1000_register(priv->dev,
+							   netdev->dev_id,
+							   SJA1000_IER, ier);
+		}
+
+		/* set chip to normal mode */
+		if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
+			mod_reg |= MOD_LOM;
+		if (priv->can.ctrlmode & CAN_CTRLMODE_PRESUME_ACK)
+			mod_reg |= MOD_STM;
+
+		status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+						     SJA1000_MOD, mod_reg);
+		if (status)
+			return status;
+	}
+
+	return -EPERM;
+}
+
+static int f81604_chipset_init(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int status;
+	int i;
+
+	/* set clock divider and output control register */
+	status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_CDR,
+					     priv->cdr | CDR_PELICAN);
+	if (status)
+		return status;
+
+	/* set acceptance filter (accept all) */
+	for (i = 0; i < SJA1000_MAX_FILTER_CNT; ++i) {
+		status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+						     SJA1000_ACCC0 + i, 0);
+		if (status)
+			return status;
+	}
+
+	for (i = 0; i < SJA1000_MAX_FILTER_CNT; ++i) {
+		status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+						     SJA1000_ACCM0 + i, 0xFF);
+		if (status)
+			return status;
+	}
+
+	return f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+					   SJA1000_OCR,
+					   priv->ocr | OCR_MODE_NORMAL);
+}
+
+static void f81604_unregister_urbs(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int i;
+
+	for (i = 0; i < F81604_MAX_RX_URBS; ++i)
+		usb_kill_urb(priv->read_urb[i]);
+
+	usb_kill_urb(priv->write_urb);
+	usb_kill_urb(priv->int_urb);
+}
+
+static int f81604_register_urbs(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int status, i;
+
+	for (i = 0; i < F81604_MAX_RX_URBS; ++i) {
+		status = usb_submit_urb(priv->read_urb[i], GFP_KERNEL);
+		if (status) {
+			netdev_warn(netdev, "%s: submit rx urb failed: %pe\n",
+				    __func__, ERR_PTR(status));
+			return status;
+		}
+	}
+
+	status = usb_submit_urb(priv->int_urb, GFP_KERNEL);
+	if (status) {
+		netdev_warn(netdev, "%s: submit int urb failed: %pe\n",
+			    __func__, ERR_PTR(status));
+		return status;
+	}
+
+	return 0;
+}
+
+static int f81604_start(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int status;
+	u8 mode;
+	u8 tmp;
+
+	f81604_unregister_urbs(netdev);
+
+	mode = F81604_RX_AUTO_RELEASE_BUF | F81604_INT_WHEN_CHANGE;
+
+	/* Set TR/AT mode */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		mode |= F81604_TX_ONESHOT;
+	else
+		mode |= F81604_TX_NORMAL;
+
+	status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+					     F81604_CTRL_MODE_REG, mode);
+	if (status)
+		return status;
+
+	/* set reset mode */
+	status = f81604_set_reset_mode(netdev);
+	if (status)
+		return status;
+
+	status = f81604_chipset_init(netdev);
+	if (status)
+		return status;
+
+	/* Clear error counters and error code capture */
+	status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_TXERR, 0);
+	if (status)
+		return status;
+
+	status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_RXERR, 0);
+	if (status)
+		return status;
+
+	/* Read clear for ECC/ALC/IR register */
+	status = f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_ECC, &tmp);
+	if (status)
+		return status;
+
+	status = f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_ALC, &tmp);
+	if (status)
+		return status;
+
+	status = f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_IR, &tmp);
+	if (status)
+		return status;
+
+	status = f81604_register_urbs(netdev);
+	if (status)
+		return status;
+
+	return f81604_set_normal_mode(netdev);
+}
+
+static int f81604_set_bittiming(struct net_device *dev)
+{
+	struct f81604_port_priv *priv = netdev_priv(dev);
+	struct can_bittiming *bt = &priv->can.bittiming;
+	int status = 0;
+	u8 btr0, btr1;
+
+	btr0 = FIELD_PREP(GENMASK(5, 0), bt->brp - 1) |
+	       FIELD_PREP(GENMASK(7, 6), bt->sjw - 1);
+
+	btr1 = FIELD_PREP(GENMASK(3, 0), bt->prop_seg + bt->phase_seg1 - 1) |
+	       FIELD_PREP(GENMASK(6, 4), bt->phase_seg2 - 1);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
+		btr1 |= SJA1000_BTR1_SAMPLE_TRIPLE;
+
+	status = f81604_set_sja1000_register(priv->dev, dev->dev_id,
+					     SJA1000_BTR0, btr0);
+	if (status) {
+		netdev_warn(dev, "%s: Set BTR0 failed: %pe\n", __func__,
+			    ERR_PTR(status));
+		return status;
+	}
+
+	status = f81604_set_sja1000_register(priv->dev, dev->dev_id,
+					     SJA1000_BTR1, btr1);
+	if (status) {
+		netdev_warn(dev, "%s: Set BTR1 failed: %pe\n", __func__,
+			    ERR_PTR(status));
+		return status;
+	}
+
+	return 0;
+}
+
+static int f81604_set_mode(struct net_device *netdev, enum can_mode mode)
+{
+	int err;
+
+	switch (mode) {
+	case CAN_MODE_START:
+		err = f81604_start(netdev);
+		if (!err && netif_queue_stopped(netdev))
+			netif_wake_queue(netdev);
+		break;
+
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static void f81604_process_rx_packet(struct urb *urb)
+{
+	struct net_device *netdev = urb->context;
+	struct net_device_stats *stats;
+	struct f81604_bulk_data *ptr;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	int i, count;
+	u8 *data;
+
+	WARN_ON(sizeof(*ptr) != F81604_DATA_SIZE);
+
+	data = urb->transfer_buffer;
+	stats = &netdev->stats;
+
+	if (urb->actual_length % F81604_DATA_SIZE)
+		netdev_warn(netdev, "actual_length %% %d != 0 (%d)\n",
+			    F81604_DATA_SIZE, urb->actual_length);
+	else if (!urb->actual_length)
+		netdev_warn(netdev, "actual_length = 0 (%d)\n",
+			    urb->actual_length);
+
+	count = urb->actual_length / F81604_DATA_SIZE;
+
+	for (i = 0; i < count; ++i) {
+		ptr = (struct f81604_bulk_data *)&data[i * F81604_DATA_SIZE];
+
+		if (ptr->cmd != F81604_CMD_DATA)
+			continue;
+
+		skb = alloc_can_skb(netdev, &cf);
+		if (!skb) {
+			netdev_warn(netdev, "%s: not enough memory", __func__);
+			continue;
+		}
+
+		cf->len = can_cc_dlc2len(ptr->dlc & F81604_DLC_LEN_MASK);
+
+		if (ptr->dlc & F81604_DLC_EFF_BIT) {
+			cf->can_id = be32_to_cpu(ptr->eff.id) >> 3;
+			cf->can_id |= CAN_EFF_FLAG;
+		} else {
+			cf->can_id = be16_to_cpu(ptr->sff.id) >> 5;
+		}
+
+		if (ptr->dlc & F81604_DLC_RTR_BIT)
+			cf->can_id |= CAN_RTR_FLAG;
+		else if (ptr->dlc & F81604_DLC_EFF_BIT)
+			memcpy(cf->data, ptr->eff.data, cf->len);
+		else
+			memcpy(cf->data, ptr->sff.data, cf->len);
+
+		if (!(cf->can_id & CAN_RTR_FLAG))
+			stats->rx_bytes += cf->len;
+
+		stats->rx_packets++;
+		netif_rx(skb);
+	}
+}
+
+static void f81604_read_bulk_callback(struct urb *urb)
+{
+	struct net_device *netdev = urb->context;
+	int status;
+
+	if (!netif_device_present(netdev))
+		return;
+
+	if (urb->status)
+		netdev_info(netdev, "%s: URB aborted %pe\n", __func__,
+			    ERR_PTR(urb->status));
+
+	switch (urb->status) {
+	case 0: /* success */
+		break;
+
+	case -ENOENT:
+	case -EPIPE:
+	case -EPROTO:
+	case -ESHUTDOWN:
+		return;
+
+	default:
+		goto resubmit_urb;
+	}
+
+	f81604_process_rx_packet(urb);
+
+resubmit_urb:
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status == -ENODEV)
+		netif_device_detach(netdev);
+	else if (status)
+		netdev_err(netdev,
+			   "%s: failed to resubmit read bulk urb: %pe\n",
+			   __func__, ERR_PTR(status));
+}
+
+static void f81604_write_bulk_callback(struct urb *urb)
+{
+	struct net_device *netdev = urb->context;
+
+	if (!netif_device_present(netdev))
+		return;
+
+	if (urb->status)
+		netdev_info(netdev, "%s: Tx URB error: %pe\n", __func__,
+			    ERR_PTR(urb->status));
+}
+
+static void f81604_handle_clear_overrun_work(struct work_struct *work)
+{
+	struct f81604_port_priv *priv;
+	struct net_device *netdev;
+
+	priv = container_of(work, struct f81604_port_priv,
+			    handle_clear_overrun_work);
+	netdev = priv->netdev;
+
+	f81604_set_sja1000_register(priv->dev, netdev->dev_id, SJA1000_CMR,
+				    CMD_CDO);
+}
+
+static void f81604_handle_clear_reg_work(struct work_struct *work)
+{
+	struct f81604_port_priv *priv;
+	struct net_device *netdev;
+	bool clear_ecc, clear_alc;
+	unsigned long flags;
+	u8 tmp;
+
+	priv = container_of(work, struct f81604_port_priv,
+			    handle_clear_reg_work);
+	netdev = priv->netdev;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	clear_alc = priv->need_clear_alc;
+	clear_ecc = priv->need_clear_ecc;
+	priv->need_clear_alc = false;
+	priv->need_clear_ecc = false;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (clear_alc)
+		f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+					    SJA1000_ALC, &tmp);
+
+	if (clear_ecc)
+		f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+					    SJA1000_ECC, &tmp);
+}
+
+static void f81604_handle_tx(struct urb *urb)
+{
+	struct f81604_int_data *data = urb->transfer_buffer;
+	struct net_device *netdev = urb->context;
+	struct net_device_stats *stats;
+	struct f81604_port_priv *priv;
+
+	priv = netdev_priv(netdev);
+	stats = &netdev->stats;
+
+	if (!(data->isrc & IRQ_TI))
+		return;
+
+	/* transmission buffer released */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
+	    !(data->sr & SR_TCS)) {
+		stats->tx_errors++;
+		can_free_echo_skb(netdev, 0, NULL);
+	} else {
+		/* transmission complete */
+		stats->tx_bytes += can_get_echo_skb(netdev, 0, NULL);
+		stats->tx_packets++;
+	}
+
+	netif_wake_queue(netdev);
+}
+
+static void f81604_read_int_callback(struct urb *urb)
+{
+	struct f81604_int_data *data = urb->transfer_buffer;
+	struct net_device *netdev = urb->context;
+	struct net_device_stats *stats;
+	struct f81604_port_priv *priv;
+	enum can_state can_state;
+	enum can_state rx_state;
+	enum can_state tx_state;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	unsigned long flags;
+	int r;
+
+	priv = netdev_priv(netdev);
+	can_state = priv->can.state;
+	stats = &netdev->stats;
+
+	if (!netif_device_present(netdev))
+		return;
+
+	if (urb->status)
+		netdev_info(netdev, "%s: Int URB aborted: %pe\n", __func__,
+			    ERR_PTR(urb->status));
+
+	switch (urb->status) {
+	case 0: /* success */
+		break;
+
+	case -ENOENT:
+	case -EPIPE:
+	case -EPROTO:
+	case -ESHUTDOWN:
+		return;
+
+	default:
+		goto resubmit_urb;
+	}
+
+	/* Note: ALC/ECC will not auto clear by read here, must to clear by
+	 * read register (via handle_clear_reg_work).
+	 */
+
+	/* handle can bus errors */
+	if (data->isrc & (IRQ_DOI | IRQ_EI | IRQ_BEI | IRQ_EPI | IRQ_ALI)) {
+		skb = alloc_can_err_skb(netdev, &cf);
+		if (!skb) {
+			netdev_warn(netdev,
+				    "no memory to alloc_can_err_skb\n");
+			goto resubmit_urb;
+		}
+
+		cf->can_id |= CAN_ERR_CNT;
+		cf->data[6] = data->txerr;
+		cf->data[7] = data->rxerr;
+
+		if (data->isrc & IRQ_DOI) {
+			/* data overrun interrupt */
+			netdev_dbg(netdev, "data overrun interrupt\n");
+			cf->can_id |= CAN_ERR_CRTL;
+			cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+			stats->rx_over_errors++;
+			stats->rx_errors++;
+
+			schedule_work(&priv->handle_clear_overrun_work);
+		}
+
+		if (data->isrc & IRQ_EI) {
+			/* error warning interrupt */
+			netdev_dbg(netdev, "error warning interrupt\n");
+
+			if (data->sr & SR_BS)
+				can_state = CAN_STATE_BUS_OFF;
+			else if (data->sr & SR_ES)
+				can_state = CAN_STATE_ERROR_WARNING;
+			else
+				can_state = CAN_STATE_ERROR_ACTIVE;
+		}
+
+		if (data->isrc & IRQ_BEI) {
+			/* bus error interrupt */
+			netdev_dbg(netdev, "bus error interrupt\n");
+
+			priv->can.can_stats.bus_error++;
+			stats->rx_errors++;
+
+			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+
+			/* set error type */
+			switch (data->ecc & ECC_MASK) {
+			case ECC_BIT:
+				cf->data[2] |= CAN_ERR_PROT_BIT;
+				break;
+			case ECC_FORM:
+				cf->data[2] |= CAN_ERR_PROT_FORM;
+				break;
+			case ECC_STUFF:
+				cf->data[2] |= CAN_ERR_PROT_STUFF;
+				break;
+			default:
+				break;
+			}
+
+			/* set error location */
+			cf->data[3] = data->ecc & ECC_SEG;
+
+			/* Error occurred during transmission? */
+			if ((data->ecc & ECC_DIR) == 0)
+				cf->data[2] |= CAN_ERR_PROT_TX;
+
+			spin_lock_irqsave(&priv->lock, flags);
+			priv->need_clear_ecc = true;
+			spin_unlock_irqrestore(&priv->lock, flags);
+
+			schedule_work(&priv->handle_clear_reg_work);
+		}
+
+		if (data->isrc & IRQ_EPI) {
+			if (can_state == CAN_STATE_ERROR_PASSIVE)
+				can_state = CAN_STATE_ERROR_WARNING;
+			else
+				can_state = CAN_STATE_ERROR_PASSIVE;
+
+			/* error passive interrupt */
+			netdev_dbg(netdev, "error passive interrupt: %d\n",
+				   can_state);
+		}
+
+		if (data->isrc & IRQ_ALI) {
+			/* arbitration lost interrupt */
+			netdev_dbg(netdev, "arbitration lost interrupt\n");
+
+			priv->can.can_stats.arbitration_lost++;
+			stats->tx_errors++;
+			cf->can_id |= CAN_ERR_LOSTARB;
+			cf->data[0] = data->alc & ALC_MASK;
+
+			spin_lock_irqsave(&priv->lock, flags);
+			priv->need_clear_alc = true;
+			spin_unlock_irqrestore(&priv->lock, flags);
+
+			schedule_work(&priv->handle_clear_reg_work);
+		}
+
+		if (can_state != priv->can.state) {
+			tx_state = data->txerr >= data->rxerr ? can_state : 0;
+			rx_state = data->txerr <= data->rxerr ? can_state : 0;
+
+			can_change_state(netdev, cf, tx_state, rx_state);
+
+			if (can_state == CAN_STATE_BUS_OFF)
+				can_bus_off(netdev);
+		}
+
+		netif_rx(skb);
+	}
+
+	/* handle TX */
+	if (can_state != CAN_STATE_BUS_OFF)
+		f81604_handle_tx(urb);
+
+resubmit_urb:
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r) {
+		netdev_err(netdev,
+			   "%s: failed resubmitting int bulk urb: %pe\n",
+			   __func__, ERR_PTR(r));
+
+		if (r == -ENODEV)
+			netif_device_detach(netdev);
+	}
+}
+
+static netdev_tx_t f81604_start_xmit(struct sk_buff *skb,
+				     struct net_device *netdev)
+{
+	struct can_frame *cf = (struct can_frame *)skb->data;
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	struct net_device_stats *stats = &netdev->stats;
+	struct f81604_bulk_data *ptr;
+	int status, len;
+
+	if (can_dropped_invalid_skb(netdev, skb))
+		return NETDEV_TX_OK;
+
+	netif_stop_queue(netdev);
+
+	WARN_ON(sizeof(*ptr) != F81604_DATA_SIZE);
+
+	ptr = (struct f81604_bulk_data *)priv->bulk_write_buffer;
+	memset(ptr, 0, F81604_DATA_SIZE);
+
+	len = can_get_cc_dlc(cf, priv->can.ctrlmode);
+	ptr->cmd = F81604_CMD_DATA;
+	ptr->dlc = len;
+
+	if (cf->can_id & CAN_RTR_FLAG)
+		ptr->dlc |= F81604_DLC_RTR_BIT;
+
+	if (cf->can_id & CAN_EFF_FLAG) {
+		ptr->eff.id = cpu_to_be32((cf->can_id & CAN_EFF_MASK) << 3);
+		ptr->dlc |= F81604_DLC_EFF_BIT;
+
+		if (!(cf->can_id & CAN_RTR_FLAG))
+			memcpy(&ptr->eff.data, cf->data, len);
+	} else {
+		ptr->sff.id = cpu_to_be16((cf->can_id & CAN_SFF_MASK) << 5);
+
+		if (!(cf->can_id & CAN_RTR_FLAG))
+			memcpy(&ptr->sff.data, cf->data, len);
+	}
+
+	can_put_echo_skb(skb, netdev, 0, 0);
+
+	status = usb_submit_urb(priv->write_urb, GFP_ATOMIC);
+	if (status) {
+		netdev_err(netdev, "%s: failed to resubmit tx bulk urb: %pe\n",
+			   __func__, ERR_PTR(status));
+
+		can_free_echo_skb(netdev, 0, NULL);
+		stats->tx_dropped++;
+
+		if (status == -ENODEV)
+			netif_device_detach(netdev);
+	}
+
+	return NETDEV_TX_OK;
+}
+
+static int f81604_get_berr_counter(const struct net_device *netdev,
+				   struct can_berr_counter *bec)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int status;
+	u8 txerr;
+	u8 rxerr;
+
+	status = f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_TXERR, &txerr);
+	if (status)
+		return status;
+
+	status = f81604_get_sja1000_register(priv->dev, netdev->dev_id,
+					     SJA1000_RXERR, &rxerr);
+	if (status)
+		return status;
+
+	bec->txerr = txerr;
+	bec->rxerr = rxerr;
+
+	return 0;
+}
+
+static void f81604_remove_urbs(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int i;
+
+	for (i = 0; i < F81604_MAX_RX_URBS; ++i)
+		usb_free_urb(priv->read_urb[i]);
+
+	usb_free_urb(priv->write_urb);
+	usb_free_urb(priv->int_urb);
+}
+
+static int f81604_prepare_urbs(struct net_device *netdev)
+{
+	static const u8 bulk_in_addr[F81604_MAX_DEV] = { 0x82, 0x84 };
+	static const u8 bulk_out_addr[F81604_MAX_DEV] = { 0x01, 0x03 };
+	static const u8 int_in_addr[F81604_MAX_DEV] = { 0x81, 0x83 };
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+	int id = netdev->dev_id;
+	int i;
+
+	for (i = 0; i < F81604_MAX_RX_URBS; ++i) {
+		priv->read_urb[i] = usb_alloc_urb(0, GFP_KERNEL);
+		if (!priv->read_urb[i])
+			goto error;
+
+		usb_fill_bulk_urb(priv->read_urb[i], priv->dev,
+				  usb_rcvbulkpipe(priv->dev, bulk_in_addr[id]),
+				  priv->bulk_read_buffer[i], F81604_BULK_SIZE,
+				  f81604_read_bulk_callback, netdev);
+	}
+
+	priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!priv->write_urb)
+		goto error;
+
+	usb_fill_bulk_urb(priv->write_urb, priv->dev,
+			  usb_sndbulkpipe(priv->dev, bulk_out_addr[id]),
+			  priv->bulk_write_buffer, F81604_DATA_SIZE,
+			  f81604_write_bulk_callback, netdev);
+
+	priv->int_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!priv->int_urb)
+		goto error;
+
+	usb_fill_int_urb(priv->int_urb, priv->dev,
+			 usb_rcvintpipe(priv->dev, int_in_addr[id]),
+			 priv->int_read_buffer, F81604_INT_SIZE,
+			 f81604_read_int_callback, netdev, 1);
+
+	return 0;
+
+error:
+	f81604_remove_urbs(netdev);
+	return -ENOMEM;
+}
+
+/* Open USB device */
+static int f81604_open(struct net_device *netdev)
+{
+	int err;
+
+	err = open_candev(netdev);
+	if (err)
+		return err;
+
+	err = f81604_start(netdev);
+	if (err)
+		goto start_failed;
+
+	netif_start_queue(netdev);
+	return 0;
+
+start_failed:
+	if (err == -ENODEV)
+		netif_device_detach(netdev);
+
+	close_candev(netdev);
+
+	return err;
+}
+
+/* Close USB device */
+static int f81604_close(struct net_device *netdev)
+{
+	struct f81604_port_priv *priv = netdev_priv(netdev);
+
+	f81604_set_reset_mode(netdev);
+
+	netif_stop_queue(netdev);
+	cancel_work_sync(&priv->handle_clear_overrun_work);
+	cancel_work_sync(&priv->handle_clear_reg_work);
+	close_candev(netdev);
+
+	f81604_unregister_urbs(netdev);
+
+	return 0;
+}
+
+static const struct net_device_ops f81604_netdev_ops = {
+	.ndo_open = f81604_open,
+	.ndo_stop = f81604_close,
+	.ndo_start_xmit = f81604_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
+};
+
+static const struct can_bittiming_const f81604_bittiming_const = {
+	.name = "f81604",
+	.tseg1_min = 1,
+	.tseg1_max = 16,
+	.tseg2_min = 1,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 64,
+	.brp_inc = 1,
+};
+
+/* Called by the usb core when driver is unloaded or device is removed */
+static void f81604_disconnect(struct usb_interface *intf)
+{
+	struct f81604_priv *priv = usb_get_intfdata(intf);
+	int i;
+
+	for (i = 0; i < F81604_MAX_DEV; ++i) {
+		if (!priv->netdev[i])
+			continue;
+
+		unregister_netdev(priv->netdev[i]);
+		f81604_remove_urbs(priv->netdev[i]);
+		free_candev(priv->netdev[i]);
+	}
+}
+
+static int f81604_set_termination(struct net_device *netdev, u16 term)
+{
+	struct f81604_port_priv *port_priv = netdev_priv(netdev);
+	struct f81604_priv *priv;
+	u8 mask, data = 0;
+	int r;
+
+	priv = usb_get_intfdata(port_priv->intf);
+
+	if (netdev->dev_id == 0)
+		mask = F81604_CAN0_TERM;
+	else
+		mask = F81604_CAN1_TERM;
+
+	if (term == F81604_TERMINATION_ENABLED)
+		data = mask;
+
+	mutex_lock(&priv->mutex);
+
+	r = f81604_mask_set_register(port_priv->dev, F81604_TERMINATOR_REG,
+				     mask, data);
+
+	mutex_unlock(&priv->mutex);
+
+	return r;
+}
+
+static int f81604_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	struct usb_device *dev = interface_to_usbdev(intf);
+	struct f81604_port_priv *port_priv;
+	struct net_device *netdev;
+	struct f81604_priv *priv;
+	int i, err;
+
+	priv = devm_kzalloc(&intf->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	usb_set_intfdata(intf, priv);
+
+	for (i = 0; i < F81604_MAX_DEV; ++i) {
+		netdev = alloc_candev(sizeof(*port_priv), 1);
+		if (!netdev) {
+			dev_err(&intf->dev, "Couldn't alloc candev: %d\n", i);
+			err = -ENOMEM;
+
+			goto failure_cleanup;
+		}
+
+		port_priv = netdev_priv(netdev);
+		netdev->dev_id = i;
+
+		mutex_init(&priv->mutex);
+		spin_lock_init(&port_priv->lock);
+
+		INIT_WORK(&port_priv->handle_clear_overrun_work,
+			  f81604_handle_clear_overrun_work);
+		INIT_WORK(&port_priv->handle_clear_reg_work,
+			  f81604_handle_clear_reg_work);
+
+		port_priv->intf = intf;
+		port_priv->dev = dev;
+		port_priv->ocr = OCR_TX0_PUSHPULL | OCR_TX1_PUSHPULL;
+		port_priv->cdr = CDR_CBP;
+		port_priv->can.state = CAN_STATE_STOPPED;
+		port_priv->can.clock.freq = F81604_CAN_CLOCK;
+
+		port_priv->can.termination_const = f81604_termination;
+		port_priv->can.termination_const_cnt =
+			ARRAY_SIZE(f81604_termination);
+		port_priv->can.bittiming_const = &f81604_bittiming_const;
+		port_priv->can.do_set_bittiming = f81604_set_bittiming;
+		port_priv->can.do_set_mode = f81604_set_mode;
+		port_priv->can.do_set_termination = f81604_set_termination;
+		port_priv->can.do_get_berr_counter = f81604_get_berr_counter;
+		port_priv->can.ctrlmode_supported =
+			CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES |
+			CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTING |
+			CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_PRESUME_ACK;
+
+		netdev->ethtool_ops = &f81604_ethtool_ops;
+		netdev->netdev_ops = &f81604_netdev_ops;
+		netdev->flags |= IFF_ECHO;
+
+		SET_NETDEV_DEV(netdev, &intf->dev);
+
+		err = f81604_set_termination(netdev,
+					     F81604_TERMINATION_DISABLED);
+		if (err)
+			goto clean_candev;
+
+		err = f81604_prepare_urbs(netdev);
+		if (err)
+			goto clean_candev;
+
+		err = register_candev(netdev);
+		if (err)
+			goto clean_candev;
+
+		port_priv->netdev = netdev;
+		priv->netdev[i] = netdev;
+
+		dev_info(&intf->dev, "Channel #%d registered as %s\n", i,
+			 netdev->name);
+	}
+
+	return 0;
+
+clean_candev:
+	netdev_err(netdev, "couldn't enable CAN device: %pe\n", ERR_PTR(err));
+	free_candev(netdev);
+
+failure_cleanup:
+	f81604_disconnect(intf);
+	return err;
+}
+
+static struct usb_driver f81604_driver = {
+	.name = "f81604",
+	.probe = f81604_probe,
+	.disconnect = f81604_disconnect,
+	.id_table = f81604_table,
+};
+
+module_usb_driver(f81604_driver);
+
+MODULE_AUTHOR("Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>");
+MODULE_DESCRIPTION("Fintek F81604 USB to 2xCANBUS");
+MODULE_LICENSE("GPL");
-- 
2.17.1

