Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A366ADD4C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjCGL3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjCGL3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:29:21 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA2048E33;
        Tue,  7 Mar 2023 03:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678188549; x=1709724549;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=1mX4LRq0+12Aka49QpG0ZBKYtnX84ry57MkwdauthQg=;
  b=l3RphQtLqF8h8rJRSC9xz8ujQ6zF16/syJz8YJSTFOAvQvKaxQfJ5Q1z
   oKyfpZYR0nOC1MrpnUWQcRWs4YCZqjOl5QgpLIAT9n889xEzljR/c4Q7X
   UnRfQs09yfyV98wH6fR+CDAb7GsgN0WGFmyfPgOOcqSuMIJdVtnazU7US
   K9O0tHC1saoCBOz5RqXAwqzHN1XEpJirmXEddm3I+dbRe+GLUmU6TGxOn
   aOlO5GWXt+ADCK8mp9iwIJGBa8LG73M975L9S5M7VET/74+viSa42obLx
   SxC6UNbBgzweAqmS0b34sxedoR+j4oiwJstRbUYvhp5JVtjCWwcY8c0xs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="334542577"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="334542577"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 03:29:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="678899577"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="678899577"
Received: from unknown (HELO ijarvine-MOBL2.mshome.net) ([10.237.66.32])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 03:29:02 -0800
Date:   Tue, 7 Mar 2023 13:29:00 +0200 (EET)
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
Subject: Re: [PATCH v7 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
In-Reply-To: <20230306170525.3732605-4-neeraj.sanjaykale@nxp.com>
Message-ID: <f7a1c4de-1865-533e-c0cb-944bfdc19052@linux.intel.com>
References: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com> <20230306170525.3732605-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-796130503-1678188547=:2203"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-796130503-1678188547=:2203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 6 Mar 2023, Neeraj Sanjay Kale wrote:

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
> FW name based on chip signature (Greg KH, Ilpo Järvinen, Sherry Sun)
> v5: Replaced bt_dev_info() with bt_dev_dbg(), handled user-space cmd
> parsing in nxp_enqueue() in a better way. (Greg KH, Luiz Augusto von Dentz)
> v6: Add support for fw-init-baudrate parameter from device tree,
> modified logic to detect FW download is needed or FW is running. (Greg
> KH, Sherry Sun)
> v7: Renamed variables, improved FW download functions, include ps_data
> into btnxpuart_dev. (Ilpo Järvinen)
> ---
>  MAINTAINERS                   |    1 +
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1309 +++++++++++++++++++++++++++++++++
>  4 files changed, 1322 insertions(+)
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

select CRC32 since you're using it now.

> +	help
> +	  NXP is serial driver required for NXP Bluetooth
> +	  devices with UART interface.
> +
> +	  Say Y here to compile support for NXP Bluetooth UART device into
> +	  the kernel, or say M here to compile as a module (btnxpuart).
> +
> +
>  endmenu


> +static void ps_control(struct hci_dev *hdev, u8 ps_state)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +	int status;
> +
> +	if (psdata->ps_state == ps_state ||
> +	    !test_bit(BTNXPUART_SERDEV_OPEN, &nxpdev->tx_state))
> +		return;
> +
> +	switch (psdata->cur_h2c_wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		if (ps_state == PS_STATE_AWAKE)
> +			status = serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +		else
> +			status = serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		if (ps_state == PS_STATE_AWAKE)
> +			status = serdev_device_break_ctl(nxpdev->serdev, 0);
> +		else
> +			status = serdev_device_break_ctl(nxpdev->serdev, -1);
> +		bt_dev_dbg(hdev, "Set UART break: %s, status=%d",
> +			   str_on_off(ps_state == PS_STATE_SLEEP), status);

Add the #include for str_on_off too.


> +/* for legacy chipsets with V1 bootloader */
> +static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	struct v1_data_req *req;
> +	u32 requested_len;
> +
> +	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
> +		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
> +		goto ret;
> +	}
> +
> +	if (!is_fw_downloading(nxpdev))
> +		goto ret;

That BTNXPUART_CHECK_BOOT_SIGNATURE check above is also the same in 3 
callsites of is_fw_downloading() so too should be moved into a common 
helper (there was 4th call into is_fw_downloading() so make another 
help for these 3 users).


-- 
 i.

--8323329-796130503-1678188547=:2203--
