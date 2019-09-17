Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55781B4F1F
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfIQN06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:26:58 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:44056 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbfIQN06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 09:26:58 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A3AE6C0184;
        Tue, 17 Sep 2019 13:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568726817; bh=142bFDJdGWNOQy3klkp1LB+voOi/6BU903BHlZdq45A=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HUY9s4NutFwJXg7EsTq7bC+vxS5wg07oCNMHudsHvLTd9q7hfKL6jLh+At5lrLleB
         BwtH7qQWnEDSzsrOEiURByEGRrl5DB4jiANvMBlQHiFkBvRhtaZmsdIFndWHAAW/tR
         uIAogTeS4v1JHHno/MpWxhTE97t2u0i4lXYloBphBGoJOX253WQJxwEj8oD65sP4Pd
         MxxrVMXPkajzS5cQaxQc/p0G/OE+MT8Pt9sXP08Okx4IlEGuisAlTcps4l0VTimqDj
         Y7bLDCVEZCTQ71w7VaOhYuzG3nPocNTfTbvq67JGP+C9qVne2XuPCVVgGRstw1PxRa
         cdpubNUdaOJuA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id E92C7A005A;
        Tue, 17 Sep 2019 13:26:56 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 17 Sep 2019 06:26:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 17 Sep 2019 06:26:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDzWE63QjBQJ4SUJKZ0fiPyIKQEKhKXa+orvIthyIc8W3DPgL4mYXSyX8m6k3+5ll5GSReByYp0qxZSR2y5yVdlQspZMJNKqy2KEl4CYNUhFp0Z296iJT+txa1SMt0nzrPz/X7hVS+Wu683Svae3HJfpvAk0HUV5aFACxHGXwnRKJdTIW17qld4HIfciQIJ2qMw7vOJaLaVySGw2oM6bQzEaJQJrDlzCtOqkCR5q+y3EMFo5r73uHmWvQ1MRIqvS3XWocUnFQYbeXIsc300jvqrEFjlSXZODtSb8Byv0JNZZxJlZHY71JzKm33Qbc4P98VVjBJe7133h7vk2XhXeXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=142bFDJdGWNOQy3klkp1LB+voOi/6BU903BHlZdq45A=;
 b=a2xU58egGeH7bT1PJiltzGsy/UQyyAylF5jUZpKXMoy5YuVJJJYncl+wZgnPMXkhNeuKVUx8Pxpw46xUxQB+U8szP5uLzfoRnSS/oq1xW9N8NkjTeaERPcmETrIYJVXIHwE1X5BRFiSJUy4zBrzkWROOqUPjhL3qSBkZZa4NTJ+ZT6Ybx1ghSgEAZh81PBTdYy7nTEXpSAArWvYQ+kGmCZ8zY+tEZcbDWnZ9Q5BXxbY5sg+axgFHmfVvRWi+46F8efnGHbqY6aEuQB0P665HvzQt2m503hLycsEL/Qd9sNaLKX5nMGxN5qyVvtle4Rvf0E3TEeNEJOfeqTiQmBBXUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=142bFDJdGWNOQy3klkp1LB+voOi/6BU903BHlZdq45A=;
 b=IMipaQwUaxok5ZHZxj8encgtfMJRmsdSBacZaAJ1q8ccEHS+Wb5IPNCx64SRrJ9E7fO4LrSBdgJqKLycCBUMs2JAYAo7KevKZbARleHVsScD8YbtaQarZN8Ec7Z0qPg5UYY8m/pe18rfFXi0ePOQOg7IUH/N59057FdH2Vncavk=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2866.namprd12.prod.outlook.com (20.179.66.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Tue, 17 Sep 2019 13:26:50 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 13:26:50 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Jose Abreu' <Jose.Abreu@synopsys.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        David Bolvansky <david.bolvansky@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: -Wsizeof-array-div warnings in ethernet drivers
Thread-Topic: -Wsizeof-array-div warnings in ethernet drivers
Thread-Index: AQHVbSoo2sCm+b6KbUmq34Z8Q4HTw6cvgEiggAAsi+CAAC4H0A==
Date:   Tue, 17 Sep 2019 13:26:50 +0000
Message-ID: <BN8PR12MB32662378E844E6ECBA3FE8D7D38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190917073232.GA14291@archlinux-threadripper>
 <BN8PR12MB3266AFAFF3FAAA9C10FB1C1FD38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <510d777024554eab846ef93d05998b63@AcuMS.aculab.com>
In-Reply-To: <510d777024554eab846ef93d05998b63@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 127b7785-a6f3-4a39-6adb-08d73b72b2b4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB2866;
x-ms-traffictypediagnostic: BN8PR12MB2866:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB28664D6C18B11BFD81EA8862D38F0@BN8PR12MB2866.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(366004)(136003)(53754006)(199004)(189003)(4326008)(76116006)(74316002)(6246003)(5660300002)(102836004)(14444005)(71200400001)(8936002)(6116002)(71190400001)(25786009)(256004)(7736002)(66066001)(316002)(6506007)(99286004)(305945005)(3846002)(26005)(186003)(54906003)(110136005)(55016002)(486006)(2906002)(7696005)(66946007)(52536014)(66476007)(66556008)(64756008)(6436002)(476003)(14454004)(33656002)(9686003)(66446008)(478600001)(81166006)(86362001)(229853002)(446003)(8676002)(7416002)(76176011)(81156014)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2866;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UcdkuzizdeQ+kwVXRB4KMXM+eumhSSLHXEdj9H82UTUiuYfT1jDkgauF/UQF7Qj0nvPWb0NizWyxiSZEwJa5/MFC3p41zgJAp9mYLV3NnV1yNvg4hUt36lBlc1gKgsIEm3kM/dUe7/bF5NRu0eB1YMG8oBPT5FLlucnriDa76xhJxY9gxhj2wOHJ3CARXMrgrA/BZ5dk56Uv3cd45l5/9iP6UfFxl7DxEMj0XD58P3OBIP1c701gz5YZs3L3WNn8z75SZRxmqyRPaCWb1THvY2qG2iLTAoZveGDOC/YbRW8vfAWqFzXAR/7ewX0XKhP5XVff17JB5pxB8hm6LbUrV8PjDcMJoIULXDUeKbpI1Lc8wH9FYFMB7+6ijK4fGGmjdLmScy0sCx0zgWc59Fwhs/cVHzjIH2Cmrjc6AYXAvNc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 127b7785-a6f3-4a39-6adb-08d73b72b2b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 13:26:50.4974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E5RrQKBg7ZKPWhMqwr5NoHGIyaFHniwmxNmRd8VcTAUef2AfuTNgA4Jn+TVdj8E1+KWEjM7EHdcrzRc3+38wzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2866
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTT4NCkRhdGU6IFNlcC8x
Ny8yMDE5LCAxMTozNjoyMSAoVVRDKzAwOjAwKQ0KDQo+IEZyb206IEpvc2UgQWJyZXUNCj4gPiBT
ZW50OiAxNyBTZXB0ZW1iZXIgMjAxOSAwODo1OQ0KPiA+IEZyb206IE5hdGhhbiBDaGFuY2VsbG9y
IDxuYXRlY2hhbmNlbGxvckBnbWFpbC5jb20+DQo+ID4gRGF0ZTogU2VwLzE3LzIwMTksIDA4OjMy
OjMyIChVVEMrMDA6MDApDQo+ID4gDQo+ID4gPiBIaSBhbGwsDQo+ID4gPg0KPiA+ID4gQ2xhbmcg
cmVjZW50bHkgYWRkZWQgYSBuZXcgZGlhZ25vc3RpYyBpbiByMzcxNjA1LCAtV3NpemVvZi1hcnJh
eS1kaXYsDQo+ID4gPiB0aGF0IHRyaWVzIHRvIHdhcm4gd2hlbiBzaXplb2YoWCkgLyBzaXplb2Yo
WSkgZG9lcyBub3QgY29tcHV0ZSB0aGUNCj4gPiA+IG51bWJlciBvZiBlbGVtZW50cyBpbiBhbiBh
cnJheSBYIChpLmUuLCBzaXplb2YoWSkgaXMgd3JvbmcpLiBTZWUgdGhhdA0KPiA+ID4gY29tbWl0
IGZvciBtb3JlIGRldGFpbHM6DQo+IC4uLg0KPiA+ID4gLi4vZHJpdmVycy9uZXQvZXRoZXJuZXQv
YW1kL3hnYmUveGdiZS1kZXYuYzozNjE6NDk6IHdhcm5pbmc6IGV4cHJlc3Npb24NCj4gPiA+IGRv
ZXMgbm90IGNvbXB1dGUgdGhlIG51bWJlciBvZiBlbGVtZW50cyBpbiB0aGlzIGFycmF5OyBlbGVt
ZW50IHR5cGUgaXMNCj4gPiA+ICd1OCcgKGFrYSAndW5zaWduZWQgY2hhcicpLCBub3QgJ3UzMicg
KGFrYSAndW5zaWduZWQgaW50JykNCj4gPiA+IFstV3NpemVvZi1hcnJheS1kaXZdDQo+ID4gPiAg
ICAgICAgIHVuc2lnbmVkIGludCBrZXlfcmVncyA9IHNpemVvZihwZGF0YS0+cnNzX2tleSkgLyBz
aXplb2YodTMyKTsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IH5+fn5+fn5+fn5+fn5+ICBeDQo+IC4uLg0KPiA+ID4gV2hhdCBpcyB0aGUgcmVhc29uaW5nIGJl
aGluZCBoYXZpbmcgdGhlIGtleSBiZWluZyBhbiBhcnJheSBvZiB1OHMgYnV0DQo+ID4gPiBzZWVt
bGluZ2x5IGNvbnZlcnRpbmcgaXQgaW50byBhbiBhcnJheSBvZiB1MzJzPyBJdCdzIG5vdCBpbW1l
ZGlhdGVseQ0KPiA+ID4gYXBwYXJlbnQgZnJvbSByZWFkaW5nIG92ZXIgdGhlIGNvZGUgYnV0IEkg
YW0gbm90IGZhbWlsaWFyIHdpdGggaXQgc28gSQ0KPiA+ID4gbWlnaHQgYmUgbWFraW5nIGEgbWlz
dGFrZS4gSSBhc3N1bWUgdGhpcyBpcyBpbnRlbnRpb25hbD8gSWYgc28sIHRoZQ0KPiA+ID4gd2Fy
bmluZyBjYW4gYmUgc2lsZW5jZWQgYW5kIHdlJ2xsIHNlbmQgcGF0Y2hlcyB0byBkbyBzbyBidXQg
d2Ugd2FudCB0bw0KPiA+ID4gbWFrZSBzdXJlIHdlIGFyZW4ndCBhY3R1YWxseSBwYXBlcmluZyBv
dmVyIGEgbWlzdGFrZS4NCj4gPiANCj4gPiBUaGlzIGlzIGJlY2F1c2Ugd2Ugd3JpdGUgMzIgYml0
cyBhdCBhIHRpbWUgdG8gdGhlIHJlZyBidXQgaW50ZXJuYWxseSB0aGUNCj4gPiBkcml2ZXIgdXNl
cyA4IGJpdHMgdG8gc3RvcmUgdGhlIGFycmF5LiBJZiB5b3UgbG9vayBhdA0KPiA+IGR3eGdtYWMy
X3Jzc19jb25maWd1cmUoKSB5b3UnbGwgc2VlIHRoYXQgY2ZnLT5rZXkgaXMgY2FzdGVkIHRvIHUz
MiB3aGljaA0KPiA+IGlzIHRoZSB2YWx1ZSB3ZSB1c2UgaW4gSFcgd3JpdGVzLiBUaGVuIHRoZSBm
b3IgbG9vcCBqdXN0IGRvZXMgdGhlIG1hdGgNCj4gPiB0byBjaGVjayBob3cgbWFueSB1MzIncyBo
YXMgdG8gd3JpdGUuDQo+IA0KPiBUaGF0IHN0aW5rcyBvZiBhIHBvc3NpYmxlIG1pc2FsaWduZWQg
ZGF0YSBhY2Nlc3MuLi4uLg0KDQpJdCdzIHBvc3NpYmxlIHRvIGhhcHBlbiBvbmx5IGlmIHN0cnVj
dHVyZSBmaWVsZCBpcyBub3QgYWxpZ25lZC4gSSBndWVzcyANCkkgY2FuIGVpdGhlciBjaGFuZ2Ug
YWxsIHRvIHUzMiBvciBqdXN0IF9fYWxpZ24gdGhlIGZpZWxkIG9mIHRoZSBzdHJ1Y3QgDQouLi4N
Cg0KLS0tDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCBBYnJldQ0K
