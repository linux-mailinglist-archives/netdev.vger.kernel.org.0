Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB524AF0CA
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfIJR7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:59:35 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:12649
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfIJR7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 13:59:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHdmtCXxZ+zP+TCtvd4TZuQ46CzrsDJ2fmAClvx6AZcbV0wMDc5R8yQyQf8IDVP54DwYfqDcWxIVf/xbic0+Ah/rlxuQS4+66cu5pZ0+5OY63LcGgtCbbpUFowmaBy3f+uK50QqESV1w/sBtRpPhcQ2md9ZnAhkp0TYMX9IWPGvDVHXzbb2O/pllEG3tlM05kS7HydNRcheT0IVrbtnBdlmo9x7PyMgIBF0H704/EQ6Rfwj7Kt8ACWxLBW2SMXfMZMjfB7M1NzkISWhtpAB83dPm3IyiXbLHmm3Eg9qmFC2Wr5luUsh4MduhUgi4gqwnZqOM9riQQXkIgUqrM94s0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JGyQqaJ2uIO/E7snvTvQdEssQXNiHDFT8xv1VCgLgQ=;
 b=kd0yS25IIOUtauLYkztJPnPIp8N1hkRIPvshXWsXgf7WUf42tp1gXiCKAF7cg6XMiRoZrSCgkLFh3aRvz7c4GA038rJAEluOQ2HBPPa31wi3gSqxA2utM4PanbZKTunRQBcnTlGuohyXeK8AbZ94tB41KjnegvhIj/K0+r2ezVfwTf46GAqrcJrWoBwV92wLjaUrYYvL/0StWqZwBADnQfI9K9RRFNLe2bVgMlatF5JevTyZYlE3CLrPJClrZPS9FwFgobPyNK23ogyN7nz11TJWyVzQTtlEKPYfiKnxYyQlng7eYNNyV4Zm4WJtaFdAuRgPxhfciDKtnLlgTkN0qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JGyQqaJ2uIO/E7snvTvQdEssQXNiHDFT8xv1VCgLgQ=;
 b=OfMdIvH0FPWEBMhx2gEncrLOjkyc0X7ykQuvCVeDMN5zlx0ODth5A7BmJOsg4uw5bhupGhh5qKtthrf2TFD2VuRDPKtbvPNWENdWXxz4FLgOcYiEPhHTkr6/Yk/SlU/QUZXnSvT9GS19I4gIShyAHkuQftiBJ53mFCOxYbsQAjw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2517.eurprd05.prod.outlook.com (10.168.77.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 17:59:31 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 17:59:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "austindh.kim@gmail.com" <austindh.kim@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [PATCH] net/mlx5: Declare 'rt' as corresponding enum type
Thread-Topic: [PATCH] net/mlx5: Declare 'rt' as corresponding enum type
Thread-Index: AQHVZ7n9IryfUGriLUeqkPLSenMurKclM4eA
Date:   Tue, 10 Sep 2019 17:59:31 +0000
Message-ID: <61418cb7514460e24bfcd431eee9c540e795fcbc.camel@mellanox.com>
References: <20190910092731.GA173476@LGEARND20B15>
In-Reply-To: <20190910092731.GA173476@LGEARND20B15>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f66e8a7-8d9a-49a0-9351-08d73618a191
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2517;
x-ms-traffictypediagnostic: DB6PR0501MB2517:|DB6PR0501MB2517:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2517185DBD1AD1320C6C22CEBEB60@DB6PR0501MB2517.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:480;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(199004)(189003)(51914003)(186003)(53936002)(66556008)(64756008)(229853002)(25786009)(6306002)(71190400001)(71200400001)(14444005)(305945005)(446003)(11346002)(7736002)(118296001)(478600001)(110136005)(14454004)(58126008)(66066001)(5660300002)(6116002)(3846002)(66946007)(6512007)(6486002)(66476007)(76116006)(107886003)(81156014)(2906002)(966005)(2501003)(316002)(54906003)(6246003)(256004)(102836004)(6506007)(76176011)(6436002)(86362001)(8676002)(26005)(36756003)(91956017)(2616005)(81166006)(486006)(8936002)(66446008)(99286004)(476003)(4326008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2517;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gP4AnRiT1XSDydRp7dGuD6uUF2A74jHJcLTaIHw5I14AY8nIKU6dZlWtD20+y0AWU/v+L//tfQvpvUILM2SeFAHxU+c4iyQYOEJFPDuiaJUiEZLvIsjOL0g8ghmKDGGZpRduDpUwBtDCjnCAcaoBxuj+yXiyHufxkBc8VHW7o1uU2T6sGQUNRqtC/5RG2inSnQLpqT4bNOoBDiN4DR+LL3PjW2GKw9aWNwOVRQUq+LYSoBrnQcTrWmgefHaIcs16sopdGEJkMhgqfaDfDMWu+cRL0XqkM8CG2yD7fsxcFRVMIV3NRmhbhY52Xf8/Kqi7k/o3mAoOwnYFjkdBzDJzD+hCYHrtLMlkjgBWcPXtdXbk53N/KTIpjQXRJDKd1qYoq5ofVmrMa6w+zJT3TxzZOoCat/zs5FZ3kiTWGpZks2E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEF86596DCCADF4A8A5EAEA81836100C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f66e8a7-8d9a-49a0-9351-08d73618a191
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 17:59:31.2442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ENwtLEZJNOUQ4axZ0NutPd7v+883Y9Ct1IHndY/MIYUVGwlDKp0Gn1gKSUUHhnY8IzTkWOfa0F/DNGmigLJP+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2517
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTEwIGF0IDE4OjI3ICswOTAwLCBBdXN0aW4gS2ltIHdyb3RlOg0KPiBX
aGVuIGJ1aWxkaW5nIGtlcm5lbCB3aXRoIGNsYW5nLCB3ZSBjYW4gb2JzZXJ2ZSBiZWxvdyB3YXJu
aW5nDQo+IG1lc3NhZ2U6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvc3RlZXJpbmcvZHJfYWN0aW9uLmM6MTA4MDo5Og0KPiB3YXJuaW5nOiBpbXBsaWNpdCBj
b252ZXJzaW9uIGZyb20gZW51bWVyYXRpb24gdHlwZSAnZW51bQ0KPiBtbHg1X3JlZm9ybWF0X2N0
eF90eXBlJw0KPiB0byBkaWZmZXJlbnQgZW51bWVyYXRpb24gdHlwZSAnZW51bSBtbHg1ZHJfYWN0
aW9uX3R5cGUnIFstICAgV2VudW0tDQo+IGNvbnZlcnNpb25dDQo+IAlydCA9IE1MWDVfUkVGT1JN
QVRfVFlQRV9MMl9UT19MMl9UVU5ORUw7DQo+ICAgICAgICAJCQkgIH4gXn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvc3RlZXJpbmcvZHJfYWN0aW9uLmM6MTA4Mjo5Og0KPiB3YXJuaW5nOiBpbXBsaWNpdCBj
b252ZXJzaW9uIGZyb20gZW51bWVyYXRpb24gdHlwZSAnZW51bQ0KPiBtbHg1X3JlZm9ybWF0X2N0
eF90eXBlJw0KPiB0byBkaWZmZXJlbnQgZW51bWVyYXRpb24gdHlwZSAnZW51bSBtbHg1ZHJfYWN0
aW9uX3R5cGUnIFstICAgV2VudW0tDQo+IGNvbnZlcnNpb25dDQo+IAlydCA9IE1MWDVfUkVGT1JN
QVRfVFlQRV9MMl9UT19MM19UVU5ORUw7DQo+ICAgICAgICAgfiBefn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9zdGVlcmluZy9kcl9hY3Rpb24uYzoxMDg0OjUxOg0KPiB3YXJuaW5nOiBpbXBsaWNpdCBjb252
ZXJzaW9uIGZyb20gZW51bWVyYXRpb24gdHlwZSAnZW51bQ0KPiBtbHg1ZHJfYWN0aW9uX3R5cGUn
DQo+IHRvIGRpZmZlcmVudCBlbnVtZXJhdGlvbiB0eXBlICdlbnVtIG1seDVfcmVmb3JtYXRfY3R4
X3R5cGUnDQo+IFstICBXZW51bS1jb252ZXJzaW9uXQ0KPiAJcmV0ID0gbWx4NWRyX2NtZF9jcmVh
dGVfcmVmb3JtYXRfY3R4KGRtbi0+bWRldiwgcnQsIGRhdGFfc3osDQo+IGRhdGEsDQo+ICAgICAg
ICAgIH5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fiAgICAgICAgICAgIF5+DQo+IA0KPiBE
ZWNsYXJlICdydCcgYXMgY29ycmVzcG9uZGluZyBlbnVtIG1seDVfcmVmb3JtYXRfY3R4X3R5cGUg
dHlwZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEF1c3RpbiBLaW0gPGF1c3RpbmRoLmtpbUBnbWFp
bC5jb20+DQpIaSBBdXN0aW4sIFRoYW5rcyBmb3IgdGhlIHBhdGNoOg0KDQpXZSBhbHJlYWR5IGhh
dmUgYSBzaW1pbGFyIHBhdGNoIHF1ZXVlZCBmb3Igc3VibWlzc2lvbi4NCmh0dHBzOi8vcGF0Y2h3
b3JrLm96bGFicy5vcmcvcGF0Y2gvMTE1ODE3NS8NCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zdGVlcmluZy9kcl9hY3Rpb24uYyB8IDIgKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdA0KPiBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zdGVl
cmluZy9kcl9hY3Rpb24uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9zdGVlcmluZy9kcl9hY3Rpb24uYw0KPiBpbmRleCBhMDJmODdmLi43ZDgxYTc3IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc3RlZXJp
bmcvZHJfYWN0aW9uLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL3N0ZWVyaW5nL2RyX2FjdGlvbi5jDQo+IEBAIC0xMDc0LDcgKzEwNzQsNyBAQCBkcl9h
Y3Rpb25fY3JlYXRlX3JlZm9ybWF0X2FjdGlvbihzdHJ1Y3QNCj4gbWx4NWRyX2RvbWFpbiAqZG1u
LA0KPiAgCWNhc2UgRFJfQUNUSU9OX1RZUF9MMl9UT19UTkxfTDI6DQo+ICAJY2FzZSBEUl9BQ1RJ
T05fVFlQX0wyX1RPX1ROTF9MMzoNCj4gIAl7DQo+IC0JCWVudW0gbWx4NWRyX2FjdGlvbl90eXBl
IHJ0Ow0KPiArCQllbnVtIG1seDVfcmVmb3JtYXRfY3R4X3R5cGUgcnQ7DQo+ICANCj4gIAkJaWYg
KGFjdGlvbi0+YWN0aW9uX3R5cGUgPT0gRFJfQUNUSU9OX1RZUF9MMl9UT19UTkxfTDIpDQo+ICAJ
CQlydCA9IE1MWDVfUkVGT1JNQVRfVFlQRV9MMl9UT19MMl9UVU5ORUw7DQo=
