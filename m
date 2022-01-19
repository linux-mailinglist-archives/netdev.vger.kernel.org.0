Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A394934CA
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351671AbiASGEz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jan 2022 01:04:55 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53777 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349816AbiASGEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 01:04:54 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20J64kywE005326, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20J64kywE005326
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 14:04:46 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 14:04:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 14:04:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Wed, 19 Jan 2022 14:04:45 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
Thread-Topic: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to
 tx.{c,h}
Thread-Index: AQHYCaFNVHVbe+NHskesfTypYlznFKxp4FMA
Date:   Wed, 19 Jan 2022 06:04:45 +0000
Message-ID: <b2bf2bc5f04b488487797aa21c50a130@realtek.com>
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
 <20220114234825.110502-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220114234825.110502-4-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/1/19_=3F=3F_03:30:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Saturday, January 15, 2022 7:48 AM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Neo Jou <neojou@gmail.com>; Jernej Skrabec <jernej.skrabec@gmail.com>; Pkshih <pkshih@realtek.com>; Martin
> Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
> 
> This code is not specific to the PCIe bus type but can be re-used by USB
> and SDIO bus types. Move it to tx.{c,h} to avoid code-duplication in the
> future.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
> index efcc1b0371a8..ec6a3683c3f8 100644
> --- a/drivers/net/wireless/realtek/rtw88/tx.c
> +++ b/drivers/net/wireless/realtek/rtw88/tx.c
> @@ -665,3 +665,38 @@ void rtw_txq_cleanup(struct rtw_dev *rtwdev, struct ieee80211_txq *txq)
>  		list_del_init(&rtwtxq->list);
>  	spin_unlock_bh(&rtwdev->txq_lock);
>  }
> +
> +static enum rtw_tx_queue_type ac_to_hwq[] = {
> +	[IEEE80211_AC_VO] = RTW_TX_QUEUE_VO,
> +	[IEEE80211_AC_VI] = RTW_TX_QUEUE_VI,
> +	[IEEE80211_AC_BE] = RTW_TX_QUEUE_BE,
> +	[IEEE80211_AC_BK] = RTW_TX_QUEUE_BK,
> +};
> +
> +static_assert(ARRAY_SIZE(ac_to_hwq) == IEEE80211_NUM_ACS);
> +
> +enum rtw_tx_queue_type rtw_tx_ac_to_hwq(enum ieee80211_ac_numbers ac)
> +{
> +	return ac_to_hwq[ac];
> +}
> +EXPORT_SYMBOL(rtw_tx_ac_to_hwq);
> +

Could I know why we can't just export the array ac_to_hwq[]?
Is there a strict rule?

--
Ping-Ke

