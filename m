Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753B21C01D9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgD3QNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:13:38 -0400
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:4801
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726544AbgD3QNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:13:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juKpiW0+HLCEBm2oN3gqhVHyPunJRDewgcTnXiTvIWJmSliqYQUogZGuJBnhG2s1KbXjB0yOEbO3YwLb2dX6lK6ESqomvslZOx6BPd0gly1ZuJK5DP0i4ImRyWzj5BOcK1vxuo9ZQiDM9mvgnmtQ2D4WLVNNTuf0Vhk1RddXlXmmp61iIV0zsSYk26bA+ir9PvhOGm6EJgikEAkOTAvH19X2zndKbFaka4dtWkmUOs1BOUftg2omq2kph9ykwohhlf2IqiJUKlrAelnoimFcXtrdrZ2K2TjflF/F86IRS/9qKfGWy3itOOaWrvlqwvONEgIWxFvDCo87grbM5d1F2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qud8TRMLf+2JulsCbgOvq+1C2Lke/Cr+w1aelFpz47c=;
 b=nrNMbugjn1aOAk9Lbi7ExHY+cbonphltZ6gb3nGgdyqgm5eMlfhb5TdOCHUXy4PFUny4bIsQsbp0MhJSAq+GvLsmPC37hetuPxLXaPpX96CZOTtFxBtHLqUYYVDIY+3zESeYoPS6NxkrOOhzz/mfKtKA1N8HFwXMtalXpSUL4JlsRdGIZArRotgdCbCHzDthauBdWstMn6ty6hMX9ej7aMheNt0hpgkip5SvmJw6gYI4uXulg4gLEbLZgvI5414rqa9SAyIiy/k1n7Uee7PTjLP+LFOZUamvGg2JeojX4zQVtGg7K4goGIVwAI/JogCecOnlXhmwJEY/SDlE0hlsNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qud8TRMLf+2JulsCbgOvq+1C2Lke/Cr+w1aelFpz47c=;
 b=dHa6nXhAvxKhgvPLMYu+hAztxUakhvGi5nh9kUio69och7liVIxFbJ1BEqi+nLaP72Ken5sMpjoXPo8ybrizVebZJqQMYFemNR8OsjvDW/ji4Sv1KaEZfsRz/Zx9/Hjg5nqhlocxuyT82/uY8QTJIHyr8Bd6jIGvEyfkvNgQNsw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6366.eurprd05.prod.outlook.com (2603:10a6:803:f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 16:13:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:13:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH 0/1] net/mlx5: Call pci_disable_sriov() on remove
