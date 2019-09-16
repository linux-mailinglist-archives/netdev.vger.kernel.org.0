Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975C4B3647
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 10:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfIPIOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 04:14:52 -0400
Received: from mail-eopbgr80083.outbound.protection.outlook.com ([40.107.8.83]:1078
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbfIPIOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 04:14:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuzlUT71Imh7WDChwH5K5iSW6wHrnyridKC4ppwkln0yq3mvkxArxOiBHrUTDwtdO1JSasXyO6QtCNGqofMwzRLSAUSmxtgEwmsE2TMFc1BiM4K9h7/oR9mGyUeEzU+L5d0zw7HdNk+lNZ1UHO5O+zGCSIQzSBS2v9QKW8ueQEJLMKfzJCTLhBH9P2LowDhp4wtCyKW7lhZWWDEOBp8SuJWsBDCMEqHTrqxkHiSLME+i4Vg51I7kx+Ega5bA60YKPsaYH7+rORhWc06G1jptylwbQCW3Ic7sCvzgdMuoasPwPvSp+c6G+bTN1NZYwBq3w/rArmDgUt9KwX61QfRIMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Lg9sGGFl2k0LJE2800/JD0yBMyfo6Pf1oTCavs4zXg=;
 b=Vg3rMMydr4Hyke4gemcck2BSvBmClua1g+O3YN/6uM04RH2/CL8ix301oPQAm7h3EEtz5zNPtcStYcM9lNvUEBcXwv3gTU4r2oLRNMCblgeBpf0lq7wvSiK9s6lPcNZAZvEa1mSlXA5Pg6nuW59dIgGQwmegN8r/sXS7GexFSPmCMszAC24fO0XyZro/2Hp0trvUVzAv93ZMhtIAlAf3CiJ/BSGEx7gr4wl/p5n0LmqKa+DLuBCmwJx7Fzcu9giLyedoOx4/r6pOFMgW++2b94934k9sSsjftw0tyTudhysOSdKB7PCjtYOVlPY/WfJP0e+poyHH6zBoYpvjfzyh7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Lg9sGGFl2k0LJE2800/JD0yBMyfo6Pf1oTCavs4zXg=;
 b=P4fa9bO71mxvFRcTYmMEyfsbeH937m50NIyc+UyJkTGwrDAoews/D1YYlCv+QuI4l9CRpv98VMjjUCzCgrZPTrwi9kDUyy7HYVNvc6r8QqIAJ5uAp5jzfN6QeW03yZaokt24l4q+vvU2NlDuta6aUdKxLm2hBN2hC7OMPusNRLg=
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com (52.133.17.145) by
 AM6PR0502MB3719.eurprd05.prod.outlook.com (52.133.21.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.26; Mon, 16 Sep 2019 08:14:47 +0000
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::d948:8f02:2013:991b]) by AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::d948:8f02:2013:991b%3]) with mapi id 15.20.2241.026; Mon, 16 Sep 2019
 08:14:47 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] mlxsw: spectrum_buffers: Add the ability
 to query the CPU port's shared buffer
Thread-Topic: [PATCH net-next v2 0/3] mlxsw: spectrum_buffers: Add the ability
 to query the CPU port's shared buffer
