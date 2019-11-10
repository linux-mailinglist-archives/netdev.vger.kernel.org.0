Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A78F6958
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKJOMD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 10 Nov 2019 09:12:03 -0500
Received: from mail-oln040092254042.outbound.protection.outlook.com ([40.92.254.42]:54878
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfKJOMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 09:12:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCwE8c1gbHTjuhmvD1VHMf9J96PlW4mBGwA5UotQqp+fkLs+ekQs/AJ/E+fNNd/M+dvRJpD9a0qkWJr4QOqN7LEHLSSVF3TBTrAvzoHy7kps6twDfU5hyamPhaMpTuFrB5Bq+ePrWpACc1ZXU/1es+OJM6p+Yl7aFgV0YG0cJD2bckn2PE1Yxvs2RGQFxdoemj0zSqATGoBXm7MrmPAQ7ULItnm8UgUOrMkjAqwWcM1p1D0VObJ9V96yjOqFucEPGWHErCBo/Nyl+UhbRRYQuxn8WUxVjPGSCMpKsJxX7xs3o1rKB41EK0rOYosTLGEKn+QZvs9LifmqhjBrxCKVtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkI36TAke4nE/5+MWGt/ueIKRMwHwE1gaAtdUV+vPBw=;
 b=HPINdMi+DYgK8mYKkqug2nOK/RZurFqJr+33j7d0F+dhWIpfz82+1aommQndhxxehBUk3iAX8EyT77vpEKjxbNOcq92GGdmJdzQHVAGKKSx64ycVQdbTjbw/L7v3MZ3C5GGicdlXW5LCQzzur1lI+cNSxuUqoyLoy6bPn0Mq7+zP2Ym4FLyts+aUGS63E9hM1zFG8oJzTbZr/gK+mAcSZ/xoHD3YyqnhzDyoe2ZO9m9wCpUItgOXflUPioIseLdrpfy3aPiZOA3BxKsRcbAuBKQqM8e8QCpuk4Kg1rGiBFibImn/Nbkxqs4wSqVkm7nHoIPE8Wod37ZDTKSGJ4EtyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from PU1APC01FT064.eop-APC01.prod.protection.outlook.com
 (10.152.252.54) by PU1APC01HT172.eop-APC01.prod.protection.outlook.com
 (10.152.253.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2430.22; Sun, 10 Nov
 2019 14:10:17 +0000
Received: from PS2P216MB0755.KORP216.PROD.OUTLOOK.COM (10.152.252.56) by
 PU1APC01FT064.mail.protection.outlook.com (10.152.253.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22 via Frontend Transport; Sun, 10 Nov 2019 14:10:17 +0000
Received: from PS2P216MB0755.KORP216.PROD.OUTLOOK.COM
 ([fe80::44f5:f4bb:1601:2602]) by PS2P216MB0755.KORP216.PROD.OUTLOOK.COM
 ([fe80::44f5:f4bb:1601:2602%9]) with mapi id 15.20.2430.023; Sun, 10 Nov 2019
 14:10:17 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Possibility of me mainlining Tehuti Networks 10GbE driver
Thread-Topic: Possibility of me mainlining Tehuti Networks 10GbE driver
Thread-Index: AQHVlduusrLCB8qbpUuakWm6pLXSWqeAqBUAgAPNUAA=
Date:   Sun, 10 Nov 2019 14:10:16 +0000
Message-ID: <PS2P216MB0755A999533207D9E687F61780750@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
References: <PS2P216MB0755843A57F285E4EE452EE5807B0@PS2P216MB0755.KORP216.PROD.OUTLOOK.COM>
 <6fc9c7ef-0f6c-01e0-132b-74a80711788e@gmail.com>
In-Reply-To: <6fc9c7ef-0f6c-01e0-132b-74a80711788e@gmail.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SYYP282CA0002.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::12) To PS2P216MB0755.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:1c::13)
x-incomingtopheadermarker: OriginalChecksum:A1BA89E1520E866C796FAF937C712EEC25AEE12ABFDE2D32373E6989E9977982;UpperCasedChecksum:9C2CF4C6A91C3B552F7B0B7A19C5150056ACE05D1EA1B08E83A6099E6A770D5F;SizeAsReceived:7596;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [qFtxrHEPPIc04BEWNAIJpivv1MRYHifjjxMNLvNgtoVe4yaPtxRTZMluWxi/OvMpOxu5SC6vasQ=]
x-microsoft-original-message-id: <20191110141008.GA1404@nicholas-dell-linux>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 8d31b90c-ca80-44be-fe22-08d765e7b5ac
x-ms-traffictypediagnostic: PU1APC01HT172:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4HHWYWI4HgrGqb6vhqJblD8Vn/mNLIsADhYjDMNKGvrkI3MHNb1R4ZlWmMs0ghqcTNpvRd6hGOs2Q3RzlWMguVpdmyD+wKQOLOCFigv/rgXpB6hzGkdAXrdVxabYpr1FIqEFvGDHNIT+yf/nzC+m8DLdEr+boupsHDijZQH4RcABf5fOschbshTOO5JnBX5p
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08F64B2109815C4295C230028098087B@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d31b90c-ca80-44be-fe22-08d765e7b5ac
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2019 14:10:16.9772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1APC01HT172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 08:06:30PM -0800, Florian Fainelli wrote:
> Hi,
> 
> On 11/7/2019 6:24 PM, Nicholas Johnson wrote:
> > Hi all,
> > 
> > To start off, if I am emailing the wrong people, please blame the output 
> > of: "scripts/get_maintainer.pl drivers/net/ethernet/tehuti/" and let me 
> > know who I should be contacting. Should I add in 
> > "linux-kernel@vger.kernel.org"?
> > 
> > I just discovered that the Tehuti 10GbE networking drivers (required for 
> > things such as some AKiTiO Thunderbolt to 10GbE adapters) are not in 
> > mainline. I am interested in mainlining it, but need to know how much 
> > work it would take and if it will force me to be the maintainer for all 
> > eternity.
> > 
> > The driver, in tn40xx-0.3.6.15-c.tar appears to be available here:
> > Link: https://www.akitio.com/faq/341-thunder3-10gbe-adapter-can-i-use-this-network-adapter-on-linux
> > Also here:
> > Link: https://github.com/acooks/tn40xx-driver
> > 
> > I see some immediate style problems and indentation issues. I can fix 
> > these.
> > 
> > The current driver only works with Linux v4.19, I believe. There are a 
> > small handful of compile errors with v5.4. I can probably fix these.
> > 
> > However, could somebody please comment on any technical issues that you 
> > can see here? How much work do you think I would have to do to mainline 
> > this? Would I have to buy such a device for testing? Would I have to buy 
> > *all* of the supported devices for testing? Or can other people do that 
> > for me?
> 
> This is based on roughly 5 minutes of browsing source files, but what I
> see, which is typical from out of tree vendor drivers is a complete lack
> of use of existing kernel APIs beyond registering a net_device which you
> would have to use to seek upstream inclusion, that includes for the most
> part:
> 
> - make use of the PHYLINK subsystem for supporting 10GBaseT and SFP
> modules instead of doing your own, there might be existing PHY drivers
> that you can use for the Aquantia and Marvell parts, see
> drivers/net/phy/ to check whether the PHY models are indeed supported
> 
> - implement a proper mii_bus interface for "talking" to the PHYs,
> implement a proper gpio_chip instance to register with Linux as a GPIO
> controller, such that then you can use i2c-gpio to become an i2c bus
> master driver, and then talk to the SFPs properly
> 
> - lots and lots of stylistic issues that must be fixed
> 
> - getting rid of private driver ioctl implementation
> 
> There are certainly many more details once we start digging of course.
> 
> > 
> > I am not keen on having to buy anything without mainline support - it is 
> > an instant disqualification of a hardware vendor. It results in a 
> > terrible user experience for experienced people (might not be able to 
> > use latest kernel which is needed for supporting other things) and is 
> > debilitating for people new to Linux who do not how to use the terminal, 
> > possibly enough so that they will go back to Windows.
> 
> Seems like a reasonable position to me, the grey area is when there is a
> Linux driver, but its quality is not making it upstream available, then
> you find yourself emailing netdev about that very situation :)
To clarify, I do not own the device, but I realised that the driver 
needs mainlining and this could be good experience.