Thread-Topic: [PATCH 0/1] net/mlx5: Call pci_disable_sriov() on remove
Thread-Index: AQHWHudVHMHIKrrNNEKlZqYQXDY+FKiR1scA
Date:   Thu, 30 Apr 2020 16:13:34 +0000
Message-ID: <08d0c332f3cfa034dddc2e3321bf7649ab718701.camel@mellanox.com>
References: <20200430120308.92773-1-schnelle@linux.ibm.com>
In-Reply-To: <20200430120308.92773-1-schnelle@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 23098d61-62fd-4fe3-abab-08d7ed216ebb
x-ms-traffictypediagnostic: VI1PR05MB6366:|VI1PR05MB6366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB63663CED3CE2A8CC44D8A64CBEAA0@VI1PR05MB6366.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CVevMzX20wxBKcdOKlLNtixmh6PxRtFwWp1eFsMDotIk5jcaXQwqj/QxKNV92/Dao0ami+WIG7He6GWj0p/GydKCD0t55JrcRGV7TIL0gSgDE0GBxfjCTqGku6ter++HRfugVelzlxoY6RrJCCowJNlBRAbrRrCDUIVKGmrR47H6C8ENQ8oo7U8S++F1q7QbUIc2AYxWZp8/PAm1ViV/kaPLilGoiscZEguWIpIKbyhUbutVdMC4aw7ujGp0lGk7H0DO7P3R/sJtoTt29N9Cpkk/dvQUcKDyk86jEP7wgc19SAasC1p6hU5zwUb4n7wUZ71++UaVJ+Au4ig63hDJGeZpMf8uvDf2w7UuUE/Gq2UOqKaeL9M4OkxZKLmSPNzQvT1jn3Ln8J1A8NySzUCNq0mtTxIMD4RNY09euUGCU55x2E0EQBtgssPc/hqgPsau
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(8936002)(66556008)(66476007)(6506007)(76116006)(26005)(186003)(110136005)(54906003)(4326008)(91956017)(86362001)(36756003)(8676002)(6636002)(66946007)(66446008)(64756008)(2616005)(6486002)(6512007)(71200400001)(498600001)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dO/gU7KH9i8gdZ2i+9+/9cy9qV2yGQAJxdn5gvuxFUA36KAt9VX0U6B9sU6cwKi3eGNaq2R8rXh/obA0bcxkpw9Y6TnXn60RqNVTQRO2amBfAy3UMiEAhQWZUk5wSOP4++AhlYwpESuRRoF2WdTczIOJRJ81hSqoipk/Bjx8Nby/bgwYHOtTgjVhxltzMt/pW2ViD09y/LX5sscz5RGli+auQem7fFDN04uLdHxnDLcLr92jUuCX+yGwp+TxNus/ThDhwXDx6C5crl9/K7ZH9GLAZ1IiGZXNl3mbFSWiljduQ+Tk52wx144Wv7dHKHTIIArW9maOnHrFrlNAjRNRc/vE2sePg3naEpXTK7wfSdWBCsNFQxyQHrFZJUoKdcrFBK2NelDfLYrv4lISbVDmm5uLEWIu1CX7dDTMHo4beu3nlewHpGiUCexPEksJlZdUOm7FMqHBG1wM4jq+6FB8VA86Bw8jfjTQ6J+asAJ54LkwSoXQ6e2dc36XqiISPKCPZ2yTPX/Pmf40ohrIFgkxACTLgVzFgqDlex+BaBOmmoi5h+x4yxjxU02i5N0WzAuOtLTabIKNLIFuYWm3o1NnlCVNY2igJmpqu9YN9BpLWWKcbENx3GvCtgNVKCr9//jzU7rYFeEueGrNS5VEFUOoz/gL6+HkX782CzXRjc18NVYVTuaJd4YYwm0JhzPp+0oeNK9teZw3r99B+O7ek9Vj4QwpSceU78gmn3xddQz05F3TtfjJlxs5dZYACYZqmybLel6DpGi5coCqf18n5pVPCg1ov7cJvCGDxzmTOmHL+mQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89DB04ACE1780142871FF08FF69CDCF1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23098d61-62fd-4fe3-abab-08d7ed216ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 16:13:34.2541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sljk5lJ7ckM6PWytoKQYuNb8G3ostwKD/+JxqPp9lbFXG7oulgDE6y04RxeCTmtmWIVyH9OqjcLLS9ocRwgRSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6366
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTMwIGF0IDE0OjAzICswMjAwLCBOaWtsYXMgU2NobmVsbGUgd3JvdGU6
DQo+IEhlbGxvLA0KPiANCj4gSSdtIGN1cnJlbnRseSB3b3JraW5nIG9uIGltcHJvdmVtZW50cyBp
biBQRi1WRiBoYW5kbGluZyBvbiBzMzkwLiBPbmUNCj4gdGhpbmcgdGhhdA0KPiBtYXkgYmUgYSBi
aXQgc3BlY2lhbCBmb3IgdXMgaXMgdGhhdCB0aGUgczM5MCBob3RwbHVnIGNvZGUgc3VwcG9ydHMN
Cj4gc2h1dHRpbmcNCj4gZG93biBhIHNpbmdsZSBQRiBvZiBhIG11bHRpLWZ1bmN0aW9uIGRldmlj
ZSBzdWNoIGFzIGEgQ29ubmVjdFgtNS4NCj4gRHVyaW5nIHRlc3RpbmcgSSBmb3VuZCB0aGF0IHRo
ZSBtbHg1X2NvcmUgZHJpdmVyIGRvZXMgbm90IGNhbGwNCj4gcGNpX2Rpc2FibGVfc3Jpb3YoKSBp
biBpdHMgcmVtb3ZlIGhhbmRsZXIgd2hpY2ggaXMgY2FsbGVkIG9uIHRoZSBQRg0KPiB2aWENCj4g
cGNpX3N0b3BfYW5kX3JlbW92ZV9idXNfZGV2aWNlKCkgb24gYW4gb3JkZXJseSBob3QgdW5wbHVn
Lg0KDQpBY3R1YWxseSB3aGF0IGhhcHBlbnMgaWYgeW91IGNhbGwgcGNpX2Rpc2FibGVfc3Jpb3Yo
KSB3aGVuIHRoZXJlIGFyZQ0KVkZzIGF0dGFjaGVkIHRvIFZNcyA/IA0KDQo+IA0KPiBGb2xsb3dp
bmcgaXMgYSBwYXRjaCB0byBmaXggdGhpcywgSSB3YW50IHRvIHBvaW50IG91dCBob3dldmVyIHRo
YXQNCj4gSSdtIG5vdA0KPiBlbnRpcmVseSBzdXJlIGFib3V0IHRoZSBlZmZlY3Qgb2YgY2xlYXJf
dmZzIHRoYXQgZGlzdGluZ3Vpc2hlcw0KPiBtbHg1X3NyaW92X2RldGFjaCgpIGZyb20gbWx4NV9z
cmlvdl9kaXNhYmxlKCkgb25seSB0aGF0IHRoZSBmb3JtZXIgaXMNCj4gY2FsbGVkDQo+IGZyb20g
dGhlIHJlbW92ZSBoYW5kbGVyIGFuZCBpdCBkb2Vzbid0IGNhbGwgcGNpX2Rpc2FibGVfc3Jpb3Yo
KS4NCj4gVGhhdCBob3dldmVyIGlzIHJlcXVpcmVkIGFjY29yZGluZyB0byBEb2N1bWVudGF0aW9u
L1BDSS9wY2ktaW92LQ0KPiBob3d0by5yc3QNCj4gDQoNClRoZSBEb2MgZG9lc24ndCBzYXkgInJl
cXVpcmVkIiwgc28gdGhlIHF1ZXN0aW9uIGlzLCBpcyBpdCByZWFsbHkNCnJlcXVpcmVkID8gDQoN
CmJlY2F1c2UgdGhlIHdheSBpIHNlZSBpdCwgaXQgaXMgdGhlIGFkbWluIHJlc3BvbnNpYmlsaXR5
IHRvIGNsZWFyIG91dA0KdmZzIGJlZm9yZSBzaHV0dGluZyBkb3duIHRoZSBQRiBkcml2ZXIuDQoN
CmFzIGV4cGxhaW5lZCBpbiB0aGUgcGF0Y2ggcmV2aWV3LCBtbHg1IHZmIGRyaXZlciBpcyByZXNp
bGllbnQgb2Ygc3VjaA0KYmVoYXZpb3IgYW5kIG9uY2UgdGhlIGRldmljZSBpcyBiYWNrIG9ubGlu
ZSB0aGUgdmYgZHJpdmVyIHF1aWNrbHkNCnJlY292ZXJzLCBzbyBpdCBpcyBhY3R1YWxseSBhIGZl
YXR1cmUgYW5kIG5vdCBhIGJ1ZyA6KQ0KDQpUaGVyZSBhcmUgbWFueSByZWFzb25zIHdoeSB0aGUg
YWRtaW4gd291bGQgd2FudCB0byBkbyB0aGlzOg0KDQoxKSBGYXN0IEZpcm13YXJlIHVwZ3JhZGUN
CjIpIEZhc3QgSHlwZXItdmlzb3IgdXBncmFkZS9yZWZyZXNoDQozKSBQRiBkZWJ1Z2dpbmcgDQoN
ClNvIHlvdSBjYW4gcXVpY2tseSByZXNldCB0aGUgUEYgZHJpdmVyIHdpdGhvdXQgdGhlIG5lZWQg
dG8gd2FpdCBmb3IgYWxsDQpWRnMgb3IgbWFudWFsbHkgZGV0YWNoLWF0dGFjaCB0aGVtLg0KDQoN
Cj4gSSd2ZSBvbmx5IHRlc3RlZCB0aGlzIG9uIHRvcCBvZiBteSBjdXJyZW50bHkgc3RpbGwgaW50
ZXJuYWwgUEYtVkYNCj4gcmV3b3JrIHNvDQo+IEkgbWlnaHQgYWxzbyBiZSB0b3RhbGx5IG1pc3Np
bmcgc29tZXRoaW5nIGhlcmUgaW4gdGhhdCBjYXNlIGV4Y3VzZSBteQ0KPiBpZ25vcmFuY2UuDQo+
IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IE5pa2xhcyBTY2huZWxsZQ0KPiANCj4gTmlrbGFzIFNjaG5l
bGxlICgxKToNCj4gICBuZXQvbWx4NTogQ2FsbCBwY2lfZGlzYWJsZV9zcmlvdigpIG9uIHJlbW92
ZQ0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zcmlvdi5j
IHwgMyArKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo=
