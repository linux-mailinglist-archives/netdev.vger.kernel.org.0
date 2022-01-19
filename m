Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE910493779
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352777AbiASJi5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jan 2022 04:38:57 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:52393 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352533AbiASJix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 04:38:53 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20J9cSYa9024415, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20J9cSYa9024415
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 17:38:28 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 19 Jan 2022 17:38:28 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 19 Jan 2022 01:38:26 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Wed, 19 Jan 2022 17:38:26 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ed Swierk <eswierk@gh.st>
Subject: RE: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Topic: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Index: AQHYBCp/WStseF16x0uJ7VAbWo+1y6xqJTFA
Date:   Wed, 19 Jan 2022 09:38:26 +0000
Message-ID: <b1e89f471e824eaba27a5dcbc363974a@realtek.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/1/19_=3F=3F_08:01:00?=
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

Hi,

> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Saturday, January 8, 2022 8:55 AM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; johannes@sipsolutions.net; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Neo Jou <neojou@gmail.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Pkshih <pkshih@realtek.com>; Ed Swierk <eswierk@gh.st>; Martin Blumenstingl
> <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
> 

[...]

I do stressed test of connection and suspend, and it get stuck after about
4 hours but no useful messages. I will re-build my kernel and turn on lockdep debug
to see if it can tell me what is wrong.

--
Ping-Ke

