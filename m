Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEDD693C73
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 03:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjBMCvL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 12 Feb 2023 21:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBMCvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 21:51:10 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B26E396;
        Sun, 12 Feb 2023 18:51:06 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31D2oRCS1011592, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31D2oRCS1011592
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Feb 2023 10:50:27 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 13 Feb 2023 10:50:28 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 13 Feb 2023 10:50:28 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Feb 2023 10:50:28 +0800
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
Subject: RE: [PATCH v2 1/3] wifi: rtw88: usb: Set qsel correctly
Thread-Topic: [PATCH v2 1/3] wifi: rtw88: usb: Set qsel correctly
Thread-Index: AQHZPUEz+Vvr7LFh8kmyj+mKp52l9a7MMUYg
Date:   Mon, 13 Feb 2023 02:50:28 +0000
Message-ID: <d0a600842a1d4c289ef2414c4415095c@realtek.com>
References: <20230210111632.1985205-1-s.hauer@pengutronix.de>
 <20230210111632.1985205-2-s.hauer@pengutronix.de>
In-Reply-To: <20230210111632.1985205-2-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/2/12_=3F=3F_10:57:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
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
> Subject: [PATCH v2 1/3] wifi: rtw88: usb: Set qsel correctly
> 
> We have to extract qsel from the skb before doing skb_push() on it,
> otherwise qsel will always be 0.
> 
> Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index 4ef38279b64c9..d9e995544e405 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -471,9 +471,9 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
>  	u8 *pkt_desc;
>  	int ep;
> 
> +	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
>  	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
>  	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
> -	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
>  	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
>  	rtw_tx_fill_tx_desc(pkt_info, skb);
>  	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
> --
> 2.30.2

