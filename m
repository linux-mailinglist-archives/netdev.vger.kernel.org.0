Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD8C43C9D6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbhJ0MlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbhJ0MlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:41:09 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B246FC061570;
        Wed, 27 Oct 2021 05:38:43 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x192so5795203lff.12;
        Wed, 27 Oct 2021 05:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X1iTxmL572LQyXWDLeOLjWzloUZOxkq1Vx62oW4jsTY=;
        b=IFY2MWI1JlO58CC1gP/+VOBUFaVvuSgQ7olYvskb+3nWet0/Wl9hBDtmE80ifwuhpZ
         kN7zUuGtBHS0ydRvMwbre4d17H5Xfho+AZkHmblNw+WL7x5Ge5kUl2dVnyv+qlx4mlyj
         YHRhnmCvWB75rae3EhdEXqnvK5H3WQ44t11DN2FyH5Rhu7GnHOE50FBcpLg7qFxhbB0V
         I2+ScVXuMO1j+sYkseHO1vZLY766guWcfE+s67KUOGHPTN7uPGhzugXA0Z6Z5UHykY1T
         46scyfzqnR7iaHXUU4dFwFHPxSMGQJGmd8y1pmPKPynTVypKS6Qnno56EjlEmYbu8igw
         1yMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X1iTxmL572LQyXWDLeOLjWzloUZOxkq1Vx62oW4jsTY=;
        b=psyQ0I7unBlLOlIFKH2d48bLkmrN+s+cA45I5GzWNMM8eFszmCKRPrZtWrYTGB7upj
         wRDG12HgZMtDnGJQ4ZMsCtbNeNncnxAuFaNXP8HQacNagHulADxko2Wg1AOB4DU67RbW
         PyhQTjspa3NauhSF/ij5OZGs1PuwjLDUVmAEjqs75VeWfyqPAyT32Xc1Wvx80t664VyF
         qLMlVIiN1gNH0zGelD2DpCqUXtKipZu3UkA48NbvfBEG2oD5lBeoFWPr/n5MkxQfygnm
         bZiQOpdSJo5NWM7w2B+Lktiq6ageond+4K4UpjB9ezAx6sF1fNSU16704GajwBZE/ohT
         y45Q==
X-Gm-Message-State: AOAM530P68o0zQO8czH5ZoeCe6eiRrk2tP3Io+85uP/dsKl9SkIJ8WU0
        4nKzP8XRHtrokWbHekhvnTM=
X-Google-Smtp-Source: ABdhPJxfklML59XG1zQqhdfzd/2ogpYiQgu74yxiLH6UHS/aDcl7BV3dKS1GwErlh4VREQXJ26tulA==
X-Received: by 2002:a19:3813:: with SMTP id f19mr22695281lfa.284.1635338321738;
        Wed, 27 Oct 2021 05:38:41 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id b7sm2222574lfi.221.2021.10.27.05.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 05:38:41 -0700 (PDT)
Date:   Wed, 27 Oct 2021 15:38:39 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     "mostafa.afgani@purelifi.com Kalle Valo" <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH v20 2/2] wireless: Initial driver submission for pureLiFi
 STA devices
Message-ID: <20211027123839.6h3rgxsgk6p4ydg3@kari-VirtualBox>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20211018100143.7565-1-srini.raju@purelifi.com>
 <20211018100143.7565-3-srini.raju@purelifi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018100143.7565-3-srini.raju@purelifi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:00:55AM +0100, Srinivasan Raju wrote:
> This driver implementation has been based on the zd1211rw driver
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture

Just small style issues in this review.

> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
> ---
>  MAINTAINERS                                   |   6 +
>  drivers/net/wireless/Kconfig                  |   1 +
>  drivers/net/wireless/Makefile                 |   1 +
>  drivers/net/wireless/purelifi/Kconfig         |  17 +
>  drivers/net/wireless/purelifi/Makefile        |   2 +
>  drivers/net/wireless/purelifi/plfxlc/Kconfig  |  14 +
>  drivers/net/wireless/purelifi/plfxlc/Makefile |   3 +
>  drivers/net/wireless/purelifi/plfxlc/chip.c   |  95 ++
>  drivers/net/wireless/purelifi/plfxlc/chip.h   |  89 ++
>  .../net/wireless/purelifi/plfxlc/firmware.c   | 275 +++++
>  drivers/net/wireless/purelifi/plfxlc/intf.h   |  52 +
>  drivers/net/wireless/purelifi/plfxlc/mac.c    | 770 ++++++++++++++
>  drivers/net/wireless/purelifi/plfxlc/mac.h    | 190 ++++
>  drivers/net/wireless/purelifi/plfxlc/usb.c    | 975 ++++++++++++++++++
>  drivers/net/wireless/purelifi/plfxlc/usb.h    | 196 ++++
>  15 files changed, 2686 insertions(+)
>  create mode 100644 drivers/net/wireless/purelifi/Kconfig
>  create mode 100644 drivers/net/wireless/purelifi/Makefile
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/Kconfig
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/Makefile
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.c
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.h
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/firmware.c
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/intf.h
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.c
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.h
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.c
>  create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.h


> diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.h b/drivers/net/wireless/purelifi/plfxlc/chip.h
> new file mode 100644
> index 000000000000..167e9b9bd7a7
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/chip.h
> @@ -0,0 +1,89 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2021 pureLiFi
> + */
> +
> +#ifndef _LF_X_CHIP_H
> +#define _LF_X_CHIP_H
> +
> +#include <net/mac80211.h>
> +
> +#include "usb.h"
> +
> +enum unit_type {
> +	STA = 0,
> +	AP = 1,
> +};
> +
> +enum {
> +	PLFXLC_RADIO_OFF = 0,
> +	PLFXLC_RADIO_ON = 1,
> +};
> +
> +struct purelifi_chip {
> +	struct purelifi_usb usb;
> +	struct mutex mutex; /* lock to protect chip data */
> +	enum unit_type unit_type;
> +	u16 link_led;
> +	u8 beacon_set;
> +	__le16 beacon_interval;

Does seem little wierd that one variable is __le16. You could change
this u16 because there will not be anymore conversion either way.

> +};

> +#endif /* _LF_X_CHIP_H */
> diff --git a/drivers/net/wireless/purelifi/plfxlc/firmware.c b/drivers/net/wireless/purelifi/plfxlc/firmware.c
> new file mode 100644
> index 000000000000..30a8a63e13b6
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/firmware.c

