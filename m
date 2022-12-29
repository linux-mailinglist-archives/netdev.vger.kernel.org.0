Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A47C658869
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 02:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiL2Bkd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Dec 2022 20:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiL2Bkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 20:40:31 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FF681183D;
        Wed, 28 Dec 2022 17:40:30 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BT1dNdR5006250, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BT1dNdR5006250
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 09:39:23 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 29 Dec 2022 09:40:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 09:40:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 09:40:16 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [RFC PATCH v1 18/19] rtw88: Add support for the SDIO based RTL8822CS chipset
Thread-Topic: [RFC PATCH v1 18/19] rtw88: Add support for the SDIO based
 RTL8822CS chipset
Thread-Index: AQHZGktEJugCouG9V0Kgbw48Ihs1066EFpog
Date:   Thu, 29 Dec 2022 01:40:16 +0000
Message-ID: <59ab30de2c33438ebad948b0a36aad21@realtek.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-19-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221227233020.284266-19-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/28_=3F=3F_10:54:00?=
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
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Wednesday, December 28, 2022 7:30 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [RFC PATCH v1 18/19] rtw88: Add support for the SDIO based RTL8822CS chipset
> 
> Wire up RTL8822CS chipset support using the new rtw88 SDIO HCI code as
> well as the existing RTL8822C chipset code.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
>  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
>  .../net/wireless/realtek/rtw88/rtw8822cs.c    | 34 +++++++++++++++++++
>  3 files changed, 48 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
> 

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
> b/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
> new file mode 100644
> index 000000000000..3d7279d70aa9
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822cs.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +// Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Normally, we should use '/* ... */' style comment. The exception is 
'// SPDX-License-Identifier: ...' in *.c

Therefore, here should be:

// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
 */

As well as other rtw88*s.c

--
Ping-Ke

