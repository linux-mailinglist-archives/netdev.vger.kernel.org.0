Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D089C639F2C
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 03:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiK1CB7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 27 Nov 2022 21:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK1CB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 21:01:58 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1484FD2F9;
        Sun, 27 Nov 2022 18:01:53 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AS20BzQ4022829, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AS20BzQ4022829
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 28 Nov 2022 10:00:11 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 28 Nov 2022 10:00:56 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 28 Nov 2022 10:00:55 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 28 Nov 2022 10:00:55 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>,
        "Bernie Huang" <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        neo_jou <neo_jou@realtek.com>
Subject: RE: [PATCH v3 07/11] rtw88: Add common USB chip support
Thread-Topic: [PATCH v3 07/11] rtw88: Add common USB chip support
Thread-Index: AQHY/oI8ptr99hEq8k+LqRAzoG392a5PWSHw
Date:   Mon, 28 Nov 2022 02:00:54 +0000
Message-ID: <1f7aa964766c4f65b836f7e1d716a1e3@realtek.com>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
 <20221122145226.4065843-8-s.hauer@pengutronix.de>
In-Reply-To: <20221122145226.4065843-8-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/27_=3F=3F_10:48:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Tuesday, November 22, 2022 10:52 PM
> To: linux-wireless@vger.kernel.org
> Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih <pkshih@realtek.com>;
> Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> Sascha Hauer <s.hauer@pengutronix.de>; neo_jou <neo_jou@realtek.com>
> Subject: [PATCH v3 07/11] rtw88: Add common USB chip support
> 
> Add the common bits and pieces to add USB support to the RTW88 driver.
> This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> itself is first written by Neo Jou.
> 
> Signed-off-by: neo_jou <neo_jou@realtek.com>
> Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
> 
> Notes:
>     Changes since v2:
>     - Fix buffer length for aggregated tx packets
>     - Increase maximum transmit buffer size to 20KiB as found in downstream drivers
>     - Change register write functions to synchronous accesses instead of just firing
>       a URB without waiting for its completion
>     - requeue rx URBs directly in completion handler rather than having a workqueue
>       for it.
> 
>     Changes since v1:
>     - Make checkpatch.pl clean
>     - Drop WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL flag
>     - Use 'ret' as variable name for return values
>     - Sort variable declarations in reverse Xmas tree order
>     - Change potentially endless loop to a limited loop
>     - Change locking to be more obviously correct
>     - drop unnecessary check for !rtwdev
>     - make sure the refill workqueue is not restarted again after we have
>       cancelled it
> 
>  drivers/net/wireless/realtek/rtw88/Kconfig  |   3 +
>  drivers/net/wireless/realtek/rtw88/Makefile |   2 +
>  drivers/net/wireless/realtek/rtw88/mac.c    |   3 +
>  drivers/net/wireless/realtek/rtw88/main.c   |   4 +
>  drivers/net/wireless/realtek/rtw88/main.h   |   4 +
>  drivers/net/wireless/realtek/rtw88/reg.h    |   1 +
>  drivers/net/wireless/realtek/rtw88/tx.h     |  31 +
>  drivers/net/wireless/realtek/rtw88/usb.c    | 918 ++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/usb.h    | 107 +++
>  9 files changed, 1073 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
> index e3d7cb6c12902..1624c5db69bac 100644
> --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> @@ -16,6 +16,9 @@ config RTW88_CORE
>  config RTW88_PCI
>  	tristate
> 
> +config RTW88_USB
> +	tristate
> +
>  config RTW88_8822B
>  	tristate
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
> index 834c66ec0af9e..9e095f8181483 100644
> --- a/drivers/net/wireless/realtek/rtw88/Makefile
> +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> @@ -45,4 +45,6 @@ obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
>  rtw88_8821ce-objs		:= rtw8821ce.o
> 
>  obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
> +obj-$(CONFIG_RTW88_USB)		+= rtw88_usb.o
>  rtw88_pci-objs			:= pci.o
> +rtw88_usb-objs			:= usb.o

nit: I prefer not interleaving with PCI.


[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> new file mode 100644
> index 0000000000000..4a12934d20712
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c

[...]

> +static u32 rtw_usb_read(struct rtw_dev *rtwdev, u32 addr, u16 len)
> +{
> +	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
> +	struct usb_device *udev = rtwusb->udev;
> +	__le32 *data;
> +	unsigned long flags;
> +	int ret;
> +	static int count;
> +
> +	spin_lock_irqsave(&rtwusb->usb_lock, flags);
> +
> +	rtwusb->usb_data_index++;
> +	rtwusb->usb_data_index &= (RTW_USB_MAX_RXTX_COUNT - 1);
> +
> +	spin_unlock_irqrestore(&rtwusb->usb_lock, flags);
> +
> +	data = &rtwusb->usb_data[rtwusb->usb_data_index];

Don't you need to hold &rtwusb->usb_lock to access rtwusb->usb_data_index?
rtw_usb_write() has similar code.

> +
> +	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +			      RTW_USB_CMD_REQ, RTW_USB_CMD_READ, addr,
> +			      RTW_USB_VENQT_CMD_IDX, data, len, 1000);
> +	if (ret < 0 && ret != -ENODEV && count++ < 4)
> +		rtw_err(rtwdev, "read register 0x%x failed with %d\n",
> +			addr, ret);
> +
> +	return le32_to_cpu(*data);
> +}
> +

[...]