> +
> +int download_fpga(struct usb_interface *intf)
> +{
> +	int r, actual_length;
> +	int fw_data_i, blk_tran_len = PLF_BULK_TLEN;
> +	const char *fw_name;
> +	unsigned char *fpga_dmabuff = NULL;
> +	unsigned char *fw_data;
> +	const struct firmware *fw = NULL;
> +	struct usb_device *udev = interface_to_usbdev(intf);

Can you please make something for function variables. They seems totally
random. If I am correct net/ and drivers/net want's reverse christmas
tree format. 

> +int download_xl_firmware(struct usb_interface *intf)
> +{
> +	const struct firmware *fwp = NULL;
> +	struct firmware_file file = {0};
> +	int s, r;
> +	u8 *buf;
> +	u32 i;
> +	const char *fw_pack;
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +
> +	r = send_vendor_command(udev, PLF_VNDR_XL_FW_CMD, NULL, 0);
> +	msleep(PLF_MSLEEP_TIME);
> +
> +	if (r) {
> +		dev_err(&intf->dev, "vendor command failed (%d)\n", r);
> +		return -EINVAL;
> +	}
> +	/* Code for single pack file download */
> +
> +	fw_pack = "plfxlc/lifi-xl.bin";
> +
> +	r = request_firmware(&fwp, fw_pack, &intf->dev);
> +	if (r) {
> +		dev_err(&intf->dev, "Request_firmware failed (%d)\n", r);
> +		return -EINVAL;
> +	}
> +	file.total_files = get_unaligned_le32(&fwp->data[0]);
> +	file.total_size = get_unaligned_le32(&fwp->size);
> +
> +	dev_dbg(&intf->dev, "XL Firmware (%d, %d)\n",
> +		file.total_files, file.total_size);
> +
> +	buf = kzalloc(PLF_XL_BUF_LEN, GFP_KERNEL);
> +	if (!buf) {
> +		release_firmware(fwp);
> +		return -ENOMEM;
> +	}
> +
> +	if (file.total_files > 10) {
> +		dev_err(&intf->dev, "Too many files (%d)\n", file.total_files);
> +		release_firmware(fwp);
> +		kfree(buf);
> +		return -EINVAL;
> +	}
> +
> +	/* Download firmware files in multiple steps */
> +	for (s = 0; s < file.total_files; s++) {
> +		buf[0] = s;
> +		r = send_vendor_command(udev, PLF_VNDR_XL_FILE_CMD, buf,
> +					PLF_XL_BUF_LEN);
> +
> +		if (s < file.total_files - 1)
> +			file.size = get_unaligned_le32(&fwp->data[4 + ((s + 1) * 4)])
> +				    - get_unaligned_le32(&fwp->data[4 + (s) * 4]);
> +		else
> +			file.size = file.total_size -
> +				    get_unaligned_le32(&fwp->data[4 + (s) * 4]);
> +
> +		if (file.size > file.total_size || file.size > 60000) {
> +			dev_err(&intf->dev, "File size is too large (%d)\n", file.size);
> +			break;
> +		}
> +
> +		file.start_addr = get_unaligned_le32(&fwp->data[4 + (s * 4)]);
> +
> +		if (file.size % PLF_XL_BUF_LEN && s < 2)
> +			file.size += PLF_XL_BUF_LEN - file.size % PLF_XL_BUF_LEN;
> +
> +		file.control_packets = file.size / PLF_XL_BUF_LEN;
> +
> +		for (i = 0; i < file.control_packets; i++) {
> +			memcpy(buf,
> +			       &fwp->data[file.start_addr + (i * PLF_XL_BUF_LEN)],
> +			       PLF_XL_BUF_LEN);
> +			r = send_vendor_command(udev, PLF_VNDR_XL_DATA_CMD, buf,
> +						PLF_XL_BUF_LEN);
> +		}
> +		dev_dbg(&intf->dev, "fw-dw step=%d,r=%d size=%d\n", s, r,
> +			file.size);
> +	}
> +	release_firmware(fwp);
> +	kfree(buf);
> +
> +	/* Code for single pack file download ends fw download finish*/

space after finish

> +
> +	r = send_vendor_command(udev, PLF_VNDR_XL_EX_CMD, NULL, 0);
> +	dev_dbg(&intf->dev, "Download fpga (4) (%d)\n", r);
> +
> +	return 0;
> +}

> diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.c b/drivers/net/wireless/purelifi/plfxlc/mac.c
> new file mode 100644
> index 000000000000..6e403d5ac84c
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/mac.c


> +int purelifi_restore_settings(struct purelifi_mac *mac)
> +{
> +	struct sk_buff *beacon;
> +	int beacon_interval, beacon_period;
> +
> +	spin_lock_irq(&mac->lock);
> +	beacon_interval = mac->beacon.interval;
> +	beacon_period = mac->beacon.period;
> +	spin_unlock_irq(&mac->lock);
> +
> +	if (mac->type != NL80211_IFTYPE_ADHOC)
> +		return 0;
> +
> +	if (mac->vif) {
> +		beacon = ieee80211_beacon_get(mac->hw, mac->vif);
> +		if (beacon) {
> +			purelifi_mac_config_beacon(mac->hw, beacon);
> +			kfree_skb(beacon);
> +			/* Returned skb is used only once and lowlevel
> +			 *  driver is responsible for freeing it.

after * there is extre space.

> +			 */
> +		}
> +	}
> +
> +	purelifi_set_beacon_interval(&mac->chip, beacon_interval,
> +				     beacon_period, mac->type);
> +
> +	spin_lock_irq(&mac->lock);
> +	mac->beacon.last_update = jiffies;
> +	spin_unlock_irq(&mac->lock);
> +
> +	return 0;
> +}

> +void purelifi_mac_tx_to_dev(struct sk_buff *skb, int error)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct ieee80211_hw *hw = info->rate_driver_data[0];
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +
> +	ieee80211_tx_info_clear_status(info);
> +	skb_pull(skb, sizeof(struct purelifi_ctrlset));
> +
> +	if (unlikely(error ||
> +		     (info->flags & IEEE80211_TX_CTL_NO_ACK))) {
> +		ieee80211_tx_status_irqsafe(hw, skb);

If this is unlikely make this  return;

> +	} else {

and delete this else so you get lower indention level.

> +		struct sk_buff_head *q = &mac->ack_wait_queue;
> +
> +		skb_queue_tail(q, skb);
> +		while (skb_queue_len(q)/* > PURELIFI_MAC_MAX_ACK_WAITERS*/) {
> +			purelifi_mac_tx_status(hw, skb_dequeue(q),
> +					       mac->ack_pending ?
> +					       mac->ack_signal : 0,
> +					       NULL);
> +			mac->ack_pending = 0;
> +		}
> +	}
> +}
> +
> +static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
> +				      struct sk_buff *beacon)
> +{
> +	return plf_usb_wreq(beacon->data, beacon->len,
> +			USB_REQ_BEACON_WR);
> +}
> +
> +static int fill_ctrlset(struct purelifi_mac *mac, struct sk_buff *skb)

Should this also have prefix purelifi.

