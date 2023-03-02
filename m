Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5064A6A84E7
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCBPGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCBPG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:06:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAC055040;
        Thu,  2 Mar 2023 07:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677769583; x=1709305583;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=nKj04xs2Fq0+7imMkFf5iPBqdy/ozgt0AwZbIx4z6sQ=;
  b=WIBI5yXM94iChRmpAW4JmSII3pfwnTzSMbO9+mO67RAwrcNNEUnzP1Q0
   sEjnfFDuZvUC7ZTj/9wPAHG27ZtT111eshF2AzuYdNpFs6uBjz1QDgyfy
   I7t9pq2IbzQsMSs8RXFO+XMwBnnD+3kXtnjSnYZ4RJBYs6LvJ5UJsm8P8
   xLlVjnmwpBhANsglhdKsisJR0Vlh+LeqFsFaX8fzldEeQFqan25FY4cDC
   qUZBFCxDaStuLNIZ/XGrWsfcVgWF+QomdErvX80GTDXVXEO/o0ZkjQbbC
   kmE3OvUc1XwRGlAIiAOynRLsoF4BNr5VB9nnEETlFubp5EK8jKLuGO84l
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="318553732"
X-IronPort-AV: E=Sophos;i="5.98,228,1673942400"; 
   d="scan'208";a="318553732"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 06:43:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="818056664"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="818056664"
Received: from pawellew-mobl1.ger.corp.intel.com ([10.252.46.79])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 06:43:37 -0800
Date:   Thu, 2 Mar 2023 16:43:25 +0200 (EET)
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
Subject: Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
In-Reply-To: <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
Message-ID: <73527cb7-6546-6c47-768c-5f4648b6d477@linux.intel.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com> <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-218316480-1677768222=:2066"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-218316480-1677768222=:2066
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 1 Mar 2023, Neeraj Sanjay Kale wrote:

> This adds a driver based on serdev driver for the NXP BT serial protocol
> based on running H:4, which can enable the built-in Bluetooth device
> inside an NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into sleep state
> whenever there is no activity for 2000ms, and will be woken up when any
> activity is to be initiated over UART.
> 
> This driver enables the power save feature by default by sending the vendor
> specific commands to the chip during setup.
> 
> During setup, the driver checks if a FW is already running on the chip
> by waiting for the bootloader signature, and downloads device specific FW
> file into the chip over UART if bootloader signature is received..
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip based
> on compatibility devices mentioned in DT bindings. Handled potential
> memory leaks and null pointer dereference issues, simplified FW download
> feature, handled byte-order and few cosmetic changes. (Ilpo Järvinen,
> Alok Tiwari, Hillf Danton)
> v3: Added conf file support necessary to support different vendor modules,
> moved .h file contents to .c, cosmetic changes. (Luiz Augusto von Dentz,
> Rob Herring, Leon Romanovsky)
> v4: Removed conf file support, optimized driver data, add logic to select
> FW name based on chip signature (Greg KH, Ilpo Jarvinen, Sherry Sun)
> v5: Replaced bt_dev_info() with bt_dev_dbg(), handled user-space cmd
> parsing in nxp_enqueue() in a better way. (Greg KH, Luiz Augusto von Dentz)
> v6: Add support for fw-init-baudrate parameter from device tree,
> modified logic to detect FW download is needed or FW is running. (Greg
> KH, Sherry Sun)
> ---
>  MAINTAINERS                   |    1 +
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1317 +++++++++++++++++++++++++++++++++
>  4 files changed, 1330 insertions(+)
>  create mode 100644 drivers/bluetooth/btnxpuart.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 030ec6fe89df..fdb9b0788c89 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22840,6 +22840,7 @@ M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
>  M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> +F:	drivers/bluetooth/btnxpuart.c
>  
>  THE REST
>  M:	Linus Torvalds <torvalds@linux-foundation.org>
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 5a1a7bec3c42..359a4833e31f 100644
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
> +	  the kernel, or say M here to compile as a module (btnxpuart).
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
> index 000000000000..f581e05ddecb
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.c
> @@ -0,0 +1,1317 @@
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
> +#include <linux/crc32.h>
> +
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +
> +#include "h4_recv.h"
> +
> +#define MANUFACTURER_NXP		37
> +
> +#define BTNXPUART_TX_STATE_ACTIVE	1
> +#define BTNXPUART_FW_DOWNLOADING	2
> +#define BTNXPUART_CHECK_BOOT_SIGNATURE	3
> +
> +#define FIRMWARE_W8987	"nxp/uartuart8987_bt.bin"
> +#define FIRMWARE_W8997	"nxp/uartuart8997_bt_v4.bin"
> +#define FIRMWARE_W9098	"nxp/uartuart9098_bt_v1.bin"
> +#define FIRMWARE_IW416	"nxp/uartiw416_bt_v0.bin"
> +#define FIRMWARE_IW612	"nxp/uartspi_n61x_v1.bin.se"
> +
> +#define CHIP_ID_W9098		0x5c03
> +#define CHIP_ID_IW416		0x7201
> +#define CHIP_ID_IW612		0x7601
> +
> +#define HCI_NXP_PRI_BAUDRATE	115200
> +#define HCI_NXP_SEC_BAUDRATE	3000000
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
> +/* Bluetooth vendor command: Independent Reset */
> +#define HCI_NXP_IND_RESET	0xfcfc
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
> +#define MAX_USER_PARAMS			10
> +
> +struct ps_data {
> +	u8    ps_mode;
> +	u8    cur_psmode;
> +	u8    ps_state;

I tried to follow the code around these variables but its turned out too
hard for me... Should ps_mode perhaps be renamed to target_psmode?

Should nxp_enqueue() check if ps_mode was changed or not before calling
hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL); ?

