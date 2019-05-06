Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686CF14899
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfEFKyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:54:03 -0400
Received: from mail-eopbgr00046.outbound.protection.outlook.com ([40.107.0.46]:33983
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbfEFKyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 06:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8Z0I9VScOt6VeP+6QLDeELm+h4b+4y8ypyzMKR4BUk=;
 b=dMKD9sCcWewAjfMpJ9cbfZAixXsFAt8VMOA2BcJlnvshObJJlxPp6GCW551qD1cOFut68cbxI3f5Lrej4Ktb+B9xXDo8DULeVSjF1byc9bLkfZ7ItbLCPVIVYX5RKE94duGURi8ztPMpP0lGQyVNAq+DnyORuFhckbm+f8yf6QM=
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com (10.169.150.142) by
 AM5PR0501MB2484.eurprd05.prod.outlook.com (10.169.153.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Mon, 6 May 2019 10:54:00 +0000
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a]) by AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a%2]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 10:54:00 +0000
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 14/15] net/mlx5: Add support for FW fatal reporter dump
Thread-Topic: [net-next 14/15] net/mlx5: Add support for FW fatal reporter
 dump
Thread-Index: AQHVAtorycA5HCVlPkqR2luU2dyXFKZcr3KAgAE+24A=
Date:   Mon, 6 May 2019 10:54:00 +0000
Message-ID: <4d297327-ec38-c0c9-cb9c-df09443f433d@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-15-saeedm@mellanox.com>
 <20190505155243.GG31501@nanopsycho.orion>