> +{
> +	unsigned int frag_len = skb->len;
> +	unsigned int tmp;
> +	u32 temp_len = 0;
> +	u32 temp_payload_len = 0;
> +	struct purelifi_ctrlset *cs;
> +
> +	if (skb_headroom(skb) < sizeof(struct purelifi_ctrlset)) {
> +		dev_dbg(purelifi_mac_dev(mac), "Not enough hroom(1)\n");
> +		return 1;
> +	}
> +
> +	cs = (void *)skb_push(skb, sizeof(struct purelifi_ctrlset));
> +	temp_payload_len = frag_len;
> +	temp_len = temp_payload_len +
> +		  sizeof(struct purelifi_ctrlset) -
> +		  sizeof(cs->id) - sizeof(cs->len);
> +
> +	/* data packet lengths must be multiple of four bytes
> +	 * and must not be a multiple of 512
> +	 * bytes. First, it is attempted to append the
> +	 * data packet in the tailroom of the skb. In rare
> +	 * ocasions, the tailroom is too small. In this case,
> +	 * the content of the packet is shifted into
> +	 * the headroom of the skb by memcpy. Headroom is allocated
> +	 * at startup (below in this file). Therefore,
> +	 * there will be always enough headroom. The call skb_headroom
> +	 * is an additional safety which might be
> +	 * dropped.
> +	 */

This is not wrapped correctly. Should be like:

	/* Data packet lengths must be multiple of four bytes and must
	 * not be a multiple of 512 bytes. First, it is attempted to
	 * append the data packet in the tailroom of the skb. In rare
	 * ocasions, the tailroom is too small. In this case, the
	 * content of the packet is shifted into the headroom of the skb
	 * by memcpy. Headroom is allocated at startup (below in this
	 * file). Therefore, there will be always enough headroom. The
	 * call skb_headroom is an additional safety which might be
	 * dropped.
 	 */

> +
> +	/* check if 32 bit aligned and align data */
> +	tmp = skb->len & 3;
> +	if (tmp) {
> +		if (skb_tailroom(skb) < (3 - tmp)) {
> +			if (skb_headroom(skb) >= 4 - tmp) {
> +				u8 len;
> +				u8 *src_pt;
> +				u8 *dest_pt;
> +
> +				len = skb->len;
> +				src_pt = skb->data;
> +				dest_pt = skb_push(skb, 4 - tmp);
> +				memmove(dest_pt, src_pt, len);
> +			} else {
> +				return -ENOBUFS;
> +			}
> +		} else {
> +			skb_put(skb, 4 - tmp);
> +		}
> +		temp_len += 4 - tmp;
> +	}
> +
> +	/* check if not multiple of 512 and align data */
> +	tmp = skb->len & 0x1ff;
> +	if (!tmp) {
> +		if (skb_tailroom(skb) < 4) {
> +			if (skb_headroom(skb) >= 4) {
> +				u8 len = skb->len;
> +				u8 *src_pt = skb->data;
> +				u8 *dest_pt = skb_push(skb, 4);
> +
> +				memcpy(dest_pt, src_pt, len);

I notice that Joe has said that you should use memmove in first version.
Just asking if this can overlap. If you are not sure memmove is safer.

> +			} else {
> +				/* should never happen because
> +				 * sufficient headroom was reserved
> +				 */
> +				return -ENOBUFS;
> +			}
> +		} else {
> +			skb_put(skb, 4);
> +		}
> +		temp_len += 4;
> +	}

You use almoust same thing two times row and it is quite long. Maybe
do new inline function.

> +
> +	cs->id = cpu_to_be32(USB_REQ_DATA_TX);
> +	cs->len = cpu_to_be32(temp_len);
> +	cs->payload_len_nw = cpu_to_be32(temp_payload_len);
> +
> +	return 0;
> +}
> +
> +static void plfxlc_op_tx(struct ieee80211_hw *hw,
> +			 struct ieee80211_tx_control *control,
> +			 struct sk_buff *skb)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_usb *usb = &mac->chip.usb;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct purelifi_header *plhdr = (void *)skb->data;
> +	unsigned long flags;
> +	int r;
> +
> +	r = fill_ctrlset(mac, skb);
> +	if (r)
> +		goto fail;
> +
> +	info->rate_driver_data[0] = hw;
> +
> +	if (plhdr->frametype  == IEEE80211_FTYPE_DATA) {
> +		u8 *dst_mac = plhdr->dmac;
> +		u8 sidx;
> +		bool found = false;
> +		struct purelifi_usb_tx *tx = &usb->tx;
> +
> +		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
> +			if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
> +				continue;
> +			if (!memcmp(tx->station[sidx].mac, dst_mac, ETH_ALEN)) {
> +				found = true;
> +				break;
> +			}

			if (memcmp(tx->station[sidx].mac, dst_mac, ETH_ALEN))
 				continue;

			found = true;
			break;

> +		}
> +
> +		/* Default to broadcast address for unknown MACs */
> +		if (!found)
> +			sidx = STA_BROADCAST_INDEX;
> +
> +		/* Stop OS from sending packets, if the queue is half full */
> +		if (skb_queue_len(&tx->station[sidx].data_list) > 60)
> +			ieee80211_stop_queues(purelifi_usb_to_hw(usb));
> +
> +		/* Schedule packet for transmission if queue is not full */
> +		if (skb_queue_len(&tx->station[sidx].data_list) < 256) {
> +			skb_queue_tail(&tx->station[sidx].data_list, skb);
> +			purelifi_send_packet_from_data_queue(usb);
> +		} else {
> +			goto fail;
> +		}

Reverse if statment and goto from there. Then no need for else.

> +	} else {
> +		spin_lock_irqsave(&usb->tx.lock, flags);
> +		r = plf_usb_wreq_async(&mac->chip.usb, skb->data, skb->len,
> +				       USB_REQ_DATA_TX, tx_urb_complete, skb);
> +		spin_unlock_irqrestore(&usb->tx.lock, flags);
> +		if (r)
> +			goto fail;
> +	}
> +	return;
> +
> +fail:
> +	dev_kfree_skb(skb);
> +}
> +
> +static int purelifi_filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
> +			       struct ieee80211_rx_status *stats)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct sk_buff *skb;
> +	struct sk_buff_head *q;
> +	unsigned long flags;
> +	bool found = 0;

bool is nicer if used with true/false.