It would be useful to explain somewhere how cur_psmode and ps_state 
actually differ because they kinda sound the same.

> +	u8    ps_cmd;
> +	u8    h2c_wakeupmode;
> +	u8    cur_h2c_wakeupmode;
> +	u8    c2h_wakeupmode;
> +	u8    c2h_wakeup_gpio;
> +	bool  driver_sent_cmd;
> +	bool  timer_on;

Look unnecessary, only used to guard del_timer_sync() but it already check 
for timer_pending().

> +	u32   interval;
> +	struct hci_dev *hdev;
> +	struct work_struct work;
> +	struct timer_list ps_timer;
> +};

> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		if (ps_state == PS_STATE_AWAKE)
> +			status = serdev_device_break_ctl(nxpdev->serdev, 0);
> +		else
> +			status = serdev_device_break_ctl(nxpdev->serdev, -1);
> +		bt_dev_dbg(hdev, "Set UART break: %s, status=%d",
> +			   ps_state == PS_STATE_AWAKE ? "off" : "on", status);

str_on_off() from linux/string_helpers.h


> +static int send_wakeup_method_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +	u8 pcmd[4];
> +	struct sk_buff *skb;
> +	u8 *status;
> +

> +	pcmd[0] = psdata->c2h_wakeupmode;
> +	pcmd[1] = psdata->c2h_wakeup_gpio;
> +	switch (psdata->h2c_wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		pcmd[2] = BT_CTRL_WAKEUP_METHOD_DSR;
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		pcmd[2] = BT_CTRL_WAKEUP_METHOD_BREAK;
> +		break;
> +	}
> +	pcmd[3] = 0xff;

Looks like an unnamed structure.

