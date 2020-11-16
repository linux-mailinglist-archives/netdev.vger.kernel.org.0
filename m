Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7482B5321
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388214AbgKPUp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:45:28 -0500
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:47464 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388202AbgKPUp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 15:45:26 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 0DB01180300E8;
        Mon, 16 Nov 2020 20:45:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:1801:2194:2199:2393:2538:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4051:4120:4321:4605:5007:6119:6609:7809:7875:7903:7904:8531:8603:8829:8957:9389:10004:10848:11026:11232:11473:11657:11658:11914:12043:12295:12296:12297:12438:12555:12679:12681:12740:12895:13439:13894:14196:14659:21080:21451:21611:21627:21987:21990:30012:30025:30034:30046:30054:30062:30067:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: brick88_06101512732b
X-Filterd-Recvd-Size: 9591
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Mon, 16 Nov 2020 20:45:19 +0000 (UTC)
Message-ID: <e246d2d2feed162e2f8f7bf46481dec7b6ce729a.camel@perches.com>
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Mon, 16 Nov 2020 12:45:18 -0800
In-Reply-To: <20201116092253.1302196-1-srini.raju@purelifi.com>
References: <20201016063444.29822-1-srini.raju@purelifi.com>
         <20201116092253.1302196-1-srini.raju@purelifi.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-16 at 14:52 +0530, Srinivasan Raju wrote:
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
> 
> This driver implementation has been based on the zd1211rw driver.
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
> 
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

trivial notes and some style and content defects:
(I stopped reading after awhile)

Commonly this changelog would go below the --- separator line.

> 
> Changes v6->v7:
> - Magic numbers removed and used IEEE80211 macors
> - usb.c is split into two files firmware.c and dbgfs.c
> - Other code style and timer function fixes (mod_timer)
> Changes v5->v6:
> - Code style fix patch from Joe Perches
> Changes v4->v5:
> - Code refactoring for clarity and redundnacy removal
> - Fix warnings from kernel test robot
> Changes v3->v4:
> - Code refactoring based on kernel code guidelines
> - Remove multi level macors and use kernel debug macros
> Changes v2->v3:
> - Code style fixes kconfig fix
> Changes v1->v2:
> - v1 was submitted to staging, v2 submitted to wireless-next
> - Code style fixes and copyright statement fix
> ---
>  MAINTAINERS                              |    5 +

[]

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -14108,6 +14108,11 @@ T:	git git://linuxtv.org/media_tree.git
[]
> +PUREILIFI USB DRIVER
> +M:	Srinivasan Raju <srini.raju@purelifi.com>
> +S:	Maintained

If you are employed there and are paid to maintain this code the
more common S: marking is "Supported"

> diff --git a/drivers/net/wireless/purelifi/Kconfig b/drivers/net/wireless/purelifi/Kconfig
[]
> +++ b/drivers/net/wireless/purelifi/Kconfig
> @@ -0,0 +1,27 @@
> +# SPDX-License-Identifier: GPL-2.0

For clarity, I think it'd be nicer to use GPL-2.0-only here and elsewhere.

> diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
[]
> +int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
> +				 u8 dtim_period, int type)
> +{
> +	if (!interval || (chip->beacon_set &&
> +			  chip->beacon_interval == interval)) {
> +		return 0;
> +	}

It's ddd that checkpatch isn't complaining about single statement uses
with braces.  I would write this like the below, but there isn't really
anything wrong with what you did either.

	if (!interval ||
	    (chip->beacon_set && chip->beacon_interval == interval))
		return 0;

> +void purelifi_chip_disable_rxtx(struct purelifi_chip *chip)
> +{
> +	u8 value;
> +
> +	value = 0;

why not make this:

	static const u8 value = 0;

> +	usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_RXTX_WR);

so this is doesn't need a cast

	usb_write_req(&value, sizeof(value), USB_REQ_RXTX_WR);

> +int purelifi_chip_set_rate(struct purelifi_chip *chip, u8 rate)
> +{
> +	int r;
> +
> +	if (!chip)
> +		return -EINVAL;
> +
> +	r = usb_write_req((const u8 *)&rate, sizeof(rate), USB_REQ_RATE_WR);

why is the cast needed here?

> +static inline void purelifi_mc_add_addr(struct purelifi_mc_hash *hash,
> +					u8 *addr
> +					)

Odd close parenthesis location

> diff --git a/drivers/net/wireless/purelifi/dbgfs.c b/drivers/net/wireless/purelifi/dbgfs.c
[]
> +ssize_t purelifi_store_frequency(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf,
> +				 size_t len)
> +{
[]
> +	if (valid) {
> +		usr_input[0] = (char)predivider;
> +		usr_input[1] = (char)feedback_divider;
> +		usr_input[2] = (char)output_div_0;
> +		usr_input[3] = (char)output_div_1;
> +		usr_input[4] = (char)output_div_2;
> +		usr_input[5] = (char)clkout3_phase;
> +
> +		dev_err(dev, "options IP_DIV: %d VCO_MULT: %d OP_DIV_PHY: %d",
> +			usr_input[0], usr_input[1], usr_input[2]);
> +		dev_err(dev, "OP_DIV_CPU: %d OP_DIV_USB: %d CLK3_PH: %d\n",
> +			usr_input[3], usr_input[4], usr_input[5]);

why is this dev_err?  It's not an error.
Shouldn't this be dev_notice or dev_info?

> +ssize_t purelifi_show_sysfs(struct device *dev,
> +			    struct device_attribute *attr,
> +			    char *buf)
> +{
> +	return 0;
> +}

This doesn't seem useful.

> +ssize_t purelifi_show_modulation(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	return 0;
> +}

This either.

> diff --git a/drivers/net/wireless/purelifi/firmware.c b/drivers/net/wireless/purelifi/firmware.c
[]
> +int download_fpga(struct usb_interface *intf)
> +{
[]
> +	for (fw_data_i = 0; fw_data_i < fw->size;) {
> +		int tbuf_idx;
> +
> +		if ((fw->size - fw_data_i) < blk_tran_len)
> +			blk_tran_len = fw->size - fw_data_i;
> +
> +		fw_data = kmalloc(blk_tran_len, GFP_KERNEL);
> +
> +		memcpy(fw_data, &fw->data[fw_data_i], blk_tran_len);

Unchecked alloc, and this should probably use kmemdup()

> +	dev_info(&intf->dev, "fpga_status");
> +	for (i = 0; i <= 8; i++)
> +		dev_info(&intf->dev, " %x ", fpga_dmabuff[i]);
> +	dev_info(&intf->dev, "\n");

pr_cont rather than dev_info for the subsequent dev_info uses
otherwise these are all on separate lines.

Or just a single array print of the results and/or use print_hex_dump.

I'd just use:

	dev_info(&intf->dev, "fpga status: %x %x %x %x %x %x %x %x\n",
		  fpga_dmabuff[0], fpga_dmabuff[1],
		  fpga_dmabuff[2], fpga_dmabuff[3],
		  fpga_dmabuff[4], fpga_dmabuff[5],
		  fpga_dmabuff[6], fpga_dmabuff[7]);

[]

> +int download_xl_firmware(struct usb_interface *intf)
> +{
[]
> +	buf = kzalloc(64, GFP_KERNEL);
> +	r = -ENOMEM;
> +	if (!buf)
> +		goto error;

Odd use of setting r before if (!buf) test

> +
> +	for (step = 0; step < no_of_files; step++) {
> +		buf[0] = step;
> +		r = send_vendor_command(udev, 0x82, buf, 64);
> +
> +		if (step < no_of_files - 1)
> +			size = *(u32 *)&fw_packed->data[4 + ((step + 1) * 4)]
> +				- *(u32 *)&fw_packed->data[4 + (step) * 4];
> +		else
> +			size = tot_size -
> +				*(u32 *)&fw_packed->data[4 + (step) * 4];
> +
> +		start_addr = *(u32 *)&fw_packed->data[4 + (step * 4)];
> +
> +		if ((size % 64) && step < 2)
> +			size += 64 - size % 64;
> +		nmb_of_control_packets = size / 64;
> +
> +		for (i = 0; i < nmb_of_control_packets; i++) {
> +			memcpy(buf,
> +			       &fw_packed->data[start_addr + (i * 64)], 64);
> +			r = send_vendor_command(udev, 0x81, buf, 64);

unchecked return

> +		}
> +	  dev_info(&intf->dev, "fw-dw step %d,r=%d size %d\n", step, r, size);

Odd indentation too

> +int upload_mac_and_serial_number(struct usb_interface *intf,
> +				 unsigned char *hw_address,
> +				 unsigned char *serial_number)
> +{
> +#ifdef LOAD_MAC_AND_SERIAL_FROM_FILE
> +	struct firmware *fw = NULL;
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	int r;
> +	char *mac_file_name = "purelifi/li_fi_x/mac.ascii";
> +
> +	r = request_firmware((const struct firmware **)&fw, mac_file_name,
> +			     &intf->dev);
> +	if (r) {
> +		dev_err(&intf->dev, "request_firmware fail (%d)\n", r);
> +		goto ERROR;
> +	}
> +	dev_info(&intf->dev, "fw->data=%s\n", fw->data);
> +	r = sscanf(fw->data,
> +		   "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
> +		    &hw_address[0], &hw_address[1],
> +		    &hw_address[2], &hw_address[3],
> +		    &hw_address[4], &hw_address[5]);
> +	if (r != 6) {
> +		dev_err(&intf->dev, "fw_dw - usage args fail (%d)\n", r);
> +		goto ERROR;
> +	}
> +	release_firmware(fw);
> +
> +	char *serial_file_name = "purelifi/li_fi_x/serial.ascii";

Please move this to the start of the block below the #ifdef

It may make more sense to separate this into multiple functions.

> diff --git a/drivers/net/wireless/purelifi/mac.c b/drivers/net/wireless/purelifi/mac.c
[]
> +static struct plf_reg_alpha2_map reg_alpha2_map[] = {

static const?

> +static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
> +		      struct ieee80211_rx_status *stats)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct sk_buff *skb;
> +	struct sk_buff_head *q;
> +	unsigned long flags;
> +	int found = 0;

bool ?

I stopped reading here...