> +	int i, position = 0;
> +
> +	if (!ieee80211_is_ack(rx_hdr->frame_control))
> +		return 0;
> +
> +	dev_dbg(purelifi_mac_dev(mac), "ACK Received\n");
> +
> +	/* code based on zy driver, this logic may need fix */
> +	q = &mac->ack_wait_queue;
> +	spin_lock_irqsave(&q->lock, flags);
> +
> +	skb_queue_walk(q, skb) {
> +		struct ieee80211_hdr *tx_hdr;
> +
> +		position++;
> +
> +		if (mac->ack_pending && skb_queue_is_first(q, skb))
> +			continue;
> +		else if (mac->ack_pending == 0)

if is enogh

> +			break;
> +
> +		tx_hdr = (struct ieee80211_hdr *)skb->data;
> +		if (likely(ether_addr_equal(tx_hdr->addr2, rx_hdr->addr1))) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +
> +	if (found) {
> +		for (i = 1; i < position; i++)
> +			skb = __skb_dequeue(q);
> +		if (i == position) {
> +			purelifi_mac_tx_status(hw, skb,
> +					       mac->ack_pending ?
> +					       mac->ack_signal : 0,
> +					       NULL);
> +			mac->ack_pending = 0;
> +		}
> +
> +		mac->ack_pending = skb_queue_len(q) ? 1 : 0;
> +		mac->ack_signal = stats->signal;
> +	}
> +
> +	spin_unlock_irqrestore(&q->lock, flags);
> +	return 1;
> +}
> +
> +int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
> +		    unsigned int length)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct ieee80211_rx_status stats;
> +	const struct rx_status *status;
> +	struct sk_buff *skb;
> +	int bad_frame = 0;
> +	__le16 fc;
> +	int need_padding;
> +	unsigned int payload_length;
> +	int sidx;
> +	struct purelifi_usb_tx *tx;

Add space

> +	/* Packet blockade during disabled interface. */
> +	if (!mac->vif)
> +		return 0;
> +
> +	memset(&stats, 0, sizeof(stats));
> +	status = (struct rx_status *)buffer;
> +
> +	stats.flag     = 0;
> +	stats.freq     = 2412;
> +	stats.band     = NL80211_BAND_LC;
> +	mac->rssi      = -15 * be16_to_cpu(status->rssi) / 10;
> +
> +	stats.signal   = mac->rssi;
> +
> +	if (status->rate_idx > 7)
> +		stats.rate_idx = 0;
> +	else
> +		stats.rate_idx = status->rate_idx;
> +
> +	mac->crc_errors = be64_to_cpu(status->crc_error_count);
> +
> +	if (!bad_frame &&
> +	    purelifi_filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
> +	    !mac->pass_ctrl)
> +		return 0;
> +
> +	buffer += sizeof(struct rx_status);
> +	payload_length = get_unaligned_be32(buffer);
> +
> +	/* MTU = 1500, MAC header = 36, CRC = 4, sum = 1540 */

Seems little confusing that you write sum = 1540 and next line you use
1560.

> +	if (payload_length > 1560) {
> +		dev_err(purelifi_mac_dev(mac), " > MTU %u\n", payload_length);
> +		return 0;
> +	}
> +	buffer += sizeof(u32);
> +
> +	fc = get_unaligned((__le16 *)buffer);
> +	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
> +
> +	tx = &mac->chip.usb.tx;
> +
> +	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
> +		if (memcmp(&buffer[10], tx->station[sidx].mac, ETH_ALEN))
> +			continue;
> +		if (tx->station[sidx].flag & STATION_CONNECTED_FLAG) {
> +			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
> +			break;
> +		}
> +	}
> +
> +	if (sidx == MAX_STA_NUM - 1) {
> +		for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
> +			if (tx->station[sidx].flag & STATION_CONNECTED_FLAG)
> +				continue;
> +			memcpy(tx->station[sidx].mac, &buffer[10], ETH_ALEN);
> +			tx->station[sidx].flag |= STATION_CONNECTED_FLAG;
> +			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
> +			break;
> +		}
> +	}
> +
> +	switch (buffer[0]) {
> +	case IEEE80211_STYPE_PROBE_REQ:
> +		dev_dbg(purelifi_mac_dev(mac), "Probe request\n");
> +		break;
> +	case IEEE80211_STYPE_ASSOC_REQ:
> +		dev_dbg(purelifi_mac_dev(mac), "Association request\n");
> +		break;
> +	case IEEE80211_STYPE_AUTH:
> +		dev_dbg(purelifi_mac_dev(mac), "Authentication req\n");
> +		break;
> +	case IEEE80211_FTYPE_DATA:
> +		dev_dbg(purelifi_mac_dev(mac), "802.11 data frame\n");
> +		break;
> +	}
> +
> +	skb = dev_alloc_skb(payload_length + (need_padding ? 2 : 0));
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	if (need_padding)
> +		/* Make sure that the payload data is 4 byte aligned. */
> +		skb_reserve(skb, 2);
> +
> +	skb_put_data(skb, buffer, payload_length);
> +	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
> +	ieee80211_rx_irqsafe(hw, skb);
> +	return 0;
> +}
> +
> +static int plfxlc_op_add_interface(struct ieee80211_hw *hw,
> +				   struct ieee80211_vif *vif)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	static const char * const iftype80211[] = {
> +		[NL80211_IFTYPE_STATION]	= "Station",
> +		[NL80211_IFTYPE_ADHOC]		= "Adhoc"
> +	};
> +
> +	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
> +		return -EOPNOTSUPP;
> +
> +	if (vif->type == NL80211_IFTYPE_ADHOC ||
> +	    vif->type == NL80211_IFTYPE_STATION) {
> +		dev_dbg(purelifi_mac_dev(mac), "%s %s\n", __func__,
> +			iftype80211[vif->type]);
> +		mac->type = vif->type;
> +		mac->vif = vif;
> +	} else {
> +		dev_dbg(purelifi_mac_dev(mac), "unsupported iftype\n");
> +		return -EOPNOTSUPP;
> +	}

