Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD527154A8
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfEFTxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 15:53:06 -0400
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:55094
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726175AbfEFTxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 15:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giWsIGRfSU9X5cNBDHR3rgwLOKOXlr6dawM55nza7rs=;
 b=tBgnuxemWWLLG6xs3vRAVnBP9YHD4aoDhsJYUxB7PNi4bK/MHK1ONEU2PSxg4gg9k+CE+kE8B+beWseqMvP0+z09UewR025Gnx9M25Qup0UTr797c8iN1rYSzoizhy23Au6b1VFGcRrz8VqpslkYAa3R+2ssVaaTLA8C2ldsYF8=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6601.eurprd05.prod.outlook.com (20.179.8.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Mon, 6 May 2019 19:52:18 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 19:52:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Moshe Shemesh <moshe@mellanox.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Thread-Topic: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Thread-Index: AQHVAtolLdJJy+/cik2B95xXeBcmGKZcrIIAgAE/fICAAA7AgIAAifcA
Date:   Mon, 6 May 2019 19:52:18 +0000
Message-ID: <1bd839d1adea5fe999ecdd2d31b31936789ce58e.camel@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
         <20190505003207.1353-10-saeedm@mellanox.com>
         <20190505154212.GC31501@nanopsycho.orion>
         <da1c4267-c258-525e-70a2-9ccd2629d5c4@mellanox.com>
         <20190506113829.GB2280@nanopsycho>
In-Reply-To: <20190506113829.GB2280@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b29b4801-f4b3-486c-f365-08d6d25c5871
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6601;
x-ms-traffictypediagnostic: DB8PR05MB6601:
x-microsoft-antispam-prvs: <DB8PR05MB660127EBE8898476DC3B03BBBE300@DB8PR05MB6601.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(54906003)(58126008)(446003)(110136005)(68736007)(2906002)(486006)(11346002)(118296001)(476003)(2616005)(81156014)(81166006)(8676002)(66066001)(8936002)(7736002)(305945005)(36756003)(6246003)(107886003)(53936002)(4326008)(25786009)(86362001)(5660300002)(6116002)(102836004)(76176011)(99286004)(316002)(53546011)(6506007)(3846002)(478600001)(256004)(14444005)(71200400001)(6512007)(71190400001)(14454004)(6486002)(6436002)(91956017)(76116006)(2501003)(229853002)(186003)(66946007)(73956011)(66446008)(26005)(66476007)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6601;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 16UNv1xlZdSwKslJ+414LSa3ya/97BE28eFNfMn2wrPeOVfarlVV2Fk+cAMuq1v18Q+EBdcwt1nJ8DObfHir2JGi9j8QDbHzcsmQS68fwY7TdPHo++RwhyRAiSE4IXflHZeHUmmtieKPokpsKH5M4NLMAO6LrXuM1214OoL+WpUJxefVJU/GImO/Z5qQ1mhk/wxIxjM9lmRC0tpWkFYJL/1LQtpJb79V2jzaHFUsZHDFX891erG9w05vCHF9Fv0KT6ELy1V/KX2O70EPQB2HgqdVekyIC2WLaAf9E88KQP2Z6JBw1bq78iz9n/j1gcPn99+YcNDaUiPlEvntzakEeZyJtHzxD7FpI/Gv7MLcoCS+5MSwgDmTnlgqWg38yjnkUxFiLFtZKXwlZTyUPvGoen0DMXc2TX3erVRHSyEM/uU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <082BAB1FFDFBC642908C4622325529A8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b29b4801-f4b3-486c-f365-08d6d25c5871
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 19:52:18.0609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6601
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTA2IGF0IDEzOjM4ICswMjAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBN
b24sIE1heSAwNiwgMjAxOSBhdCAxMjo0NTo0NFBNIENFU1QsIG1vc2hlQG1lbGxhbm94LmNvbSB3
cm90ZToNCj4gPiANCj4gPiBPbiA1LzUvMjAxOSA2OjQyIFBNLCBKaXJpIFBpcmtvIHdyb3RlOg0K
PiA+ID4gU3VuLCBNYXkgMDUsIDIwMTkgYXQgMDI6MzM6MjNBTSBDRVNULCBzYWVlZG1AbWVsbGFu
b3guY29tIHdyb3RlOg0KPiA+ID4gPiBGcm9tOiBNb3NoZSBTaGVtZXNoIDxtb3NoZUBtZWxsYW5v
eC5jb20+DQo+ID4gPiA+IA0KPiA+ID4gPiBDcmVhdGUgbWx4NV9kZXZsaW5rX2hlYWx0aF9yZXBv
cnRlciBmb3IgRlcgcmVwb3J0ZXIuIFRoZSBGVw0KPiA+ID4gPiByZXBvcnRlcg0KPiA+ID4gPiBp
bXBsZW1lbnRzIGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyIGRpYWdub3NlIGNhbGxiYWNrLg0KPiA+
ID4gPiANCj4gPiA+ID4gVGhlIGZ3IHJlcG9ydGVyIGRpYWdub3NlIGNvbW1hbmQgY2FuIGJlIHRy
aWdnZXJlZCBhbnkgdGltZSBieQ0KPiA+ID4gPiB0aGUgdXNlcg0KPiA+ID4gPiB0byBjaGVjayBj
dXJyZW50IGZ3IHN0YXR1cy4NCj4gPiA+ID4gSW4gaGVhbHRoeSBzdGF0dXMsIGl0IHdpbGwgcmV0
dXJuIGNsZWFyIHN5bmRyb21lLiBPdGhlcndpc2UgaXQNCj4gPiA+ID4gd2lsbCBkdW1wDQo+ID4g
PiA+IHRoZSBoZWFsdGggaW5mbyBidWZmZXIuDQo+ID4gPiA+IA0KPiA+ID4gPiBDb21tYW5kIGV4
YW1wbGUgYW5kIG91dHB1dCBvbiBoZWFsdGh5IHN0YXR1czoNCj4gPiA+ID4gJCBkZXZsaW5rIGhl
YWx0aCBkaWFnbm9zZSBwY2kvMDAwMDo4MjowMC4wIHJlcG9ydGVyIGZ3DQo+ID4gPiA+IFN5bmRy
b21lOiAwDQo+ID4gPiA+IA0KPiA+ID4gPiBDb21tYW5kIGV4YW1wbGUgYW5kIG91dHB1dCBvbiBu
b24gaGVhbHRoeSBzdGF0dXM6DQo+ID4gPiA+ICQgZGV2bGluayBoZWFsdGggZGlhZ25vc2UgcGNp
LzAwMDA6ODI6MDAuMCByZXBvcnRlciBmdw0KPiA+ID4gPiBkaWFnbm9zZSBkYXRhOg0KPiA+ID4g
PiBhc3NlcnRfdmFyWzBdIDB4ZmMzZmMwNDMNCj4gPiA+ID4gYXNzZXJ0X3ZhclsxXSAweDAwMDFi
NDFjDQo+ID4gPiA+IGFzc2VydF92YXJbMl0gMHgwMDAwMDAwMA0KPiA+ID4gPiBhc3NlcnRfdmFy
WzNdIDB4MDAwMDAwMDANCj4gPiA+ID4gYXNzZXJ0X3Zhcls0XSAweDAwMDAwMDAwDQo+ID4gPiA+
IGFzc2VydF9leGl0X3B0ciAweDAwODAzM2I0DQo+ID4gPiA+IGFzc2VydF9jYWxscmEgMHgwMDgw
MzY1Yw0KPiA+ID4gPiBmd192ZXIgMTYuMjQuMTAwMA0KPiA+ID4gPiBod19pZCAweDAwMDAwMjBk
DQo+ID4gPiA+IGlyaXNjX2luZGV4IDANCj4gPiA+ID4gc3luZCAweDg6IHVucmVjb3ZlcmFibGUg
aGFyZHdhcmUgZXJyb3INCj4gPiA+ID4gZXh0X3N5bmQgMHgwMDNkDQo+ID4gPiA+IHJhdyBmd192
ZXIgMHgxMDE4MDNlOA0KPiA+ID4gPiANCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTW9zaGUgU2hl
bWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBFcmFuIEJl
biBFbGlzaGEgPGVyYW5iZUBtZWxsYW5veC5jb20+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFNh
ZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+ID4gDQo+ID4gPiAJDQo+ID4g
PiBbLi4uXQkNCj4gPiA+IAkNCj4gPiA+IAkNCj4gPiA+ID4gK3N0YXRpYyBpbnQNCj4gPiA+ID4g
K21seDVfZndfcmVwb3J0ZXJfZGlhZ25vc2Uoc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVy
DQo+ID4gPiA+ICpyZXBvcnRlciwNCj4gPiA+ID4gKwkJCSAgc3RydWN0IGRldmxpbmtfZm1zZyAq
Zm1zZykNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKwlzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2ID0N
Cj4gPiA+ID4gZGV2bGlua19oZWFsdGhfcmVwb3J0ZXJfcHJpdihyZXBvcnRlcik7DQo+ID4gPiA+
ICsJc3RydWN0IG1seDVfY29yZV9oZWFsdGggKmhlYWx0aCA9ICZkZXYtPnByaXYuaGVhbHRoOw0K
PiA+ID4gPiArCXU4IHN5bmQ7DQo+ID4gPiA+ICsJaW50IGVycjsNCj4gPiA+ID4gKw0KPiA+ID4g
PiArCW11dGV4X2xvY2soJmhlYWx0aC0+aW5mb19idWZfbG9jayk7DQo+ID4gPiA+ICsJbWx4NV9n
ZXRfaGVhbHRoX2luZm8oZGV2LCAmc3luZCk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlpZiAoIXN5
bmQpIHsNCj4gPiA+ID4gKwkJbXV0ZXhfdW5sb2NrKCZoZWFsdGgtPmluZm9fYnVmX2xvY2spOw0K
PiA+ID4gPiArCQlyZXR1cm4gZGV2bGlua19mbXNnX3U4X3BhaXJfcHV0KGZtc2csDQo+ID4gPiA+
ICJTeW5kcm9tZSIsIHN5bmQpOw0KPiA+ID4gPiArCX0NCj4gPiA+ID4gKw0KPiA+ID4gPiArCWVy
ciA9IGRldmxpbmtfZm1zZ19zdHJpbmdfcGFpcl9wdXQoZm1zZywgImRpYWdub3NlDQo+ID4gPiA+
IGRhdGEiLA0KPiA+ID4gPiArCQkJCQkgICBoZWFsdGgtPmluZm9fYnVmKTsNCj4gPiA+IA0KPiA+
ID4gTm8hIFRoaXMgaXMgd3JvbmchIFlvdSBhcmUgc25lYWtpbmcgaW4gdGV4dCBibG9iLiBQbGVh
c2UgcHV0IHRoZQ0KPiA+ID4gaW5mbyBpbg0KPiA+ID4gc3RydWN0dXJlZCBmb3JtIHVzaW5nIHBy
b3BlciBmbXNnIGhlbHBlcnMuDQo+ID4gPiANCj4gPiBUaGlzIGlzIHRoZSBmdyBvdXRwdXQgZm9y
bWF0LCBpdCBpcyBhbHJlYWR5IGluIHVzZSwgSSBkb24ndCB3YW50DQo+ID4gdG8gDQo+ID4gY2hh
bmdlIGl0LCBqdXN0IGhhdmUgaXQgaGVyZSBpbiB0aGUgZGlhZ25vc2Ugb3V0cHV0IHRvby4NCj4g
DQo+IEFscmVhZHkgaW4gdXNlIHdoZXJlPyBpbiBkbWVzZz8gU29ycnksIGJ1dCB0aGF0IGlzIG5v
dCBhbiBhcmd1bWVudC4NCj4gUGxlYXNlIGZvcm1hdCB0aGUgbWVzc2FnZSBwcm9wZXJseS4NCj4g
DQoNCldoYXQgaXMgd3JvbmcgaGVyZSA/IA0KDQpVbmxpa2UgYmluYXJ5IGR1bXAgZGF0YSwgSSB0
aG91Z2h0IGRpYWdub3NlIGRhdGEgaXMgYWxsb3dlZCB0byBiZQ0KZGV2ZWxvcGVyIGZyaWVuZGx5
IGZyZWUgdGV4dCBmb3JtYXQsIGlmIG5vdCB0aGVuIGxldCdzIGVuZm9yY2UgaXQgaW4NCmRldmxp
bmsgQVBJLiBKaXJpLCAgeW91IGNhbid0IGF1ZGl0IGVhY2ggYW5kIGV2ZXJ5IHVzZSBvZg0KZGV2
bGlua19mbXNnX3N0cmluZ19wYWlyX3B1dCwgaXQgbXVzdCBiZSBkb25lIGJ5IGRlc2lnbi4NCg0K
VGhhbmtzLA0KU2FlZWQNCg==
