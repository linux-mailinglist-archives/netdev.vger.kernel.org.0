Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B1694A85
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjBMPNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbjBMPNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:13:45 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13E71817F;
        Mon, 13 Feb 2023 07:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676301221; x=1707837221;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=dH1/NWqy+7NbuEJsaXVW+WVbP0VonR/+YuqXHe+jICU=;
  b=ZiuGloY6MvBiIiYb73i0f2rPIOHQSjlc0jyNcAMEkqDnGA/tZeL+CZOX
   1IaL2DyAhBwoENLWAoXF0s40nY7fEvztLukH5QrneL7exbdZURmTrZvtq
   rwLJ68kJv1JFQXIKpnHLTdBF/abqNwEiJuaswo5Se6FcVysdXvTlHlr09
   K3ggrxiBCMHu/M1uIu8UNbPI238ed4kedSs+LaGIgTw3GK90PM/8Lt9Wr
   Z27GwIWcZP3wA07MFRbsqd4VcTEqBU4XNyWPDlvDuDcV+IKZdjLpRks4O
   QhT9J82ETmv0HdSdi0ixOgQDAZLIHtZNnwhWquiOPHxP4ibMkmT2iKYWv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="395518566"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="395518566"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 07:06:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="646407545"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="646407545"
Received: from hdevries-mobl.ger.corp.intel.com ([10.249.36.140])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 07:06:35 -0800
Date:   Mon, 13 Feb 2023 17:06:32 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, alok.a.tiwari@oracle.com,
        hdanton@sina.com, leon@kernel.org, Netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v3 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
In-Reply-To: <20230213145432.1192911-4-neeraj.sanjaykale@nxp.com>
Message-ID: <57476483-c0f4-f2c4-188d-294e2bc9daf3@linux.intel.com>
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com> <20230213145432.1192911-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-571507949-1676300656=:1712"
Content-ID: <7aadb92-985-e0c3-ceba-b74ec6ad3bcf@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-571507949-1676300656=:1712
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <8403d42-77fb-fdb5-a20-4a61a6627821@linux.intel.com>

Hi,

You didn't address my comments I made for v2.

-- 
 i.


On Mon, 13 Feb 2023, Neeraj Sanjay Kale wrote:

