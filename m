Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316E73652B6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhDTHBX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Apr 2021 03:01:23 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49460 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhDTHBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 03:01:21 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13K70f862022777, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13K70f862022777
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 15:00:41 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 20 Apr 2021 15:00:40 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 20 Apr 2021 15:00:39 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74]) by
 RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74%5]) with mapi id
 15.01.2106.013; Tue, 20 Apr 2021 15:00:39 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 4/6] r8152: support new chips
Thread-Topic: [PATCH net-next 4/6] r8152: support new chips
Thread-Index: AQHXMpdaTtc3dnJiRE+pHF9mj571x6q3Ka6AgAXMWPA=
Date:   Tue, 20 Apr 2021 07:00:39 +0000
Message-ID: <0de9842749db4718b8f45a0f2fff7967@realtek.com>
References: <1394712342-15778-350-Taiwan-albertk@realtek.com>
        <1394712342-15778-354-Taiwan-albertk@realtek.com>
 <20210416145017.1946f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416145017.1946f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/4/19_=3F=3F_11:43:00?=
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/20/2021 02:53:45
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163215 [Apr 19 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/20/2021 02:57:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?us-ascii?Q?Clean,_bases:_2021/4/20_=3F=3F_04:46:00?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/20/2021 06:45:29
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163221 [Apr 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/20/2021 06:47:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, April 17, 2021 5:50 AM
> > +	switch (tp->version) {
> > +	case RTL_VER_10:
> > +		data = ocp_reg_read(tp, 0xad40);
> > +		data &= ~0x3ff;
> > +		data |= BIT(7) | BIT(2);
> > +		ocp_reg_write(tp, 0xad40, data);
> > +
> > +		data = ocp_reg_read(tp, 0xad4e);
> > +		data |= BIT(4);
> > +		ocp_reg_write(tp, 0xad4e, data);
> > +		data = ocp_reg_read(tp, 0xad16);
> > +		data &= ~0x3ff;
> > +		data |= 0x6;
> > +		ocp_reg_write(tp, 0xad16, data);
> > +		data = ocp_reg_read(tp, 0xad32);
> > +		data &= ~0x3f;
> > +		data |= 6;
> > +		ocp_reg_write(tp, 0xad32, data);
> > +		data = ocp_reg_read(tp, 0xac08);
> > +		data &= ~(BIT(12) | BIT(8));
> > +		ocp_reg_write(tp, 0xac08, data);
> > +		data = ocp_reg_read(tp, 0xac8a);
> > +		data |= BIT(12) | BIT(13) | BIT(14);
> > +		data &= ~BIT(15);
> > +		ocp_reg_write(tp, 0xac8a, data);
> > +		data = ocp_reg_read(tp, 0xad18);
> > +		data |= BIT(10);
> > +		ocp_reg_write(tp, 0xad18, data);
> > +		data = ocp_reg_read(tp, 0xad1a);
> > +		data |= 0x3ff;
> > +		ocp_reg_write(tp, 0xad1a, data);
> > +		data = ocp_reg_read(tp, 0xad1c);
> > +		data |= 0x3ff;
> > +		ocp_reg_write(tp, 0xad1c, data);
> > +
> > +		data = sram_read(tp, 0x80ea);
> > +		data &= ~0xff00;
> > +		data |= 0xc400;
> > +		sram_write(tp, 0x80ea, data);
> > +		data = sram_read(tp, 0x80eb);
> > +		data &= ~0x0700;
> > +		data |= 0x0300;
> > +		sram_write(tp, 0x80eb, data);
> > +		data = sram_read(tp, 0x80f8);
> > +		data &= ~0xff00;
> > +		data |= 0x1c00;
> > +		sram_write(tp, 0x80f8, data);
> > +		data = sram_read(tp, 0x80f1);
> > +		data &= ~0xff00;
> > +		data |= 0x3000;
> > +		sram_write(tp, 0x80f1, data);

These are the parameters of PHY.
Some are used for speed down about power saving.
And some are used for performance.

> > +	switch (tp->version) {
> > +	case RTL_VER_12:
> > +		ocp_reg_write(tp, 0xbf86, 0x9000);
> > +		data = ocp_reg_read(tp, 0xc402);
> > +		data |= BIT(10);
> > +		ocp_reg_write(tp, 0xc402, data);
> > +		data &= ~BIT(10);
> > +		ocp_reg_write(tp, 0xc402, data);
> > +		ocp_reg_write(tp, 0xbd86, 0x1010);
> > +		ocp_reg_write(tp, 0xbd88, 0x1010);
> > +		data = ocp_reg_read(tp, 0xbd4e);
> > +		data &= ~(BIT(10) | BIT(11));
> > +		data |= BIT(11);
> > +		ocp_reg_write(tp, 0xbd4e, data);
> > +		data = ocp_reg_read(tp, 0xbf46);
> > +		data &= ~0xf00;
> > +		data |= 0x700;
> > +		ocp_reg_write(tp, 0xbf46, data);

These are used to adjust the clock of GPHY.
It influences the linking.

> > +	data = r8153_phy_status(tp, 0);
> > +	switch (data) {
> > +	case PHY_STAT_EXT_INIT:
> > +		rtl8152_apply_firmware(tp, true);
> > +
> > +		data = ocp_reg_read(tp, 0xa466);
> > +		data &= ~BIT(0);
> > +		ocp_reg_write(tp, 0xa466, data);

These let the PHY exit PHY_STAT_EXT_INIT state.

> What are all these magic constants? :(

I think it is difficult for me to make all magic values meaningful.
The PHY setting is very complex. Only PHY engineers know
what are the settings mean.

> > @@ -6878,7 +8942,11 @@ static int rtl8152_probe(struct usb_interface
> *intf,
> >  	set_ethernet_addr(tp);
> >
> >  	usb_set_intfdata(intf, tp);
> > -	netif_napi_add(netdev, &tp->napi, r8152_poll, RTL8152_NAPI_WEIGHT);
> > +
> > +	if (tp->support_2500full)
> > +		netif_napi_add(netdev, &tp->napi, r8152_poll, 256);
> 
> why 256? We have 100G+ drivers all using 64 what's special here?
> 
> > +	else
> > +		netif_napi_add(netdev, &tp->napi, r8152_poll, 64);

We test 2.5G Ethernet on some embedded platform.
And we find 64 is not large enough, and the performance
couldn't reach 2.5 G bits/s.

Best Regards,
Hayes

