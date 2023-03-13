Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E8D6B726E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjCMJWf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Mar 2023 05:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjCMJWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:22:33 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D53303CB;
        Mon, 13 Mar 2023 02:22:32 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32D9M9xeC013503, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32D9M9xeC013503
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Mar 2023 17:22:09 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 13 Mar 2023 17:22:21 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 13 Mar 2023 17:22:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Mar 2023 17:22:20 +0800
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
Subject: RE: [PATCH v2 RFC 9/9] wifi: rtw88: Add support for the SDIO based RTL8821CS chipset
Thread-Topic: [PATCH v2 RFC 9/9] wifi: rtw88: Add support for the SDIO based
 RTL8821CS chipset
Thread-Index: AQHZU48VGCxmxOqKXUqxNunwzfio6674cHaQ
Date:   Mon, 13 Mar 2023 09:22:20 +0000
Message-ID: <2df6178819784f9f9b5c9956bddf7e3f@realtek.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-10-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230310202922.2459680-10-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Saturday, March 11, 2023 4:29 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v2 RFC 9/9] wifi: rtw88: Add support for the SDIO based RTL8821CS chipset
> 
> Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> well as the existing RTL8821C chipset code.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Changes since v1:
> - use /* ... */ style for copyright comments
> 
> 
>  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
>  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
>  .../net/wireless/realtek/rtw88/rtw8821cs.c    | 35 +++++++++++++++++++
>  3 files changed, 49 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> 

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> new file mode 100644
> index 000000000000..7ad7c13ac9e6
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> + */
> +
> +#include <linux/mmc/sdio_func.h>
> +#include <linux/mmc/sdio_ids.h>
> +#include <linux/module.h>
> +#include "sdio.h"
> +#include "rtw8821c.h"

nit: alphabetic order


I run sparse/smatch with this patchset, and smatch warns:

1. drivers/net/wireless/realtek/rtw88/mac.c:313 rtw_mac_power_switch() error: uninitialized symbol 'imr'.
This should be a false-alarm, but just initialize imr to 0 to avoid this.


2. drivers/net/wireless/realtek/rtw88/sdio.c:136 rtw_sdio_read_indirect_bytes() error: uninitialized symbol 'ret'.
This should be a false-alarm too. I guess it considers 'count = 0' is possible.

Ping-Ke

