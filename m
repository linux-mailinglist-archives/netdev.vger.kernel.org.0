Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE23B51CEE
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732140AbfFXVQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:16:13 -0400
Received: from mail-eopbgr740117.outbound.protection.outlook.com ([40.107.74.117]:35648
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfFXVQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 17:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDpXINy0imnR7M+9OR+rAuW0W2lA2hTrlqaq3L9ac30=;
 b=Vmp5Nn7CSkBfDpVHWnT4N5i/iu2lt816ZfOww+p65T4vRXqWGFP3wFfjGrvYRW4fzqkaXFHv6Gz0ZZktQkFajRdmwwB38GkynEewGmBrfRJRRVl9GVnYZhs9ZOOas4TajAwvxRqnss8rI0ttWlyjd9rzrilIMWPYedcuLbEJ3tk=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1760.namprd22.prod.outlook.com (10.164.206.163) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 21:16:08 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 21:16:08 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Paul Burton <pburton@wavecomp.com>
CC:     "Maciej W. Rozycki" <macro@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] FDDI: defza: Include linux/io-64-nonatomic-lo-hi.h
Thread-Topic: [PATCH] FDDI: defza: Include linux/io-64-nonatomic-lo-hi.h
Thread-Index: AQHVJ7V1UXxjnCnLE027KWvd1IREUaarVKiA
Date:   Mon, 24 Jun 2019 21:16:08 +0000
Message-ID: <MWHPR2201MB1277792136FAB29E384E2152C1E00@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190620221224.27352-1-paul.burton@mips.com>
In-Reply-To: <20190620221224.27352-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:a03:60::20) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7176eab-ad1e-4d85-2b32-08d6f8e92cf6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1760;
x-ms-traffictypediagnostic: MWHPR2201MB1760:
x-microsoft-antispam-prvs: <MWHPR2201MB1760D83E1597F277CFEE223AC1E00@MWHPR2201MB1760.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39840400004)(136003)(366004)(376002)(396003)(52314003)(189003)(199004)(486006)(14444005)(53936002)(7736002)(68736007)(76176011)(386003)(66066001)(25786009)(4326008)(186003)(305945005)(42882007)(316002)(256004)(74316002)(6506007)(99286004)(54906003)(476003)(52116002)(11346002)(446003)(44832011)(7696005)(26005)(8676002)(102836004)(6116002)(3846002)(9686003)(71190400001)(71200400001)(14454004)(5660300002)(229853002)(6862004)(8936002)(52536014)(6436002)(64756008)(66556008)(33656002)(66446008)(66476007)(6246003)(73956011)(2906002)(55016002)(478600001)(66946007)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1760;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CvkYjJ3Cpaz4DfxEJMJ3bbMSR9QVeh5OnI4Q9OWpsesn9TSqauu4kC5qPJaIy3HqgcVz/q+eAdsUtPQUv2k11emzbmJcmluds7WYh7rWTaGqZBoZT8aVbgnpNqgSaEUsWJUjdewZ7d8LVu/4cZ+aMdZWxTcOydoRmgjtctyIMHu9X+kXAZSlOki5Y6Vy5bLYg3lOntkGB2kjvd7WwTu/Sn/VIGA4/5sUd1MQ4siYZ0yE8GBYTrLjCMAhuW/T+9EROvf6BE64liGcsYtP2uyOghE+hXs7HVeyOjfvjNZ1xjREeiPq6QcxFVe+kasTP1ghTCEhuYZzjdqbK0YxhNUxo4mw5hdUib73TZVtDcrbo8ok+5lCxbAj7+sTQG4ATnbz9/WFM2IJZR5wYYo3ZfU6qkK+VADS9NluUwPrqFCfHK0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7176eab-ad1e-4d85-2b32-08d6f8e92cf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 21:16:08.7815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNClBhdWwgQnVydG9uIHdyb3RlOg0KPiBDdXJyZW50bHkgYXJjaC9taXBzL2luY2x1
ZGUvYXNtL2lvLmggcHJvdmlkZXMgNjRiIG1lbW9yeSBhY2Nlc3Nvcg0KPiBmdW5jdGlvbnMgc3Vj
aCBhcyByZWFkcSAmIHdyaXRlcSBldmVuIG9uIE1JUFMzMiBwbGF0Zm9ybXMgd2hlcmUgdGhvc2UN
Cj4gYWNjZXNzb3JzIGNhbm5vdCBhY3R1YWxseSBwZXJmb3JtIGEgNjRiIG1lbW9yeSBhY2Nlc3Mu
IFRoZXkgaW5zdGVhZA0KPiBCVUcoKS4gVGhpcyBpcyB1bmZvcnR1bmF0ZSBmb3IgZHJpdmVycyB3
aGljaCBlaXRoZXIgI2lmZGVmIG9uIHRoZQ0KPiBwcmVzZW5jZSBvZiB0aGVzZSBhY2Nlc3NvcnMs
IG9yIGNhbiBmdW5jdGlvbiB3aXRoIG5vbi1hdG9taWMNCj4gaW1wbGVtZW50YXRpb25zIG9mIHRo
ZW0gZm91bmQgaW4gZWl0aGVyIGxpbnV4L2lvLTY0LW5vbmF0b21pYy1sby1oaS5oIG9yDQo+IGxp
bnV4L2lvLTY0LW5vbmF0b21pYy1oaS1sby5oLiBBcyBzdWNoIHdlJ3JlIHByZXBhcmluZyB0byBy
ZW1vdmUgdGhlDQo+IGRlZmluaXRpb25zIG9mIHRoZXNlIDY0YiBhY2Nlc3NvciBmdW5jdGlvbnMg
Zm9yIE1JUFMzMiBrZXJuZWxzLg0KPiANCj4gSW4gcHJlcGFyYXRpb24gZm9yIHRoaXMsIGluY2x1
ZGUgbGludXgvaW8tNjQtbm9uYXRvbWljLWxvLWhpLmggaW4NCj4gZGVmemEuYyBpbiBvcmRlciB0
byBwcm92aWRlIGEgbm9uLWF0b21pYyBpbXBsZW1lbnRhdGlvbiBvZiB0aGUNCj4gcmVhZHFfcmVs
YXhlZCAmIHdyaXRlcV9yZWxheGVkIGZ1bmN0aW9ucyB0aGF0IGFyZSB1c2VkIGJ5IHRoaXMgY29k
ZS4gSW4NCj4gcHJhY3RpY2UgdGhpcyB3aWxsIGhhdmUgbm8gcnVudGltZSBlZmZlY3QsIHNpbmNl
IHVzZSBvZiB0aGUgNjRiIGFjY2Vzc29yDQo+IGZ1bmN0aW9ucyBpcyBjb25kaXRpb25hbCB1cG9u
IHNpemVvZih1bnNpZ25lZCBsb25nKSA9PSA4LCBpZS4gdXBvbg0KPiBDT05GSUdfNjRCSVQ9eS4g
VGhpcyBtZWFucyB0aGUgY2FsbHMgdG8gdGhlc2Ugbm9uLWF0b21pYyByZWFkcSAmIHdyaXRlcQ0K
PiBpbXBsZW1lbnRhdGlvbnMgd2lsbCBiZSBvcHRpbWl6ZWQgb3V0IGFueXdheSwgYnV0IHdlIG5l
ZWQgdGhlaXINCj4gZGVmaW5pdGlvbnMgdG8ga2VlcCB0aGUgY29tcGlsZXIgaGFwcHkuDQo+IA0K
PiBGb3IgNjRiaXQga2VybmVscyB1c2luZyB0aGlzIGNvZGUgdGhpcyBjaGFuZ2Ugc2hvdWxkIGFs
c28gaGF2ZSBubyBlZmZlY3QNCj4gYmVjYXVzZSBhc20vaW8uaCB3aWxsIGNvbnRpbnVlIHRvIHBy
b3ZpZGUgdGhlIGRlZmluaXRpb25zIG9mDQo+IHJlYWRxX3JlbGF4ZWQgJiB3cml0ZXFfcmVsYXhl
ZCwgd2hpY2ggbGludXgvaW8tNjQtbm9uYXRvbWljLWxvLWhpLmgNCj4gY2hlY2tzIGZvciBiZWZv
cmUgZGVmaW5pbmcgaXRzZWxmLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUGF1bCBCdXJ0b24gPHBh
dWwuYnVydG9uQG1pcHMuY29tPg0KPiBDYzogU2VyZ2UgU2VtaW4gPFNlcmdleS5TZW1pbkB0LXBs
YXRmb3Jtcy5ydT4NCj4gQ2M6ICJNYWNpZWogVy4gUm96eWNraSIgPG1hY3JvQGxpbnV4LW1pcHMu
b3JnPg0KPiBDYzogIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IENj
OiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1taXBzQHZnZXIua2VybmVsLm9y
Zw0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBBY2tlZC1ieTogTWFjaWVq
IFcuIFJvenlja2kgPG1hY3JvQGxpbnV4LW1pcHMub3JnPg0KPiBBY2tlZC1ieTogRGF2aWQgUy4g
TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KDQpBcHBsaWVkIHRvIG1pcHMtbmV4dC4NCg0K
VGhhbmtzLA0KICAgIFBhdWwNCg0KWyBUaGlzIG1lc3NhZ2Ugd2FzIGF1dG8tZ2VuZXJhdGVkOyBp
ZiB5b3UgYmVsaWV2ZSBhbnl0aGluZyBpcyBpbmNvcnJlY3QNCiAgdGhlbiBwbGVhc2UgZW1haWwg
cGF1bC5idXJ0b25AbWlwcy5jb20gdG8gcmVwb3J0IGl0LiBdDQo=
