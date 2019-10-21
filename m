Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010F4DF5B0
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfJUTIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:08:46 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:47406
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726672AbfJUTIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 15:08:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfeENbcSuEOd+r2/RWe33z6n6xFCD9yhu/EY/hpVplFcGykhjuDNS9lDZSVTNGcbRqrNDt0yTCh0eq6rKYsG9T1N0JflBFVPTFPZDXXAadXoFZuzWvV7h6gc718YNctygF6MHRCfmhZ5pB/0dto6Ix7LexlR5VQQmjpd89PpCrmu07F6OiSwsDFaECAP43UCU5AZHEWfVrmkT3h+lYydNKhov6fkJU4RAmBzi3RDSJAOj6vlyHZDZ0wB+YCkfxwkk0zlHvBEmBgR0hkTRmLsDJCcCDizmS+aqEOr615UTEmTiEwXJhDasB/1Nek5i6bYrcCB+EzAAThZDA60ByY2Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=as/YQ9lz7NIs19ydQsc72dPXKKEbVQ4Rk/cEvf28J/I=;
 b=mJVKQjMDe9f9/j8GifGouQNdWs/gY8v2XagxwlBd5/FyjXodB85iRc5LpyAYsH2E1De9UGHdQoyRm674aLXjUzZcybHRF72qCVjM8tGmjYZFwGIXngPL1Xlo07avzkkOc59z+y7tBc2tWOSmDi/XBrAp+lLgCkllXNFjNxP5rj1UGCIx4Oyb3jI+lHrw/jXcG9+fiS9BcgyJsqfHzMDD9xaNg7CSxFkHDlg58cJTKV60sFbyYDvU19wuJWIi6Jfo2t3NVV6FAh2Pjd5/eTdaSC6n4WKT24DB27QSZ5nvKQioBTk4JOFPMo/Q0ZMOjHRzVIH6x5EYLdvPd5T44OR8sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=as/YQ9lz7NIs19ydQsc72dPXKKEbVQ4Rk/cEvf28J/I=;
 b=HA5SjJtjIh99kUYOt+fdgknRyVVZBjq7+JJ+E8HKMf+TirPfZxQdlpYMZ2bx17oqDLgwcpBWEGR0ihZMh+DrIv2awqTX8CZPEh0556ywYjGDpUtrUwYg/l0yC9HOIUTUkJH3m/oypQWfTRxyniIRQefJUzstDfWit68qJdOrCGM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4477.eurprd05.prod.outlook.com (52.134.123.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Mon, 21 Oct 2019 19:08:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 19:08:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/10 net-next] page_pool cleanups
Thread-Topic: [PATCH 00/10 net-next] page_pool cleanups
Thread-Index: AQHVhHQsb02Xj+NegE6uf7PssTGj26dg4oMAgAAtF4CABG1igA==
Date:   Mon, 21 Oct 2019 19:08:41 +0000
Message-ID: <a82be17dbaa84d4868d6825967b8a87afa3551ba.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
         <1df61f9dedf2e26bbc94298cc2605002a4700ce6.camel@mellanox.com>
         <A6D1D7E1-56F4-4474-A7E7-68627AEE528D@gmail.com>
