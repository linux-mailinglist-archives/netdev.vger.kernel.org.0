Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C274AD212
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 08:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348011AbiBHHSb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Feb 2022 02:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347170AbiBHHSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 02:18:23 -0500
X-Greylist: delayed 140 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 23:18:21 PST
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0245C0401F5;
        Mon,  7 Feb 2022 23:18:21 -0800 (PST)
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 2187F78w8002212, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 2187F78w8002212
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 8 Feb 2022 15:15:07 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Feb 2022 15:15:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 15:15:06 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Tue, 8 Feb 2022 15:15:06 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Henning Schild <henning.schild@siemens.com>
CC:     Aaron Ma <aaron.ma@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: RE: [PATCH v3] net: usb: r8152: Add MAC passthrough support for RTL8153BL
Thread-Topic: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Thread-Index: AQHYFAANjLdOSvtCR0KlGk2k9pQgE6x3kd2AgACjlICAAAm2AIARBXOA
Date:   Tue, 8 Feb 2022 07:15:06 +0000
Message-ID: <780d5453fbd24f61bb10f6e8f0acbda1@realtek.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
 <20220128043207.14599-1-aaron.ma@canonical.com>
 <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
 <YfQwpy1Kkz3wheTi@lunn.ch>
 <BL1PR12MB515773B15441F5BC375E452DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
In-Reply-To: <BL1PR12MB515773B15441F5BC375E452DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/2/8_=3F=3F_02:24:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Limonciello, Mario <Mario.Limonciello@amd.com>
> Sent: Saturday, January 29, 2022 2:41 AM
[...]
> > I've not yet been convinced by replies that the proposed code really
> > does only match the given dock, and not random USB dongles.
> 
> Didn't Realtek confirm this bit is used to identify the Lenovo devices?

Excuse me. Last week is our vacation of Chinese New Year.
Realtek confirms that bit is used to identify the Lenovo devices.
We use different bits for specific customers.
For RTL8153B, bit 0 and 2 of USB OCP 0xD81F are for Dell. Bit 3 is for Lenovo.
However, Realtek couldn't answer if the Lenovo devices are used on docks only.

Best Regards,
Hayes

> > To be
> > convinced i would probably like to see code which positively
> > identifies the dock, and that the USB device is on the correct port of
> > the USB hub within the dock. I doubt you can actually do that in a
> > sane way inside an Ethernet driver. As you say, it will likely lead to
> > unmaintainable spaghetti-code.
> >
> > I also don't really think the vendor would be keen on adding code
> > which they know will get reverted as soon as it is shown to cause a
> > regression.
> >
> > So i would prefer to NACK this, and push it to udev rules where you
> > have a complete picture of the hardware and really can identify with
> > 100% certainty it really is the docks NIC.
> 
> I remember when I did the Dell implementation I tried userspace first.
> 
> Pushing this out to udev has a few other implications I remember hitting:
> 1) You need to also get the value you're supposed to use from ACPI BIOS
>      exported some way in userland too.
> 2) You can run into race conditions with other device or MAC renaming rules.
>     My first try I did it with NM and hit that continually.  So you would
> probably
>     need to land this in systemd or so.
> 
> >
> >    Andrew------Please consider the environment before printing this e-mail.
