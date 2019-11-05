Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AB6EF721
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387791AbfKEIVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:21:32 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:38434 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387484AbfKEIVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:21:32 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4DDF6C08FC;
        Tue,  5 Nov 2019 08:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572942090; bh=zDK2LXlItrR+3Iquue1JBX7GBR/pzFOe8BcmTtgIYYE=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=SNuLE3ODZyxfCHYQaBx/2hOREN8AybXt783q0+XEhfl1SUgogeX4WfBzspax/15YI
         wfZJP1ZoSAxLkAeGqEThoh2lVcp2fC7PVOXLp0pW3giz/b/NSHRLlOC44CeRURS69P
         9m4c/Xm1LHsSssFgl5QxHhlRczq+pyN+NK6X3C+sy7UksBDgaljO72Kr41dDtxi/Nh
         L1IcxSNhIAN7lhHsKQFWbyGIu3BhigFPdNzP/5pjUI4Rzau1MEX8bd+UIDj3dgE9ri
         lvLE9cfjEcw29ImOi5FlKsN5SU7rafWDvywX8Yt77XF6ycBT0MphAeQ5c2ZkIeO5Jp
         Hjamhj9C0/Lgg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 11F68A006D;
        Tue,  5 Nov 2019 08:21:24 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 5 Nov 2019 00:21:18 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 5 Nov 2019 00:21:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGpFlisH02YsX4FDFYTVtI++qZhXo7hpsDfBbG2Ytjew3MzwPoVrPM1NX6Lbo8KFeqtWiw8uejCArsVaPw8cNJ2DC6MhlJv3c0oWd3tKP09wj7HiypPYMrDpJSYr8g1qeazSiMFkFMNNueJWa/1RsT+Al4PNo+IsI8hGeAPegHIh0QQMjhf+AOLFDfHkzPf7OJCTM7b/fwqhvuJQf9dwUdjS1RQWi/PYEbhNvjgiUTs7KAS2lF5nTNuHrQJrlKhMje2Invf9/5YTLMYMCnznDI4wQcthRZmWhH9wWLpQEfdKtg+RnJa0fUEC6p1oO5N3JDiPyk0+awKve9g9n57rhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDK2LXlItrR+3Iquue1JBX7GBR/pzFOe8BcmTtgIYYE=;
 b=Y0SPh4GdFWfytMyUxOng/2koFfPQr7kXeAGc5kk6J/8gY0QvtyMXfZv88p0UCI+fXjUhABZdS5TchDzggmXAbLs7MNgGvy5tk9H3IR9lgXhtyKPZFzzH7R4ll+L45HnkFIvzGC77qgeo8UlPHTyhJK+rJlLXW1etLkXhTgHb1bgXV7wpH5ngdDR+i/BGi2sCXD0lM5Y5kDzmsf+nPd61BeUwnDpsjrL67e6fWK9aqDLAlKerjQciDA2f5iTzebQ5biV7VRcICwJH7mEPF1O0aGMGMO+ckQQ2LaOxp/9EMTuMKcsypbWKQpUtL2l7nQpBgpoTPaWZuExQEFj3C1uM6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDK2LXlItrR+3Iquue1JBX7GBR/pzFOe8BcmTtgIYYE=;
 b=KJpsujssN+bQThbEJSzd8TCzlizacjqKsbpHUdyzSKBBbE5Sgvua+tVogM1czwn5idFlZjEwF0UF/6F93v1uykNrTeFFSyMpbSA29/PGnrW9vOWm37/SdbxwFuDlDv8znu2gTzo76D95Vz5yuJ4jIFx+Z9X03RAnD8ajKoxLbKg=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3249.namprd12.prod.outlook.com (20.179.66.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 08:21:16 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8%5]) with mapi id 15.20.2430.020; Tue, 5 Nov 2019
 08:21:16 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     syzbot <syzbot+d9536adc269404a984f8@syzkaller.appspotmail.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "arvid.brodin@alten.se" <arvid.brodin@alten.se>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jose.abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robin@protonic.nl" <robin@protonic.nl>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: RE: KASAN: use-after-free Read in j1939_session_get_by_addr
