Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC36D8D7A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbjDFCcN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Apr 2023 22:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDFCcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:32:10 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863238A53;
        Wed,  5 Apr 2023 19:32:07 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3362VKyiC027848, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3362VKyiC027848
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 6 Apr 2023 10:31:20 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 6 Apr 2023 10:31:39 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 6 Apr 2023 10:31:39 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 6 Apr 2023 10:31:39 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macromorgan@hotmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?iso-8859-1?Q?Pali_Roh=E1r?= <pali@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH v5 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
Thread-Topic: [PATCH v5 2/9] wifi: rtw88: sdio: Add HCI implementation for
 SDIO based chipsets
Thread-Index: AQHZZ/pJyJYNwZ4fx0+w0E4CUS/4Nq8dj67A
Date:   Thu, 6 Apr 2023 02:31:39 +0000
Message-ID: <0c9e1c2b3bc04abcb79de87610382d6a@realtek.com>
References: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
 <20230405200729.632435-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230405200729.632435-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Thursday, April 6, 2023 4:07 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macromorgan@hotmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Larry Finger <Larry.Finger@lwfinger.net>; Pali Rohár <pali@kernel.org>; Simon Horman
> <simon.horman@corigine.com>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v5 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
> 
> Add a sub-driver for SDIO based chipsets which implements the following
> functionality:
> - register accessors for 8, 16 and 32 bits for all states of the card
>   (including usage of 4x 8 bit access for one 32 bit buffer if the card
>   is not fully powered on yet - or if it's fully powered on then 1x 32
>   bit access is used)
> - checking whether there's space in the TX FIFO queue to transmit data
> - transfers from the host to the device for actual network traffic,
>   reserved pages (for firmware download) and H2C (host-to-card)
>   transfers
> - receiving data from the device
> - deep power saving state
> 
> The transmit path is optimized so DMA-capable SDIO host controllers can
> directly use the buffers provided because the buffer's physical
> addresses are 8 byte aligned.
> 
> The receive path is prepared to support RX aggregation where the
> chipset combines multiple MAC frames into one bigger buffer to reduce
> SDIO transfer overhead.
> 
> Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>