Thread-Index: AQHVbFadRw/d6MLkEEi85wg5LHdYLact9OuA
Date:   Mon, 16 Sep 2019 08:14:47 +0000
Message-ID: <95297977-0757-68c2-77f3-960056050fb3@mellanox.com>
References: <20190916061750.26207-1-idosch@idosch.org>
In-Reply-To: <20190916061750.26207-1-idosch@idosch.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-clientproxiedby: PR1PR01CA0009.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::22) To AM6PR0502MB3783.eurprd05.prod.outlook.com
 (2603:10a6:209:3::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7572bda-10d7-49f5-1fb5-08d73a7df07f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR0502MB3719;
x-ms-traffictypediagnostic: AM6PR0502MB3719:|AM6PR0502MB3719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0502MB37192BC72B6C87E3EF595C13C58C0@AM6PR0502MB3719.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(189003)(199004)(305945005)(71190400001)(110136005)(54906003)(316002)(58126008)(8936002)(36756003)(81156014)(31686004)(476003)(229853002)(53936002)(6512007)(6486002)(6436002)(6116002)(3846002)(446003)(11346002)(2616005)(186003)(52116002)(99286004)(53546011)(6506007)(66446008)(7736002)(64756008)(66476007)(66556008)(386003)(26005)(76176011)(102836004)(66946007)(86362001)(31696002)(2201001)(65806001)(65956001)(81166006)(66066001)(6246003)(107886003)(8676002)(2501003)(14454004)(25786009)(486006)(478600001)(4326008)(71200400001)(5660300002)(256004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0502MB3719;H:AM6PR0502MB3783.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1+rU247KrIyk7CcgeLGW0GgzSUx/X4gGbSqFtCpCU6Qez5BSZI5cXuJzF7vRY4QDRjPjZNDVRr2GXtphGe/Rat3fIFGIq77kDU+0UFT1gA+IzHpwIjeuRfO3Gfg4R+0WDiAXoJHjDY54OuvAetPQ+WDHnAqYU1uDpts/0g0LQ8KHYXQdKCkI+GdnTX1rFpDhgBs3IxmtQZeMLnQQ9LlqcCkVs2LQfddcSn0NaX5b1F3mrz5IvvdHnoalhrod2icUYTScKQVSA5VvZY8XgeC43WIMBhca/GRxScM4R7y9DnxCldOPcBd74wj67jZcpa62hwK/SfAzK1LM0KrXnwvZr0cBy/46hHU4//c9OUHOKcTFwu6XdK+vrf7q9GiAFLt4tMgmPfVUR03OT4zfX0cZ9xWWp8i+vtmobhoAyOaFmAw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23A13C3DD3A827409E05ABE785F6658D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7572bda-10d7-49f5-1fb5-08d73a7df07f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 08:14:47.8072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PHhZWmOivIkBXs3MRUCMp1gJBd/0o+J1sx3bKv0yRD+9CM39WBt7oXNYLilFHYJGaOLCvC0iZMtWJXpvYHGl6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3719
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCkkgaGF2ZSB2MyB3aXRoIGFsbCB0aGUgZml4ZXMgSmlyaSBjb21tZW50ZWQu
IENhbiBJIHNlbmQgaXQ/IE9yIHNob3VsZCBJIHdhaXQNCnVudGlsIG5ldC1uZXh0IHdpbGwgYmUg
b3BlbiBhZ2Fpbj8NCg0KVGhhbmtzLA0KU2hhbG9tLg0KDQpPbiAxNi8wOS8yMDE5IDk6MTcsIElk
byBTY2hpbW1lbCB3cm90ZToNCj4gRnJvbTogSWRvIFNjaGltbWVsIDxpZG9zY2hAbWVsbGFub3gu
Y29tPg0KPiANCj4gU2hhbG9tIHNheXM6DQo+IA0KPiBXaGlsZSBkZWJ1Z2dpbmcgcGFja2V0IGxv
c3MgdG93YXJkcyB0aGUgQ1BVLCBpdCBpcyB1c2VmdWwgdG8gYmUgYWJsZSB0bw0KPiBxdWVyeSB0
aGUgQ1BVIHBvcnQncyBzaGFyZWQgYnVmZmVyIHF1b3RhcyBhbmQgb2NjdXBhbmN5Lg0KPiANCj4g
UGF0Y2ggIzEgcHJldmVudHMgY2hhbmdpbmcgdGhlIENQVSBwb3J0J3MgdGhyZXNob2xkIGFuZCBi
aW5kaW5nLg0KPiANCj4gUGF0Y2ggIzIgcmVnaXN0ZXJzIHRoZSBDUFUgcG9ydCB3aXRoIGRldmxp
bmsuDQo+IA0KPiBQYXRjaCAjMyBhZGRzIHRoZSBhYmlsaXR5IHRvIHF1ZXJ5IHRoZSBDUFUgcG9y
dCdzIHNoYXJlZCBidWZmZXIgcXVvdGFzIGFuZA0KPiBvY2N1cGFuY3kuDQo+IA0KPiB2MjoNCj4g
DQo+IFBhdGNoICMxOg0KPiAqIHMvMC9NTFhTV19QT1JUX0NQVV9QT1JULw0KPiAqIEFzc2lnbiAi
bWx4c3dfc3AtPnBvcnRzW01MWFNXX1BPUlRfQ1BVX1BPUlQiIGF0IHRoZSBlbmQgb2YNCj4gICBt
bHhzd19zcF9jcHVfcG9ydF9jcmVhdGUoKSB0byBhdm9pZCBOVUxMIGFzc2lnbm1lbnQgb24gZXJy
b3IgcGF0aA0KPiAqIEFkZCBjb21tb24gZnVuY3Rpb25zIGZvciBtbHhzd19jb3JlX3BvcnRfaW5p
dC9maW5pKCkNCj4gDQo+IFBhdGNoICMyOg0KPiAqIE1vdmUgImNoYW5naW5nIENQVSBwb3J0J3Mg
dGhyZXNob2xkIGFuZCBiaW5kaW5nIiBjaGVjayB0byBhIHNlcGFyYXRlDQo+ICAgcGF0Y2gNCj4g
DQo+IFNoYWxvbSBUb2xlZG8gKDMpOg0KPiAgIG1seHN3OiBzcGVjdHJ1bV9idWZmZXJzOiBQcmV2
ZW50IGNoYW5naW5nIENQVSBwb3J0J3MgY29uZmlndXJhdGlvbg0KPiAgIG1seHN3OiBzcGVjdHJ1
bTogUmVnaXN0ZXIgQ1BVIHBvcnQgd2l0aCBkZXZsaW5rDQo+ICAgbWx4c3c6IHNwZWN0cnVtX2J1
ZmZlcnM6IEFkZCB0aGUgYWJpbGl0eSB0byBxdWVyeSB0aGUgQ1BVIHBvcnQncw0KPiAgICAgc2hh
cmVkIGJ1ZmZlcg0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seHN3L2Nv
cmUuYyAgICB8IDY1ICsrKysrKysrKysrKysrKystLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seHN3L2NvcmUuaCAgICB8ICA1ICsrDQo+ICAuLi4vbmV0L2V0aGVybmV0L21l
bGxhbm94L21seHN3L3NwZWN0cnVtLmMgICAgfCA0NiArKysrKysrKysrKysrDQo+ICAuLi4vbWVs
bGFub3gvbWx4c3cvc3BlY3RydW1fYnVmZmVycy5jICAgICAgICAgfCA1MSArKysrKysrKysrKyst
LS0NCj4gIDQgZmlsZXMgY2hhbmdlZCwgMTUwIGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygt
KQ0KPiANCg0K
