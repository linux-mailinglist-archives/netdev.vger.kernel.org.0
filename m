Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647D96373D8
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKXI1C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Nov 2022 03:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiKXI1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:27:01 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38F10DDFBE;
        Thu, 24 Nov 2022 00:27:00 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AO8Pe8Z2026323, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AO8Pe8Z2026323
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 24 Nov 2022 16:25:40 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 24 Nov 2022 16:26:23 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 24 Nov 2022 16:26:23 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 24 Nov 2022 16:26:23 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     Bernie Huang <phhuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Viktor Petrenko" <g0000ga@gmail.com>, Neo Jou <neojou@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>
Subject: RE: [PATCH v3 00/11] RTW88: Add support for USB variants
Thread-Topic: [PATCH v3 00/11] RTW88: Add support for USB variants
Thread-Index: AQHY/oI6X+HeQwQE6E+5y32AEGOa3q5KgcmAgAMh88D//5TGAIAAhqEg
Date:   Thu, 24 Nov 2022 08:26:23 +0000
Message-ID: <be8781b95e934617b33f338c84665677@realtek.com>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
 <20221122145527.GA29978@pengutronix.de>
 <015051d9a5b94bbca5135c58d2cfebf3@realtek.com>
 <20221124082158.GE29978@pengutronix.de>
In-Reply-To: <20221124082158.GE29978@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/24_=3F=3F_06:24:00?=
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
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Thursday, November 24, 2022 4:22 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Bernie Huang <phhuang@realtek.com>; linux-wireless@vger.kernel.org; Hans Ulli Kroll
> <linux@ulli-kroll.de>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>; netdev@vger.kernel.org;
> Kalle Valo <kvalo@kernel.org>; Yan-Hsuan Chuang <tony0620emma@gmail.com>; linux-kernel@vger.kernel.org;
> Viktor Petrenko <g0000ga@gmail.com>; Neo Jou <neojou@gmail.com>; kernel@pengutronix.de; Johannes Berg
> <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>; Da Xue <da@libre.computer>
> Subject: Re: [PATCH v3 00/11] RTW88: Add support for USB variants
> 
> On Thu, Nov 24, 2022 at 06:48:23AM +0000, Ping-Ke Shih wrote:
> >
> > > -----Original Message-----
> > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > Sent: Tuesday, November 22, 2022 10:55 PM
> > > To: Bernie Huang <phhuang@realtek.com>
> > > Cc: linux-wireless@vger.kernel.org; Ping-Ke Shih <pkshih@realtek.com>; Hans Ulli Kroll
> > > <linux@ulli-kroll.de>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> netdev@vger.kernel.org;
> > > Kalle Valo <kvalo@kernel.org>; Yan-Hsuan Chuang <tony0620emma@gmail.com>;
> linux-kernel@vger.kernel.org;
> > > Viktor Petrenko <g0000ga@gmail.com>; Neo Jou <neojou@gmail.com>; Bernie Huang <phhuang@realtek.com>;
> > > kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum
> <alex@appudo.com>;
> > > Da Xue <da@libre.computer>
> > > Subject: Re: [PATCH v3 00/11] RTW88: Add support for USB variants
> > >
> > > On Tue, Nov 22, 2022 at 03:52:15PM +0100, Sascha Hauer wrote:
> > > > This is the third round of adding support for the USB variants to the
> > > > RTW88 driver. There are a few changes to the last version which make it
> > > > worth looking at this version.
> > > >
> > > > First of all RTL8723du and RTL8821cu are tested working now. The issue
> > > > here was that the txdesc checksum calculation was wrong. I found the
> > > > correct calculation in various downstream drivers found on github.
> > > >
> > > > The second big issue was that TX packet aggregation was wrong. When
> > > > aggregating packets each packet start has to be aligned to eight bytes.
> > > > The necessary alignment was added to the total URB length before
> > > > checking if there is another packet to aggregate, so the URB length
> > > > included that padding after the last packet, which is wrong.  Fixing
> > > > this makes the driver work much more reliably.
> > > >
> > > > I added all people to Cc: who showed interest in this driver and I want
> > > > to welcome you for testing and reviewing.
> > >
> > > There still is a problem with the RTL8822cu chipset I have here.  When
> > > using NetworkManager I immediately lose the connection to the AP after
> > > it has been connected:
> > >
> > > [  376.213846] wlan0: authenticate with 76:83:c2:ce:81:b1
> > > [  380.085463] wlan0: send auth to 76:83:c2:ce:81:b1 (try 1/3)
> > > [  380.091446] wlan0: authenticated
> > > [  380.108864] wlan0: associate with 76:83:c2:ce:81:b1 (try 1/3)
> > > [  380.136448] wlan0: RX AssocResp from 76:83:c2:ce:81:b1 (capab=0x1411 status=0 aid=2)
> > > [  380.202955] wlan0: associated
> > > [  380.268140] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > > [  380.275328] wlan0: Connection to AP 76:83:c2:ce:81:b1 lost
> > >
> > > That doesn't happen when using plain wpa_supplicant. This seems to go
> > > down to cd96e22bc1da ("rtw88: add beacon filter support"). After being
> > > connected I get a BCN_FILTER_CONNECTION_LOSS beacon. Plain
> > > wpa_supplicant seems to go another code patch and doesn't activate
> > > connection quality monitoring.
> > >
> > > The connection to the AP works fluently also with NetworkManager though
> > > when I just ignore the BCN_FILTER_CONNECTION_LOSS beacon.
> > >
> > > Any idea what may be wrong here?
> > >
> >
> > Please reference to below patch to see if it can work to you.
> >
> > https://lore.kernel.org/linux-wireless/20221124064442.28042-1-pkshih@realtek.com/T/#u
> 
> Great! That solves this issue \o/
> 

Do you mind to add "Tested-by:" tag to the patch?  :-)

Ping-Ke


