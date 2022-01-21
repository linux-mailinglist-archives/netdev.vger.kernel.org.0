Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B8B495A73
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378897AbiAUHOw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 02:14:52 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:45368 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378887AbiAUHOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:14:45 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20L7EUKK0024197, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20L7EUKK0024197
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 15:14:30 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 21 Jan 2022 15:14:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 20 Jan 2022 23:14:30 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Fri, 21 Jan 2022 15:14:30 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Pkshih <pkshih@realtek.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     "kernel@collabora.com" <kernel@collabora.com>
Subject: RE: [PATCH v3] rtw88: check for validity before using a pointer
Thread-Topic: [PATCH v3] rtw88: check for validity before using a pointer
Thread-Index: AQHX+KPvE/unI/D/606seZj0xgKxUqxBV0ZAgCvilcA=
Date:   Fri, 21 Jan 2022 07:14:30 +0000
Message-ID: <d41cad1d43074b858209f3d7227c4e14@realtek.com>
References: <YcWK1jxnd3vGdmCq@debian-BULLSEYE-live-builder-AMD64>
 <505cb763449e4b4ab493857e014e31a1@realtek.com>
In-Reply-To: <505cb763449e4b4ab493857e014e31a1@realtek.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/1/21_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Pkshih <pkshih@realtek.com>
> Sent: Friday, December 24, 2021 5:01 PM
> To: Muhammad Usama Anjum <usama.anjum@collabora.com>; Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle
> Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Bernie
> Huang <phhuang@realtek.com>; open list:REALTEK WIRELESS DRIVER (rtw88) <linux-wireless@vger.kernel.org>;
> open list:NETWORKING DRIVERS <netdev@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Cc: kernel@collabora.com
> Subject: RE: [PATCH v3] rtw88: check for validity before using a pointer
> 
> > -----Original Message-----
> > From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> > Sent: Friday, December 24, 2021 4:55 PM
> > To: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller
> > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Pkshih <pkshih@realtek.com>; Bernie Huang
> > <phhuang@realtek.com>; open list:REALTEK WIRELESS DRIVER (rtw88) <linux-wireless@vger.kernel.org>; open
> > list:NETWORKING DRIVERS <netdev@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> > Cc: usama.anjum@collabora.com; kernel@collabora.com
> > Subject: [PATCH v3] rtw88: check for validity before using a pointer
> >
> > ieee80211_probereq_get() can return NULL. Pointer skb should be checked
> > for validty before use. If it is not valid, list of skbs needs to be
> > freed.
> >
> > Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
> > Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> 
> [...]
> 

I take this patch into my patchset [1], because my new patches are based this patch
related to fixes of hw_scan.

[1] https://lore.kernel.org/linux-wireless/20220121070813.9656-2-pkshih@realtek.com/T/#u

--
Ping-Ke