> 
> > 
> > Andy, what is your relationship to Tehuti Networks? Would you be happy 
> > to maintain this if I mainlined it? It says you are maintainer of 
> > drivers/net/ethernet/tehuti/ directory. I will not do this if I am 
> > expected to maintain it - in no small part because I do not know a lot 
> > about it. I will only be modifying what is currently available to make 
> > it acceptable for mainline, if possible.
> 
> Given how the driver is broken up, you can do a couple of strategies:
> 
> - try to submit it all as-is (almost) under drivers/staging/ where it
> may get contributions from people to clean it up to the kernel coding
> style, using coccinelle semantic patch and pretty much anything that can
> be done by inspecting code visually while not really testing it. This
> might make the driver stay in staging for a long time, but if there are
> in-kernel API changes, they will be done and so it will continue to
> build and maybe even work, for any version of Linux in which it got
> included and onward. The problem with that approach is that it will
> likely stay in limbo unless a dedicated set of people start working
> towards moving it out of staging.
> 
> - rewrite it in smaller parts and submit it in small chunks, with basic
> functionality one step at a time, e.g.: driver skeleton/entry point as a
> pci_device/driver, then net_device registration without anything, then
> RX path, then TX path, then control path, then ethtool interface, etc.
> etc. Given the shape of the driver, but not knowing how familiar you are
> with the driver or the kernel, a 3 man/month work for someone motivated
> is probably an optimistic estimate of the work you have ahead of you,
> 6m/m sounds more realistic. There is also an expectation that you will
> be maintaining this driver for a few months (maybe years) to come, and
> network drivers tend to always have something that needs to be fixed, so
> it is a nice side gig, but it could be time consuming.
Okay, that is a lot. Perhaps this is unwise.