Thread-Topic: KASAN: use-after-free Read in j1939_session_get_by_addr
Thread-Index: AQHVk5CzJBI66yU4HEqovBXUIWZV2Kd8OFCAgAAERsA=
Date:   Tue, 5 Nov 2019 08:21:16 +0000
Message-ID: <BN8PR12MB3266A0CC1496ED5D532EA6D5D37E0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <0000000000009393ba059691c6a3@google.com>
 <0000000000009427b5059694e33c@google.com>
In-Reply-To: <0000000000009427b5059694e33c@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1621015d-6ca9-497a-0cb7-08d761c920cd
x-ms-traffictypediagnostic: BN8PR12MB3249:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB32495C820587CD6170E12669D37E0@BN8PR12MB3249.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(396003)(376002)(136003)(346002)(199004)(189003)(14444005)(186003)(81156014)(71200400001)(81166006)(256004)(2501003)(476003)(6506007)(5660300002)(4744005)(52536014)(6436002)(478600001)(66446008)(66556008)(66946007)(7696005)(64756008)(66476007)(26005)(99286004)(3846002)(66066001)(6246003)(33656002)(74316002)(8676002)(2201001)(316002)(71190400001)(25786009)(7736002)(76116006)(305945005)(6116002)(486006)(76176011)(229853002)(86362001)(7416002)(11346002)(110136005)(446003)(55016002)(9686003)(2906002)(8936002)(102836004)(14454004)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3249;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aeazp953cXzAWzWj7Sumh73E4XU2Skf0MzLstjPFYD0PHaFCjhTDiCfliJYLbLAyEmOif7w7meE+KzSTxPEt/M0OrkNxaLFqd+B0ubgbC8CaMuJGKGorKmmKxQmWraJsFBoACXuym9kRM+1vEWCCD3ZdqanfpcUjbBN+eLvdJ8ceJaMUY2equHgIZJWQBFdwBK/2sqvDbcGOGORoe3MI7cR0xfWLEpdXfvmfspfzkPeIMT17/GEUPlstEXNXoJOfvQgK6eNhsELaybLR+Otioau64n0UUA5+9eBFAWHB+Z55LP8ssf34KZCDuunJSBBrZejnVYYIalqSEBihHHtcVFq90l4Jfkiz4M1B+JbUrPcqLe28UUWMzUO9E/xgDZHXLKGIMdxeI/Amo+A0A3FsPWYIoxcpLdVQNMgDFaaXknFK6kmMSesJpuMkKjgU0FDa
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1621015d-6ca9-497a-0cb7-08d761c920cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 08:21:16.2394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4JL6gy0nTjFV+Dl1gF1/ClGjQeQjtr7W9L2yEmla5ugwletrqBUFkm2Wf7DgSSaUUsKq+4Qw0Ctq0EDFWyjjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3249
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogc3l6Ym90IDxzeXpib3QrZDk1MzZhZGMyNjk0MDRhOTg0ZjhAc3l6a2FsbGVyLmFwcHNw
b3RtYWlsLmNvbT4NCkRhdGU6IE5vdi8wNS8yMDE5LCAwODowNTowMSAoVVRDKzAwOjAwKQ0KDQo+
IHN5emJvdCBoYXMgYmlzZWN0ZWQgdGhpcyBidWcgdG86DQo+IA0KPiBjb21taXQgMmFmNjEwNmFl
OTQ5NjUxZDUyOWM4YzNmMDczNGMzYTdiYWJkMGQ0Yg0KPiBBdXRob3I6IEpvc2UgQWJyZXUgPEpv
c2UuQWJyZXVAc3lub3BzeXMuY29tPg0KPiBEYXRlOiAgIFR1ZSBKdWwgOSAwODowMzowMCAyMDE5
ICswMDAwDQo+IA0KPiAgICAgIG5ldDogc3RtbWFjOiBJbnRyb2R1Y2luZyBzdXBwb3J0IGZvciBQ
YWdlIFBvb2wNCg0KRnJvbSB0aGUgY29uZmlnIHByb3ZpZGVkLCBzdG1tYWMgZHJpdmVyIGlzIG5v
dCBldmVuIGVuYWJsZWQuIENhbiB5b3UgDQpwbGVhc2UgY29uZmlybSB0aGUgYmlzZWN0aW9uIHBy
b2Nlc3MgPw0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