> +
> +static void rtw_usb_write_port_tx_complete(struct urb *urb)
> +{
> +	struct rtw_usb_txcb *txcb = urb->context;
> +	struct rtw_dev *rtwdev = txcb->rtwdev;
> +	struct ieee80211_hw *hw = rtwdev->hw;
> +
> +	while (true) {

Is it possible to have a hard limit to prevent unexpected infinite loop?

> +		struct sk_buff *skb = skb_dequeue(&txcb->tx_ack_queue);
> +		struct ieee80211_tx_info *info;
> +		struct rtw_usb_tx_data *tx_data;
> +
> +		if (!skb)
> +			break;
> +
> +		info = IEEE80211_SKB_CB(skb);
> +		tx_data = rtw_usb_get_tx_data(skb);
> +
> +		/* enqueue to wait for tx report */
> +		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
> +			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
> +			continue;
> +		}
> +
> +		/* always ACK for others, then they won't be marked as drop */
> +		ieee80211_tx_info_clear_status(info);
> +		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
> +			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
> +		else
> +			info->flags |= IEEE80211_TX_STAT_ACK;
> +
> +		ieee80211_tx_status_irqsafe(hw, skb);
> +	}
> +
> +	kfree(txcb);
> +}
> +

[...]

> +
> +static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list)
> +{
> +	struct rtw_dev *rtwdev = rtwusb->rtwdev;
> +	struct rtw_usb_txcb *txcb;
> +	struct sk_buff *skb_head;
> +	struct sk_buff *skb_iter;
> +	u8 *data_ptr;
> +	int agg_num = 0;
> +	unsigned int align_next = 0;
> +
> +	if (skb_queue_empty(list))
> +		return false;
> +
> +	txcb = kmalloc(sizeof(*txcb), GFP_ATOMIC);
> +	if (!txcb)
> +		return false;
> +
> +	txcb->rtwdev = rtwdev;
> +	skb_queue_head_init(&txcb->tx_ack_queue);
> +
> +	skb_iter = skb_dequeue(list);
> +
> +	if (skb_queue_empty(list)) {
> +		skb_head = skb_iter;
> +		goto queue;
> +	}
> +
> +	skb_head = dev_alloc_skb(RTW_USB_MAX_XMITBUF_SZ);
> +	if (!skb_head) {
> +		skb_head = skb_iter;
> +		goto queue;
> +	}
> +
> +	data_ptr = skb_head->data;
> +
> +	while (skb_iter) {
> +		unsigned long flags;
> +
> +		memcpy(data_ptr, skb_iter->data, skb_iter->len);
> +		skb_put(skb_head, skb_iter->len + align_next);

skb_put(skb_head, align_next);
skb_put_data(skb_head, skb_iter->data, skb_iter->len);

Then, don't need to maintain 'data_ptr'.

> +
> +		align_next = ALIGN(skb_iter->len, 8) - skb_iter->len;
> +		data_ptr += skb_iter->len + align_next;
> +
> +		agg_num++;
> +
> +		skb_queue_tail(&txcb->tx_ack_queue, skb_iter);
> +
> +		spin_lock_irqsave(&list->lock, flags);
> +
> +		skb_iter = skb_peek(list);
> +
> +		if (skb_iter && skb_iter->len + skb_head->len <= RTW_USB_MAX_XMITBUF_SZ)
> +			__skb_unlink(skb_iter, list);
> +		else
> +			skb_iter = NULL;
> +		spin_unlock_irqrestore(&list->lock, flags);
> +	}
> +
> +	if (agg_num > 1)
> +		rtw_usb_fill_tx_checksum(rtwusb, skb_head, agg_num);
> +
> +queue:
> +	skb_queue_tail(&txcb->tx_ack_queue, skb_head);
> +
> +	rtw_usb_write_port(rtwdev, GET_TX_DESC_QSEL(skb_head->data), skb_head,
> +			   rtw_usb_write_port_tx_complete, txcb);
> +
> +	return true;
> +}
> +

[...]

> +
> +static void rtw_usb_rx_resubmit(struct rtw_usb *rtwusb, struct rx_usb_ctrl_block *rxcb)
> +{
> +	struct rtw_dev *rtwdev = rtwusb->rtwdev;
> +	int error;
> +
> +	rxcb->rx_skb = alloc_skb(RTW_USB_MAX_RECVBUF_SZ, GFP_ATOMIC);
> +	if (!rxcb->rx_skb)
> +		return;
> +
> +	usb_fill_bulk_urb(rxcb->rx_urb, rtwusb->udev,
> +			  usb_rcvbulkpipe(rtwusb->udev, rtwusb->pipe_in),
> +			  rxcb->rx_skb->data, RTW_USB_MAX_RECVBUF_SZ,
> +			  rtw_usb_read_port_complete, rxcb);
> +
> +	error = usb_submit_urb(rxcb->rx_urb, GFP_ATOMIC);
> +	if (error) {
> +		kfree_skb(rxcb->rx_skb);
> +		if (error != -ENODEV)
> +			rtw_err(rtwdev, "Err sending rx data urb %d\n",
> +				error);

nit: straighten rtw_err()

> +	}
> +}
> +

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
> new file mode 100644
> index 0000000000000..e26f8afb09f29
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/usb.h

[...]

> +
> +static inline struct rtw_usb_tx_data *rtw_usb_get_tx_data(struct sk_buff *skb)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +
> +	BUILD_BUG_ON(sizeof(struct rtw_usb_tx_data) >
> +		sizeof(info->status.status_driver_data));

coding style: 

align the open parenthesis 

	BUILD_BUG_ON(sizeof(struct rtw_usb_tx_data) >
		     sizeof(info->status.status_driver_data));

> +
> +	return (struct rtw_usb_tx_data *)info->status.status_driver_data;
> +}
> +
> +int rtw_usb_probe(struct usb_interface *intf, const struct usb_device_id *id);
> +void rtw_usb_disconnect(struct usb_interface *intf);
> +
> +#endif
> --
> 2.30.2