> +static void ps_init(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_RTS);
> +	usleep_range(5000, 10000);
> +	serdev_device_set_tiocm(nxpdev->serdev, TIOCM_RTS, 0);
> +	usleep_range(5000, 10000);
> +
> +	switch (psdata->h2c_wakeupmode) {
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
> +		bt_dev_dbg(hdev, "HCI_RUNNING is not set");
> +		return;

Is this an error that should be returned through the callchain rather than
concealed?

> +	}
> +	if (psdata->cur_h2c_wakeupmode != psdata->h2c_wakeupmode)
> +		hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +	if (psdata->cur_psmode != psdata->ps_mode)
> +		hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +}
> +
> +/* NXP Firmware Download Feature */
> +static int nxp_download_firmware(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err = 0;
> +
> +	nxpdev->fw_dnld_v1_offset = 0;
> +	nxpdev->fw_v1_sent_bytes = 0;
> +	nxpdev->fw_v1_expected_len = HDR_LEN;
> +	nxpdev->fw_v3_offset_correction = 0;
> +	nxpdev->baudrate_changed = false;
> +	nxpdev->timeout_changed = false;
> +
> +	serdev_device_set_baudrate(nxpdev->serdev, HCI_NXP_PRI_BAUDRATE);
> +	serdev_device_set_flow_control(nxpdev->serdev, 0);
> +	nxpdev->current_baudrate = HCI_NXP_PRI_BAUDRATE;
> +
> +	/* Wait till FW is downloaded and CTS becomes low */
> +	err = wait_event_interruptible_timeout(nxpdev->fw_dnld_done_wait_q,
> +					       !test_bit(BTNXPUART_FW_DOWNLOADING,
> +							 &nxpdev->tx_state),
> +					       msecs_to_jiffies(60000));
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
> +	release_firmware(nxpdev->fw);
> +	memset(nxpdev->fw_name, 0, MAX_FW_FILE_NAME_LEN);

Use sizeof() instead.

> +
> +	/* Allow the downloaded FW to initialize */
> +	usleep_range(800000, 1000000);

There would be USEC_PER_* constants to make these easier to read.

> +	return 0;
> +}
> +
> +static void nxp_send_ack(u8 ack, struct hci_dev *hdev)
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

This could be done as:

        int len = 1;

        ack_nak[0] = ack;
        if (ack == NXP_ACK_V3) {
                len = 2;
                ack_nak[1] = crc8(crc8_table, ack_nak, 1, 0xff);
        }
        serdev_device_write_buf(nxpdev->serdev, ack_nak, len);

or calculate the len with NXP_ACK_V3 ? 2 : 1 on the func call line.

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
> +		nxp_cmd5.crc = swab32(crc32_be(0UL, (char *)&nxp_cmd5,
> +					       sizeof(nxp_cmd5) - 4));

swab32(crc32_be(...)) seems and odd construct instead of __cpu_to_le32().

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
> +		uart_config.crc = swab32(crc32_be(0UL, (char *)&uart_config,
> +						  sizeof(uart_config) - 4));

Ditto.

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
> +	nxp_cmd7.crc = swab32(crc32_be(0UL, (char *)&nxp_cmd7,
> +				       sizeof(nxp_cmd7) - 4));

Ditto.

> +	serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7, req_len);

Is it safe to assume req_len is small enough to not leak stack content?

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
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	struct v1_data_req *req;
> +	u32 requested_len;
> +	int err;
> +
> +	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
> +		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
> +		goto ret;
> +	}
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;

This appears in both v1 and v3 (x2) functions, add a common helper for it.

> +	req = (struct v1_data_req *)skb_pull_data(skb, sizeof(struct v1_data_req));
> +	if (!req)
> +		goto ret;
> +
> +	if ((req->len ^ req->len_comp) != 0xffff) {
> +		bt_dev_dbg(hdev, "ERR: Send NAK");
> +		nxp_send_ack(NXP_NAK_V1, hdev);
> +		goto ret;
> +	}
> +	nxp_send_ack(NXP_ACK_V1, hdev);
> +
> +	if (nxp_data->fw_dnld_use_high_baudrate) {
> +		if (!nxpdev->timeout_changed) {
> +			nxpdev->timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +			goto ret;
> +		}
> +		if (!nxpdev->baudrate_changed) {
> +			nxpdev->baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +			if (nxpdev->baudrate_changed) {
> +				serdev_device_set_baudrate(nxpdev->serdev,
> +							   HCI_NXP_SEC_BAUDRATE);
> +				serdev_device_set_flow_control(nxpdev->serdev, 1);
> +				nxpdev->current_baudrate = HCI_NXP_SEC_BAUDRATE;
> +			}
> +			goto ret;
> +		}
> +	}
> +
> +	if (!strlen(nxpdev->fw_name)) {
> +		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
> +			 nxp_data->fw_name);
> +		bt_dev_info(hdev, "Request Firmware: %s", nxpdev->fw_name);