Reverse if so no else needed.

> +
> +	return 0;
> +}

> +static void plfxlc_op_bss_info_changed(struct ieee80211_hw *hw,
> +				       struct ieee80211_vif *vif,
> +				       struct ieee80211_bss_conf *bss_conf,
> +				       u32 changes)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	int associated;
> +
> +	dev_dbg(purelifi_mac_dev(mac), "changes: %x\n", changes);
> +
> +	if (mac->type != NL80211_IFTYPE_ADHOC) { /* for STATION */
> +		associated = is_valid_ether_addr(bss_conf->bssid);
> +		goto exit_all;
> +	}
> +	/* for ADHOC */
> +	associated = true;
> +	if (changes & BSS_CHANGED_BEACON) {
> +		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
> +
> +		if (beacon) {
> +			purelifi_mac_config_beacon(hw, beacon);
> +			kfree_skb(beacon);
> +			/*Returned skb is used only once and

space after *

> +			 * low-level driver is
> +			 * responsible for freeing it.
> +			 */
> +		}
> +	}
> +
> +	if (changes & BSS_CHANGED_BEACON_ENABLED) {
> +		u16 interval = 0;
> +		u8 period = 0;
> +
> +		if (bss_conf->enable_beacon) {
> +			period = bss_conf->dtim_period;
> +			interval = bss_conf->beacon_int;
> +		}
> +
> +		spin_lock_irq(&mac->lock);
> +		mac->beacon.period = period;
> +		mac->beacon.interval = interval;
> +		mac->beacon.last_update = jiffies;
> +		spin_unlock_irq(&mac->lock);
> +
> +		purelifi_set_beacon_interval(&mac->chip, interval,
> +					     period, mac->type);
> +	}
> +exit_all:
> +	spin_lock_irq(&mac->lock);
> +	mac->associated = associated;
> +	spin_unlock_irq(&mac->lock);
> +}

> +static const struct ieee80211_ops plfxlc_ops = {
> +	.tx                 = plfxlc_op_tx,
> +	.start              = plfxlc_op_start,
> +	.stop               = plfxlc_op_stop,
> +	.add_interface      = plfxlc_op_add_interface,
> +	.remove_interface   = plfxlc_op_remove_interface,
> +	.set_rts_threshold  = purelifi_set_rts_threshold,
> +	.config             = plfxlc_op_config,
> +	.configure_filter   = plfxlc_op_configure_filter,
> +	.bss_info_changed   = plfxlc_op_bss_info_changed,
> +	.get_stats          = purelifi_get_stats,
> +	.get_et_sset_count  = purelifi_get_et_sset_count,
> +	.get_et_stats       = purelifi_get_et_stats,
> +	.get_et_strings     = purelifi_get_et_strings,
> +};

Just asking why some prefixes are purelifi and some are plfxlc?

> diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.h b/drivers/net/wireless/purelifi/plfxlc/mac.h
> new file mode 100644
> index 000000000000..3852d7343a40
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/mac.h
> @@ -0,0 +1,190 @@

> +struct purelifi_mac {
> +	struct purelifi_chip chip;
> +	spinlock_t lock; /* lock for mac data */
> +	struct ieee80211_hw *hw;
> +	struct ieee80211_vif *vif;
> +	struct beacon beacon;
> +	struct work_struct set_rts_cts_work;
> +	struct work_struct process_intr;
> +	struct purelifi_mc_hash multicast_hash;
> +	u8 intr_buffer[USB_MAX_EP_INT_BUFFER];
> +	u8 regdomain;
> +	u8 default_regdomain;
> +	u8 channel;
> +	int type;
> +	int associated;
> +	unsigned long flags;
> +	struct sk_buff_head ack_wait_queue;
> +	struct ieee80211_channel channels[14];
> +	struct ieee80211_rate rates[12];
> +	struct ieee80211_supported_band band;

Maybe move these below other ieee8011_* structs. Will be muh more
readable. Right now this struct is just big mess to read.

> +
> +	/* whether to pass frames with CRC errors to stack */
> +	bool pass_failed_fcs;
> +
> +	/* whether to pass control frames to stack */
> +	bool pass_ctrl;
> +
> +	/* whether we have received a 802.11 ACK that is pending */
> +	bool ack_pending;
> +
> +	/* signal strength of the last 802.11 ACK received */
> +	int ack_signal;
> +
> +	unsigned char hw_address[ETH_ALEN];
> +	char serial_number[PURELIFI_SERIAL_LEN];
> +	u64 crc_errors;
> +	u64 rssi;
> +};

> diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
> new file mode 100644
> index 000000000000..8cd9f223025e
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/usb.c

> +void purelifi_send_packet_from_data_queue(struct purelifi_usb *usb)
> +{
> +	struct sk_buff *skb = NULL;
> +	unsigned long flags;
> +	static u8 sidx;

Static here, but I might already tell that in preview message, but here
for safety.

> +	u8 last_served_sidx;
> +	struct purelifi_usb_tx *tx = &usb->tx;
> +
> +	spin_lock_irqsave(&tx->lock, flags);
> +	last_served_sidx = sidx;
> +	do {
> +		sidx = (sidx + 1) % MAX_STA_NUM;
> +		if (!tx->station[sidx].flag & STATION_CONNECTED_FLAG)
> +			continue;
> +		if (!(tx->station[sidx].flag & STATION_FIFO_FULL_FLAG))
> +			skb = skb_peek(&tx->station[sidx].data_list);
> +	} while ((sidx != last_served_sidx) && (!skb));
> +
> +	if (skb) {
> +		skb = skb_dequeue(&tx->station[sidx].data_list);
> +		plf_usb_wreq_async(usb, skb->data, skb->len, USB_REQ_DATA_TX,
> +				   tx_urb_complete, skb);
> +		if (skb_queue_len(&tx->station[sidx].data_list) <= 60)
> +			ieee80211_wake_queues(purelifi_usb_to_hw(usb));
> +	}
> +	spin_unlock_irqrestore(&tx->lock, flags);
> +}

> +static void rx_urb_complete(struct urb *urb)
> +{
> +	int r;
> +	struct purelifi_usb *usb;
> +	struct purelifi_usb_tx *tx;
> +	const u8 *buffer;
> +	unsigned int length;
> +	u16 status;
> +	u8 sidx;
> +
> +	if (!urb) {
> +		pr_err("urb is NULL\n");
> +		return;
> +	} else if (!urb->context) {

Another if is as good as this.

> +		pr_err("urb ctx is NULL\n");
> +		return;
> +	}

> +int purelifi_usb_enable_rx(struct purelifi_usb *usb)
> +{
> +	int r;
> +	struct purelifi_usb_rx *rx = &usb->rx;
> +
> +	mutex_lock(&rx->setup_mutex);
> +	r = __lf_x_usb_enable_rx(usb);
> +	if (!r)
> +		usb->rx_usb_enabled = 1;

Use true.

> +
> +	mutex_unlock(&rx->setup_mutex);
> +
> +	return r;
> +}

> +int purelifi_usb_tx(struct purelifi_usb *usb, struct sk_buff *skb)
> +{
> +	int r;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct usb_device *udev = purelifi_usb_to_usbdev(usb);
> +	struct urb *urb;
> +	struct purelifi_usb_tx *tx = &usb->tx;
> +
> +	if (!test_bit(PLF_BIT_ENABLED, &tx->enabled)) {
> +		r = -ENOENT;
> +		goto out;
> +	}
> +
> +	urb = usb_alloc_urb(0, GFP_ATOMIC);
> +	if (!urb) {
> +		r = -ENOMEM;
> +		goto out;
> +	}
> +
> +	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
> +			  skb->data, skb->len, tx_urb_complete, skb);
> +
> +	info->rate_driver_data[1] = (void *)jiffies;
> +	skb_queue_tail(&tx->submitted_skbs, skb);
> +	usb_anchor_urb(urb, &tx->submitted);
> +
> +	r = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (r) {
> +		dev_dbg(purelifi_usb_dev(usb), "urb %p submit failed (%d)\n",
> +			urb, r);
> +		usb_unanchor_urb(urb);
> +		skb_unlink(skb, &tx->submitted_skbs);
> +		goto error;
> +	}
> +	return 0;
> +error:
> +	usb_free_urb(urb);
> +out:
> +	return r;

Do need to error paths in this function. Just return when goto out and
you use error just in one place.

> +}

> +int plf_usb_wreq_async(struct purelifi_usb *usb, const u8 *buffer,
> +		       int buffer_len, enum plf_usb_req_enum usb_req_id,
> +		       usb_complete_t complete_fn,
> +		       void *context)
> +{
> +	int r;
> +	struct usb_device *udev = interface_to_usbdev(ez_usb_interface);
> +	struct urb *urb = usb_alloc_urb(0, GFP_ATOMIC);
> +
> +	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
> +			  (void *)buffer, buffer_len, complete_fn, context);
> +
> +	r = usb_submit_urb(urb, GFP_ATOMIC);
> +

