Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E6D6FEDB
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfGVLj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:39:29 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33534 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728969AbfGVLj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:39:29 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C44B6C0BDF;
        Mon, 22 Jul 2019 11:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563795568; bh=W7SXDkD3rVsP29mxuGi2n9CEjS9lOEaPxhpAZxD2fmU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=TOiqW11flpmZRVv3bJF6VmjeqqREM/F+Y/JwkFHYgwfUsPnRf+hcuS6sMpnzO3dE2
         Tt4MP+NGu6R7U4fl0bNp/+Ld69m/2K4hbEbdJOrU4vFurZGrMrHpnEj/LOv1vTFaxE
         Xyhe+kyLMhPHHjU7P2o6+tCCoxXwpZ2PBfmUR2Af1k/yhC3AIcXyG42Oqe0HfB+TFg
         VWfghg+MFVfomuu8tzTzzeQMQgKO/PjPp80xpcH85RGyLakZmMNDftkYbO2j5UR0sP
         4PFTsHn8iL9jDRYAB0pn9pj69a6V6jlg9MAxiogd1H/zmFy/bjdBIgU7zOd36tWxRV
         sl7UVgFgOtQLQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 76FA1A00AE;
        Mon, 22 Jul 2019 11:39:25 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 22 Jul 2019 04:39:24 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Jul 2019 04:39:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZmUUwwRs34GdXq7AWG2ugbEWfniaAM+xVLsnbbgujBCXeovtw6OQnb5Kzt6xIqMxJYFkcOsS6M7JB8eXaXC6VCg6i1zktAbfya+cF83jsJH20MWkjNOW3Rmv51Wau93ut0NUNTVFTIKlH5+gbZoxFTk4hJ9zxCVXfoeXPi2T0/K9Ljkp9fRJZZkdMFHsx7fqnvG4wwW8MCWG7/hMRkK5x5lJOLHYmEd9swnquYIDbIVkMub7GTbpMizKV0c0SK2FUffmcydgqH55bkkRHwOMNp5bdeh3esFk60bzQCtCLwzCTr5RC0M54+EqW4QFyqXHu17eJLqoqdgVMOJJqJV3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6iMCAORZMFD0YaMo69QkaFq1D00XGCGblJXMUF9Wrc=;
 b=W78mqQhFOStng03/NbsdzzlWYF2MOLlnDWj5VibQfHpyKnOvn0tiwqTZKXZIEpOt9Zde6+D4JClRX7iOMEbyQW/8QWNt8ssH2Uk/r9eHIEELAyr/UjYsfZ0bEwKFnrRCPs9A6WCmfWWhUvP4CKip3TH0NPyiS3gRzYMoEIL3EeDzHr7B7o4BA78Ksv96Qf7Ej5TByQ70gVe7plKcoe8Rj3P2UbBd6w7t4kahHZ0I31IWa3FSP/kIa5+qdZW2IzvsYpvJnCdn/wGUU4QyZ6tWrDbkLL4ahsICR6rJgW2bkG4ZaaRjBwbCrM5fFATVESwLk7dbakAkYPEqMrfbOHbztQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6iMCAORZMFD0YaMo69QkaFq1D00XGCGblJXMUF9Wrc=;
 b=juOvjpnSqhWg6Us6wIqfL8Kzg8dFYU7JvxS0jVl1BeDvPwrfvqoiqrCyAbzGjmst02kfxw0NwZQJHr7K6p/leLh2NtuI2ENa/1EEj9dv+zNJ17ACeelgt9KgDt8AhxPw4iO/0SVTqO8ZkxTRizBfQcekH9NHeHjEg1cx7pay3bo=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3524.namprd12.prod.outlook.com (20.179.66.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 11:39:22 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 11:39:22 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Lars Persson <lists@bofh.nu>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>
CC:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOA=
Date:   Mon, 22 Jul 2019 11:39:21 +0000
Message-ID: <BN8PR12MB326661846D53AAEE315A7434D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722101830.GA24948@apalos>
 <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
In-Reply-To: <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd259319-63ac-43cd-4e9a-08d70e993d82
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:BN8PR12MB3524;
x-ms-traffictypediagnostic: BN8PR12MB3524:
x-microsoft-antispam-prvs: <BN8PR12MB352429FF0625FF58B3A40D5AD3C40@BN8PR12MB3524.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(39860400002)(366004)(346002)(136003)(199004)(189003)(478600001)(7696005)(66066001)(446003)(476003)(102836004)(6436002)(66616009)(66446008)(64756008)(66556008)(76176011)(66946007)(66476007)(76116006)(316002)(86362001)(52536014)(110136005)(54906003)(55016002)(26005)(11346002)(186003)(3846002)(6116002)(25786009)(2906002)(81156014)(81166006)(8936002)(71190400001)(71200400001)(229853002)(256004)(7736002)(9686003)(99936001)(8676002)(14454004)(5024004)(68736007)(53936002)(53546011)(6506007)(486006)(7416002)(33656002)(5660300002)(305945005)(4326008)(6246003)(74316002)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3524;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: khoE1cFfBn58f3DJ+iDniBy9wlijsZkzQ87AY35BW0jG8YqjkziCHb3qgepLns/Ax3EomXZlSmasUnM2vIsN8BZUjvsH9OuwMkAG0MvYMHot8vZNy5ytOfxykE7SbW0lQhBaWiXKHgeYboH+6+xBrsLYlgZXwjW9arwxqQgyL4mF3FIuWDFmauVGLtmarEJwjANhnGn3zwOerp1OFQ4hjw4+KAUnuGiPFNa1Mj7kMTw4ai+9HQfi86rS8fPpQPG5EHie4tCJQ0OsYKlyxT/yEs3Lf4V082DrfG6xUrcM68U7gaAgy/j1is/SPo5Q7pX/o3peOP21Pob8H4sXyOye3KqVf/DufYXuu1NYTIKm83Zys6esTBvxPhDT+X+6+YVYOA/0FDMhBz180+KGbrwOas/NP0Pqln4Jw377qLyZ2Og=
Content-Type: multipart/mixed;
        boundary="_002_BN8PR12MB326661846D53AAEE315A7434D3C40BN8PR12MB3266namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fd259319-63ac-43cd-4e9a-08d70e993d82
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 11:39:21.9720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3524
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_BN8PR12MB326661846D53AAEE315A7434D3C40BN8PR12MB3266namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogTGFycyBQZXJzc29uIDxsaXN0c0Bib2ZoLm51Pg0KRGF0ZTogSnVsLzIyLzIwMTksIDEy
OjExOjUwIChVVEMrMDA6MDApDQoNCj4gT24gTW9uLCBKdWwgMjIsIDIwMTkgYXQgMTI6MTggUE0g
SWxpYXMgQXBhbG9kaW1hcw0KPiA8aWxpYXMuYXBhbG9kaW1hc0BsaW5hcm8ub3JnPiB3cm90ZToN
Cj4gPg0KPiA+IE9uIFRodSwgSnVsIDE4LCAyMDE5IGF0IDA3OjQ4OjA0QU0gKzAwMDAsIEpvc2Ug
QWJyZXUgd3JvdGU6DQo+ID4gPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNv
bT4NCj4gPiA+IERhdGU6IEp1bC8xNy8yMDE5LCAxOTo1ODo1MyAoVVRDKzAwOjAwKQ0KPiA+ID4N
Cj4gPiA+ID4gTGV0IG1lIGtub3cgaWYgeW91IGhhdmUgYW55IHRob3VnaHRzLg0KPiA+ID4NCj4g
PiA+IENhbiB5b3UgdHJ5IGF0dGFjaGVkIHBhdGNoID8NCj4gPiA+DQo+ID4NCj4gPiBUaGUgbG9n
IHNheXMgIHNvbWVvbmUgY2FsbHMgcGFuaWMoKSByaWdodD8NCj4gPiBDYW4gd2UgdHJ5ZSBhbmQg
ZmlndXJlIHdlcmUgdGhhdCBoYXBwZW5zIGR1cmluZyB0aGUgc3RtbWFjIGluaXQgcGhhc2U/DQo+
ID4NCj4gDQo+IFRoZSByZWFzb24gZm9yIHRoZSBwYW5pYyBpcyBoaWRkZW4gaW4gdGhpcyBvbmUg
bGluZSBvZiB0aGUga2VybmVsIGxvZ3M6DQo+IEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBB
dHRlbXB0ZWQgdG8ga2lsbCBpbml0ISBleGl0Y29kZT0weDAwMDAwMDBiDQo+IA0KPiBUaGUgaW5p
dCBwcm9jZXNzIGlzIGtpbGxlZCBieSBTSUdTRUdWIChzaWduYWwgMTEgPSAweGIpLg0KPiANCj4g
SSB3b3VsZCBzdWdnZXN0IHlvdSBsb29rIGZvciBkYXRhIGNvcnJ1cHRpb24gYnVncyBpbiB0aGUg
UlggcGF0aC4gSWYNCj4gdGhlIGNvZGUgaXMgZmV0Y2hlZCBmcm9tIHRoZSBORlMgbW91bnQgdGhl
biBhIGNvcnJ1cHQgUlggYnVmZmVyIGNhbg0KPiB0cmlnZ2VyIGEgY3Jhc2ggaW4gdXNlcnNwYWNl
Lg0KPiANCj4gL0xhcnMNCg0KDQpKb24sIEknbSBub3QgZmFtaWxpYXIgd2l0aCBBUk0uIEFyZSB0
aGUgYnVmZmVyIGFkZHJlc3NlcyBiZWluZyBhbGxvY2F0ZWQgDQppbiBhIGNvaGVyZW50IHJlZ2lv
biA/IENhbiB5b3UgdHJ5IGF0dGFjaGVkIHBhdGNoIHdoaWNoIGFkZHMgZnVsbCBtZW1vcnkgDQpi
YXJyaWVyIGJlZm9yZSB0aGUgc3luYyA/DQoNCi0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJy
ZXUNCg==

--_002_BN8PR12MB326661846D53AAEE315A7434D3C40BN8PR12MB3266namp_
Content-Type: application/octet-stream;
	name="0001-net-stmmac-Add-memory-barrier.patch"
Content-Description: 0001-net-stmmac-Add-memory-barrier.patch
Content-Disposition: attachment;
	filename="0001-net-stmmac-Add-memory-barrier.patch"; size=1397;
	creation-date="Mon, 22 Jul 2019 11:38:06 GMT";
	modification-date="Mon, 22 Jul 2019 11:38:06 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxZmU0OTY0ZTgzMmUzMmUyYzU3MDZhMGVkMTc0YzlmOGUwNDE5ZWZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MWZlNDk2NGU4MzJlMzJlMmM1NzA2YTBlZDE3NGM5
ZjhlMDQxOWVmZC4xNTYzNzk1NDg2LmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IE1vbiwgMjIgSnVsIDIwMTkgMTM6
Mzc6NTEgKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBzdG1tYWM6IEFkZCBtZW1vcnkg
YmFycmllcgoKU2lnbmVkLW9mZi1ieTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+
CgotLS0KQ2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0LmNvbT4KQ2M6
IEFsZXhhbmRyZSBUb3JndWUgPGFsZXhhbmRyZS50b3JndWVAc3QuY29tPgpDYzogSm9zZSBBYnJl
dSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkNjOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD4KQ2M6IE1heGltZSBDb3F1ZWxpbiA8bWNvcXVlbGluLnN0bTMyQGdtYWlsLmNv
bT4KQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcKQ2M6IGxpbnV4LXN0bTMyQHN0LW1kLW1haWxt
YW4uc3Rvcm1yZXBseS5jb20KQ2M6IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9y
ZwpDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwotLS0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWlj
cm8vc3RtbWFjL3N0bW1hY19tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9zdG1tYWNfbWFpbi5jCmluZGV4IDdhNjkyMDA5OGRkMC4uMjA3YzM3NTViY2M1IDEwMDY0
NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5j
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMK
QEAgLTM0MjUsNiArMzQyNSw5IEBAIHN0YXRpYyBpbnQgc3RtbWFjX3J4KHN0cnVjdCBzdG1tYWNf
cHJpdiAqcHJpdiwgaW50IGxpbWl0LCB1MzIgcXVldWUpCiAJCQkJY29udGludWU7CiAJCQl9CiAK
KwkJCS8qIEZ1bGwgbWVtb3J5IGJhcnJpZXIgKi8KKwkJCW1iKCk7CisKIAkJCWRtYV9zeW5jX3Np
bmdsZV9mb3JfY3B1KHByaXYtPmRldmljZSwgYnVmLT5hZGRyLAogCQkJCQkJZnJhbWVfbGVuLCBE
TUFfRlJPTV9ERVZJQ0UpOwogCQkJc2tiX2NvcHlfdG9fbGluZWFyX2RhdGEoc2tiLCBwYWdlX2Fk
ZHJlc3MoYnVmLT5wYWdlKSwKLS0gCjIuNy40Cgo=

--_002_BN8PR12MB326661846D53AAEE315A7434D3C40BN8PR12MB3266namp_--
