Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F78E1BF18
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 23:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEMV0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 17:26:36 -0400
Received: from mail-eopbgr720126.outbound.protection.outlook.com ([40.107.72.126]:38338
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbfEMV0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 17:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHCP/IgkV9JDW9zD/gfQRZzVOinUXUNC1+l5QFJO3yc=;
 b=EJt4a/jy8C0NVFsv72bxJGk80QR2MHY3CPwUvyaRiOWja7V7n3xfeS48JfW1nrmo4evDy8AoE9uzLJZibVZ0pTv3aOe1YWxj7GD4kDcab4sYMFJwfTsl4TQpuKtKyUNi9N5KdzQCqzWCIpvC+TAk2bq3+mhgebJScYgWysxvCi4=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3609.namprd06.prod.outlook.com (10.167.236.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 21:26:28 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 21:26:28 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Topic: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Index: AQHVB3nKLczzbyv1Ekyx8+zOFp2aoKZlvT2AgAAe/wCAA6E4AIAABBwAgAAJa4CAAAsdgA==
Date:   Mon, 13 May 2019 21:26:28 +0000
Message-ID: <1557782787.4229.36.camel@impinj.com>
References: <20190510214550.18657-1-tpiepho@impinj.com>
         <20190510214550.18657-5-tpiepho@impinj.com>
         <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
         <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
         <1557777496.4229.13.camel@impinj.com>
         <b246b18d-5523-7b8b-9cd0-b8ccb8a511e9@gmail.com>
         <20190513204641.GA12345@lunn.ch>
In-Reply-To: <20190513204641.GA12345@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tpiepho@impinj.com; 
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fab894f7-5ce2-4222-b5d1-08d6d7e9a91b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3609;
x-ms-traffictypediagnostic: MWHPR0601MB3609:
x-microsoft-antispam-prvs: <MWHPR0601MB3609250789FD7E70D648A187D30F0@MWHPR0601MB3609.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(136003)(366004)(39850400004)(189003)(199004)(476003)(229853002)(76176011)(486006)(68736007)(2616005)(2501003)(4326008)(102836004)(8676002)(103116003)(8936002)(81166006)(14454004)(478600001)(81156014)(53936002)(6506007)(71190400001)(71200400001)(446003)(6246003)(11346002)(5660300002)(91956017)(14444005)(73956011)(76116006)(2906002)(256004)(66476007)(66556008)(64756008)(66446008)(66946007)(26005)(86362001)(36756003)(6486002)(316002)(54906003)(110136005)(6436002)(3846002)(305945005)(7736002)(66066001)(6512007)(99286004)(6116002)(186003)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3609;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iRUPLiIFK/snASSFPfbpzsTJ3dVh9qs7MV8NSw8VWi/k71L/b8d4B7oEj7mTopXJHsCqNTIYrCcGiLLbIEpAHVcHNHUBqJbweE2t/PNE6qXkDWLw7jv6FCtzh4AYQSbs++fOC/3DqW0y/o91ETLkpuFXk7G9N5wMvmUf7FnCLMWp9t2g+u12qKlfVRQCYtHMC9pIcXLLWFVQjziRB3q9MHY/uI1PWjGPNtpEEd0M9Mzh5XAh1bCzADv/ZsfH5LMirOKFEEFERvod7vuhjq9OxautB59XZnEg2UkByqUjkRk5mm74NXg0M9oW5s2+MFP+cp5alRkSmjn9iMaFkmko3Rw/XrwzNSu6V9SENG2db80LTVdAuOvnxZbbmuhXvah+rdHJ5HgsjQOarn7OUguW8mCnBwzzapzjUoDI1bXAxlQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBD6CD64ABF63E4DB485EB55C500E53B@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab894f7-5ce2-4222-b5d1-08d6d7e9a91b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 21:26:28.1699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3609
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTEzIGF0IDIyOjQ2ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiA+IFBlcmhhcHMgeW91IGNvdWxkIHRlbGwgbWUgaWYgdGhlIGFwcHJvYWNoIEkndmUgdGFrZW4g
aW4gcGF0Y2ggMywgDQo+ID4gPiAiQWRkIGFiaWxpdHkgdG8gZGlzYWJsZSBvdXRwdXQgY2xvY2si
LCBhbmQgcGF0Y2ggNCwgIkRpc2FibGUgdHgvcngNCj4gPiA+IGRlbGF5IHdoZW4gbm90IGNvbmZp
Z3VyZWQiLCBhcmUgY29uc2lkZXJlZCBhY2NlcHRhYmxlPyAgSSBjYW4gY29uY2VpdmUNCj4gPiA+
IG9mIGFyZ3VtZW50cyBmb3IgYWx0ZXJuYXRlIGFwcHJvYWNoZXMuICBJIHdvdWxkIGxpa2UgdG8g
YWRkIHN1cHBvcnQgZm9yDQo+ID4gPiAgdGhlc2UgaW50byB1LWJvb3QgdG9vLCBidXQgdHlwaWNh
bGx5IHUtYm9vdCBmb2xsb3dzIHRoZSBrZXJuZWwgRFQNCj4gPiA+IGJpbmRpbmdzLCBzbyBJIHdh
bnQgdG8gZmluYWxpemUgdGhlIGtlcm5lbCBEVCBzZW1hbnRpY3MgYmVmb3JlIHNlbmRpbmcNCj4g
PiA+IHBhdGNoZXMgdG8gdS1ib290Lg0KPiA+ID4gDQo+ID4gDQo+ID4gSSBsYWNrIGV4cGVyaWVu
Y2Ugd2l0aCB0aGVzZSBUSSBQSFkncy4gTWF5YmUgQW5kcmV3IG9yIEZsb3JpYW4gY2FuIGFkdmlz
ZS4NCj4gDQo+IEhpIFRyZW50DQo+IA0KPiBJIGFscmVhZHkgZGVsZXRlZCB0aGUgcGF0Y2hlcy4g
Rm9yIHBhdGNoIDM6DQo+IA0KPiArIAkgIGlmIChkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCA+IERQ
ODM4NjdfQ0xLX09fU0VMX1JFRl9DTEsgJiYNCj4gKwkgICAgICAgICBkcDgzODY3LT5jbGtfb3V0
cHV0X3NlbCAhPSBEUDgzODY3X0NMS19PX1NFTF9PRkYpIHsNCj4gKwkJIAlwaHlkZXZfZXJyKHBo
eWRldiwgInRpLGNsay1vdXRwdXQtc2VsIHZhbHVlICV1IG91dCBvZiByYW5nZVxuIiwNCj4gKwkJ
CQkgICBkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCk7DQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsNCj4g
KwkJICAgICAgfQ0KPiANCj4gVGhpcyBsYXN0IGJpdCBsb29rcyBvZGQuIElmIGl0IGlzIG5vdCBP
RkYsIGl0IGlzIGludmFsaWQ/DQoNClRoZSB2YWxpZCB2YWx1ZXMgYXJlIGluIHRoZSByYW5nZSAw
IHRvIERQODM4NjdfQ0xLX09fU0VMX1JFRl9DTEsgYW5kDQphbHNvIERQODM4NjdfQ0xLX09fU0VM
X09GRi4gIFRodXMgaW52YWxpZCB2YWx1ZXMgYXJlIHRob3NlIGdyZWF0ZXIgdGhhbg0KRFA4Mzg2
N19DTEtfT19TRUxfUkVGX0NMSyB3aGljaCBhcmUgbm90IERQODM4NjdfQ0xLX09fU0VMX09GRi4N
Cg0KPiANCj4gQXJlIHRoZXJlIGFueSBpbiB0cmVlIHVzZXJzIG9mIERQODM4NjdfQ0xLX09fU0VM
X1JFRl9DTEs/IFdlIGhhdmUgdG8NCj4gYmUgY2FyZWZ1bCBjaGFuZ2luZyBpdHMgbWVhbmluZy4g
QnV0IGlmIG5vYm9keSBpcyBhY3R1YWxseSB1c2luZyBpdC4uLg0KDQpOb3BlLiAgSSBkb3VidCB0
aGlzIHdpbGwgYWZmZWN0IGFueW9uZS4gIFRoZXknZCBuZWVkIHRvIHN0cmFwIHRoZSBwaHkNCnRv
IGdldCBhIGRpZmZlcmVudCBjb25maWd1cmF0aW9uLCBhbmQgdGhlIGV4cGxpY2l0bHkgYWRkIGEg
cHJvcGVydHksDQp3aGljaCBpc24ndCBpbiB0aGUgZXhhbXBsZSBEVFMgZmlsZXMsIHRvIGNoYW5n
ZSB0aGUgY29uZmlndXJhdGlvbiB0bw0Kc29tZXRoaW5nIHRoZXkgZGlkbid0IHdhbnQsIGFuZCB0
aGVuIGRlcGVuZCBvbiBhIGRyaXZlciBidWcgaWdub3JpbmcNCnRoZSBlcnJvbmVvdXMgc2V0dGlu
ZyB0aGV5IGFkZGVkLg0KDQo+IFBhdGNoIDQ6DQo+IA0KPiBUaGlzIGlzIGhhcmRlci4gSWRlYWxs
eSB3ZSB3YW50IHRvIGZpeCB0aGlzLiBBdCBzb21lIHBvaW50LCBzb21lYm9keQ0KPiBpcyBnb2lu
ZyB0byB3YW50ICdyZ21paScgdG8gYWN0dWFsbHkgbWVhbiAncmdtaWknLCBiZWNhdXNlIHRoYXQg
aXMNCj4gd2hhdCB0aGVpciBoYXJkd2FyZSBuZWVkcy4NCj4gDQo+IENvdWxkIHlvdSBhZGQgYSBX
QVJOX09OKCkgZm9yICdyZ21paScgYnV0IHRoZSBQSFkgaXMgYWN0dWFsbHkgYWRkaW5nIGENCj4g
ZGVsYXk/IEFuZCBhZGQgYSBjb21tZW50IGFib3V0IHNldHRpbmcgdGhlIGNvcnJlY3QgdGhpbmcg
aW4gZGV2aWNlDQo+IHRyZWU/ICBIb3BlZnVsbHkgd2Ugd2lsbCB0aGVuIGdldCBwYXRjaGVzIGNv
cnJlY3RpbmcgRFQgYmxvYnMuIEFuZCBpZg0KPiB3ZSBsYXRlciBkbyBuZWVkIHRvIGZpeCAncmdt
aWknLCB3ZSB3aWxsIGJyZWFrIGxlc3MgYm9hcmQuDQoNClllcyBJIGNhbiBkbyB0aGlzLiAgU2hv
dWxkIGl0IHdhcm4gb24gYW55IHVzZSBvZiAicmdtaWkiPyAgSWYgc28sIGhvdw0Kd291bGQgc29t
ZW9uZSBtYWtlIHRoZSB3YXJuaW5nIGdvIGF3YXkgaWYgdGhleSBhY3R1YWxseSB3YW50IHJnbWlp
IG1vZGUNCndpdGggbm8gZGVsYXk/DQoNCkkgc3VzcGVjdCBoc2RrLmR0cyBpcyBhbiBleGFtcGxl
IG9mIGFuIGluLXRyZWUgYnJva2VuIGJvYXJkIHRoYXQgdXNlcw0KInJnbWlpIiB3b3VsZCBpdCBz
aG91bGQgaGF2ZSB1c2VkICJyZ21paS1pZCIuICBVbmZvcnR1bmF0ZWx5LCBwaHkgZHRzDQpub2Rl
cyBkb24ndCB1c3VhbGx5IHByb3ZpZGUgYSBjb21wYXRpYmxlIHRoYXQgaWRlbnRpZmllcyB0aGUg
cGh5LCB1c2luZw0KaW5zdGVhZCBydW4tdGltZSBhdXRvLWRldGVjdGlvbiBiYXNlZCBvbiBQSFkg
aWQgcmVnaXN0ZXJzLCBzbyB0aGVyZSdzDQpubyB3YXkgdG8gdGVsbCBmcm9tIHRoZSBkdHMgZmls
ZXMgd2hhdCBib2FyZHMgdXNlIHRoaXMgcGh5IHVubGVzcyB0aGV5DQphbHNvIHNwZWNpZnkgb25l
IG9mIHRoZSBwaHkgc3BlY2lmaWMgcHJvcGVydGllcy4gIFdoaWNoIGlzIGhvdyBJIGZvdW5kDQpo
c2RrLmR0cyAoYW5kIG5vIG90aGVyIGJvYXJkcykuDQo=
