Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC22176334
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgCBSs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:48:27 -0500
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:35001
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727590AbgCBSs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 13:48:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ww2LKNfBlewkNv01yHkcz9OiqDGaVTag33tn2jDqWEKiZl989nZJftwOsmRY/3wbwj58r4vzbu207lWG3dRR8WGCjvDa+XFJFyvmH8cFPYodRAXvpm7aV6/tfFnDy8qXFtK2EqPeGif67xAD/8n5YQXYDS5nocQ2Zc6wyv+9a7JRvrGo6QX6G+XhrWCkWHRajl7I5EcZGhkLshmhZlkLukB7sthZ/ZdnYjstTE41fKZkGavqWh1ekSvphwR7ps89KJFcqyKcqg8jSRgg42gaAItEq6LvtdKgEj4jbxFP15bSIa00VFAyla2YnObTfwYw3TzyUdGY4ahLuRGKE+BJYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaBDfu2VXPgp4U41lQOxcMBYEcU37OEvdy6xSyJzm6M=;
 b=V45rj0KlNUCkB7cnMk96und7Yij9PYu53t1CQKKr5y/Z+QEPTonPgU0CyZ77z1SX4McrYRgxI1oTfFNywHqfEe5LvuDVEKoukP8aS2lHhU4saBYdClQmBakZyPIa85IioM9F6TyQQEpPmgV0ozC4Y5x8c8vtVUI1T3gtdc1ba75YdPHuoqKSSKQBPmsxIne2/VNLsu19fvqO+fZ0ik3aKdxI7ZdXwu5YV5v1+BAv2j4v7lu1OTxQ+sKM9GxpIBF6Ip1CVrffy770XspJuERnVLeqhxl9NfXNfVwNFxb5PZ9bUcA9K17IzFufL6zmQ7VNKuCBrCZOLbZOqrn0cQBzTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaBDfu2VXPgp4U41lQOxcMBYEcU37OEvdy6xSyJzm6M=;
 b=FWX/ydrRu6BG29iWa5xfTSjUQsavxeHU4M3qkKWjrHaVTGRik5kuVunl421ZolBjWgONAoKDpPAE9SuOoDKCiJ+6GOiQqlDn9QJP1waOTuK2nCluRP3LG1Xi8C1zjNwz5WPTBLraqIlYUXACPaANrMoOMc17A7NCCsq5kTbjklg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Mon, 2 Mar 2020 18:48:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 18:48:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>
Subject: Re: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups
 parameter
Thread-Topic: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups
 parameter