> This adds a driver based on serdev driver for the NXP BT serial
> protocol based on running H:4, which can enable the built-in
> Bluetooth device inside a generic NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into
> sleep state whenever there is no activity for 2000ms, and will
> be woken up when any activity is to be initiated over UART.
> 
> This driver enables the power save feature by default by sending
> the vendor specific commands to the chip during setup.
> 
> During setup, the driver checks if a FW is already running on the
> chip based on the CTS line, and downloads device specific FW file
> into the chip over UART.
> 
> The driver contains certain device specific default parameters
> related to FW filename, baudrate and timeouts which can be
> overwritten by an optional user space config file. These parameters
> may vary from one module vendor to another.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip
> based on compatibility devices mentioned in DT bindings. Handled
> potential memory leaks and null pointer dereference issues,
> simplified FW download feature, handled byte-order and few cosmetic
> changes. (Ilpo J�rvinen, Alok Tiwari, Hillf Danton)
> v3: Added conf file support necessary to support different vendor
> modules, moved .h file contents to .c, cosmetic changes. (Luiz
> Augusto von Dentz, Rob Herring, Leon Romanovsky)
> ---
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1370 +++++++++++++++++++++++++++++++++
>  3 files changed, 1382 insertions(+)
>  create mode 100644 drivers/bluetooth/btnxpuart.c
> 
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 5a1a7bec3c42..773b40d34b7b 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -465,4 +465,15 @@ config BT_VIRTIO
>  	  Say Y here to compile support for HCI over Virtio into the
>  	  kernel or say M to compile as a module.
>  
> +config BT_NXPUART
> +	tristate "NXP protocol support"
> +	depends on SERIAL_DEV_BUS
> +	help
> +	  NXP is serial driver required for NXP Bluetooth
> +	  devices with UART interface.
> +
> +	  Say Y here to compile support for NXP Bluetooth UART device into
> +	  the kernel, or say M here to compile as a module.
> +
> +
>  endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index e0b261f24fc9..7a5967e9ac48 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
>  obj-$(CONFIG_BT_MTK)		+= btmtk.o
>  
>  obj-$(CONFIG_BT_VIRTIO)		+= virtio_bt.o
> +obj-$(CONFIG_BT_NXPUART)	+= btnxpuart.o
>  
>  obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
>  
> diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
> new file mode 100644
> index 000000000000..d774564d47ce
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.c
> @@ -0,0 +1,1370 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *  NXP Bluetooth driver
> + *  Copyright 2018-2023 NXP
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +
> +#include <linux/serdev.h>
> +#include <linux/of.h>
> +#include <linux/skbuff.h>
> +#include <asm/unaligned.h>
> +#include <linux/firmware.h>
> +#include <linux/string.h>
> +#include <linux/crc8.h>
> +
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +
> +#include "h4_recv.h"
> +
> +#define BTNXPUART_TX_STATE_ACTIVE	1
> +#define BTNXPUART_FW_DOWNLOADING	2
> +
> +#define MAX_TAG_STR_LEN				20
> +#define BT_FW_CONF_FILE				"nxp/bt_mod_para.conf"
> +#define USER_CONFIG_TAG				"user_config"
> +#define FW_NAME_TAG					"fw_name"
> +#define OPER_SPEED_TAG				"oper_speed"
> +#define FW_DL_PRI_BAUDRATE_TAG		"fw_dl_pri_speed"
> +#define FW_DL_SEC_BAUDRATE_TAG		"fw_dl_sec_speed"
> +#define FW_INIT_BAUDRATE			"fw_init_speed"
> +#define PS_INTERVAL_MS				"ps_interval_ms"
> +
> +#define FIRMWARE_W8987	"nxp/sdiouart8987_combo_v0.bin"
> +#define FIRMWARE_W8997	"nxp/uartuart8997_bt_v4.bin"
> +#define FIRMWARE_W9098	"nxp/uartuart9098_bt_v1.bin"
> +#define FIRMWARE_IW416	"nxp/sdiouartiw416_combo_v0.bin"
> +#define FIRMWARE_IW612	"nxp/sduart_nw61x_v1.bin.se"
> +
> +#define MAX_FW_FILE_NAME_LEN    50
> +
> +/* Default ps timeout period in milli-second */
> +#define PS_DEFAULT_TIMEOUT_PERIOD     2000
> +
> +/* wakeup methods */
> +#define WAKEUP_METHOD_DTR       0
> +#define WAKEUP_METHOD_BREAK     1
> +#define WAKEUP_METHOD_EXT_BREAK 2
> +#define WAKEUP_METHOD_RTS       3
> +#define WAKEUP_METHOD_INVALID   0xff
> +
> +/* power save mode status */
> +#define PS_MODE_DISABLE         0
> +#define PS_MODE_ENABLE          1
> +
> +/* Power Save Commands to ps_work_func  */
> +#define PS_CMD_EXIT_PS          1
> +#define PS_CMD_ENTER_PS         2
> +
> +/* power save state */
> +#define PS_STATE_AWAKE          0
> +#define PS_STATE_SLEEP          1
> +
> +/* Bluetooth vendor command : Sleep mode */
> +#define HCI_NXP_AUTO_SLEEP_MODE	0xfc23
> +/* Bluetooth vendor command : Wakeup method */
> +#define HCI_NXP_WAKEUP_METHOD	0xfc53
> +/* Bluetooth vendor command : Set operational baudrate */
> +#define HCI_NXP_SET_OPER_SPEED	0xfc09
> +
> +/* Bluetooth Power State : Vendor cmd params */
> +#define BT_PS_ENABLE			0x02
> +#define BT_PS_DISABLE			0x03
> +
> +/* Bluetooth Host Wakeup Methods */
> +#define BT_HOST_WAKEUP_METHOD_NONE      0x00
> +#define BT_HOST_WAKEUP_METHOD_DTR       0x01
> +#define BT_HOST_WAKEUP_METHOD_BREAK     0x02
> +#define BT_HOST_WAKEUP_METHOD_GPIO      0x03
> +
> +/* Bluetooth Chip Wakeup Methods */
> +#define BT_CTRL_WAKEUP_METHOD_DSR       0x00
> +#define BT_CTRL_WAKEUP_METHOD_BREAK     0x01
> +#define BT_CTRL_WAKEUP_METHOD_GPIO      0x02
> +#define BT_CTRL_WAKEUP_METHOD_EXT_BREAK 0x04
> +#define BT_CTRL_WAKEUP_METHOD_RTS       0x05
> +
> +struct ps_data {
> +	u8    ps_mode;
> +	u8    cur_psmode;
> +	u8    ps_state;
> +	u8    ps_cmd;
> +	u8    wakeupmode;
> +	u8    cur_wakeupmode;
> +	bool  driver_sent_cmd;
> +	u8    timer_on;
> +	u32   interval;
> +	struct hci_dev *hdev;
> +	struct work_struct work;
> +	struct timer_list ps_timer;
> +};
> +
> +struct btnxpuart_data {
> +	u32 fw_dnld_pri_baudrate;
> +	u32 fw_dnld_sec_baudrate;
> +	u32 fw_init_baudrate;
> +	u32 oper_speed;
> +	u32 ps_interval_ms;
> +	const u8 *fw_name;
> +};
> +
> +struct btnxpuart_dev {
> +	struct hci_dev *hdev;
> +	struct serdev_device *serdev;
> +
> +	struct work_struct tx_work;
> +	unsigned long tx_state;
> +	struct sk_buff_head txq;
> +	struct sk_buff *rx_skb;
> +
> +	const struct firmware *fw;
> +	const struct firmware *fw_config;
> +	u8 fw_name[MAX_FW_FILE_NAME_LEN];
> +	u32 fw_dnld_v1_offset;
> +	u32 fw_v1_sent_bytes;
> +	u32 fw_v3_offset_correction;
> +	wait_queue_head_t suspend_wait_q;
> +
> +	u32 new_baudrate;
> +	u32 current_baudrate;
> +
> +	struct ps_data *psdata;
> +	struct btnxpuart_data *nxp_data;
> +};
> +
> +#define NXP_V1_FW_REQ_PKT      0xa5
> +#define NXP_V1_CHIP_VER_PKT    0xaa
> +#define NXP_V3_FW_REQ_PKT      0xa7
> +#define NXP_V3_CHIP_VER_PKT    0xab
> +
> +#define NXP_ACK_V1             0x5a
> +#define NXP_NAK_V1             0xbf
> +#define NXP_ACK_V3             0x7a
> +#define NXP_NAK_V3             0x7b
> +#define NXP_CRC_ERROR_V3       0x7c
> +
> +#define HDR_LEN					16
> +
> +#define NXP_RECV_FW_REQ_V1 \
> +	.type = NXP_V1_FW_REQ_PKT, \
> +	.hlen = 4, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 4
> +
> +#define NXP_RECV_CHIP_VER_V3 \
> +	.type = NXP_V3_CHIP_VER_PKT, \
> +	.hlen = 4, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 4
> +
> +#define NXP_RECV_FW_REQ_V3 \
> +	.type = NXP_V3_FW_REQ_PKT, \
> +	.hlen = 9, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 9
> +
> +struct v1_data_req {
> +	__le16 len;
> +	__le16 len_comp;
> +} __packed;
> +
> +struct v3_data_req {
> +	__le16 len;
> +	__le32 offset;
> +	__le16 error;
> +	u8 crc;
> +} __packed;
> +
> +struct v3_start_ind {
> +	__le16 chip_id;
> +	u8 loader_ver;
> +	u8 crc;
> +} __packed;
> +
> +/* UART register addresses of BT chip */
> +#define CLKDIVADDR       0x7f00008f
> +#define UARTDIVADDR      0x7f000090
> +#define UARTMCRADDR      0x7f000091
> +#define UARTREINITADDR   0x7f000092
> +#define UARTICRADDR      0x7f000093
> +#define UARTFCRADDR      0x7f000094
> +
> +#define MCR   0x00000022
> +#define INIT  0x00000001
> +#define ICR   0x000000c7
> +#define FCR   0x000000c7
> +
> +#define POLYNOMIAL8				0x07
> +#define POLYNOMIAL32			0x04c11db7L
> +
> +struct uart_reg {
> +	__le32 address;
> +	__le32 value;
> +} __packed;
> +
> +struct uart_config {
> +	struct uart_reg clkdiv;
> +	struct uart_reg uartdiv;
> +	struct uart_reg mcr;
> +	struct uart_reg re_init;
> +	struct uart_reg icr;
> +	struct uart_reg fcr;
> +	__le32 crc;
> +} __packed;
> +
> +struct nxp_bootloader_cmd {
> +	__le32 header;
> +	__le32 arg;
> +	__le32 payload_len;
> +	__le32 crc;
> +} __packed;
> +
> +static u8 crc8_table[CRC8_TABLE_SIZE];
> +static unsigned long crc32_table[256];
> +
> +/* Default Power Save configuration */
> +int wakeupmode = WAKEUP_METHOD_BREAK;
> +int ps_mode = PS_MODE_ENABLE;
> +
> +static struct sk_buff *nxp_drv_send_cmd(struct hci_dev *hdev, u16 opcode,
> +										u32 plen,
> +										void *param)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	struct sk_buff *skb;
> +
> +	psdata->driver_sent_cmd = true;	/* set flag to prevent re-sending command in nxp_enqueue */
> +	skb = __hci_cmd_sync(hdev, opcode, plen, param, HCI_CMD_TIMEOUT);
> +	psdata->driver_sent_cmd = false;
> +
> +	return skb;
> +}
> +
> +static void btnxpuart_tx_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +	if (schedule_work(&nxpdev->tx_work))
> +		set_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
> +}
> +
> +/* NXP Power Save Feature */
> +static void ps_start_timer(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (!psdata)
> +		return;
> +
> +	if (psdata->cur_psmode == PS_MODE_ENABLE) {
> +		psdata->timer_on = 1;
> +		mod_timer(&psdata->ps_timer, jiffies + (psdata->interval * HZ) / 1000);
> +	}
> +}
> +
> +static void ps_cancel_timer(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (!psdata)
> +		return;
> +
> +	flush_work(&psdata->work);
> +	if (psdata->timer_on)
> +		del_timer_sync(&psdata->ps_timer);
> +	kfree(psdata);
> +}
> +
> +static void ps_control(struct hci_dev *hdev, u8 ps_state)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (psdata->ps_state == ps_state)
> +		return;
> +
> +	switch (psdata->cur_wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		if (ps_state == PS_STATE_AWAKE)
> +			serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +		else
> +			serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		bt_dev_info(hdev, "Set UART break: %s", ps_state == PS_STATE_AWAKE ? "off" : "on");
> +		if (ps_state == PS_STATE_AWAKE)
> +			serdev_device_break_ctl(nxpdev->serdev, 0);
> +		else
> +			serdev_device_break_ctl(nxpdev->serdev, -1);
> +		break;
> +	}
> +	psdata->ps_state = ps_state;
> +	if (ps_state == PS_STATE_AWAKE)
> +		btnxpuart_tx_wakeup(nxpdev);
> +}
> +
> +static void ps_work_func(struct work_struct *work)
> +{
> +	struct ps_data *data = container_of(work, struct ps_data, work);
> +
> +	if (data->ps_cmd == PS_CMD_ENTER_PS && data->cur_psmode == PS_MODE_ENABLE)
> +		ps_control(data->hdev, PS_STATE_SLEEP);
> +	else if (data->ps_cmd == PS_CMD_EXIT_PS)
> +		ps_control(data->hdev, PS_STATE_AWAKE);
> +}
> +
> +static void ps_timeout_func(struct timer_list *t)
> +{
> +	struct ps_data *data = from_timer(data, t, ps_timer);
> +	struct hci_dev *hdev = data->hdev;
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	data->timer_on = 0;
> +	if (test_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state)) {
> +		ps_start_timer(nxpdev);
> +	} else {
> +		data->ps_cmd = PS_CMD_ENTER_PS;
> +		schedule_work(&data->work);
> +	}
> +}
> +
> +static int ps_init_work(struct hci_dev *hdev)
> +{
> +	struct ps_data *psdata = kzalloc(sizeof(*psdata), GFP_KERNEL);
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +
> +	if (!psdata) {
> +		bt_dev_err(hdev, "Can't allocate control structure for Power Save feature");
> +		return -ENOMEM;
> +	}
> +	nxpdev->psdata = psdata;
> +
> +	psdata->interval = nxp_data->ps_interval_ms;
> +	psdata->ps_state = PS_STATE_AWAKE;
> +	psdata->ps_mode = ps_mode;
> +	psdata->hdev = hdev;
> +
> +	switch (wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		psdata->wakeupmode = WAKEUP_METHOD_DTR;
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		psdata->wakeupmode = WAKEUP_METHOD_BREAK;
> +		break;
> +	}
> +	psdata->cur_psmode = PS_MODE_DISABLE;
> +	psdata->cur_wakeupmode = WAKEUP_METHOD_INVALID;
> +	INIT_WORK(&psdata->work, ps_work_func);
> +
> +	return 0;
> +}
> +
> +static void ps_init_timer(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	psdata->timer_on = 0;
> +	timer_setup(&psdata->ps_timer, ps_timeout_func, 0);
> +}
> +
> +static int ps_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (psdata->ps_state == PS_STATE_AWAKE)
> +		return 0;
> +	psdata->ps_cmd = PS_CMD_EXIT_PS;
> +	schedule_work(&psdata->work);
> +
> +	return 1;
> +}
> +
> +static int send_ps_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	u8 pcmd;
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	if (psdata->ps_mode == PS_MODE_ENABLE)
> +		pcmd = BT_PS_ENABLE;
> +	else
> +		pcmd = BT_PS_DISABLE;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_AUTO_SLEEP_MODE, 1, &pcmd);
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting Power Save mode failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (!*status)
> +			psdata->cur_psmode = psdata->ps_mode;
> +		else
> +			psdata->ps_mode = psdata->cur_psmode;
> +		if (psdata->cur_psmode == PS_MODE_ENABLE)
> +			ps_start_timer(nxpdev);
> +		else
> +			ps_wakeup(nxpdev);
> +		bt_dev_info(hdev, "Power Save mode response: status=%d, ps_mode=%d",
> +					*status, psdata->cur_psmode);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +static int send_wakeup_method_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	u8 pcmd[4];
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	pcmd[0] = BT_HOST_WAKEUP_METHOD_NONE;
> +	pcmd[1] = 0xff;
> +	switch (psdata->wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		pcmd[2] = BT_CTRL_WAKEUP_METHOD_DSR;
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		pcmd[2] = BT_CTRL_WAKEUP_METHOD_BREAK;
> +		break;
> +	}
> +	pcmd[3] = 0xff;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_WAKEUP_METHOD, 4, pcmd);
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting wake-up method failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (*status == 0)
> +			psdata->cur_wakeupmode = psdata->wakeupmode;
> +		else
> +			psdata->wakeupmode = psdata->cur_wakeupmode;
> +		bt_dev_info(hdev, "Set Wakeup Method response: status=%d, wakeupmode=%d",
> +					*status, psdata->cur_wakeupmode);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +static int ps_init(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	serdev_device_set_tiocm(nxpdev->serdev, TIOCM_RTS, 0);
> +
> +	switch (psdata->wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +		serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		serdev_device_break_ctl(nxpdev->serdev, -1);
> +		usleep_range(5000, 10000);
> +		serdev_device_break_ctl(nxpdev->serdev, 0);
> +		usleep_range(5000, 10000);
> +		break;
> +	}
> +	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
> +		bt_dev_err(hdev, "HCI_RUNNING is not set");
> +		return -EBUSY;
> +	}
> +	if (psdata->cur_wakeupmode != psdata->wakeupmode)
> +		hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +	if (psdata->cur_psmode != psdata->ps_mode)
> +		hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +
> +	return 0;
> +}
> +
> +/* NXP Firmware Download Feature */
> +static void nxp_fw_dnld_gen_crc32_table(void)
> +{
> +	int i, j;
> +	unsigned long crc_accum;
> +
> +	for (i = 0; i < 256; i++) {
> +		crc_accum = ((unsigned long)i << 24);
> +		for (j = 0; j < 8; j++) {
> +			if (crc_accum & 0x80000000L)
> +				crc_accum = (crc_accum << 1) ^ POLYNOMIAL32;
> +			else
> +				crc_accum = (crc_accum << 1);
> +		}
> +		crc32_table[i] = crc_accum;
> +	}
> +}
> +
> +static unsigned long nxp_fw_dnld_update_crc(unsigned long crc_accum,
> +									char *data_blk_ptr,
> +									int data_blk_size)
> +{
> +	unsigned long i, j;
> +
> +	for (j = 0; j < data_blk_size; j++) {
> +		i = ((unsigned long)(crc_accum >> 24) ^ *data_blk_ptr++) & 0xff;
> +		crc_accum = (crc_accum << 8) ^ crc32_table[i];
> +	}
> +	return crc_accum;
> +}
> +
> +static int nxp_download_firmware(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	int err = 0;
> +
> +	nxpdev->fw_dnld_v1_offset = 0;
> +	nxpdev->fw_v1_sent_bytes = 0;
> +
> +	crc8_populate_msb(crc8_table, POLYNOMIAL8);
> +	nxp_fw_dnld_gen_crc32_table();
> +
> +	if (!strlen(nxpdev->fw_name))
> +		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
> +				 nxp_data->fw_name);
> +
> +	bt_dev_info(hdev, "Request Firmware: %s", nxpdev->fw_name);
> +	err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
> +	if (err < 0) {
> +		bt_dev_err(hdev, "Firmware file %s not found", nxpdev->fw_name);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		return err;
> +	}
> +
> +	serdev_device_set_baudrate(nxpdev->serdev, nxp_data->fw_dnld_pri_baudrate);
> +	serdev_device_set_flow_control(nxpdev->serdev, 0);
> +	nxpdev->current_baudrate = nxp_data->fw_dnld_pri_baudrate;
> +	nxpdev->fw_v3_offset_correction = 0;
> +
> +	/* Wait till FW is downloaded and CTS becomes low */
> +	err = wait_event_interruptible_timeout(nxpdev->suspend_wait_q,
> +							!test_bit(BTNXPUART_FW_DOWNLOADING,
> +									  &nxpdev->tx_state),
> +							msecs_to_jiffies(60000));
> +	if (err == 0) {
> +		bt_dev_err(hdev, "FW Download Timeout.");
> +		return -ETIMEDOUT;
> +	}
> +
> +	serdev_device_set_flow_control(nxpdev->serdev, 1);
> +	err = serdev_device_wait_for_cts(nxpdev->serdev, 1, 60000);
> +	if (err < 0) {
> +		bt_dev_err(hdev, "CTS is still high. FW Download failed.");
> +		return err;
> +	}
> +	bt_dev_info(hdev, "CTS is low");
> +	release_firmware(nxpdev->fw);
> +
> +	/* Allow the downloaded FW to initialize */
> +	usleep_range(1000000, 1200000);
> +
> +	return 0;
> +}
> +
> +static int nxp_send_ack(u8 ack, struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	u8 ack_nak[2];
> +
> +	if (ack == NXP_ACK_V1 || ack == NXP_NAK_V1) {
> +		ack_nak[0] = ack;
> +		serdev_device_write_buf(nxpdev->serdev, ack_nak, 1);
> +	} else if (ack == NXP_ACK_V3) {
> +		ack_nak[0] = ack;
> +		ack_nak[1] = crc8(crc8_table, ack_nak, 1, 0xff);
> +		serdev_device_write_buf(nxpdev->serdev, ack_nak, 2);
> +	}
> +	return 0;
> +}
> +
> +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct nxp_bootloader_cmd nxp_cmd5;
> +	struct uart_config uart_config;
> +
> +	if (req_len == sizeof(nxp_cmd5)) {
> +		nxp_cmd5.header = __cpu_to_le32(5);
> +		nxp_cmd5.arg = 0;
> +		nxp_cmd5.payload_len = __cpu_to_le32(sizeof(uart_config));
> +		nxp_cmd5.crc = swab32(nxp_fw_dnld_update_crc(0UL,
> +									 (char *)&nxp_cmd5,
> +									 sizeof(nxp_cmd5) - 4));
> +
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd5, req_len);
> +		nxpdev->fw_v3_offset_correction += req_len;
> +	} else if (req_len == sizeof(uart_config)) {
> +		uart_config.clkdiv.address = __cpu_to_le32(CLKDIVADDR);
> +		uart_config.clkdiv.value = __cpu_to_le32(0x00c00000);
> +		uart_config.uartdiv.address = __cpu_to_le32(UARTDIVADDR);
> +		uart_config.uartdiv.value = __cpu_to_le32(1);
> +		uart_config.mcr.address = __cpu_to_le32(UARTMCRADDR);
> +		uart_config.mcr.value = __cpu_to_le32(MCR);
> +		uart_config.re_init.address = __cpu_to_le32(UARTREINITADDR);
> +		uart_config.re_init.value = __cpu_to_le32(INIT);
> +		uart_config.icr.address = __cpu_to_le32(UARTICRADDR);
> +		uart_config.icr.value = __cpu_to_le32(ICR);
> +		uart_config.fcr.address = __cpu_to_le32(UARTFCRADDR);
> +		uart_config.fcr.value = __cpu_to_le32(FCR);
> +		uart_config.crc = swab32(nxp_fw_dnld_update_crc(0UL,
> +									(char *)&uart_config,
> +									sizeof(uart_config) - 4));
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&uart_config, req_len);
> +		serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +		nxpdev->fw_v3_offset_correction += req_len;
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static bool nxp_fw_change_timeout(struct hci_dev *hdev, u16 req_len)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct nxp_bootloader_cmd nxp_cmd7;
> +
> +	if (req_len != sizeof(nxp_cmd7))
> +		return false;
> +
> +	nxp_cmd7.header = __cpu_to_le32(7);
> +	nxp_cmd7.arg = __cpu_to_le32(0x70);
> +	nxp_cmd7.payload_len = 0;
> +	nxp_cmd7.crc = swab32(nxp_fw_dnld_update_crc(0UL,
> +								(char *)&nxp_cmd7,
> +								sizeof(nxp_cmd7) - 4));
> +
> +	serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7, req_len);
> +	serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +	nxpdev->fw_v3_offset_correction += req_len;
> +	return true;
> +}
> +
> +static u32 nxp_get_data_len(const u8 *buf)
> +{
> +	struct nxp_bootloader_cmd *hdr = (struct nxp_bootloader_cmd *)buf;
> +
> +	return __le32_to_cpu(hdr->payload_len);
> +}
> +
> +/* for legacy chipsets with V1 bootloader */
> +static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct v1_data_req *req = skb_pull_data(skb, sizeof(struct v1_data_req));
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	static bool timeout_changed;
> +	static bool baudrate_changed;
> +	u32 requested_len;
> +	static u32 expected_len = HDR_LEN;
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;
> +
> +	if (!nxpdev->fw)
> +		goto ret;
> +
> +	if (req && (req->len ^ req->len_comp) != 0xffff) {
> +		bt_dev_info(hdev, "ERR: Send NAK");
> +		nxp_send_ack(NXP_NAK_V1, hdev);
> +		goto ret;
> +	}
> +	nxp_send_ack(NXP_ACK_V1, hdev);
> +
> +	if (nxp_data->fw_dnld_sec_baudrate != nxpdev->current_baudrate) {
> +		if (!timeout_changed) {
> +			timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +			goto ret;
> +		}
> +		if (!baudrate_changed) {
> +			baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +			if (baudrate_changed) {
> +				serdev_device_set_baudrate(nxpdev->serdev,
> +								nxp_data->fw_dnld_sec_baudrate);
> +				serdev_device_set_flow_control(nxpdev->serdev, 1);
> +				nxpdev->current_baudrate = nxp_data->fw_dnld_sec_baudrate;
> +			}
> +			goto ret;
> +		}
> +	}
> +
> +	requested_len = req->len;
> +	if (requested_len == 0) {
> +		bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->suspend_wait_q);
> +		goto ret;
> +	}
> +	if (requested_len & 0x01) {
> +		/* The CRC did not match at the other end.
> +		 * Simply send the same bytes again.
> +		 */
> +		requested_len = nxpdev->fw_v1_sent_bytes;
> +		bt_dev_err(hdev, "CRC error. Resend %d bytes of FW.", requested_len);
> +	} else {
> +		nxpdev->fw_dnld_v1_offset += nxpdev->fw_v1_sent_bytes;
> +
> +		/* The FW bin file is made up of many blocks of
> +		 * 16 byte header and payload data chunks. If the
> +		 * FW has requested a header, read the payload length
> +		 * info from the header, before sending the header.
> +		 * In the next iteration, the FW should request the
> +		 * payload data chunk, which should be equal to the
> +		 * payload length read from header. If there is a
> +		 * mismatch, clearly the driver and FW are out of sync,
> +		 * and we need to re-send the previous header again.
> +		 */
> +		if (requested_len == expected_len) {
> +			if (requested_len == HDR_LEN)
> +				expected_len = nxp_get_data_len(nxpdev->fw->data +
> +									nxpdev->fw_dnld_v1_offset);
> +			else
> +				expected_len = HDR_LEN;
> +		} else {
> +			if (requested_len == HDR_LEN) {
> +				/* FW download out of sync. Send previous chunk again */
> +				nxpdev->fw_dnld_v1_offset -= nxpdev->fw_v1_sent_bytes;
> +				expected_len = HDR_LEN;
> +			}
> +		}
> +	}
> +
> +	if (nxpdev->fw_dnld_v1_offset + requested_len <= nxpdev->fw->size)
> +		serdev_device_write_buf(nxpdev->serdev,
> +				nxpdev->fw->data + nxpdev->fw_dnld_v1_offset,
> +				requested_len);
> +	nxpdev->fw_v1_sent_bytes = requested_len;
> +
> +ret:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static int nxp_recv_chip_ver_v3(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		nxp_send_ack(NXP_ACK_V3, hdev);
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct v3_data_req *req = skb_pull_data(skb, sizeof(struct v3_data_req));
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	static bool timeout_changed;
> +	static bool baudrate_changed;
> +
> +	if (!req || !nxpdev || !nxpdev->fw->data)
> +		goto ret;
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;
> +
> +	nxp_send_ack(NXP_ACK_V3, hdev);
> +
> +	if (nxpdev->current_baudrate != nxp_data->fw_dnld_sec_baudrate) {
> +		if (!timeout_changed) {
> +			timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +			goto ret;
> +		}
> +
> +		if (!baudrate_changed) {
> +			baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +			if (baudrate_changed) {
> +				serdev_device_set_baudrate(nxpdev->serdev,
> +								nxp_data->fw_dnld_sec_baudrate);
> +				serdev_device_set_flow_control(nxpdev->serdev, 1);
> +				nxpdev->current_baudrate = nxp_data->fw_dnld_sec_baudrate;
> +			}
> +			goto ret;
> +		}
> +	}
> +
> +	if (req->len == 0) {
> +		bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->suspend_wait_q);
> +		goto ret;
> +	}
> +	if (req->error)
> +		bt_dev_err(hdev, "FW Download received err 0x%02x from chip. Resending FW chunk.",
> +			   req->error);
> +
> +	if (req->offset < nxpdev->fw_v3_offset_correction) {
> +		/* This scenario should ideally never occur.
> +		 * But if it ever does, FW is out of sync and
> +		 * needs a power cycle.
> +		 */
> +		bt_dev_err(hdev, "Something went wrong during FW download. Please power cycle and try again");
> +		goto ret;
> +	}
> +
> +	serdev_device_write_buf(nxpdev->serdev,
> +				nxpdev->fw->data + req->offset - nxpdev->fw_v3_offset_correction,
> +				req->len);
> +
> +ret:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static int nxp_set_baudrate_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	u32 new_baudrate = __cpu_to_le32(nxpdev->new_baudrate);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	u8 *pcmd = (u8 *)&new_baudrate;
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	if (!psdata)
> +		return 0;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_SET_OPER_SPEED, 4, pcmd);
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting baudrate failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (*status == 0) {
> +			serdev_device_set_baudrate(nxpdev->serdev, nxpdev->new_baudrate);
> +			nxpdev->current_baudrate = nxpdev->new_baudrate;
> +		}
> +		bt_dev_info(hdev, "Set baudrate response: status=%d, baudrate=%d",
> +					*status, nxpdev->new_baudrate);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +/* NXP protocol */
> +static void nxp_update_device_data(struct hci_dev *hdev,
> +								   char *label, char *value)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	int ret = 0;
> +	u32 val;
> +
> +	if (!strncmp(label, FW_NAME_TAG, MAX_TAG_STR_LEN)) {
> +		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
> +				 value);
> +		return;
> +	}
> +
> +	ret = sscanf(value, "%u", &val);
> +	if (ret != 1) {
> +		bt_dev_err(hdev, "Error parsing value for %s", label);
> +		return;
> +	}
> +
> +	if (!strncmp(label, OPER_SPEED_TAG, MAX_TAG_STR_LEN))
> +		nxp_data->oper_speed = val;
> +	else if (!strncmp(label, FW_DL_PRI_BAUDRATE_TAG, MAX_TAG_STR_LEN))
> +		nxp_data->fw_dnld_pri_baudrate = val;
> +	else if (!strncmp(label, FW_DL_SEC_BAUDRATE_TAG, MAX_TAG_STR_LEN))
> +		nxp_data->fw_dnld_sec_baudrate = val;
> +	else if (!strncmp(label, FW_INIT_BAUDRATE, MAX_TAG_STR_LEN))
> +		nxp_data->fw_init_baudrate = val;
> +	else if (!strncmp(label, PS_INTERVAL_MS, MAX_TAG_STR_LEN))
> +		nxp_data->ps_interval_ms = val;
> +}
> +
> +static void nxp_parse_conf_file(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	char *dptr, *label, *value;
> +	bool valid_param = false;
> +	bool skipline = false;
> +	int param_index = 0;
> +	const char *sptr;
> +	int line_num = 1;
> +	char line[100];
> +	int ret = 0;
> +	int i, j;
> +
> +	ret = request_firmware(&nxpdev->fw_config, BT_FW_CONF_FILE, &hdev->dev);
> +	if (ret < 0) {
> +		bt_dev_info(hdev, "No NXP config file, using default settings");
> +		return;
> +	}
> +
> +	sptr = nxpdev->fw_config->data;
> +	j = 0;
> +	for (i = 0; i < nxpdev->fw_config->size; i++) {
> +		/* if current line is a comment, ignore */
> +		if (sptr[i] == '#') {
> +			skipline = true;
> +			continue;
> +		}
> +		/* keep ignoring the entire comment line */
> +		if (sptr[i] != '\n' && skipline)
> +			continue;
> +		/* ignore space, <CR> and comma */
> +		if (sptr[i] == ' ' || sptr[i] == '\r' || sptr[i] == ',')
> +			continue;
> +		/* handle '}' */
> +		if (sptr[i] == '}') {
> +			if (!valid_param) {
> +				bt_dev_err(hdev, "Unexpected '}' on line %d", line_num);
> +				goto ret;
> +			}
> +			valid_param = false;
> +			param_index++;
> +			continue;
> +		}
> +		/* handle new-line character */
> +		if (sptr[i] == '\n') {
> +			line_num++;
> +			if (skipline) {
> +				skipline = false;
> +				continue;
> +			}
> +			line[j] = '\0';
> +			/* ignore empty lines */
> +			if (strlen(line) == 0)
> +				continue;
> +
> +			dptr = line;
> +			label = strsep(&dptr, "=");
> +			value = strsep(&dptr, "=");
> +			if (label && value) {
> +				/* handle '{' */
> +				if (!strncmp(value, "{", MAX_TAG_STR_LEN) &&
> +					!strncmp(label, USER_CONFIG_TAG, MAX_TAG_STR_LEN)) {
> +					valid_param = true;
> +				} else if (valid_param) {
> +					nxp_update_device_data(hdev, label, value);
> +				}
> +			} else {
> +				bt_dev_err(hdev, "Invalid \"key\" = \"value\" pair at line: %d",
> +					   line_num - 1);
> +				goto ret;
> +			}
> +			j = 0;
> +		} else {
> +			line[j] = sptr[i];
> +			j++;
> +			if (j >= 100) {
> +				bt_dev_err(hdev, "Line too long: %d", line_num);
> +				goto ret;
> +			}
> +		}
> +	}
> +
> +ret:
> +	release_firmware(nxpdev->fw_config);
> +}
> +
> +static int nxp_setup(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	int err = 0;
> +
> +	if (!nxpdev)
> +		return 0;
> +
> +	set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +
> +	nxp_parse_conf_file(hdev);
> +	init_waitqueue_head(&nxpdev->suspend_wait_q);
> +
> +	if (!serdev_device_get_cts(nxpdev->serdev)) {
> +		bt_dev_info(hdev, "CTS high. Need FW Download");
> +		err = nxp_download_firmware(hdev);
> +		if (err < 0)
> +			return err;
> +	} else {
> +		bt_dev_info(hdev, "CTS low. FW already running.");
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +	}
> +
> +	serdev_device_set_flow_control(nxpdev->serdev, 1);
> +	serdev_device_set_baudrate(nxpdev->serdev, nxp_data->fw_init_baudrate);
> +	nxpdev->current_baudrate = nxp_data->fw_init_baudrate;
> +
> +	if (nxpdev->current_baudrate != nxp_data->oper_speed) {
> +		nxpdev->new_baudrate = nxp_data->oper_speed;
> +		hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
> +	}
> +
> +	if (!ps_init_work(hdev))
> +		ps_init_timer(hdev);
> +	ps_init(hdev);
> +
> +	return 0;
> +}
> +
> +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	struct hci_command_hdr *hdr;
> +	u8 *param;
> +
> +	if (!nxpdev || !psdata) {
> +		kfree_skb(skb);
> +		goto ret;
> +	}
> +
> +	/* if vendor commands are received from user space (e.g. hcitool), update
> +	 * driver flags accordingly and ask driver to re-send the command to FW.
> +	 */
> +	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT && !psdata->driver_sent_cmd) {
> +		hdr = (struct hci_command_hdr *)skb->data;
> +		param = skb->data + HCI_COMMAND_HDR_SIZE;
> +		switch (__le16_to_cpu(hdr->opcode)) {
> +		case HCI_NXP_AUTO_SLEEP_MODE:
> +			if (hdr->plen >= 1) {
> +				if (param[0] == BT_PS_ENABLE)
> +					psdata->ps_mode = PS_MODE_ENABLE;
> +				else if (param[0] == BT_PS_DISABLE)
> +					psdata->ps_mode = PS_MODE_DISABLE;
> +				hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +				kfree_skb(skb);
> +				goto ret;
> +			}
> +			break;
> +		case HCI_NXP_WAKEUP_METHOD:
> +			if (hdr->plen >= 4) {
> +				switch (param[2]) {
> +				case BT_CTRL_WAKEUP_METHOD_DSR:
> +					psdata->wakeupmode = WAKEUP_METHOD_DTR;
> +					break;
> +				case BT_CTRL_WAKEUP_METHOD_BREAK:
> +				default:
> +					psdata->wakeupmode = WAKEUP_METHOD_BREAK;
> +					break;
> +				}
> +				hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +				kfree_skb(skb);
> +				goto ret;
> +			}
> +			break;
> +		case HCI_NXP_SET_OPER_SPEED:
> +			if (hdr->plen == 4) {
> +				nxpdev->new_baudrate = *((u32 *)param);
> +				hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
> +				kfree_skb(skb);
> +				goto ret;
> +			}
> +		}
> +	}
> +
> +	/* Prepend skb with frame type */
> +	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> +	skb_queue_tail(&nxpdev->txq, skb);
> +
> +	btnxpuart_tx_wakeup(nxpdev);
> +ret:
> +	return 0;
> +}
> +
> +static struct sk_buff *nxp_dequeue(void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = (struct btnxpuart_dev *)data;
> +
> +	ps_wakeup(nxpdev);
> +	ps_start_timer(nxpdev);
> +	return skb_dequeue(&nxpdev->txq);
> +}
> +
> +/* btnxpuart based on serdev */
> +static void btnxpuart_tx_work(struct work_struct *work)
> +{
> +	struct btnxpuart_dev *nxpdev = container_of(work, struct btnxpuart_dev,
> +						   tx_work);
> +	struct serdev_device *serdev = nxpdev->serdev;
> +	struct hci_dev *hdev = nxpdev->hdev;
> +	struct sk_buff *skb;
> +	int len;
> +
> +	while ((skb = nxp_dequeue(nxpdev))) {
> +		len = serdev_device_write_buf(serdev, skb->data, skb->len);
> +		hdev->stat.byte_tx += len;
> +
> +		skb_pull(skb, len);
> +		if (skb->len > 0) {
> +			skb_queue_head(&nxpdev->txq, skb);
> +			break;
> +		}
> +
> +		switch (hci_skb_pkt_type(skb)) {
> +		case HCI_COMMAND_PKT:
> +			hdev->stat.cmd_tx++;
> +			break;
> +		case HCI_ACLDATA_PKT:
> +			hdev->stat.acl_tx++;
> +			break;
> +		case HCI_SCODATA_PKT:
> +			hdev->stat.sco_tx++;
> +			break;
> +		}
> +
> +		kfree_skb(skb);
> +	}
> +	clear_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
> +}
> +
> +static int btnxpuart_open(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err = 0;
> +
> +	err = serdev_device_open(nxpdev->serdev);
> +	if (err) {
> +		bt_dev_err(hdev, "Unable to open UART device %s",
> +			   dev_name(&nxpdev->serdev->dev));
> +	}
> +
> +	return err;
> +}
> +
> +static int btnxpuart_close(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (!nxpdev)
> +		return 0;
> +
> +	serdev_device_close(nxpdev->serdev);
> +
> +	return 0;
> +}
> +
> +static int btnxpuart_flush(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (!nxpdev)
> +		return 0;
> +
> +	/* Flush any pending characters */
> +	serdev_device_write_flush(nxpdev->serdev);
> +	skb_queue_purge(&nxpdev->txq);
> +
> +	cancel_work_sync(&nxpdev->tx_work);
> +
> +	kfree_skb(nxpdev->rx_skb);
> +	nxpdev->rx_skb = NULL;
> +
> +	return 0;
> +}
> +
> +static const struct h4_recv_pkt nxp_recv_pkts[] = {
> +	{ H4_RECV_ACL,          .recv = hci_recv_frame },
> +	{ H4_RECV_SCO,          .recv = hci_recv_frame },
> +	{ H4_RECV_EVENT,        .recv = hci_recv_frame },
> +	{ NXP_RECV_FW_REQ_V1,   .recv = nxp_recv_fw_req_v1 },
> +	{ NXP_RECV_CHIP_VER_V3, .recv = nxp_recv_chip_ver_v3 },
> +	{ NXP_RECV_FW_REQ_V3,   .recv = nxp_recv_fw_req_v3 },
> +};
> +
> +static int btnxpuart_receive_buf(struct serdev_device *serdev, const u8 *data,
> +								 size_t count)
> +{
> +	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
> +
> +	if (test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state)) {
> +		if (*data != NXP_V1_FW_REQ_PKT && *data != NXP_V1_CHIP_VER_PKT &&
> +			*data != NXP_V3_FW_REQ_PKT && *data != NXP_V3_CHIP_VER_PKT) {
> +			/* Unknown bootloader signature, skip without returning error */
> +			return count;
> +		}
> +	}
> +
> +	ps_start_timer(nxpdev);
> +
> +	nxpdev->rx_skb = h4_recv_buf(nxpdev->hdev, nxpdev->rx_skb, data, count,
> +						nxp_recv_pkts, ARRAY_SIZE(nxp_recv_pkts));
> +	if (IS_ERR(nxpdev->rx_skb)) {
> +		int err = PTR_ERR(nxpdev->rx_skb);
> +
> +		bt_dev_err(nxpdev->hdev, "Frame reassembly failed (%d)", err);
> +		nxpdev->rx_skb = NULL;
> +		return err;
> +	}
> +	nxpdev->hdev->stat.byte_rx += count;
> +	return count;
> +}
> +
> +static void btnxpuart_write_wakeup(struct serdev_device *serdev)
> +{
> +	serdev_device_write_wakeup(serdev);
> +}
> +
> +static const struct serdev_device_ops btnxpuart_client_ops = {
> +	.receive_buf = btnxpuart_receive_buf,
> +	.write_wakeup = btnxpuart_write_wakeup,
> +};
> +
> +static int nxp_serdev_probe(struct serdev_device *serdev)
> +{
> +	struct hci_dev *hdev;
> +	struct btnxpuart_dev *nxpdev;
> +
> +	nxpdev = devm_kzalloc(&serdev->dev, sizeof(*nxpdev), GFP_KERNEL);
> +	if (!nxpdev)
> +		return -ENOMEM;
> +
> +	nxpdev->nxp_data = (struct btnxpuart_data *)device_get_match_data(&serdev->dev);
> +
> +	nxpdev->serdev = serdev;
> +	serdev_device_set_drvdata(serdev, nxpdev);
> +
> +	serdev_device_set_client_ops(serdev, &btnxpuart_client_ops);
> +
> +	INIT_WORK(&nxpdev->tx_work, btnxpuart_tx_work);
> +	skb_queue_head_init(&nxpdev->txq);
> +
> +	/* Initialize and register HCI device */
> +	hdev = hci_alloc_dev();
> +	if (!hdev) {
> +		dev_err(&serdev->dev, "Can't allocate HCI device\n");
> +		return -ENOMEM;
> +	}
> +
> +	nxpdev->hdev = hdev;
> +
> +	hdev->bus = HCI_UART;
> +	hci_set_drvdata(hdev, nxpdev);
> +
> +	hdev->manufacturer = 37;
> +	hdev->open  = btnxpuart_open;
> +	hdev->close = btnxpuart_close;
> +	hdev->flush = btnxpuart_flush;
> +	hdev->setup = nxp_setup;
> +	hdev->send  = nxp_enqueue;
> +	SET_HCIDEV_DEV(hdev, &serdev->dev);
> +
> +	if (hci_register_dev(hdev) < 0) {
> +		dev_err(&serdev->dev, "Can't register HCI device\n");
> +		hci_free_dev(hdev);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static void nxp_serdev_remove(struct serdev_device *serdev)
> +{
> +	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	struct hci_dev *hdev = nxpdev->hdev;
> +
> +	/* Restore FW baudrate to fw_init_baudrate if changed.
> +	 * This will ensure FW baudrate is in sync with
> +	 * driver baudrate in case this driver is re-inserted.
> +	 */
> +	if (nxp_data->fw_init_baudrate != nxpdev->current_baudrate) {
> +		nxpdev->new_baudrate = nxp_data->fw_init_baudrate;
> +		nxp_set_baudrate_cmd(hdev, NULL);
> +	}
> +
> +	ps_cancel_timer(nxpdev);
> +	hci_unregister_dev(hdev);
> +	hci_free_dev(hdev);
> +}
> +
> +/* Following default values are as per Murata M.2 modules
> + * For modules from different vendor, if any of the device
> + * parameters are different, they can be over-written by
> + * config file /lib/firmware/nxp/bt_mod_para.conf
> + */
> +static struct btnxpuart_data w8987_data = {
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 115200,
> +	.oper_speed		= 3000000,
> +	.ps_interval_ms = PS_DEFAULT_TIMEOUT_PERIOD,
> +	.fw_name = FIRMWARE_W8987,
> +};
> +
> +static struct btnxpuart_data w8997_data = {
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 115200,
> +	.fw_init_baudrate = 115200,
> +	.oper_speed		= 3000000,
> +	.ps_interval_ms = PS_DEFAULT_TIMEOUT_PERIOD,
> +	.fw_name = FIRMWARE_W8997,
> +};
> +
> +static struct btnxpuart_data w9098_data = {
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 115200,
> +	.oper_speed		= 3000000,
> +	.ps_interval_ms = PS_DEFAULT_TIMEOUT_PERIOD,
> +	.fw_name = FIRMWARE_W9098,
> +};
> +
> +static struct btnxpuart_data iw416_data = {
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 115200,
> +	.oper_speed		= 3000000,
> +	.ps_interval_ms = PS_DEFAULT_TIMEOUT_PERIOD,
> +	.fw_name = FIRMWARE_IW416,
> +};
> +
> +static struct btnxpuart_data iw612_data = {
> +	.fw_dnld_pri_baudrate = 115200,
> +	.fw_dnld_sec_baudrate = 3000000,
> +	.fw_init_baudrate = 115200,
> +	.oper_speed		= 3000000,
> +	.ps_interval_ms = PS_DEFAULT_TIMEOUT_PERIOD,
> +	.fw_name = FIRMWARE_IW612,
> +};
> +
> +static const struct of_device_id nxpuart_of_match_table[] = {
> +	{ .compatible = "nxp,88w8987-bt", .data = &w8987_data },
> +	{ .compatible = "nxp,88w8997-bt", .data = &w8997_data },
> +	{ .compatible = "nxp,88w9098-bt", .data = &w9098_data },
> +	{ .compatible = "nxp,iw416-bt", .data = &iw416_data },
> +	{ .compatible = "nxp,iw612-bt", .data = &iw612_data },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, nxpuart_of_match_table);
> +
> +static struct serdev_device_driver nxp_serdev_driver = {
> +	.probe = nxp_serdev_probe,
> +	.remove = nxp_serdev_remove,
> +	.driver = {
> +		.name = "btnxpuart",
> +		.of_match_table = of_match_ptr(nxpuart_of_match_table),
> +	},
> +};
> +
> +module_serdev_device_driver(nxp_serdev_driver);
> +
> +MODULE_AUTHOR("Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>");
> +MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");
> +MODULE_LICENSE("GPL");
> 
--8323329-571507949-1676300656=:1712--
