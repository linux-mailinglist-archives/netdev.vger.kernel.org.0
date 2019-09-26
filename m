Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4128BBF5A4
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 17:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfIZPOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 11:14:40 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:44846
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727249AbfIZPOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 11:14:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBhoC3OKTc61bPp+AwvpeQM18TxU5ZFRwkWSPsoxeXJ+4122rZ1LrLuzJ2TRt23SrAf6VuKPm6bPzffGn4h5aIhi67vQi8PATl0HTXEqcoRHdf0DaebwzrCMqqESDPikTxxpzxyVGX7q0lce1Bd/r7S8o+94nv8aQgWr6EHF79KmoCCL6QuiWLHYYWgKlOmrHuh0fF++WJ0wCG+uwI9cAGQkMkr1gU+E/Iet85rq4pR5a5uEkfhaJ4rgWJs7v4bU0BpP1vO5BGGp2vVLhHgJkgjoM71JgpudZnbRfYpZAqKc0YW0wgk/BYJep7mUuJtpoLw3kV90qPz9QOJlnb0keQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQBCp0RZCIxn3YzaCUMBUZYyFag1flstfv2UmfZQVL4=;
 b=nMRGUFXPFuDXEyvCEmnzZd9SfXuwKdwRUMOWF9iy5rQ6CAndf6whYLxSAw4SPnHePY65U7pHyak8yQJdtHP0Isn6DKvDHPrC9vRd17wPeU+sZaWy0L4eJ/Lv6f2NKE2awyIqjj/GloNKJ04AIeAHTs5tFmmFMWMDSXQg+rax6EAvBWRyYojm+ADs9zI0qy0SUevbeFU8GkJNl7jVN1h0BYVuhjhYwLyP8/JuLEgO42VrhGk3QwC+r1fGtY3/3uvNQdmRD77J3agBWZZ7PvUGAVov1+g0fHTZvriHAKzUxxbekbbXsDjpkiS0D9r2+wo/Ct5nX8k87HJbAuSEORNRMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQBCp0RZCIxn3YzaCUMBUZYyFag1flstfv2UmfZQVL4=;
 b=h+IiS5bDBVqnYrhzdFb5IjLI0Lhm8yj4uZ/P2VjTYfHod/b4pWvhzX/1QA93GStw1L1dwdKsOIIE30BO84UvCuFqDgeM3pQpRxkObHB/rmLC10wLqkEbpakd8mylrhVMhyDEa1As0+IK7R0RP6MDiLQUnWIhJEhQqGXsxhSduY8=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3332.eurprd05.prod.outlook.com (10.171.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Thu, 26 Sep 2019 15:14:34 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 15:14:33 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Thread-Topic: CONFIG_NET_TC_SKB_EXT
Thread-Index: AQHVbtxxDxq98BXUU0W1ldTc//QoBKczG/uAgAGj5oCAAGQoAIAAC2iAgAATpQCAAcftgIAAGgkAgAB1cACAAKZjgIABc1wA///TvACAATZdAIAB6dAAgAElAoCAACxNgIAADSyAgAAIVACAAA2EAA==
Date:   Thu, 26 Sep 2019 15:14:32 +0000
Message-ID: <5ae6ca73-3683-b907-85fd-3d09bed9b68e@mellanox.com>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
 <1569153104-17875-1-git-send-email-paulb@mellanox.com>
 <20190922144715.37f71fbf@cakuba.netronome.com>
 <68c6668c-f316-2ceb-31b0-8197d22990ae@mellanox.com>
 <d6867e6c-2b81-5fcd-1d88-46663bed6e26@solarflare.com>
 <4f99e2b6-0f09-9d2c-6300-dfc884d501a8@mellanox.com>
 <3c09871f-a367-56ca-0d25-f0699a7b79d0@solarflare.com>
 <541fde6d-01ce-edf3-84e4-153756aba00f@mellanox.com>
 <08f58572-26ed-e947-5b0c-73732ef7eb35@solarflare.com>
 <ecfb7918-7660-91f0-035e-56f58a41dc17@mellanox.com>
 <3aff5059-c28c-f194-72f0-69edddf89f84@solarflare.com>
In-Reply-To: <3aff5059-c28c-f194-72f0-69edddf89f84@solarflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0501CA0055.eurprd05.prod.outlook.com
 (2603:10a6:200:68::23) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: faa6ad65-aef2-4d5d-b569-08d742943c10
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3332;
x-ms-traffictypediagnostic: AM4PR05MB3332:|AM4PR05MB3332:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB333299E600F6AD875C6CFBFBCF860@AM4PR05MB3332.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(199004)(189003)(8676002)(102836004)(71200400001)(36756003)(14444005)(71190400001)(478600001)(26005)(4326008)(256004)(54906003)(2906002)(6116002)(3846002)(2616005)(186003)(14454004)(5660300002)(476003)(386003)(305945005)(110136005)(6506007)(11346002)(7736002)(446003)(8936002)(31686004)(52116002)(7416002)(486006)(53546011)(229853002)(31696002)(76176011)(81166006)(81156014)(86362001)(7116003)(316002)(6436002)(25786009)(6486002)(66946007)(66446008)(64756008)(66476007)(6512007)(66556008)(6246003)(66066001)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3332;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ShtdFKrDAAMIgli5DEbeybVbXdwJLVZxLhR7H+vrCYnvCxtWA7KSNKARfK5haUAgN/qhbZhuv+kM8gFOmvtScTWpy3zTu2+WqEJ8DcDZGTsTiJjm5CzcvuV6YCeZaciDEi9np3jMzgCr/Gmj41fvXnMrX9BE5gb3gPp/0sMASSeYNzxsezWlik1/U4J/ROR/Wi/i8afQQUBCFy4rCdVeqqCE9atAQTXlo6LToq+Wdu+3PA/OXlmX7edLaHqk0+igDhbsblmKDvGQL2IIa+sX4YdKL6f1YZLuGhLJi+7yG5QNIfKu7FXJetGHW/WXvZBdPmsCSPVjBark7evDpHjbpCiQ/mrI22ZPknry64TH9AnPC+nKoXY67U1zswZKsk2/5J7IW1gGneUQzAXzXCALr+k06UqhCEYwMJqVNkmxaQQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6F636A48846A4429B23D9847147DFFB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa6ad65-aef2-4d5d-b569-08d742943c10
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 15:14:33.4421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k9dj91xVGcqnyhkZGwijCKSDAQ17TVARu/rlnd3zKlSrJpGVrbHy8gATAZCS1JHlHXERSjOQUiFYHYCnREmgTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3332
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA5LzI2LzIwMTkgNToyNiBQTSwgRWR3YXJkIENyZWUgd3JvdGU6DQo+IE9uIDI2LzA5LzIw
MTkgMTQ6NTYsIFBhdWwgQmxha2V5IHdyb3RlOg0KPj4+PiBJbiBuYXQgc2NlbmFyaW9zIHRoZSBw
YWNrZXQgd2lsbCBiZSBtb2RpZmllZCwgYW5kIHRoZW4gdGhlcmUgY2FuIGJlIGEgbWlzczoNCj4+
Pj4NCj4+Pj4gICAgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLXRyayAuLi4uIENUKHpvbmUgWCwgUmVz
dG9yZSBOQVQpLGdvdG8gY2hhaW4gMQ0KPj4+Pg0KPj4+PiAgICDCoMKgwqDCoMKgwqDCoMKgwqDC
oCArdHJrK2VzdCwgbWF0Y2ggb24gaXB2NCwgQ1Qoem9uZSBZKSwgZ290byBjaGFpbiAyDQo+Pj4+
DQo+Pj4+ICAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgICt0cmsrZXN0LCBvdXRwdXQuLg0KPj4+IEkn
bSBjb25mdXNlZCwgSSB0aG91Z2h0IHRoZSB1c3VhbCBuYXQgc2NlbmFyaW8gbG9va2VkIG1vcmUg
bGlrZQ0KPj4+ICAgwqDCoMKgIDA6IC10cmsgLi4uIGFjdGlvbiBjdCh6b25lIHgpLCBnb3RvIGNo
YWluIDENCj4+PiAgIMKgwqDCoCAxOiArdHJrK25ldyAuLi4gYWN0aW9uIGN0KGNvbW1pdCwgbmF0
PWZvbykgIyBzdyBvbmx5DQo+Pj4gICDCoMKgwqAgMTogK3Ryaytlc3QgLi4uIGFjdGlvbiBjdChu
YXQpLCBtaXJyZWQgZXRoMQ0KPj4+IGkuZS4gdGhlIE5BVCBvbmx5IGhhcHBlbnMgYWZ0ZXIgY29u
bnRyYWNrIGhhcyBtYXRjaGVkIChhbmQgdGh1cyBwcm92aWRlZA0KPj4+ICAgwqB0aGUgc2F2ZWQg
TkFUIG1ldGFkYXRhKSwgYXQgdGhlIGVuZCBvZiB0aGUgcGlwZS7CoCBJIGRvbid0IHNlZSBob3cg
eW91DQo+Pj4gICDCoGNhbiBOQVQgYSAtdHJrIHBhY2tldC4NCj4+IEJvdGggYXJlIHZhbGlkLCBO
YXQgaW4gdGhlIGZpcnN0IGhvcCwgZXhlY3V0ZXMgdGhlIG5hdCBzdG9yZWQgb24gdGhlDQo+PiBj
b25uZWN0aW9uIGlmIGF2YWlsYWJsZSAoY29uZmlndXJlZCBieSBjb21taXQpLg0KPiBUaGlzIHN0
aWxsIGlzbid0IG1ha2luZyBzZW5zZSB0byBtZS4NCj4gVW50aWwgeW91J3ZlIGRvbmUgYSBjb25u
dHJhY2sgbG9va3VwIGFuZCBmb3VuZCB0aGUgY29ubmVjdGlvbiwgeW91IGNhbid0DQo+ICDCoHVz
ZSBOQVQgaW5mb3JtYXRpb24gdGhhdCdzIHN0b3JlZCBpbiB0aGUgY29ubmVjdGlvbi4NCj4gU28g
dGhlIE5BVCBjYW4gb25seSBoYXBwZW4gYWZ0ZXIgYSBjb25udHJhY2sgbWF0Y2ggaXMgZm91bmQu
DQoNClRoYXQncyBob3cgaXQgd29ya3MsIENUIGFjdGlvbiByZXN0b3JlcyB0aGUgbWV0YWRhdGEg
KG5mX2Nvbm4gb24gdGhlIA0KU0tCKSwgeW91IGNhbiB0aGVuLCBpZiBuZWVkZWQswqAgZXhlY3V0
ZSB0aGUgbmF0LA0KDQpUaGF0IGlzIHN0b3JlZCBpbXBsaWNpdGx5IG9uIHRoaXMgbWV0YWRhdGEg
KGJ5IHVzaW5nIHRoZSByZXZlcnNlIG9mIHRoZSANCnJlcGx5IHR1cGxlKS4gSXQncyB3aHkgbmZf
Y29ubiBzdGF0dXMgaGFzIHR3byBzdGF0dXMgYml0cyANCihJUFNfU1JDX05BVF9ET05FX0JJVMKg
IGFuZCBJUFNfU1JDX05BVCkuDQoNCkFmdGVyIHlvdSBleGVjdXRlIGl0LCBJUFNfU1JDX05BVF9E
T05FX0JJVMKgIGlzIHNldCwgaW5zdGVhZCBvZiBqdXN0IA0KSVBTX1NSQ19OQVQgKG5hdCBuZWVk
ZWQgYml0KS4NCg0KVGhlIHVzYWdlIGlzIHN0cmFpZ2h0IGZyb20gb3ZzIHRlc3RzdWl0ZSwgcGxl
YXNlIHNlZSBpdCBpbiBvdnMgZ2l0Lg0KDQo+DQo+IEFuZCBhbGwgdGhlIHJlc3Qgb2YgeW91ciBz
dHVmZiAobGlrZSBkb2luZyBjb25udHJhY2sgdHdpY2UsIGluIGRpZmZlcmVudA0KPiAgwqB6b25l
cyBYIGFuZCBZKSBpcyAnd2VpcmQnIGluYXNtdWNoIGFzIGl0J3MgYmV5b25kIHRoZSBiYXNpYyBt
aW5pbXVtDQo+ICDCoGZ1bmN0aW9uYWxpdHkgZm9yIGEgdXNlZnVsIG9mZmxvYWQsIGFuZCBpbmhl
cmVudGx5IGRvZXNuJ3QgbWFwIHRvIGENCj4gIMKgZml4ZWQtbGF5b3V0IChub24tbG9vcHkpIEhX
IHBpcGVsaW5lLsKgIFlvdSBtYXkgd2FudCB0byBzdXBwb3J0IGl0IGluDQo+ICDCoHlvdXIgZHJp
dmVyLCB5b3UgbWF5IGJlIGFibGUgdG8gc3VwcG9ydCBpdCBpbiB5b3VyIGhhcmR3YXJlLCBidXQg
aXQncw0KPiAgwqBub3QgdHJ1ZSB0aGF0ICJldmVuIG5hdCBuZWVkcyB0aGF0IiAodGhlIG5hdCBz
Y2VuYXJpbyBJIGRlc2NyaWJlZCBhYm92ZQ0KPiAgwqBpcyBlbnRpcmVseSByZWFzb25hYmxlIGFu
ZCBpcyBwZXJmZWN0bHkgd29ya2FibGUgaW4gYW4gYWxsLW9yLW5vdGhpbmcNCj4gIMKgb2ZmbG9h
ZCB3b3JsZCksIHNvIGlmIHlvdXIgY2hhbmdlcyBhcmUgY2F1c2luZyBwcm9ibGVtcywgdGhleSBz
aG91bGQgYmUNCj4gIMKgcmV2ZXJ0ZWQgZm9yIHRoaXMgY3ljbGUuDQoNClRoZSBjaGFuZ2UgZGlk
bid0IGNhdXNlIGFueSBwcm9ibGVtLCBhbmQgdGhpcyBkb2Vzbid0IGNvbnRyYWRpY3QgYW55IA0K
b3RoZXIgdmVuZG9yLCBkb2luZyB3aGF0IHlvdSBzdWdnZXN0IC0gb2ZmbG9hZGluZyBqdXN0IGEg
c3Vic2V0IG9mIHRoZSANCnJ1bGVzLg0KDQpBcyB3ZSBhcmUgZGlzY3Vzc2luZyB0aGUgY29uZmln
IGRlZmF1bHQsIEkndmUgc2VudCBhIHBhdGNoIHRvIHNldCB0aGUgDQpjb25maWcgdG8gTi4NCg0K
DQo=