In-Reply-To: <20190505155243.GG31501@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR01CA0014.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::27) To AM5PR0501MB2546.eurprd05.prod.outlook.com
 (2603:10a6:203:c::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6673fd01-c5e3-415a-178d-08d6d211252f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM5PR0501MB2484;
x-ms-traffictypediagnostic: AM5PR0501MB2484:
x-microsoft-antispam-prvs: <AM5PR0501MB24841E8CC0BA2B3827E09FACD9300@AM5PR0501MB2484.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(396003)(346002)(376002)(189003)(199004)(58126008)(54906003)(99286004)(8676002)(110136005)(476003)(486006)(25786009)(6486002)(4326008)(6436002)(31686004)(256004)(36756003)(8936002)(14454004)(5660300002)(3846002)(6116002)(229853002)(478600001)(81166006)(81156014)(2906002)(11346002)(2616005)(53546011)(386003)(65826007)(6506007)(26005)(102836004)(186003)(6246003)(86362001)(305945005)(316002)(68736007)(31696002)(107886003)(7736002)(6512007)(6636002)(53936002)(71190400001)(71200400001)(64126003)(65806001)(66066001)(65956001)(66446008)(73956011)(66946007)(66556008)(66476007)(446003)(52116002)(64756008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0501MB2484;H:AM5PR0501MB2546.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EOJ+XYihDvzpTlPYLARJ87doZQVoaquI7A8XJ+10oE7r01kYwbwhOLb0r0qPHjOHVm0DBc0FQjASZzUF0RWx7Uzpfd4b7akGQsTrMeodIBwimESOqVVfBj++KQ6PaxWWQdjZalMUxOEFmf1HE9PsMk2qdVQBZWJWyYbhtemZA6FQMq38lTfGe1jCagF40/S+l62v18C7liqP5b2WU74z/LmCS+9na3AG4AU+C34xUtHvqyPPL4rpo043TWKL4/g8rCVbIuTCVvUgfNFktJr5xh6jnF6coTLvJ0KKyyDuUTdKlJzLr0ONWZ6ssDAh9PRoZKESDIr91vb1kFpdZO358xX1hQIYrs0lYe56MaHQbzuSNVZkUAJfI0sTh2IAkK01cyByswDyBIVW06Pguk13m7L2sS9fJI21+p5HICvZ5F0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57B2E354A9EE284896628A69ACE72EC4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6673fd01-c5e3-415a-178d-08d6d211252f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 10:54:00.2646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0501MB2484
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvNS8yMDE5IDY6NTIgUE0sIEppcmkgUGlya28gd3JvdGU6DQo+IFN1biwgTWF5IDA1
LCAyMDE5IGF0IDAyOjMzOjMzQU0gQ0VTVCwgc2FlZWRtQG1lbGxhbm94LmNvbSB3cm90ZToNCj4+
IEZyb206IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NCj4+DQo+PiBBZGQgc3Vw
cG9ydCBvZiBkdW1wIGNhbGxiYWNrIGZvciBtbHg1IEZXIGZhdGFsIHJlcG9ydGVyLg0KPj4gVGhl
IEZXIGZhdGFsIGR1bXAgdXNlIGNyLWR1bXAgZnVuY3Rpb25hbGl0eSB0byBnYXRoZXIgY3Itc3Bh
Y2UgZGF0YSBmb3INCj4+IGRlYnVnLiBUaGUgY3ItZHVtcCB1c2VzIHZzYyBpbnRlcmZhY2Ugd2hp
Y2ggaXMgdmFsaWQgZXZlbiBpZiB0aGUgRlcNCj4+IGNvbW1hbmQgaW50ZXJmYWNlIGlzIG5vdCBm
dW5jdGlvbmFsLCB3aGljaCBpcyB0aGUgY2FzZSBpbiBtb3N0IEZXIGZhdGFsDQo+PiBlcnJvcnMu
DQo+PiBUaGUgY3ItZHVtcCBpcyBzdG9yZWQgYXMgYSBtZW1vcnkgcmVnaW9uIHNuYXBzaG90IHRv
IGVhc2UgcmVhZCBieQ0KPj4gYWRkcmVzcy4NCj4+DQo+PiBDb21tYW5kIGV4YW1wbGUgYW5kIG91
dHB1dDoNCj4+ICQgZGV2bGluayBoZWFsdGggZHVtcCBzaG93IHBjaS8wMDAwOjgyOjAwLjAgcmVw
b3J0ZXIgZndfZmF0YWwNCj4+IGRldmxpbmtfcmVnaW9uX25hbWU6IGNyLXNwYWNlIHNuYXBzaG90
X2lkOiAxDQo+Pg0KPj4gJCBkZXZsaW5rIHJlZ2lvbiByZWFkIHBjaS8wMDAwOjgyOjAwLjAvY3It
c3BhY2Ugc25hcHNob3QgMSBhZGRyZXNzIDk4MzA2NCBsZW5ndGggOA0KPj4gMDAwMDAwMDAwMDBm
MDAxOCBlMSAwMyAwMCAwMCBmYiBhZSBhOSAzZg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IE1vc2hl
IFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1h
aGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPj4gLS0tDQo+PiAuLi4vbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYyAgfCAzOSArKysrKysrKysrKysrKysrKysrDQo+
PiAxIGZpbGUgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMNCj4+IGluZGV4IGU2NGYw
ZTMyY2Q2Ny4uNTI3MWM4OGVmNjRjIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2hlYWx0aC5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMNCj4+IEBAIC01NDcsOSArNTQ3LDQ4IEBA
IG1seDVfZndfZmF0YWxfcmVwb3J0ZXJfcmVjb3ZlcihzdHJ1Y3QgZGV2bGlua19oZWFsdGhfcmVw
b3J0ZXIgKnJlcG9ydGVyLA0KPj4gCXJldHVybiBtbHg1X2hlYWx0aF9jYXJlKGRldik7DQo+PiB9
DQo+Pg0KPj4gK3N0YXRpYyBpbnQNCj4+ICttbHg1X2Z3X2ZhdGFsX3JlcG9ydGVyX2R1bXAoc3Ry
dWN0IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyICpyZXBvcnRlciwNCj4+ICsJCQkgICAgc3RydWN0
IGRldmxpbmtfZm1zZyAqZm1zZywgdm9pZCAqcHJpdl9jdHgpDQo+PiArew0KPj4gKwlzdHJ1Y3Qg
bWx4NV9jb3JlX2RldiAqZGV2ID0gZGV2bGlua19oZWFsdGhfcmVwb3J0ZXJfcHJpdihyZXBvcnRl
cik7DQo+PiArCWNoYXIgY3JkdW1wX3JlZ2lvblsyMF07DQo+PiArCXUzMiBzbmFwc2hvdF9pZDsN
Cj4+ICsJaW50IGVycjsNCj4+ICsNCj4+ICsJaWYgKCFtbHg1X2NvcmVfaXNfcGYoZGV2KSkgew0K
Pj4gKwkJbWx4NV9jb3JlX2VycihkZXYsICJPbmx5IFBGIGlzIHBlcm1pdHRlZCBydW4gRlcgZmF0
YWwgZHVtcFxuIik7DQo+PiArCQlyZXR1cm4gLUVQRVJNOw0KPj4gKwl9DQo+PiArDQo+PiArCWVy
ciA9IG1seDVfY3JkdW1wX2NvbGxlY3QoZGV2LCBjcmR1bXBfcmVnaW9uLCAmc25hcHNob3RfaWQp
Ow0KPj4gKwlpZiAoZXJyKQ0KPj4gKwkJcmV0dXJuIGVycjsNCj4+ICsNCj4+ICsJaWYgKHByaXZf
Y3R4KSB7DQo+PiArCQlzdHJ1Y3QgbWx4NV9md19yZXBvcnRlcl9jdHggKmZ3X3JlcG9ydGVyX2N0
eCA9IHByaXZfY3R4Ow0KPj4gKw0KPj4gKwkJZXJyID0gbWx4NV9md19yZXBvcnRlcl9jdHhfcGFp
cnNfcHV0KGZtc2csIGZ3X3JlcG9ydGVyX2N0eCk7DQo+PiArCQlpZiAoZXJyKQ0KPj4gKwkJCXJl
dHVybiBlcnI7DQo+PiArCX0NCj4+ICsNCj4+ICsJZXJyID0gZGV2bGlua19mbXNnX3N0cmluZ19w
YWlyX3B1dChmbXNnLCAiZGV2bGlua19yZWdpb25fbmFtZSIsDQo+PiArCQkJCQkgICBjcmR1bXBf
cmVnaW9uKTsNCj4gDQo+IE9oIGNvbWUgb24uIFlvdSBjYW5ub3QgYmUgc2VyaW91cyA6LyBQbGVh
c2UgZG8gcHJvcGVyIGxpbmthZ2UgdG8gcmVnaW9uDQo+IGFuZCBzbmFwc2hvdCBpbiBkZXZsaW5r
IGNvcmUuDQo+IA0KDQpOb3Qgc3VyZSBJIHVuZGVyc3RhbmQgd2hhdCB5b3UgbWVhbiwgYXMgSSB3
cm90ZSBpbiB0aGUgY29tbWl0IG1lc3NhZ2UsIA0KdGhlIHJlZ2lvbiBzbmFwc2hvdCBhZGRlZCB2
YWx1ZSBoZXJlLCBpcyB0aGF0IHVzZXIgY2FuIHJlYWQgZGF0YSBieSBvZmZzZXQuDQoNCj4gDQo+
IA0KPj4gKwlpZiAoZXJyKQ0KPj4gKwkJcmV0dXJuIGVycjsNCj4+ICsNCj4+ICsJZXJyID0gZGV2
bGlua19mbXNnX3UzMl9wYWlyX3B1dChmbXNnLCAic25hcHNob3RfaWQiLCBzbmFwc2hvdF9pZCk7
DQo+PiArCWlmIChlcnIpDQo+PiArCQlyZXR1cm4gZXJyOw0KPj4gKw0KPj4gKwlyZXR1cm4gMDsN
Cj4+ICt9DQo+PiArDQo+PiBzdGF0aWMgY29uc3Qgc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9y
dGVyX29wcyBtbHg1X2Z3X2ZhdGFsX3JlcG9ydGVyX29wcyA9IHsNCj4+IAkJLm5hbWUgPSAiZndf
ZmF0YWwiLA0KPj4gCQkucmVjb3ZlciA9IG1seDVfZndfZmF0YWxfcmVwb3J0ZXJfcmVjb3ZlciwN
Cj4+ICsJCS5kdW1wID0gbWx4NV9md19mYXRhbF9yZXBvcnRlcl9kdW1wLA0KPj4gfTsNCj4+DQo+
PiAjZGVmaW5lIE1MWDVfUkVQT1JURVJfRldfR1JBQ0VGVUxfUEVSSU9EIDEyMDAwMDANCj4+IC0t
IA0KPj4gMi4yMC4xDQo+Pg0K
