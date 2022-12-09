Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E3B647C8C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 04:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLIDSW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Dec 2022 22:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiLIDSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:18:21 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DA547D069;
        Thu,  8 Dec 2022 19:18:17 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B93GWplC026671, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B93GWplC026671
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 9 Dec 2022 11:16:32 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 9 Dec 2022 11:17:20 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 9 Dec 2022 11:17:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 9 Dec 2022 11:17:20 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Kalle Valo <kvalo@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>,
        "Bernie Huang" <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: RE: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
Thread-Topic: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
Thread-Index: AQHZA9p/gdNauXKGBEa6UnG4y/tPNK5VjnKAgAALtACADn7s0IAAx4yA
Date:   Fri, 9 Dec 2022 03:17:19 +0000
Message-ID: <7699d3f9e4a244349807a34b3981e26c@realtek.com>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
        <20221129100754.2753237-9-s.hauer@pengutronix.de>
        <20221129081753.087b7a35@kernel.org>
        <d2113f20-d547-ce16-ff7f-2d1286321014@lwfinger.net>
 <87tu260yeb.fsf@kernel.org>
In-Reply-To: <87tu260yeb.fsf@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/9_=3F=3F_02:13:00?=
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
> From: Kalle Valo <kvalo@kernel.org>
> Sent: Thursday, December 8, 2022 10:21 PM
> To: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Jakub Kicinski <kuba@kernel.org>; Sascha Hauer <s.hauer@pengutronix.de>;
> linux-wireless@vger.kernel.org; Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke
> Shih <pkshih@realtek.com>; Yan-Hsuan Chuang <tony0620emma@gmail.com>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>
> Subject: Re: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
> 
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
> > On 11/29/22 10:17, Jakub Kicinski wrote:
> >> On Tue, 29 Nov 2022 11:07:51 +0100 Sascha Hauer wrote:
> >>> +config RTW88_8821CU
> >>> +	tristate "Realtek 8821CU USB wireless network adapter"
> >>> +	depends on USB
> >>> +	select RTW88_CORE
> >>> +	select RTW88_USB
> >>> +	select RTW88_8821C
> >>> +	help
> >>> +	  Select this option will enable support for 8821CU chipset
> >>> +
> >>> +	  802.11ac USB wireless network adapter
> >>
> >> Those kconfig knobs add so little code, why not combine them all into
> >> one? No point bothering the user with 4 different questions with amount
> >> to almost nothing.
> >
> > I see only one knob there, name RTW88_8821CU. The other configuration
> > variables select parts of the code that are shared with other drivers
> > such as RTW88_8821CE and these parts must be there.
> 
> I just test compiled these patches and we have four new questions:
> 
>   Realtek 8822BU USB wireless network adapter (RTW88_8822BU) [N/m/?] (NEW) m
>   Realtek 8822CU USB wireless network adapter (RTW88_8822CU) [N/m/?] (NEW) m
>   Realtek 8723DU USB wireless network adapter (RTW88_8723DU) [N/m/?] (NEW) m
>   Realtek 8821CU USB wireless network adapter (RTW88_8821CU) [N/m/?] (NEW)
> 
> To me this looks too fine grained. Does it really make sense, for
> example, to enable RTW88_8822BU but not RTW88_8822CU? Would just having
> RTW88_USB containing all USB devices be more sensible? And the same for
> PCI, and if we have in the future, SDIO devices.
> 

Summerize Realtek 802.11n/11ac WiFi drivers after this patchset:

                        Kconfig
  driver      #-of-ko   knob   support chips
  ---------------------------------------------------------------------
  rtl8xxxu   1          1      8188fu, 8192cu, 8192eu, 8723au, 8723bu
  rtlwifi    15         9      8192se, 8723ae, 8723be, 8192ee, 8192de, 8188ee, 8192ce, 8821ae
                               8192cu
  rtw88      15         8      8723de, 8821ce, 8822be, 8822ce
                               8723du, 8821cu, 8822bu, 8822cu

If we merge into single one Kconfig knob, we could have a long list name

"Realtek 8723DU/8821CU/8822BU/8822CU USB wireless network adapter"

or an implicit name

"Realtek 802.11n/802.11ac USB wireless network adapter"

The string mixes "802.11n/802.11ac" because hardware architecture of
Realtek WiFi chips change during 11n/11ac generations, so rtlwifi (old architecture)
and rtw88 (new architecture) support both 11n and 11ac chips. That is a little
bit inconvenient to people who wants to know which driver support his own WiFi
module explicitly.

Another thing is to save some compile time and disk space to build these .ko if
we have separated knobs. For Ubuntu or other distros users, I think they
may not care about this, because distros have already built drivers and disk
of notebook or desktop is large. But, for embedded users, like Raspberry Pi
or proprietary embedded system, they may want to highly customize drivers
due to limit of hardware resource.

Therefore, I prefer to preserve current Kconfig. Though single one knob is
really simple for anything.

Ping-Ke