One strategy could be to hollow out a mainline driver and use its 
structure?

> 
> > 
> > Also, license issues - does GPLv2 permit mainlining to happen? I believe 
> > the Tehuti driver is available under GPLv2 (correct me if I am wrong).
> 
> The source code on the github tree suggests this is the case, therefore
> it is entirely appropriate to seek upstream inclusion given the license
> allows it.
> 
> What needs to be figured out is the PHY firmware situation which appears
> to be completed punted onto the user to figure out which files (and
> where to download), how to extract the relevant firmware blobs (there
> are scripts, okay). If you have a contact with one of the vendors
> supported by the driver, or better yet, with Tehuti, that may be
> something they could help with. A mainline driver with proprietary
> firmware blobs is not uncommon, but having to get the blobs outside of
> linux-firmware is a real pain for distributions and some might even
> refuse to build your driver because of that.
Could I please have more information / reading resources on the PHY 
business? My understanding is that the NIC firmware would be dealing 
with the PHY (this is the MII, right?) and the OS would have nothing to 
do with it (it just sees a NIC which processes packets). But it seems 
like this is not the case. Can you please clarify this? One guess is 
that the NIC firmware handles most of it, but the OS is able to detect 
and display info on the PHY to userspace. Incorrect?

Above you mentioned mii_bus for PHYs, but a driver like Aquantia 
Atlantic does not have references to PHYs or MII. Why do some not need 
the feature when others do?

> 
> > 
> > Would I need to send patches for this, or for something this size, is it 
> > better to send a pull request? If I am going to do patches, I will need 
> > to make a gmail account or something, as Outlook messes with the 
> > encoding of the things which I send.
> 
> For sending patches, you would want to use git send-email to make sure
> you avoid MUA issues.
> 
> > 
> > Thanks for any comments on this.
> 
> Hope all of this helps. Cheers
Thanks, it does answer a lot of questions.

> -- 
> Florian

Would it make it easier to buy a single Tehuti NIC and try to make a 
driver just for that model? Or does each additional model generally not 
add much more work?

I would dive into this and see how far I can get, but I have to make an 
investment in an expensive piece of hardware I do not particularly want.

Given my inexperience, it is unlikely to succeed, and then I have a 
device laying around without mainline support, making it difficult to 
use.

Perhaps a better tree to be barking up is "what do I need to do to get 
to the point where I could do something like this?" Can you suggest 
smaller pieces of work which are not trivial / harder than code cleanup 
to start building experience?

Thanks!

Regards,
Nicholas.
