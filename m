Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC15F4A039
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfFRMGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:06:00 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:58519
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfFRMGA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcWx94Q5Uyanjwk94sd/nnI7jx4KAUy+b3+ehsY3k4Q=;
 b=E957Zdrl47Xy2d8/21jBLw0AoGcaRpypw9uoK2UYZY7K54Tp7SCKA5NE1/0ZOD0DzvzkDp3yPVLrp0jXvMFOHURpZt2uu6Qrp6XB8oEzqyPprDIKzHu8vS6xHJNWhBOa6ctXkObdt1XIiEASjFMdiwtSWEpEHQ+jXxMaspoPmPw=
Received: from DB6PR0501MB2342.eurprd05.prod.outlook.com (10.168.56.21) by
 DB6PR0501MB2328.eurprd05.prod.outlook.com (10.168.56.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 12:05:56 +0000
Received: from DB6PR0501MB2342.eurprd05.prod.outlook.com
 ([fe80::ec3d:c810:e8d8:8aef]) by DB6PR0501MB2342.eurprd05.prod.outlook.com
 ([fe80::ec3d:c810:e8d8:8aef%9]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:05:56 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
CC:     Petr Machata <petrm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: arm32 build failure after
 992aa864dca068554802a65a467a2640985cc213
Thread-Topic: arm32 build failure after
 992aa864dca068554802a65a467a2640985cc213
Thread-Index: AQHVJXeaQJyu+P7LqEmJZmmYcFVfYqahUWoA
Date:   Tue, 18 Jun 2019 12:05:56 +0000
Message-ID: <60390608-aec3-503d-e4f2-2b4e93aeefaa@mellanox.com>
References: <20190618014604.GA17174@archlinux-epyc>
In-Reply-To: <20190618014604.GA17174@archlinux-epyc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
x-clientproxiedby: AM5PR0201CA0015.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::25) To DB6PR0501MB2342.eurprd05.prod.outlook.com
 (2603:10a6:4:4c::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d7db394-8708-4c76-2692-08d6f3e55194
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2328;
x-ms-traffictypediagnostic: DB6PR0501MB2328:
x-microsoft-antispam-prvs: <DB6PR0501MB23288EBC24C169DBF5E3CA7EC5EA0@DB6PR0501MB2328.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39860400002)(136003)(366004)(51914003)(189003)(199004)(53754006)(7736002)(86362001)(316002)(73956011)(58126008)(66476007)(110136005)(5660300002)(71190400001)(36756003)(256004)(31696002)(54906003)(6246003)(65826007)(66556008)(71200400001)(14444005)(486006)(2906002)(99286004)(26005)(11346002)(446003)(476003)(52116002)(76176011)(6506007)(386003)(53546011)(186003)(102836004)(2616005)(66946007)(25786009)(64126003)(3846002)(14454004)(81166006)(8936002)(68736007)(6486002)(6436002)(31686004)(229853002)(6636002)(53936002)(66066001)(64756008)(65806001)(65956001)(81156014)(66446008)(8676002)(4326008)(6116002)(478600001)(305945005)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2328;H:DB6PR0501MB2342.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JZqeNadyxCBG0pjfPIS/PUFi5/pT5/Ool9jbNQfGp4aRCGd6TNyCPkuaoisN/nqGOTni65IUOOQAoLrpzOLV/3pI5pWuTeuD3SSsgyMBphmu6Ik7SkTE3sgsJV7Fgrqlk1z4V1fVPn7emwQEbdxoZASrjuRM9YIMFHeooHgoTs134AUhYzch+1Pr3iwxF+fWwj55sgpJ//OyuoRnL+HL/XwAtXzZfbBEyrNLW7wjfSMOrnEvtm5tpK683b6VFCgZQyGAAe86aVR6FyO4PFxoi3mplxt5+6qG5YV2lvUltwkHRDVqCOMwNRZzc8yhXyswcdDjDDUpL4+XgVQMPzPn42f/PwXgYl8ENVIwa0qNM2Pkbl6dTTKaMdt1HwF1GRhuiBb7CO6T6SHVK+5/Jr47eKHQuP8DR5N1pWmMNK8EGBo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <94E9B454FC28BD4A9154D89988536B10@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d7db394-8708-4c76-2692-08d6f3e55194
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:05:56.6742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2328
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTgvMDYvMjAxOSA0OjQ2LCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90ZToNCj4gSGkgYWxsLA0K
PiANCj4gQSAzMi1iaXQgQVJNIGFsbHllc2NvbmZpZyBmYWlscyB0byBsaW5rIGFmdGVyIGNvbW1p
dCA5OTJhYTg2NGRjYTANCj4gKCJtbHhzdzogc3BlY3RydW1fcHRwOiBBZGQgaW1wbGVtZW50YXRp
b24gZm9yIHBoeXNpY2FsIGhhcmR3YXJlIGNsb2NrDQo+IG9wZXJhdGlvbnMiKSBiZWNhdXNlIG9m
IDY0LWJpdCBkaXZpc2lvbjoNCj4gDQo+IGFybS1saW51eC1nbnVlYWJpLWxkOg0KPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAubzogaW4gZnVuY3Rpb24N
Cj4gYG1seHN3X3NwMV9wdHBfcGhjX3NldHRpbWUnOg0KPiBzcGVjdHJ1bV9wdHAuYzooLnRleHQr
MHgzOWMpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBfX2FlYWJpX3VsZGl2bW9kJw0KPiANCj4g
VGhlIGZvbGxvd2luZyBkaWZmIGZpeGVzIGl0IGJ1dCBJIGhhdmUgbm8gaWRlYSBpZiBpdCBpcyBw
cm9wZXIgb3Igbm90DQo+IChoZW5jZSByZWFjaGluZyBvdXQgYmVmb3JlIHNlbmRpbmcgaXQsIGlu
IGNhc2Ugb25lIG9mIHlvdSBoYXMgYSBtb3JlDQo+IHByb3BlciBpZGVhKS4NCj4gDQo+IENoZWVy
cywNCj4gTmF0aGFuDQo+IA0KPiAtLS0NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seHN3L3NwZWN0cnVtX3B0cC5jDQo+IGluZGV4IDJhOWJiYzkwMjI1ZS4u
NjU2ODZmMGI2ODM0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHhzdy9zcGVjdHJ1bV9wdHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHhzdy9zcGVjdHJ1bV9wdHAuYw0KPiBAQCAtODcsNyArODcsNyBAQCBtbHhzd19zcDFf
cHRwX3BoY19zZXR0aW1lKHN0cnVjdCBtbHhzd19zcF9wdHBfY2xvY2sgKmNsb2NrLCB1NjQgbnNl
YykNCj4gICAgICAgICB1MzIgbmV4dF9zZWM7DQo+ICAgICAgICAgaW50IGVycjsNCj4gIA0KPiAt
ICAgICAgIG5leHRfc2VjID0gbnNlYyAvIE5TRUNfUEVSX1NFQyArIDE7DQo+ICsgICAgICAgbmV4
dF9zZWMgPSAodTMyKWRpdjY0X3U2NChuc2VjLCBOU0VDX1BFUl9TRUMgKyAxKTsNCj4gICAgICAg
ICBuZXh0X3NlY19pbl9uc2VjID0gbmV4dF9zZWMgKiBOU0VDX1BFUl9TRUM7DQo+ICANCj4gICAg
ICAgICBzcGluX2xvY2soJmNsb2NrLT5sb2NrKTsNCj4gDQo+IA0KDQoNCg0KVGhhbmtzIGZvciB0
aGUgcmVwb3J0LiBJIHdpbGwgc2VuZCBhIGZpeC4NCg==
