Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234A015B100
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgBLT30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:29:26 -0500
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:6075
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729098AbgBLT3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 14:29:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjzETuMuxEBmKIzFXvrxUrkZ30d2NLGD/ulLFn2p2QaNBMN6LsAIUBX0bsqSQZtrJ+tlhu2bZQ535/uUHzsGpO89Uvsifz8qP0UJRLcx7stu7PdD/IGWZD/f/u8V6lNr1pkuFOmhHVGnPehxqG4tTWH9ioO2YXOvxoMN2rpikXK+3l3QbojrxNEtJp89PnPzLk8wjvet6ecACh86mM0GzumWvKyM3qGUzUDF5HtqjzTwoXJewNVtNHKNa3P6FVNoCY/uXxszYT3A/txWTAt2kz8vnsF+f/0rS19w06bRJGfGovCvvlWtealf15pZTtZJGTC2lsPw7cFdDgJuvP+jdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpxFCKeNYYaVgVeq9zOsQy1mnxiizKCRlG9gI+CVedE=;
 b=kTnCRHN6C7siCyNSAQVe/hTchlBlVFJzNeSY521XdQPtv38n9kmTlGOhB8O8LhTJn349/Yii5lvebgiKGHUA5tBvJlkgor+Pb5JSF0OllGrwOheuD9djYeerC78WPS8GhJZM0qiqgb6isoB9JArpGVhIA8kmSvckYxpIuWPe/1TcO9aEtbC6qf/cnb+gMkgxEiGhz/XK2CVgnieqY6nFJARzthzK1v3Ik35IPdqGubb9hTQbZy1ZaM1jgDlb76TVTYpDzds4CihsvOVwWwAmQ3MXh+/e8z7TCiT21ljIX10y7j+t5DICuWGCH7LF9rFyrsoKRBgpuYYAkVzjRFYUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpxFCKeNYYaVgVeq9zOsQy1mnxiizKCRlG9gI+CVedE=;
 b=gRMNF9Aa2KuQg2lhoj4Ow02V7L3Bpy38Mu3twerCI1jCPI4htTAFP+cSn6CH0SScwMbFYxrY2lNRlidY1/eFuLXk/rKiPIed4zi3uqJ1UcLsSpQNGBPCV8/s61HiWHjsAgp2xtK95XnrMG2/piFq2SUNBCuTh7fef5toEGFr0k8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6767.eurprd05.prod.outlook.com (10.186.160.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 12 Feb 2020 19:29:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 19:29:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next V3 00/13] Mellanox, mlx5 updates
 2020-01-24
Thread-Topic: [pull request][net-next V3 00/13] Mellanox, mlx5 updates
 2020-01-24
Thread-Index: AQHV4SuUZbQoaccCvUWFDYDbDhBaaqgWoZ2AgAFRfQA=
Date:   Wed, 12 Feb 2020 19:29:22 +0000
Message-ID: <1b6d59f2e063779605a1ec77d15705185c982ead.camel@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
         <CAL3LdT5Z1Ba5fsfCwqndcVgT+dYoeJAJ6Ph6BzuaQO=KBVppgg@mail.gmail.com>
