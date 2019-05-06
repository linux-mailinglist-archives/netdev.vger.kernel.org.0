Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4567114881
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfEFKpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:45:49 -0400
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:14661
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbfEFKpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 06:45:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB2A38yKJO39zJkdiW1JpdEAu1F4WZY3DT5GVceu2fo=;
 b=n7eqYQpZt3F0L2nSjhMG8kDSZZBXXHkzRh/P0pVIQnoFXQaQgtP7kU4/uX8/qyj/3Uo4lY+aDA6fmtj4YWQE3ebJzX/OG03a/jo4iRUg9rWC2PKk2Jy6AIrmnCHSBHbUDAep5L2wcEEHTLNTq8M6kKp0558LI9N8cUYydch8Ytk=
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com (10.169.150.142) by
 AM5PR0501MB2370.eurprd05.prod.outlook.com (10.169.148.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Mon, 6 May 2019 10:45:44 +0000
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a]) by AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a%2]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 10:45:44 +0000
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Thread-Topic: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Thread-Index: AQHVAtolLdJJy+/cik2B95xXeBcmGKZcrIIAgAE/fIA=
Date:   Mon, 6 May 2019 10:45:44 +0000
Message-ID: <da1c4267-c258-525e-70a2-9ccd2629d5c4@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-10-saeedm@mellanox.com>
 <20190505154212.GC31501@nanopsycho.orion>
