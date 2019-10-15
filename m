Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8BAD80F1
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbfJOU00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:26:26 -0400
Received: from mail-eopbgr50074.outbound.protection.outlook.com ([40.107.5.74]:50926
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728692AbfJOU00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:26:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FckKsZmrKJQsHfmMt/2TnkUpO6aefkp//f1D3eiMUIgXQmOTDwHLO4I5qO3yc8ryJVj3K0JVZmPWfW+q3JwwvmWLzUrsTuhT9UulSImGJNXvada/8Mxu1UP6sZ/it7JHgJIdk4ne9DBVoo5D+LRGlGh7aq6C3TJJKEf//kFigJhnKtmXvzM4jMJtkXlQgzKJGwBYMCP6Vaijla9plA9yicsWirA1WiWZQ/HY1vtJtHlzrxOSfxcKFZcCIIKVtQ7coNMZO/RR4GK9M3JZEAXouX9lIueMUpFv8S8GEJtpe2xR4Mh1m36VsM6X3ty5jeIA/Mcbm/c8A0btdDuZJnqu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpR5kazZHW3L4NnXjuui2d0H1qhnWLIoxsuDfMSSYTY=;
 b=nKr+PyY/msBrNtDAA8kyle2wnLtKE7WrC/nREigvJGtkIR8QmpBzxzJFocRo3ZvWoNzXhF/+iSs3f75lE5URYInqUltK5nlF7Md40SWKS9/0YH+m0qmov5+6NbrK/GNQKrkw2aE1V2B0ewHJWeig34uBPqVPc/AXZ2v7r/zvZWxVvZGjGTVhVX6gxKylMV/9kFpoBCZUvbMIbs/lZZz1AENO3p3qNBT5wxFWIybbHmO7K4BD8Po7pzWx6IzITUb+Bj9uhSbaZ0V5w09pRX267BnJP/CJXvXvP6iRCI/9Dpb6+lYe4Y4wcn+1tXmdHYDoQUnSiH7SO2SU/u/BomeBkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpR5kazZHW3L4NnXjuui2d0H1qhnWLIoxsuDfMSSYTY=;
 b=szXQJS5u39Kp+CFq5dtxZJF1qfpY3/GejCSG7QegR/53d/942mdqYvVlMita9jifSWkUorNMsnOqaS8le7P8PA2cWfYRWZQEqE//JDlVgrt715JErUpgQeL3zTm9o5VSCKTEmEuizb0cgEJ1LEMvwZ+v4nhv/EO0NKQ4tN4BYbk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6384.eurprd05.prod.outlook.com (20.179.26.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 20:26:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:26:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "leon@kernel.org" <leon@kernel.org>,
        "qing.huang@oracle.com" <qing.huang@oracle.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Fixed a typo in a comment in esw_del_uc_addr()
Thread-Topic: [PATCH] net/mlx5: Fixed a typo in a comment in esw_del_uc_addr()
Thread-Index: AQHVfZvaYd0hti/8YUa6kLitVM5e6adcMmKA
Date:   Tue, 15 Oct 2019 20:26:20 +0000
Message-ID: <7c93709a9a0b62a18021a8d039d02c95d74d851a.camel@mellanox.com>
References: <20190921004928.24349-1-qing.huang@oracle.com>
         <20889bb7-0b36-831f-faa1-6bfe0e70dd94@oracle.com>
         <20191008054711.GC5855@unreal>
In-Reply-To: <20191008054711.GC5855@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7f61ac2-fe17-46a1-920b-08d751adf0e1
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB6384:
x-microsoft-antispam-prvs: <VI1PR05MB63849016F4935E75F56F08D4BE930@VI1PR05MB6384.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(189003)(199004)(2906002)(102836004)(2501003)(486006)(5660300002)(4326008)(6436002)(3846002)(66066001)(476003)(6512007)(446003)(25786009)(2616005)(11346002)(6116002)(26005)(6486002)(478600001)(229853002)(6246003)(71200400001)(71190400001)(36756003)(14444005)(316002)(256004)(305945005)(14454004)(66946007)(64756008)(66446008)(66476007)(66556008)(53546011)(8676002)(118296001)(81156014)(81166006)(76116006)(110136005)(58126008)(86362001)(91956017)(8936002)(99286004)(7736002)(76176011)(54906003)(6506007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6384;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p+6d6vLGY990xSvMGMi/lUbAXImYliV2sEEOc8KsZC76z1eZNLugtgTKjE1Z8v7T1Vea2ICSGFh6I+JerQs2/IGLt7w0mQAsFGs2C5jtEXv1ZnsxZSgl0Z+qlOohQND5oqC8irF16F6KWnXNE7OMbepm/ouAC1xjUwIRbqtqrz9xrkS9G5wF1CEQvMexCyEwCWT/fEe0xxAOdkoNUj7cysAietnKvE2hY7DQoyrvTe2UbmbqwEuQfECTXQfk00dTMpV3wLmQ1BsvCE2h66zJbWMGC1aD19+4cf5k5k7G8FB9Jbt78FILOsPBGpd618/0PCYSmsvIFYdiFECbLxiBvk2B9fiqzc7NGUzMAKw7CwKXbSkAgKzgTf161O92Muq507dD19QH/xpa0ezqXr5TWF+gs1F2NdCvemUtQrguvVg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0647BBB8146DD458E66EEAA78DFBB85@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f61ac2-fe17-46a1-920b-08d751adf0e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:26:20.7252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jhj/Zq8ypp4fmRMwSBPtTo3XvK3DBoQIII9HQhjwdWeN0VpWUgYC2XVw0LieuKwKt2swQ2cpjsY1iXH1nkgr3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6384
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTA4IGF0IDA4OjQ3ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIE1vbiwgT2N0IDA3LCAyMDE5IGF0IDA1OjM4OjU1UE0gLTA3MDAsIFFpbmcgSHVhbmcg
d3JvdGU6DQo+ID4gSSBrbm93IHRoaXMgaXMgbm90IGNyaXRpY2FsLiBNYXliZSBzb21lb25lIGNh
biBtZXJnZSB0aGlzIG9yIGZpeCBpdA0KPiA+IHdpdGgNCj4gPiBvdGhlciBjb21taXRzPyBUaGFu
a3MuDQo+IA0KPiBJdCBpcyBub3QgImxpbnV4LXJkbWEiLCBidXQgbmV0ZGV2LiBZb3VyIGNoYW5j
ZXMgd2lsbCBiZSBtdWNoIGhpZ2hlcg0KPiBpZg0KPiB5b3UgdXNlIGdldF9tYWludGFpbmVyLnBs
IGFuZCBwdXQgcmVsZXZhbnQgbWFpbGluZyBsaXN0cyB0b2dldGhlcg0KPiB3aXRoDQo+IG1haW50
YWluZXJzIGluIFRPL0NDIHBhcnRzIG9mIGFuIGVtYWlsLg0KPiANCj4gU2FlZWQgd2lsbCByZXR1
cm4gZnJvbSB2YWNhdGlvbiBhbmQgd2lsbCB0YWtlIGl0IHRvIGhpcyBuZXQtbmV4dA0KPiBwYXJ0
Lg0KPiANCg0KDQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUsIHBsZWFzZSBzdWJtaXQgYWxsIG1s
eDUgY29yZSAobmV0KSBwYXRjaGVzIHRvDQpuZXRkZXYgbWFpbGluZyBsaXN0IGluIHRoZSBmdXR1
cmUgdG8gbWFrZSBpdCBlYXNpZXIgdG8gZmluZCBhbmQgcmV2aWV3DQp0aGVzZSBwYXRjaGVzLg0K
DQpUaGFua3MsDQpTYWVlZC4NCg0KDQo+IFRoYW5rcw0KPiANCj4gPiBPbiA5LzIwLzE5IDU6NDkg
UE0sIFFpbmcgSHVhbmcgd3JvdGU6DQo+ID4gPiBDaGFuZ2VkICJtYW5hZ2Vyc3MiIHRvICJtYW5h
Z2VycyIuDQo+ID4gPiANCj4gPiA+IEZpeGVzOiBhMWIzODM5YWM0YTQgKCJuZXQvbWx4NTogRS1T
d2l0Y2gsIFByb3Blcmx5IHJlZmVyIHRvIHRoZQ0KPiA+ID4gZXN3IG1hbmFnZXIgdnBvcnQiKQ0K
PiA+ID4gU2lnbmVkLW9mZi1ieTogUWluZyBIdWFuZyA8cWluZy5odWFuZ0BvcmFjbGUuY29tPg0K
PiA+ID4gLS0tDQo+ID4gPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lc3dpdGNoLmMgfCAyICstDQo+ID4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KPiA+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQo+ID4gPiBpbmRleCA4MWUw
M2U0Li40ODY0MmI4IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KPiA+ID4gQEAgLTUzMCw3ICs1MzAsNyBA
QCBzdGF0aWMgaW50IGVzd19kZWxfdWNfYWRkcihzdHJ1Y3QNCj4gPiA+IG1seDVfZXN3aXRjaCAq
ZXN3LCBzdHJ1Y3QgdnBvcnRfYWRkciAqdmFkZHIpDQo+ID4gPiAgIAl1MTYgdnBvcnQgPSB2YWRk
ci0+dnBvcnQ7DQo+ID4gPiAgIAlpbnQgZXJyID0gMDsNCj4gPiA+IC0JLyogU2tpcCBtbHg1X21w
ZnNfZGVsX21hYyBmb3IgZXN3aXRjaCBtYW5hZ2Vyc3MsDQo+ID4gPiArCS8qIFNraXAgbWx4NV9t
cGZzX2RlbF9tYWMgZm9yIGVzd2l0Y2ggbWFuYWdlcnMsDQo+ID4gPiAgIAkgKiBpdCBpcyBhbHJl
YWR5IGRvbmUgYnkgaXRzIG5ldGRldiBpbg0KPiA+ID4gbWx4NWVfZXhlY3V0ZV9sMl9hY3Rpb24N
Cj4gPiA+ICAgCSAqLw0KPiA+ID4gICAJaWYgKCF2YWRkci0+bXBmcyB8fCBlc3ctPm1hbmFnZXJf
dnBvcnQgPT0gdnBvcnQpDQo=