In-Reply-To: <CAL3LdT5Z1Ba5fsfCwqndcVgT+dYoeJAJ6Ph6BzuaQO=KBVppgg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5d57f5c2-e514-4e66-26dd-08d7aff1dcd3
x-ms-traffictypediagnostic: VI1PR05MB6767:
x-microsoft-antispam-prvs: <VI1PR05MB67677724C3C6B466FA69F1C9BE1B0@VI1PR05MB6767.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(199004)(189003)(91956017)(76116006)(66946007)(26005)(6916009)(4326008)(66446008)(66476007)(64756008)(66556008)(8676002)(8936002)(81166006)(81156014)(54906003)(15650500001)(478600001)(316002)(36756003)(6486002)(2906002)(86362001)(6506007)(53546011)(6512007)(186003)(5660300002)(2616005)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6767;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fGYUXyfMikPgjpdXIdqlYXW9d6cLuIfBwqWSE2tq58dz+tcbTFmK+WrjRC34DL2lbynVG21wkIU/MHJ5fW2yWeG8i6zpm+iwvB+T113dSZpjYSUdZNoW7WShUZYI4OigD0SjASzS8Tv5zWsKM0PSNF4JLVCNLBLJdhqyphNeAJb03/i0Bb5nJ+Y4UWcN6DMCjJy0HypG/vg9hW36L/AfR3mMJGB6iM5kNz+Y3IRVxcpDH0sLtn38x/3P5l+wD4BM8UKuYazrf09bHKqgvPg5ieIGtgQCcbTIKEnFEJxeoEn5KuV9Yc1mIa3eZHAJnh2V0Uzz4Kt39r4UEg+U9cng2MF5eO+LCR7ZjH7RNi8M+8amk+6+7xCdxCzxIHxe2t9mv4/vYNf8PPbASfW0egpYAL3ZsYSuwQYq+ONe+7b4JjR0KVs5bsinyJ0lvusGYRRq
x-ms-exchange-antispam-messagedata: QRRf3iKC+ZhSAtuu7nFcMoA9GYt4BBwhhUvnREn2OuEux4Nsw/oMOzwYGs4rVIPx3e5SKKRFUe84hmL/7fheZCL0AsHYQrrVRAAqboxI97svf0TfyuGId3ojiXhstMA54szV7Au7VRQkuiO2ennjXw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F274758CA350F439658CCF06999557C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d57f5c2-e514-4e66-26dd-08d7aff1dcd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 19:29:22.1430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Isxb9H6+32oVKgtysLC09rqW5OaJt0tsZh+GfRJU23RjIg7XOOUVoLq9+jRnLQlMKrdwosLqArDOqOCY/N28JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6767
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTExIGF0IDE1OjIxIC0wODAwLCBKZWZmIEtpcnNoZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgRmViIDExLCAyMDIwIGF0IDI6MzYgUE0gU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBt
ZWxsYW5veC5jb20+DQo+IHdyb3RlOg0KPiA+IEhpIERhdmUsDQo+ID4gDQo+ID4gVGhpcyBzZXJp
ZXMgYWRkcyBzb21lIHVwZGF0ZXMgdG8gbWx4NSBkcml2ZXINCj4gPiAxKSBEZXZsaW5rIGhlYWx0
aCBkdW1wIHN1cHBvcnQgZm9yIGJvdGggcnggYW5kIHR4IGhlYWx0aCByZXBvcnRlcnMuDQo+ID4g
MikgRkVDIG1vZGVzIHN1cHBvcnRzLg0KPiA+IDMpIHR3byBtaXNjIHNtYWxsIHBhdGNoZXMuDQo+
ID4gDQo+ID4gVjM6DQo+ID4gIC0gSW1wcm92ZSBldGh0b29sIHBhdGNoICJGRUMgTExSUyIgY29t
bWl0IG1lc3NhZ2UgYXMgcmVxdWVzdGVkIGJ5DQo+ID4gICAgQW5kcmV3IEx1bm4uDQo+ID4gIC0g
U2luY2Ugd2UndmUgbWlzc2VkIHRoZSBsYXN0IGN5Y2xlLCBkcm9wcGVkIHR3byBzbWFsbCBmaXhl
cw0KPiA+IHBhdGNoZXMsDQo+ID4gICAgYXMgdGhleSBzaG91bGQgZ28gdG8gbmV0IG5vdy4NCj4g
PiANCj4gPiBWMjoNCj4gPiAgLSBSZW1vdmUgIlxuIiBmcm9tIHNucHJpbnRmLCBoYXBwZW5lZCBk
dWUgdG8gcmViYXNlIHdpdGggYQ0KPiA+IGNvbmZsaWN0aW5nDQo+ID4gICAgZmVhdHVyZSwgVGhh
bmtzIEpvZSBmb3Igc3BvdHRpbmcgdGhpcy4NCj4gPiANCj4gPiBGb3IgbW9yZSBpbmZvcm1hdGlv
biBwbGVhc2Ugc2VlIHRhZyBsb2cgYmVsb3cuDQo+ID4gDQo+ID4gUGxlYXNlIHB1bGwgYW5kIGxl
dCBtZSBrbm93IGlmIHRoZXJlIGlzIGFueSBwcm9ibGVtLg0KPiA+IA0KPiA+IFBsZWFzZSBub3Rl
IHRoYXQgdGhlIHNlcmllcyBzdGFydHMgd2l0aCBhIG1lcmdlIG9mIG1seDUtbmV4dA0KPiA+IGJy
YW5jaCwNCj4gPiB0byByZXNvbHZlIGFuZCBhdm9pZCBkZXBlbmRlbmN5IHdpdGggcmRtYSB0cmVl
Lg0KPiA+IA0KPiA+IE5vdGUgYWJvdXQgbm9uLW1seDUgY2hhbmdlOg0KPiA+IEZvciB0aGUgRkVD
IGxpbmsgbW9kZXMgc3VwcG9ydCwgQXlhIGFkZGVkIHRoZSBkZWZpbmUgZm9yDQo+ID4gbG93IGxh
dGVuY3kgUmVlZCBTb2xvbW9uIEZFQyBhcyBMTFJTLCBpbjoNCj4gPiBpbmNsdWRlL3VhcGkvbGlu
dXgvZXRodG9vbC5oDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IFNhZWVkLg0KPiANCj4gRGF2ZSBo
YXMgbm90IG9wZW5lZCB1cCBuZXQtbmV4dCB5ZXQsIG9yIGRvIHlvdSBrbm93IHNvbWV0aGluZyBJ
DQo+IGRvbid0Li4uDQoNCk15IGJhZCAhDQo=
