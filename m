Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D11BDD11D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503046AbfJRVWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:22:25 -0400
Received: from mail-eopbgr50040.outbound.protection.outlook.com ([40.107.5.40]:3253
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727508AbfJRVWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 17:22:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoCIY7ikL/rrRIWrM68TRJIXVRQ3hI3NLf7SqDbzBwnsXKzRsKufw42EhB0FfFXSPdpbpgKbjZ264J0w1eCHiod9fSuGZwOj9+6Q5POAznXvJPyye+b6mV8Y8eaD4AwGTe6A13XOZ9pBRfPXlFaMS4hzY1/7Co8jcdPDZrxgVyrj3FJQnlvC5qx5JiVabajeCOricfPzAfiOY8G8dVD7E51VPIYoUIUpngcZlOFjE79nniDIyLxUckDgHF/OIUennZ3dqMuVDJ8SMFN1MYLM7KU5OKuwhApidtFVoojGB5CFcX2uoZc3ymU6z0gs0zazXth9q4SSsOgNTypuWBrBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdeVc+yvLaJecyNyC4nUEUGleHxVuGXkhuqANK2U8Fo=;
 b=YddVVSZstRIORpTNDiAPZcZAFkKnZFwJ9B0z5M9GWWMF/wLH1rByQyhv/+DSrdpWJnoaJFNEmavnwyY95dL565MHitcnyyyv9s2erbI49Q1TYuSg5ru9OfMM0M23XfimwpKkvCj3PtBrRz0otY+PNptTH6pMbMNtqnWcQ9y/y/Wy93SX7LrrhtJoEvlmGqFArCJT6FY2TrgHusc3EUmiJVjjUakpmUconoaHp3jkeFR/xcqBkTaUl6ttH067W/m5HRpfuetdNJC/pPV/85CmLc32X/74y+xF9Wvjkd0tKoVpsQHttxs5aV54+pDkfeb3g4UJ6lXo5Il4tI7cxv0fmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdeVc+yvLaJecyNyC4nUEUGleHxVuGXkhuqANK2U8Fo=;
 b=CMaQZfpI3NtOK+5XCT5Kh2Ptsu+saOUine8DkUUxFOuQKmEV2AkY6qmRb+mkeCgG1aMMR9kcHJLndXn9cjE2roEp79xRQ9JupzLKYW33wrp82VCNCwhsgCwos+F29bCVotGY6lxMdB2PG/ZwVi7yp9ctdBUjTDGaF5POubfXqhk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6142.eurprd05.prod.outlook.com (20.178.205.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Fri, 18 Oct 2019 21:21:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 21:21:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/10 net-next] page_pool cleanups
Thread-Topic: [PATCH 00/10 net-next] page_pool cleanups
Thread-Index: AQHVhHQsb02Xj+NegE6uf7PssTGj26dg4oMAgAAImYA=
Date:   Fri, 18 Oct 2019 21:21:41 +0000
Message-ID: <02eb26349dfe19d41f9b81b35fdb2b1e14008b7e.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
         <1df61f9dedf2e26bbc94298cc2605002a4700ce6.camel@mellanox.com>
In-Reply-To: <1df61f9dedf2e26bbc94298cc2605002a4700ce6.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53428db4-06b9-478f-2084-08d754112b2b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB6142:|VI1PR05MB6142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61420E7EA0C5603EB09F6A1FBE6C0@VI1PR05MB6142.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(189003)(199004)(81156014)(6116002)(66946007)(71190400001)(8936002)(99286004)(256004)(3846002)(81166006)(76176011)(36756003)(6486002)(6436002)(66066001)(14444005)(5660300002)(118296001)(71200400001)(14454004)(66556008)(25786009)(66446008)(66476007)(64756008)(2906002)(6512007)(6246003)(229853002)(76116006)(91956017)(476003)(478600001)(4326008)(4001150100001)(102836004)(86362001)(486006)(11346002)(305945005)(58126008)(7736002)(446003)(54906003)(110136005)(186003)(316002)(2501003)(8676002)(6506007)(2616005)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6142;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bANPt+cXc6l/ax6Z8wwlzw6Ld7x1CYpOuUmMF5CPRb4DZQvQ5JXQ0uP4HiK13+cX+QBtzfmA14UKyfvu55hlOPHXLcIP8u8gHCqVZzqWECWSrZ+7qGRD02gu9EGt7ZsNM0KRQOckqbgHGst+tCEBzWqob74c6Z7feTBYLNR0WWNtXs+jZPPKalSUZMZFssSUfOfWs9HhgSZQhQHbGqNMbipq0124i9xFYfCTzhWsKJOyJUW6wqsBMdpwpqQ8fDYh60pCqZccKBNo2LB61zKm08DZSTAAH3ZX9CjGxAQmvm7jHfcesYcgx8azdwiEfbA6HaPELWPdN+Fqdf2M0jIyf1dQA/EEYMMWwL9jNMjewLOw5hMDdxZUryvnZJkj8qodxDu8ZdMIr7cVlxSM9qnhfQtAGq+C10tx4Tj+8iw+ta0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0491571BD4329A45B87DE7A3BEBA6DA5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53428db4-06b9-478f-2084-08d754112b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 21:21:41.0559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mbDfVI5Zc3ghLJxDByWrDQUXWc1FbPc0UZHx2987LtKdG8GXn+m3i1m57+OoqTCNiPcNu2C0Xcqd8qn/Nd/j0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTE4IGF0IDEzOjUwIC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gT24gV2VkLCAyMDE5LTEwLTE2IGF0IDE1OjUwIC0wNzAwLCBKb25hdGhhbiBMZW1vbiB3cm90
ZToNCj4gPiBUaGlzIHBhdGNoIGNvbWJpbmVzIHdvcmsgZnJvbSB2YXJpb3VzIHBlb3BsZToNCj4g
PiAtIHBhcnQgb2YgVGFyaXEncyB3b3JrIHRvIG1vdmUgdGhlIERNQSBtYXBwaW5nIGZyb20NCj4g
PiAgIHRoZSBtbHg1IGRyaXZlciBpbnRvIHRoZSBwYWdlIHBvb2wuICBUaGlzIGRvZXMgbm90DQo+
ID4gICBpbmNsdWRlIGxhdGVyIHBhdGNoZXMgd2hpY2ggcmVtb3ZlIHRoZSBkbWEgYWRkcmVzcw0K
PiA+ICAgZnJvbSB0aGUgZHJpdmVyLCBhcyB0aGlzIGNvbmZsaWN0cyB3aXRoIEFGX1hEUC4NCj4g
PiANCj4gPiAtIFNhZWVkJ3MgY2hhbmdlcyB0byBjaGVjayB0aGUgbnVtYSBub2RlIGJlZm9yZQ0K
PiA+ICAgaW5jbHVkaW5nIHRoZSBwYWdlIGluIHRoZSBwb29sLCBhbmQgZmx1c2hpbmcgdGhlDQo+
ID4gICBwb29sIG9uIGEgbm9kZSBjaGFuZ2UuDQo+ID4gDQo+IA0KPiBIaSBKb25hdGhhbiwgdGhh
bmtzIGZvciBzdWJtaXR0aW5nIHRoaXMsDQo+IHRoZSBwYXRjaGVzIHlvdSBoYXZlIGFyZSBub3Qg
dXAgdG8gZGF0ZSwgaSBoYXZlIG5ldyBvbmVzIHdpdGggdHJhY2luZw0KPiBzdXBwb3J0IGFuZCBz
b21lIGZpeGVzIGZyb20gb2ZmbGlzdCByZXZpZXcgaXRlcmF0aW9ucywgcGx1cw0KPiBwZXJmb3Jt
YW5jZQ0KPiBudW1iZXJzIGFuZCBhICBjb3ZlciBsZXR0ZXIuIA0KPiANCj4gSSB3aWxsIHNlbmQg
aXQgdG8geW91IGFuZCB5b3UgY2FuIHBvc3QgaXQgYXMgdjIgPyANCg0KYWN0dWFsbHkgaSBzdWdn
ZXN0IHRvIHRha2UgbXkgMyBwYXRjaGVzIG91dCBvZiB0aGlzIHNlcmllcyBhbmQgc3VibWl0DQp0
aGVtIGFzIHN0YW5kYWxvbmUsIHRoZXkgYXJlIG5vdCBkaXJlY3RseSByZWxhdGVkIHRvIHRoZSBv
dGhlciBzdHVmZg0KaGVyZSwgYW5kIGNhbiBwZXJmZWN0bHkgd29yayB3aXRob3V0IHRoZW0sIHNp
bmNlIG15IDMgcGF0Y2hlcyBhcmUNCmFkZHJlc3NpbmcgYSByZWFsIGlzc3VlIHdpdGggcGFnZSBw
b29sIG51bWEgbm9kZSBtaWdyYXRpb24uDQoNCj4gDQo+IA0KPiA+IC0gU3RhdGlzdGljcyBhbmQg
Y2xlYW51cCBmb3IgcGFnZSBwb29sLg0KPiA+IA0KPiA+IEpvbmF0aGFuIExlbW9uICg1KToNCj4g
PiAgIHBhZ2VfcG9vbDogQWRkIHBhZ2VfcG9vbF9rZWVwX3BhZ2UNCj4gPiAgIHBhZ2VfcG9vbDog
YWxsb3cgY29uZmlndXJhYmxlIGxpbmVhciBjYWNoZSBzaXplDQo+ID4gICBwYWdlX3Bvb2w6IEFk
ZCBzdGF0aXN0aWNzDQo+ID4gICBuZXQvbWx4NTogQWRkIHBhZ2VfcG9vbCBzdGF0cyB0byB0aGUg
TWVsbGFub3ggZHJpdmVyDQo+ID4gICBwYWdlX3Bvb2w6IENsZWFudXAgYW5kIHJlbmFtZSBwYWdl
X3Bvb2wgZnVuY3Rpb25zLg0KPiA+IA0KPiA+IFNhZWVkIE1haGFtZWVkICgyKToNCj4gPiAgIHBh
Z2VfcG9vbDogQWRkIEFQSSB0byB1cGRhdGUgbnVtYSBub2RlIGFuZCBmbHVzaCBwYWdlIGNhY2hl
cw0KPiA+ICAgbmV0L21seDVlOiBSeCwgVXBkYXRlIHBhZ2UgcG9vbCBudW1hIG5vZGUgd2hlbiBj
aGFuZ2VkDQo+ID4gDQo+ID4gVGFyaXEgVG91a2FuICgzKToNCj4gPiAgIG5ldC9tbHg1ZTogUlgs
IFJlbW92ZSBSWCBwYWdlLWNhY2hlDQo+ID4gICBuZXQvbWx4NWU6IFJYLCBNYW5hZ2UgUlggcGFn
ZXMgb25seSB2aWEgcGFnZSBwb29sIEFQSQ0KPiA+ICAgbmV0L21seDVlOiBSWCwgSW50ZXJuYWwg
RE1BIG1hcHBpbmcgaW4gcGFnZV9wb29sDQo+ID4gDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbi5oICB8ICAxOCArLQ0KPiA+ICAuLi4vbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYyAgfCAgMTIgKy0NCj4gPiAgLi4uL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jIHwgIDE5ICstDQo+ID4gIC4uLi9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMgICB8IDEyOCArKy0tLS0tLS0tDQo+
ID4gIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuYyAgICB8ICAzOSAr
Ky0tDQo+ID4gIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuaCAgICB8
ICAxOSArLQ0KPiA+ICBpbmNsdWRlL25ldC9wYWdlX3Bvb2wuaCAgICAgICAgICAgICAgICAgICAg
ICAgfCAyMTYgKysrKysrKysrLS0tLS0NCj4gPiAtLQ0KPiA+IC0NCj4gPiAgbmV0L2NvcmUvcGFn
ZV9wb29sLmMgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMjIxICsrKysrKysrKysrLS0tDQo+
ID4gLS0NCj4gPiAtLQ0KPiA+ICA4IGZpbGVzIGNoYW5nZWQsIDMxOSBpbnNlcnRpb25zKCspLCAz
NTMgZGVsZXRpb25zKC0pDQo+ID4gDQo=
