Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3955D4934CD
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351738AbiASGFJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jan 2022 01:05:09 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53783 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351692AbiASGFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 01:05:00 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20J64pGoA005333, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20J64pGoA005333
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 14:04:51 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 14:04:51 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 19 Jan 2022 14:04:51 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Wed, 19 Jan 2022 14:04:51 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH 4/4] rtw88: mac: Use existing interface mask macros in rtw_pwr_seq_parser()
Thread-Topic: [PATCH 4/4] rtw88: mac: Use existing interface mask macros in
 rtw_pwr_seq_parser()
Thread-Index: AQHYCaFOP71kjZBr50uLFOdzW1gqK6xp4WUQ
Date:   Wed, 19 Jan 2022 06:04:50 +0000
Message-ID: <858f879db56143ad8e5a226cc11dba48@realtek.com>
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
 <20220114234825.110502-5-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220114234825.110502-5-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
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
> Subject: [PATCH 4/4] rtw88: mac: Use existing interface mask macros in rtw_pwr_seq_parser()
> 
> Replace the magic numbers for the intf_mask with their existing
> RTW_PWR_INTF_PCI_MSK and RTW_PWR_INTF_USB_MSK macros to make the code
> easier to understand.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