Remove newline.

> +	if (r)
> +		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
> +
> +	return r;
> +}
> +
> +int plf_usb_wreq(void *buffer, int buffer_len,
> +		 enum plf_usb_req_enum usb_req_id)
> +{
> +	int r;
> +	int actual_length;
> +	int usb_bulk_msg_len;
> +	unsigned char *dma_buffer = NULL;
> +	struct usb_device *udev = interface_to_usbdev(ez_usb_interface);
> +	struct plf_usb_req usb_req;
> +
> +	get_usb_req(udev, buffer, buffer_len, usb_req_id, &usb_req);
> +	usb_bulk_msg_len = sizeof(__le32) + sizeof(__le32) +
> +			   be32_to_cpu(usb_req.len);
> +
> +	dma_buffer = kmemdup(&usb_req, usb_bulk_msg_len, GFP_KERNEL);
> +
> +	if (!dma_buffer) {
> +		r = -ENOMEM;
> +		goto error;
> +	}
> +
> +	r = usb_bulk_msg(udev,
> +			 usb_sndbulkpipe(udev, EP_DATA_OUT),
> +			 dma_buffer, usb_bulk_msg_len,
> +			 &actual_length, USB_BULK_MSG_TIMEOUT_MS);
> +	kfree(dma_buffer);
> +error:
> +	if (r)
> +		dev_err(&udev->dev, "usb_bulk_msg failed (%d)\n", r);

Can also be enomem. So maybe return -ENOMEM in upper.

> +
> +	return r;
> +}

> +static int probe(struct usb_interface *intf,
> +		 const struct usb_device_id *id)
> +{
> +	int r = 0;
> +	struct purelifi_chip *chip;
> +	struct purelifi_usb *usb;
> +	struct purelifi_usb_tx *tx;
> +	struct ieee80211_hw *hw = NULL;
> +	u8 hw_address[ETH_ALEN];
> +	u8 serial_number[PURELIFI_SERIAL_LEN];
> +	unsigned int i;
> +
> +	ez_usb_interface = intf;
> +
> +	hw = purelifi_mac_alloc_hw(intf);
> +

Remove newline

> +	if (!hw) {
> +		r = -ENOMEM;
> +		goto error;

Just return straight away. This should not need message.

> +	}
> +
> +	chip = &purelifi_hw_mac(hw)->chip;
> +	usb = &chip->usb;
> +	tx = &usb->tx;
> +
> +	r = upload_mac_and_serial(intf, hw_address, serial_number);
> +

Remove newline.

<snip>

> +	timer_setup(&usb->sta_queue_cleanup,
> +		    sta_queue_cleanup_timer_callb, 0);
> +	usb->sta_queue_cleanup.expires = jiffies + STA_QUEUE_CLEANUP_JIFF;
> +	add_timer(&usb->sta_queue_cleanup);
> +
> +	usb->initialized = 1;

true

> +	return 0;
> +error:
> +	if (hw) {
> +		purelifi_mac_release(purelifi_hw_mac(hw));
> +		ieee80211_unregister_hw(hw);
> +		ieee80211_free_hw(hw);
> +	}
> +	dev_err(&intf->dev, "pureLifi:Device error");
> +	return r;
> +}
> +
> +static void disconnect(struct usb_interface *intf)
> +{
> +	struct ieee80211_hw *hw = purelifi_intf_to_hw(intf);
> +	struct purelifi_mac *mac;
> +	struct purelifi_usb *usb;
> +
> +	/* Either something really bad happened, or
> +	 * we're just dealing with
> +	 * a DEVICE_INSTALLER.
> +	 */

wrapping

> +	if (!hw)
> +		return;
> +
> +	mac = purelifi_hw_mac(hw);
> +	usb = &mac->chip.usb;
> +
> +	del_timer_sync(&usb->tx.tx_retry_timer);
> +	del_timer_sync(&usb->sta_queue_cleanup);
> +
> +	ieee80211_unregister_hw(hw);
> +
> +	purelifi_usb_disable_tx(usb);
> +	purelifi_usb_disable_rx(usb);
> +
> +	/* If the disconnect has been caused by a removal of the
> +	 * driver module, the reset allows reloading of the driver. If the
> +	 * reset will not be executed here,
> +	 * the upload of the firmware in the
> +	 * probe function caused by the reloading of the driver will fail.
> +	 */

ditto

> +	usb_reset_device(interface_to_usbdev(intf));
> +
> +	purelifi_mac_release(mac);
> +	ieee80211_free_hw(hw);
> +}

> +static struct purelifi_usb *get_purelifi_usb(struct usb_interface *intf)
> +{
> +	struct ieee80211_hw *hw = purelifi_intf_to_hw(intf);
> +	struct purelifi_mac *mac;
> +
> +	/* Either something really bad happened, or
> +	 * we're just dealing with
> +	 * a DEVICE_INSTALLER.
> +	 */

wrapping

  Argillander