Thread-Index: AQHV7dBf+8fMhcV1wEmnFSRdyCqZu6gw+dYAgASw0gA=
Date:   Mon, 2 Mar 2020 18:48:22 +0000
Message-ID: <646c4248586b419fd9ca483aa13fb774d8b08195.camel@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
         <20200228004446.159497-9-saeedm@mellanox.com>
         <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6cf93c0f-503a-473b-4b60-08d7beda48c4
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB69272AF51F4750422B0C5718BEE70@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(189003)(199004)(66556008)(2906002)(66476007)(66946007)(64756008)(478600001)(81156014)(8676002)(81166006)(91956017)(6512007)(76116006)(316002)(54906003)(2616005)(66446008)(4326008)(107886003)(6506007)(36756003)(5660300002)(6916009)(26005)(6486002)(71200400001)(186003)(86362001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gBOHxF/MEVRGzkeWsd/h0ls31GPuFDSKY6DnpJEun9K0LaOXZDq1VHhEtCnBF6qZqRJbWeWDp9l+eBpPKCWjHS82zHbBOTOzKSaqvLAG5BvmqhxJNssc5+X3bXrNUAp/9lhuvT2Z33rS0isHa1ZtzOFeZ7PH0dPxBqttJUyGN7ETefF7AnZ8ItXG9lyc84awu5flPEmG1ExLr9aA8hgUrIXwpFklMNJGgj22/6IyK7VogJ2XsXwDwedgrk6MsfDtimGU/REQxzTbg61Z+ebchFB1H/xvSBoH6VogRFo//bLGLklRBxu+P3zyeNel9BzFDxURHtTIInY4MHT2kvGBQs2hjJwCV/bZmUgH2GlwQAXjPPezibrsBdDdmCu8gQWWJlPWWfhhSHd1FkKtq+9IyyG4KYyz3XuMvd7ha6/VqHzCg3mxSw5Xt3x5YMyJIayG
x-ms-exchange-antispam-messagedata: z3QZwMKbV2tu0cE9VFEqt3ZD0FyPcwwz1FkyAhEslQcLe5bn6YcfxV9fC34jFQx5KuF7Tl5uVclROC4fBxm3uhaIE1Gf1bbCMV7B+yQkI0qe4YfHMXV5zvxRPzJw2bFzJSGoK8A4SCyr5M0c5phmvg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0FE8CA710880F4795599C8625D7622E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf93c0f-503a-473b-4b60-08d7beda48c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 18:48:22.6567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fj/H/80BOlTmn8KjAwIuPkB/8SUEKqrWCtiTUrzvcSDE9YDuWwzqkI4KvYyH3GOjHhbFGpv70LDyOt/z+jY66A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAyLTI4IGF0IDExOjEwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyNyBGZWIgMjAyMCAxNjo0NDozOCAtMDgwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBKaWFuYm8gTGl1IDxqaWFuYm9sQG1lbGxhbm94LmNvbT4NCj4gPiANCj4g
PiBBZGQgYSBkZXZsaW5rIHBhcmFtZXRlciB0byBjb250cm9sIHRoZSBudW1iZXIgb2YgbGFyZ2Ug
Z3JvdXBzIGluIGENCj4gPiBhdXRvZ3JvdXBlZCBmbG93IHRhYmxlLiBUaGUgZGVmYXVsdCB2YWx1
ZSBpcyAxNSwgYW5kIHRoZSByYW5nZSBpcw0KPiA+IGJldHdlZW4gMQ0KPiA+IGFuZCAxMDI0Lg0K
PiA+IA0KPiA+IFRoZSBzaXplIG9mIGVhY2ggbGFyZ2UgZ3JvdXAgY2FuIGJlIGNhbGN1bGF0ZWQg
YWNjb3JkaW5nIHRvIHRoZQ0KPiA+IGZvbGxvd2luZw0KPiA+IGZvcm11bGE6IHNpemUgPSA0TSAv
IChmZGJfbGFyZ2VfZ3JvdXBzICsgMSkuDQo+ID4gDQo+ID4gRXhhbXBsZXM6DQo+ID4gLSBTZXQg
dGhlIG51bWJlciBvZiBsYXJnZSBncm91cHMgdG8gMjAuDQo+ID4gICAgICQgZGV2bGluayBkZXYg
cGFyYW0gc2V0IHBjaS8wMDAwOjgyOjAwLjAgbmFtZSBmZGJfbGFyZ2VfZ3JvdXBzDQo+ID4gXA0K
PiA+ICAgICAgIGNtb2RlIGRyaXZlcmluaXQgdmFsdWUgMjANCj4gPiANCj4gPiAgIFRoZW4gcnVu
IGRldmxpbmsgcmVsb2FkIGNvbW1hbmQgdG8gYXBwbHkgdGhlIG5ldyB2YWx1ZS4NCj4gPiAgICAg
JCBkZXZsaW5rIGRldiByZWxvYWQgcGNpLzAwMDA6ODI6MDAuMA0KPiA+IA0KPiA+IC0gUmVhZCB0
aGUgbnVtYmVyIG9mIGxhcmdlIGdyb3VwcyBpbiBmbG93IHRhYmxlLg0KPiA+ICAgICAkIGRldmxp
bmsgZGV2IHBhcmFtIHNob3cgcGNpLzAwMDA6ODI6MDAuMCBuYW1lIGZkYl9sYXJnZV9ncm91cHMN
Cj4gPiAgICAgcGNpLzAwMDA6ODI6MDAuMDoNCj4gPiAgICAgICBuYW1lIGZkYl9sYXJnZV9ncm91
cHMgdHlwZSBkcml2ZXItc3BlY2lmaWMNCj4gPiAgICAgICAgIHZhbHVlczoNCj4gPiAgICAgICAg
ICAgY21vZGUgZHJpdmVyaW5pdCB2YWx1ZSAyMA0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEpp
YW5ibyBMaXUgPGppYW5ib2xAbWVsbGFub3guY29tPg0KPiA+IFJldmlld2VkLWJ5OiBWbGFkIEJ1
c2xvdiA8dmxhZGJ1QG1lbGxhbm94LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogUm9pIERheWFuIDxy
b2lkQG1lbGxhbm94LmNvbT4NCj4gPiBBY2tlZC1ieTogSmlyaSBQaXJrbyA8amlyaUBtZWxsYW5v
eC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5v
eC5jb20+DQo+IA0KPiBTbGljaW5nIG1lbW9yeSB1cCBzb3VuZHMgbGlrZSBzb21ldGhpbmcgdGhh
dCBzaG91bGQgYmUgc3VwcG9ydGVkIHZpYQ0KPiB0aGUgZGV2bGluay1yZXNvdXJjZSBBUEksIG5v
dCBieSBwYXJhbXMgYW5kIG5vbi1vYnZpb3VzIGNhbGN1bGF0aW9ucw0KPiA6KA0KDQpIaSBKYWt1
YiwgeW91IGhhdmUgYSBwb2ludCwgYnV0IGR1ZSB0byB0byB0aGUgbm9uLXRyaXZpYWxpdHkgb2Yg
dGhlDQppbnRlcm5hbCBtbG54IGRyaXZlciBhbmQgRlcgYXJjaGl0ZWN0dXJlIG9mIGhhbmRsaW5n
IGludGVybmFsIEZEQiB0YWJsZQ0KYnJlYWtkb3duLCB3ZSBwcmVmZXJyZWQgdG8gZ28gd2l0aCBv
bmUgZHJpdmVyLXNwZWNpZmljIHBhcmFtZXRlciB0bw0Kc2ltcGxpZnkgdGhlIGFwcHJvYWNoLCBp
bnN0ZWFkIG9mIDMgb3IgNCBnZW5lcmljIHBhcmFtcywgd2hpY2ggd2lsbCBub3QNCm1ha2UgYW55
IHNlbnNlIHRvIG90aGVyIHZlbmRvcnMgZm9yIG5vdy4NCg0KQXMgYWx3YXlzIHdlIHdpbGwga2Vl
cCBhbiBleWUgb24gd2hhdCBvdGhlciB2ZW5kb3JzIGFyZSBkb2luZyBhbmQgd2lsbA0KdHJ5IHRv
IHVuaWZ5IHdpdGggYSBnZW5lcmljIHNldCBvZiBwYXJhbXMgb25jZSBvdGhlciB2ZW5kb3JzIHNo
b3cNCmludGVyZXN0IG9mIGEgc2ltaWxhciB0aGluZy4NCg0KVGhhbmtzLA0KU2FlZWQuDQo=