In-Reply-To: <20190505154212.GC31501@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM4P190CA0004.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::14) To AM5PR0501MB2546.eurprd05.prod.outlook.com
 (2603:10a6:203:c::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5140049-c14d-4303-1c20-08d6d20ffd6f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM5PR0501MB2370;
x-ms-traffictypediagnostic: AM5PR0501MB2370:
x-microsoft-antispam-prvs: <AM5PR0501MB2370CCF5E08A55EE3F247FEDD9300@AM5PR0501MB2370.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(305945005)(86362001)(107886003)(6246003)(6512007)(2616005)(476003)(486006)(478600001)(11346002)(53936002)(6636002)(6486002)(229853002)(65826007)(14444005)(256004)(81166006)(81156014)(25786009)(8936002)(8676002)(5660300002)(4326008)(31696002)(6506007)(102836004)(7736002)(26005)(53546011)(186003)(446003)(386003)(68736007)(64756008)(14454004)(66556008)(66446008)(66946007)(73956011)(66476007)(65956001)(2906002)(6116002)(3846002)(6436002)(36756003)(316002)(31686004)(71200400001)(58126008)(110136005)(99286004)(52116002)(54906003)(76176011)(65806001)(71190400001)(66066001)(64126003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0501MB2370;H:AM5PR0501MB2546.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Vze4G6y43PwDug894kJLN5oO9eV47YfkSNMM+C1FplPirMh8JJV+0EdRLODMoVFBvi+eM0B0ZXODlHAZS/PZmS7vC6T0lrLiakVL2WNjuDgveym2egml0FJacy9Vn+8SoMaxqZhjmtnFlpeeZtzIQu3Bsl/Is7oIBDWDFGAfKndjARoTDk9ne+zFc0+WOm0xk51sEEu+ww3L+NqLUpTKu1st/HprHttXqQL3qwc/hPM4o9dsCaTMJwCb55aw7pHxMUKplYGrWb8LrfgGrCi91Pr4r72Fra8/X6b9eCFRm/ClbiWUtJpPHlUxf3iiIZAHItmkecIZWJ6gObtemaH4+EpzJRVYx4rU/pLyZDNEs0sh7CSPAqVlkKnaj35Im4ihyp/QYD3Abl3R5N5McKlzTqegCUl4OWJ3KRZdlIcpXjU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91776E6B4A9C5545BBBAA1D8E309E45A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5140049-c14d-4303-1c20-08d6d20ffd6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 10:45:44.0986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0501MB2370
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvNS8yMDE5IDY6NDIgUE0sIEppcmkgUGlya28gd3JvdGU6DQo+IFN1biwgTWF5IDA1
LCAyMDE5IGF0IDAyOjMzOjIzQU0gQ0VTVCwgc2FlZWRtQG1lbGxhbm94LmNvbSB3cm90ZToNCj4+
IEZyb206IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NCj4+DQo+PiBDcmVhdGUg
bWx4NV9kZXZsaW5rX2hlYWx0aF9yZXBvcnRlciBmb3IgRlcgcmVwb3J0ZXIuIFRoZSBGVyByZXBv
cnRlcg0KPj4gaW1wbGVtZW50cyBkZXZsaW5rX2hlYWx0aF9yZXBvcnRlciBkaWFnbm9zZSBjYWxs
YmFjay4NCj4+DQo+PiBUaGUgZncgcmVwb3J0ZXIgZGlhZ25vc2UgY29tbWFuZCBjYW4gYmUgdHJp
Z2dlcmVkIGFueSB0aW1lIGJ5IHRoZSB1c2VyDQo+PiB0byBjaGVjayBjdXJyZW50IGZ3IHN0YXR1
cy4NCj4+IEluIGhlYWx0aHkgc3RhdHVzLCBpdCB3aWxsIHJldHVybiBjbGVhciBzeW5kcm9tZS4g
T3RoZXJ3aXNlIGl0IHdpbGwgZHVtcA0KPj4gdGhlIGhlYWx0aCBpbmZvIGJ1ZmZlci4NCj4+DQo+
PiBDb21tYW5kIGV4YW1wbGUgYW5kIG91dHB1dCBvbiBoZWFsdGh5IHN0YXR1czoNCj4+ICQgZGV2
bGluayBoZWFsdGggZGlhZ25vc2UgcGNpLzAwMDA6ODI6MDAuMCByZXBvcnRlciBmdw0KPj4gU3lu
ZHJvbWU6IDANCj4+DQo+PiBDb21tYW5kIGV4YW1wbGUgYW5kIG91dHB1dCBvbiBub24gaGVhbHRo
eSBzdGF0dXM6DQo+PiAkIGRldmxpbmsgaGVhbHRoIGRpYWdub3NlIHBjaS8wMDAwOjgyOjAwLjAg
cmVwb3J0ZXIgZncNCj4+IGRpYWdub3NlIGRhdGE6DQo+PiBhc3NlcnRfdmFyWzBdIDB4ZmMzZmMw
NDMNCj4+IGFzc2VydF92YXJbMV0gMHgwMDAxYjQxYw0KPj4gYXNzZXJ0X3ZhclsyXSAweDAwMDAw
MDAwDQo+PiBhc3NlcnRfdmFyWzNdIDB4MDAwMDAwMDANCj4+IGFzc2VydF92YXJbNF0gMHgwMDAw
MDAwMA0KPj4gYXNzZXJ0X2V4aXRfcHRyIDB4MDA4MDMzYjQNCj4+IGFzc2VydF9jYWxscmEgMHgw
MDgwMzY1Yw0KPj4gZndfdmVyIDE2LjI0LjEwMDANCj4+IGh3X2lkIDB4MDAwMDAyMGQNCj4+IGly
aXNjX2luZGV4IDANCj4+IHN5bmQgMHg4OiB1bnJlY292ZXJhYmxlIGhhcmR3YXJlIGVycm9yDQo+
PiBleHRfc3luZCAweDAwM2QNCj4+IHJhdyBmd192ZXIgMHgxMDE4MDNlOA0KPj4NCj4+IFNpZ25l
ZC1vZmYtYnk6IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NCj4+IFNpZ25lZC1v
ZmYtYnk6IEVyYW4gQmVuIEVsaXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4+IFNpZ25lZC1v
ZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiANCj4gCQ0KPiBb
Li4uXQkNCj4gCQ0KPiAJDQo+PiArc3RhdGljIGludA0KPj4gK21seDVfZndfcmVwb3J0ZXJfZGlh
Z25vc2Uoc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyICpyZXBvcnRlciwNCj4+ICsJCQkg
IHN0cnVjdCBkZXZsaW5rX2Ztc2cgKmZtc2cpDQo+PiArew0KPj4gKwlzdHJ1Y3QgbWx4NV9jb3Jl
X2RldiAqZGV2ID0gZGV2bGlua19oZWFsdGhfcmVwb3J0ZXJfcHJpdihyZXBvcnRlcik7DQo+PiAr
CXN0cnVjdCBtbHg1X2NvcmVfaGVhbHRoICpoZWFsdGggPSAmZGV2LT5wcml2LmhlYWx0aDsNCj4+
ICsJdTggc3luZDsNCj4+ICsJaW50IGVycjsNCj4+ICsNCj4+ICsJbXV0ZXhfbG9jaygmaGVhbHRo
LT5pbmZvX2J1Zl9sb2NrKTsNCj4+ICsJbWx4NV9nZXRfaGVhbHRoX2luZm8oZGV2LCAmc3luZCk7
DQo+PiArDQo+PiArCWlmICghc3luZCkgew0KPj4gKwkJbXV0ZXhfdW5sb2NrKCZoZWFsdGgtPmlu
Zm9fYnVmX2xvY2spOw0KPj4gKwkJcmV0dXJuIGRldmxpbmtfZm1zZ191OF9wYWlyX3B1dChmbXNn
LCAiU3luZHJvbWUiLCBzeW5kKTsNCj4+ICsJfQ0KPj4gKw0KPj4gKwllcnIgPSBkZXZsaW5rX2Zt
c2dfc3RyaW5nX3BhaXJfcHV0KGZtc2csICJkaWFnbm9zZSBkYXRhIiwNCj4+ICsJCQkJCSAgIGhl
YWx0aC0+aW5mb19idWYpOw0KPiANCj4gTm8hIFRoaXMgaXMgd3JvbmchIFlvdSBhcmUgc25lYWtp
bmcgaW4gdGV4dCBibG9iLiBQbGVhc2UgcHV0IHRoZSBpbmZvIGluDQo+IHN0cnVjdHVyZWQgZm9y
bSB1c2luZyBwcm9wZXIgZm1zZyBoZWxwZXJzLg0KPiANClRoaXMgaXMgdGhlIGZ3IG91dHB1dCBm
b3JtYXQsIGl0IGlzIGFscmVhZHkgaW4gdXNlLCBJIGRvbid0IHdhbnQgdG8gDQpjaGFuZ2UgaXQs
IGp1c3QgaGF2ZSBpdCBoZXJlIGluIHRoZSBkaWFnbm9zZSBvdXRwdXQgdG9vLg0K
