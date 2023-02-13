Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47708693C79
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 03:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBMCwU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 12 Feb 2023 21:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjBMCwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 21:52:18 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA04910A8F;
        Sun, 12 Feb 2023 18:52:05 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31D2pdXgB011814, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31D2pdXgB011814
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Feb 2023 10:51:39 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 13 Feb 2023 10:51:40 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 13 Feb 2023 10:51:40 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Feb 2023 10:51:40 +0800
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
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Bernie Huang <phhuang@realtek.com>,
        Andreas Henriksson <andreas@fatal.se>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: RE: [PATCH v2 3/3] wifi: rtw88: usb: drop now unnecessary URB size check
Thread-Topic: [PATCH v2 3/3] wifi: rtw88: usb: drop now unnecessary URB size
 check
Thread-Index: AQHZPUEygoH2E0H/i0ye/MUSSQBvh67MMaAg
Date:   Mon, 13 Feb 2023 02:51:40 +0000
Message-ID: <dceebe908ea84c34863cbed1e54e3e38@realtek.com>
References: <20230210111632.1985205-1-s.hauer@pengutronix.de>
 <20230210111632.1985205-4-s.hauer@pengutronix.de>
In-Reply-To: <20230210111632.1985205-4-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/2/12_=3F=3F_10:57:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Friday, February 10, 2023 7:17 PM
> To: linux-wireless@vger.kernel.org
> Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih <pkshih@realtek.com>;
> Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> kernel@pengutronix.de; Alexander Hochbaum <alex@appudo.com>; Da Xue <da@libre.computer>; Bernie Huang
> <phhuang@realtek.com>; Andreas Henriksson <andreas@fatal.se>; Viktor Petrenko <g0000ga@gmail.com>; Sascha
> Hauer <s.hauer@pengutronix.de>
> Subject: [PATCH v2 3/3] wifi: rtw88: usb: drop now unnecessary URB size check
> 
> Now that we send URBs with the URB_ZERO_PACKET flag set we no longer
> need to make sure that the URB sizes are not multiple of the
> bulkout_size. Drop the check.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/usb.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index 1a09c9288198a..2a8336b1847a5 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -414,24 +414,11 @@ static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
>  					u32 size)
>  {
>  	const struct rtw_chip_info *chip = rtwdev->chip;
> -	struct rtw_usb *rtwusb;
>  	struct rtw_tx_pkt_info pkt_info = {0};
> -	u32 len, desclen;
> -
> -	rtwusb = rtw_get_usb_priv(rtwdev);
> 
>  	pkt_info.tx_pkt_size = size;
>  	pkt_info.qsel = TX_DESC_QSEL_BEACON;
> -
> -	desclen = chip->tx_pkt_desc_sz;
> -	len = desclen + size;
> -	if (len % rtwusb->bulkout_size == 0) {
> -		len += RTW_USB_PACKET_OFFSET_SZ;
> -		pkt_info.offset = desclen + RTW_USB_PACKET_OFFSET_SZ;
> -		pkt_info.pkt_offset = 1;
> -	} else {
> -		pkt_info.offset = desclen;
> -	}
> +	pkt_info.offset = chip->tx_pkt_desc_sz;
> 
>  	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
>  }
> --
> 2.30.2