Don't print at all when there's no error here.

> +		err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
> +		if (err < 0) {
> +			bt_dev_err(hdev, "Firmware file %s not found", nxpdev->fw_name);
> +			clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +			return err;
> +		}
> +	}

v1 and v3 duplicates this block except for how the fw_name is acquired,
create a helper.

> +	requested_len = req->len;
> +	if (requested_len == 0) {
> +		bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
> +		goto ret;
> +	}
> +	if (requested_len & 0x01) {
> +		/* The CRC did not match at the other end.
> +		 * Simply send the same bytes again.
> +		 */
> +		requested_len = nxpdev->fw_v1_sent_bytes;
> +		bt_dev_dbg(hdev, "CRC error. Resend %d bytes of FW.", requested_len);
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
> +		if (requested_len == nxpdev->fw_v1_expected_len) {
> +			if (requested_len == HDR_LEN)
> +				nxpdev->fw_v1_expected_len = nxp_get_data_len(nxpdev->fw->data +
> +									nxpdev->fw_dnld_v1_offset);
> +			else
> +				nxpdev->fw_v1_expected_len = HDR_LEN;
> +		} else {
> +			if (requested_len == HDR_LEN) {

else if

> +				/* FW download out of sync. Send previous chunk again */
> +				nxpdev->fw_dnld_v1_offset -= nxpdev->fw_v1_sent_bytes;
> +				nxpdev->fw_v1_expected_len = HDR_LEN;
> +			}
> +		}
> +	}
> +
> +	if (nxpdev->fw_dnld_v1_offset + requested_len <= nxpdev->fw->size)
> +		serdev_device_write_buf(nxpdev->serdev,
> +					nxpdev->fw->data + nxpdev->fw_dnld_v1_offset,
> +					requested_len);
> +	nxpdev->fw_v1_sent_bytes = requested_len;
> +
> +ret:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static u8 *nxp_get_fw_name_from_chipid(struct hci_dev *hdev, u16 chipid)
> +{
> +	u8 *fw_name = NULL;
> +
> +	switch (chipid) {
> +	case CHIP_ID_W9098:
> +		fw_name = FIRMWARE_W9098;
> +		break;
> +	case CHIP_ID_IW416:
> +		fw_name = FIRMWARE_IW416;
> +		break;
> +	case CHIP_ID_IW612:
> +		fw_name = FIRMWARE_IW612;
> +		break;
> +	default:
> +		bt_dev_err(hdev, "Unknown chip signature %04X", chipid);

%04x ?

> +		break;
> +	}
> +	return fw_name;
> +}
> +
> +static int nxp_recv_chip_ver_v3(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct v3_start_ind *req = skb_pull_data(skb, sizeof(struct v3_start_ind));
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err;
> +
> +	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
> +		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
> +		goto ret;
> +	}
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;
> +
> +	if (!strlen(nxpdev->fw_name)) {
> +		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
> +			 nxp_get_fw_name_from_chipid(hdev, req->chip_id));
> +
> +		bt_dev_info(hdev, "Request Firmware: %s", nxpdev->fw_name);
> +		err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
> +		if (err < 0) {
> +			bt_dev_err(hdev, "Firmware file %s not found", nxpdev->fw_name);
> +			clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +			goto ret;
> +		}
> +	}
> +	nxp_send_ack(NXP_ACK_V3, hdev);
> +ret:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct v3_data_req *req;
> +
> +	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
> +		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
> +		goto ret;
> +	}
> +
> +	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
> +		goto ret;
> +
> +	req = (struct v3_data_req *)skb_pull_data(skb, sizeof(struct v3_data_req));
> +	if (!req || !nxpdev || !nxpdev->fw)
> +		goto ret;

Can nxpdev really be NULL here?