In-Reply-To: <A6D1D7E1-56F4-4474-A7E7-68627AEE528D@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90d1d373-6285-490f-3834-08d7565a162d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB4477:|VI1PR05MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4477ADC279BCACFB68880FE9BE690@VI1PR05MB4477.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(189003)(199004)(2351001)(4001150100001)(36756003)(6506007)(6486002)(6436002)(14454004)(229853002)(6512007)(2501003)(4326008)(478600001)(6116002)(5640700003)(76116006)(6246003)(64756008)(66476007)(66556008)(66446008)(86362001)(3846002)(91956017)(66946007)(2906002)(7736002)(118296001)(26005)(5660300002)(1361003)(316002)(305945005)(25786009)(186003)(66066001)(256004)(81166006)(6916009)(81156014)(8936002)(76176011)(99286004)(71190400001)(71200400001)(53546011)(8676002)(58126008)(54906003)(446003)(476003)(11346002)(2616005)(486006)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4477;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yF8GOzdTNUa8TqL+4rYr14zz1KyeWeZ4b9nvQNuk78S6YWzd4FdeAMXdeKnTRXbyfE1PRYgB/dcrxnSdXxr+B4vIqeD/BLjd7OkHvMMVg5rOY/jjn6LLmLzk5M5FDtCQiuSxCB0pqEdOAzudfk4zkSbVXzhJxuofyYtMPlQ/+ECfrBTlVCqdkog+s9+O3a2QNY3ORv1W0dh0/R4JzB7ZIolkmiSDlelazciTRYn4Zvchqp8FgiNWT1Qx+0BrQVbvgUYmUN/18auLKC4hgKlMx4O3CeFh+2lU89r0X0HaGVSX5qcDFD3EbLDq6W/Z+Vdi56wDZTgDXG+KbPqOuegyYUIc/S0F/XkS3OKW9Em3/20iQcHHr1eGLxx2ZQiMWO4wy7y2aWCAiFdRR3rtbD41snzDs4hu8xzkP/rYOHhuFWevvL1KWYjIzxZDpBfe07Hp
Content-Type: text/plain; charset="utf-8"
Content-ID: <788EC45FD0DCBC4DA92E2322EF0520E5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d1d373-6285-490f-3834-08d7565a162d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 19:08:41.3673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJZ3bOWQAT37FdP2DY1nUXq031lpbbQSmNcF2CwQWksT9ESPLuoCgzurqy+0U6d4IyBZ+So4g26iR7CQFutpmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTE4IGF0IDE2OjMyIC0wNzAwLCBKb25hdGhhbiBMZW1vbiB3cm90ZToN
Cj4gDQo+IE9uIDE4IE9jdCAyMDE5LCBhdCAxMzo1MCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+
IA0KPiA+IE9uIFdlZCwgMjAxOS0xMC0xNiBhdCAxNTo1MCAtMDcwMCwgSm9uYXRoYW4gTGVtb24g
d3JvdGU6DQo+ID4gPiBUaGlzIHBhdGNoIGNvbWJpbmVzIHdvcmsgZnJvbSB2YXJpb3VzIHBlb3Bs
ZToNCj4gPiA+IC0gcGFydCBvZiBUYXJpcSdzIHdvcmsgdG8gbW92ZSB0aGUgRE1BIG1hcHBpbmcg
ZnJvbQ0KPiA+ID4gICB0aGUgbWx4NSBkcml2ZXIgaW50byB0aGUgcGFnZSBwb29sLiAgVGhpcyBk
b2VzIG5vdA0KPiA+ID4gICBpbmNsdWRlIGxhdGVyIHBhdGNoZXMgd2hpY2ggcmVtb3ZlIHRoZSBk
bWEgYWRkcmVzcw0KPiA+ID4gICBmcm9tIHRoZSBkcml2ZXIsIGFzIHRoaXMgY29uZmxpY3RzIHdp
dGggQUZfWERQLg0KPiA+ID4gDQo+ID4gPiAtIFNhZWVkJ3MgY2hhbmdlcyB0byBjaGVjayB0aGUg
bnVtYSBub2RlIGJlZm9yZQ0KPiA+ID4gICBpbmNsdWRpbmcgdGhlIHBhZ2UgaW4gdGhlIHBvb2ws
IGFuZCBmbHVzaGluZyB0aGUNCj4gPiA+ICAgcG9vbCBvbiBhIG5vZGUgY2hhbmdlLg0KPiA+ID4g
DQo+ID4gDQo+ID4gSGkgSm9uYXRoYW4sIHRoYW5rcyBmb3Igc3VibWl0dGluZyB0aGlzLA0KPiA+
IHRoZSBwYXRjaGVzIHlvdSBoYXZlIGFyZSBub3QgdXAgdG8gZGF0ZSwgaSBoYXZlIG5ldyBvbmVz
IHdpdGgNCj4gPiB0cmFjaW5nDQo+ID4gc3VwcG9ydCBhbmQgc29tZSBmaXhlcyBmcm9tIG9mZmxp
c3QgcmV2aWV3IGl0ZXJhdGlvbnMsIHBsdXMNCj4gPiBwZXJmb3JtYW5jZQ0KPiA+IG51bWJlcnMg
YW5kIGEgIGNvdmVyIGxldHRlci4NCj4gPiANCj4gPiBJIHdpbGwgc2VuZCBpdCB0byB5b3UgYW5k
IHlvdSBjYW4gcG9zdCBpdCBhcyB2MiA/DQo+IA0KPiBTdXJlLCBJIGhhdmUgc29tZSBvdGhlciBj
bGVhbnVwcyB0byBkbyBhbmQgaGF2ZSBhIGNvbmNlcm4gYWJvdXQNCj4gdGhlIGNhY2hlIGVmZmVj
dGl2ZW5lc3MgZm9yIHNvbWUgd29ya2xvYWRzLg0KDQpPayB0aGVuLCBJIHdpbGwgc3VibWl0IHRo
ZSBwYWdlIHBvb2wgTlVNQSBjaGFuZ2UgcGF0Y2hlcyBzZXBhcmF0ZWx5Lg0KSSB3aWxsIHJlbW92
ZSB0aGUgZmx1c2ggbWVjaGFuaXNtIGFuZCB3aWxsIGFkZCB5b3VyIGNoYW5nZXMuDQoNCmZvciB0
aGUgb3RoZXIgcGF0Y2hlcywgbWx4NSBjYWNoZSBhbmQgcGFnZSBwb29sIHN0YXRpc3RpY3MsIGkg
dGhpbmsNCnRoZXkgbmVlZCBzb21lIG1vcmUgd29yayBhbmQgYSBsb3Qgb2YgcGllY2VzIGFyZSBz
dGlsbCBXSVAuIEkgZG9uJ3QNCndhbnQgdG8gYmxvY2sgdGhlIE5VTUEgY2hhbmdlIEFQSSBwYXRj
aGVzLg0K