> +	nxp_send_ack(NXP_ACK_V3, hdev);
> +
> +	if (!nxpdev->timeout_changed) {
> +		nxpdev->timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +		goto ret;
> +	}
> +
> +	if (!nxpdev->baudrate_changed) {
> +		nxpdev->baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +		if (nxpdev->baudrate_changed) {
> +			serdev_device_set_baudrate(nxpdev->serdev,
> +						   HCI_NXP_SEC_BAUDRATE);
> +			serdev_device_set_flow_control(nxpdev->serdev, 1);
> +			nxpdev->current_baudrate = HCI_NXP_SEC_BAUDRATE;
> +		}
> +		goto ret;
> +	}
> +
> +	if (req->len == 0) {
> +		bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
> +		goto ret;
> +	}
> +	if (req->error)
> +		bt_dev_dbg(hdev, "FW Download received err 0x%02x from chip. Resending FW chunk.",
> +			   req->error);

It feels something might be off here, because regardless of req->error, 
the same serdev_device_write_buf() will occur so the "Resending" part 
of the comment doesn't make much of a sense.


> +	if (req->offset < nxpdev->fw_v3_offset_correction) {
> +		/* This scenario should ideally never occur.
> +		 * But if it ever does, FW is out of sync and
> +		 * needs a power cycle.

Use 80 columns.

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

__le32 new_baudrate

> +static bool nxp_check_boot_sign(struct btnxpuart_dev *nxpdev)
> +{
> +	int ret;
> +
> +	serdev_device_set_baudrate(nxpdev->serdev, HCI_NXP_PRI_BAUDRATE);
> +	serdev_device_set_flow_control(nxpdev->serdev, 0);
> +	set_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> +
> +	ret = wait_event_interruptible_timeout(nxpdev->check_boot_sign_wait_q,
> +					       !test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE,
> +							 &nxpdev->tx_state),
> +					       msecs_to_jiffies(1000));
> +	if (ret == 0)
> +		return false;
> +	else
> +		return true;

How does does this handle -ERESTARTSYS? But this runs in nxp_setup() so is
that even relevant (I don't know).

You can also rely on int -> bool conversion here instead of open-coding 
with if () ...

> +}
> +
> +static int nxp_setup(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err = 0;
> +
> +	if (!nxpdev)
> +		return 0;

How can this happen??

> +	set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +	init_waitqueue_head(&nxpdev->fw_dnld_done_wait_q);
> +	init_waitqueue_head(&nxpdev->check_boot_sign_wait_q);
> +
> +	if (nxp_check_boot_sign(nxpdev)) {
> +		bt_dev_dbg(hdev, "Need FW Download.");
> +		err = nxp_download_firmware(hdev);
> +		if (err < 0)
> +			return err;
> +	} else {
> +		bt_dev_dbg(hdev, "FW already running.");
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +	}
> +
> +	serdev_device_set_flow_control(nxpdev->serdev, 1);
> +	device_property_read_u32(&nxpdev->serdev->dev, "fw-init-baudrate",
> +				 &nxpdev->fw_init_baudrate);
> +	if (!nxpdev->fw_init_baudrate)
> +		nxpdev->fw_init_baudrate = FW_INIT_BAUDRATE;
> +	serdev_device_set_baudrate(nxpdev->serdev, nxpdev->fw_init_baudrate);
> +	nxpdev->current_baudrate = nxpdev->fw_init_baudrate;
> +
> +	if (nxpdev->current_baudrate != HCI_NXP_SEC_BAUDRATE) {
> +		nxpdev->new_baudrate = HCI_NXP_SEC_BAUDRATE;
> +		hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
> +	}
> +
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
> +	u8 param[MAX_USER_PARAMS];
> +
> +	if (!nxpdev || !psdata)
> +		goto free_skb;
> +
> +	/* if vendor commands are received from user space (e.g. hcitool), update
> +	 * driver flags accordingly and ask driver to re-send the command to FW.
> +	 */
> +	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT && !psdata->driver_sent_cmd) {

Should this !psdata->driver_sent_cmd do something else than end up into a
place labelled send_skb. Maybe return early (or free skb + return)? 
There's a comment elsewhere stating: "set flag to prevent re-sending 
command in nxp_enqueue."

> +		if (!skb->len || skb->len > (MAX_USER_PARAMS + HCI_COMMAND_HDR_SIZE))
> +			goto send_skb;
> +
> +		hdr = (struct hci_command_hdr *)skb->data;
> +		if (hdr->plen != (skb->len - HCI_COMMAND_HDR_SIZE))
> +			goto send_skb;

Are these two gotos happily sending invalid skbs?

> +		memcpy(param, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
> +		switch (__le16_to_cpu(hdr->opcode)) {
> +		case HCI_NXP_AUTO_SLEEP_MODE:
> +			if (hdr->plen >= 1) {
> +				if (param[0] == BT_PS_ENABLE)
> +					psdata->ps_mode = PS_MODE_ENABLE;
> +				else if (param[0] == BT_PS_DISABLE)
> +					psdata->ps_mode = PS_MODE_DISABLE;
> +				hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		case HCI_NXP_WAKEUP_METHOD:
> +			if (hdr->plen >= 4) {
> +				psdata->c2h_wakeupmode = param[0];
> +				psdata->c2h_wakeup_gpio = param[1];
> +				switch (param[2]) {
> +				case BT_CTRL_WAKEUP_METHOD_DSR:
> +					psdata->h2c_wakeupmode = WAKEUP_METHOD_DTR;
> +					break;
> +				case BT_CTRL_WAKEUP_METHOD_BREAK:
> +				default:
> +					psdata->h2c_wakeupmode = WAKEUP_METHOD_BREAK;
> +					break;
> +				}
> +				hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		case HCI_NXP_SET_OPER_SPEED:
> +			if (hdr->plen == 4) {
> +				nxpdev->new_baudrate = *((u32 *)param);
> +				hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		case HCI_NXP_IND_RESET:
> +			if (hdr->plen == 1) {
> +				hci_cmd_sync_queue(hdev, nxp_set_ind_reset, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		default:
> +			break;

Okay to end up into place labelled send_skb?

> +		}
> +	}
> +
> +send_skb:
> +	/* Prepend skb with frame type */
> +	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> +	skb_queue_tail(&nxpdev->txq, skb);
> +
> +	btnxpuart_tx_wakeup(nxpdev);
> +ret:
> +	return 0;
> +
> +free_skb:
> +	kfree_skb(skb);
> +	goto ret;
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


> +static int btnxpuart_close(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (!nxpdev)
> +		return 0;

Can it be NULL here?

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

Ditto.

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
> +static bool is_valid_bootloader_signature(const u8 *data, size_t count)
> +{
> +	if ((*data == NXP_V1_FW_REQ_PKT && count == sizeof(struct v1_data_req) + 1) ||
> +	    (*data == NXP_V3_FW_REQ_PKT && count == sizeof(struct v3_data_req) + 1) ||
> +	    (*data == NXP_V3_CHIP_VER_PKT && count == sizeof(struct v3_start_ind) + 1))
> +		return true;
> +	else
> +		return false;
> +}
> +
> +static int btnxpuart_receive_buf(struct serdev_device *serdev, const u8 *data,
> +				 size_t count)
> +{
> +	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
> +
> +	if (test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state)) {
> +		if (!is_valid_bootloader_signature(data, count)) {

Use && instead of cascading.

> +			/* Unknown bootloader signature, skip without returning error */
> +			return count;
> +		}
> +	}
> +
> +	ps_start_timer(nxpdev);
> +
> +	nxpdev->rx_skb = h4_recv_buf(nxpdev->hdev, nxpdev->rx_skb, data, count,
> +				     nxp_recv_pkts, ARRAY_SIZE(nxp_recv_pkts));
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
> +	hdev->manufacturer = MANUFACTURER_NXP;
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
> +	if (!ps_init_work(hdev))
> +		ps_init_timer(hdev);

Eh, shouldn't this fail the probe on error?

But then, why is psdata not embedded into btnxpuart_dev but separately
allocated?

> +	crc8_populate_msb(crc8_table, POLYNOMIAL8);

Is it okay to populate after HCI device is registered?


-- 
 i.

--8323329-218316480-1677768222=:2066--
