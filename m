Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1B1E0513
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 05:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388587AbgEYDQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 23:16:05 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:37504
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388419AbgEYDQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 23:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZR1QurKa9pskghVLtTvwiC0JSpWVvP51oQ4eARzXC8tTlCjaWLSs3CaDSiPnj6+Mzcr30i2sGS7+gHQ5u7oMqxhN8cbR7XgBYVow4KVzygC9J7248cDUPflMh9z5SC+Q3DPuGaMXhYZgcE9US9FE0bwkDrmPKR+YQ0Gy8PrblvGjQCOqYX1sL7dOqbDfEkdJv2ZDLo4mqnQGKAGYO/2S4Iu15klkJ338p+Cd5gc1cc92o46MVpYvpBYa16JKjhJSqktXWr2afx+UNKZKi4kPStAwV8Tee1kaBJqhQV3Vti0ckPTUOoV+zHv03WD9yrX9SV94tnGDeQMzT/NqijjLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4b91+Z01h1GyI0rBuRu64Ni0n0lk3HvpWBUocZU6Il8=;
 b=HafeKhoILcZ5QE+hY2+ZWr9PynyeWbd/JqmVcMlRCDURKApwYvahP/7N2jwN4U9f/wTGM9rrVqO80ECsAh/aTWadNOWUwGOWK/LU3r0dmETMu8lE9Wkbqh1kIkePNpRBp1LD4uenKJwcFcBuahRhsED9wjWMwJD/RSijjFsLQAEfNceY4D2DYBiGNG/7gamQnxiNH8O/dC7zsEY/SmZGPh0Tn5UBOGb1mLx2LWTwN3SuQHug8aK40jScUG7N7aKRkga3Fyi8zvdN2YZJMiu6UPmKeJJpMXOoKjJ6CvgqYfLFgW4RY2zVMYCd3AbvF6DxcsTj50uqfCJHi1lTrpDStw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4b91+Z01h1GyI0rBuRu64Ni0n0lk3HvpWBUocZU6Il8=;
 b=sH+WlCIyL6gtra4gdC+zSlxODPzEH5GoZdmdCp1aG04mf8nqQ10S8NafnEn7tU+R9tU5PWLaB7P10VUdCJm48x1ay4hKqnzIoVBZpnLUMnktgPlt2SLc03dtbImHZACbmbs0gq0DQrZzDIL6vOhJkzlcI8RXyEgEijy88SIXITw=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3752.eurprd04.prod.outlook.com
 (2603:10a6:209:23::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 03:16:01 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 03:16:01 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 2/4] dt-bindings: fec: update the gpr
 property
Thread-Topic: [EXT] Re: [PATCH net 2/4] dt-bindings: fec: update the gpr
 property
Thread-Index: AQHWLoHQN7gpdt0z6U+r6vmZ8zy9Oai1eUuAgAKo3xA=
Date:   Mon, 25 May 2020 03:16:01 +0000
Message-ID: <AM6PR0402MB36079E73B769948E717245BEFFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-3-git-send-email-fugang.duan@nxp.com>
 <CANh8QzxfVtk+3N=5UttjXK6CR9ZQ=qD-Twu7y-zKabLJZGQ2yQ@mail.gmail.com>
In-Reply-To: <CANh8QzxfVtk+3N=5UttjXK6CR9ZQ=qD-Twu7y-zKabLJZGQ2yQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: flowbird.group; dkim=none (message not signed)
 header.d=none;flowbird.group; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a7317398-da67-4cd7-aaa8-08d80059f3d2
x-ms-traffictypediagnostic: AM6PR0402MB3752:
x-microsoft-antispam-prvs: <AM6PR0402MB3752520126C246C2ADD8BE39FFB30@AM6PR0402MB3752.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F8LzGhyUqV3p0D6j17bSzgPjxrkb0laggFKmiEkftWM2lhzYlOvf+z8Xb0K1IbBkWsYriryU7Tdrfdq0PLCVw80ecPheBVEek+K/ZRQnoBmFHAkbXmtddIqXyMmo1PZayKIPzjhXe8oEIaLpIajU9Mg6ttaRnpE2udB+nWigyl9BDzirsMQsEp9InBRS2NVpWE6LAtcYzqpIwRVaDao26vS3txM6lvYfGGVYWa+d3MYvsuB9HbvBKmEnmlPCSBFeFlNzQAzjIXeO9tFYU3rgBJV5ENeI8a1KKr4Q49qIg1eo7z7orgpq+fiW3Wrg5rd8Y8TLag3NL6heXRRsE4vuwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(66556008)(66446008)(64756008)(66476007)(52536014)(66946007)(478600001)(6506007)(86362001)(76116006)(9686003)(186003)(2906002)(5660300002)(71200400001)(316002)(55016002)(26005)(8936002)(8676002)(33656002)(7696005)(6916009)(54906003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: k6k204vlIyUkOeBYW32JpaiujyHWh2B3E0z5ioAL3g9OjqI2sExS/oVU+HcLH98+qn8N6gYkMN5wUsdtzD3vlj3RY0cT7cxOqRZdQAEE7xMpawyndnIv/XXEVc057Rcgc1XaoGiW5IUVH/KvGEUICt2u2OdUA5+7rPKWWwjEEkJBwxx+3aFb/Nx/Nwctyziwj30vOnbsiXKHSQDvKGtY6bPkFOBZ2+h9ceIkIHACdkK80Hf8wX27rE9gPE2xc456bIM1AnxXxFzFRQFpkiDxHfrhQd0JbXZ7F1WDBB5rQ3wI9+x1awzsnmNc5CCIfJqhOpav08mbNE2ShPrmfh6vRKEIispdRgsAgBBGqTni3W7GRNCQIBZfTIAmRn4bc34zLLv/QywYL6cvT++1H1vxmB1kxT+qJjCy5J8buyIlT5bn06A7X1LkIQ57ILaa5wu5CMJvAsr3gzd8YGb17fEI+ASCvK3m2eDf6T+kQfdfrHw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7317398-da67-4cd7-aaa8-08d80059f3d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 03:16:01.5254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IgPxLEhA9fieaKaO06Z5iRwjts0R7eNhPmHz7ysDXn5Sws6Pam7W8eOPhxqE7sLnT1taCiK/uQYIL5Inbz809A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRnV6emV5LCBNYXJ0aW4gPG1hcnRpbi5mdXp6ZXlAZmxvd2JpcmQuZ3JvdXA+IFNlbnQ6
IFNhdHVyZGF5LCBNYXkgMjMsIDIwMjAgNjoxNiBQTQ0KPiA+ICAtIGdwcjogcGhhbmRsZSBvZiBT
b0MgZ2VuZXJhbCBwdXJwb3NlIHJlZ2lzdGVyIG1vZGUuIFJlcXVpcmVkIGZvcg0KPiA+IHdha2Ug
b24gTEFODQo+ID4gLSAgb24gc29tZSBTb0NzDQo+ID4gKyAgb24gc29tZSBTb0NzLiBSZWdpc3Rl
ciBiaXRzIG9mIHN0b3AgbW9kZSBjb250cm9sLCB0aGUgZm9ybWF0IGlzDQo+ID4gKyAgICAgICA8
JmdwciByZXFfZ3ByIHJlcV9iaXQ+Lg0KPiA+ICsgICAgICAgIGdwciBpcyB0aGUgcGhhbmRsZSB0
byBnZW5lcmFsIHB1cnBvc2UgcmVnaXN0ZXIgbm9kZS4NCj4gPiArICAgICAgICByZXFfZ3ByIGlz
IHRoZSBncHIgcmVnaXN0ZXIgb2Zmc2V0IGZvciBFTkVUIHN0b3AgcmVxdWVzdC4NCj4gPiArICAg
ICAgICByZXFfYml0IGlzIHRoZSBncHIgYml0IG9mZnNldCBmb3IgRU5FVCBzdG9wIHJlcXVlc3Qu
DQo+ID4NCj4gDQo+IE1vcmUgb2YgYSBEVCBiaW5kaW5nIGNoYW5nZXMgcG9saWN5IHF1ZXN0aW9u
LCBkbyB3ZSBjYXJlIGFib3V0IHN1cHBvcnRpbmcNCj4gdGhlIG9sZCBubyBhcmd1bWVudCBiaW5k
aW5nIHRvbz8NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgaXQgYWN0dWFsbHkgbWF0dGVycyBzZWVpbmcg
YXMgdGhlIG5vIGFyZ3VtZW50IGdwciBub2RlIGJpbmRpbmcNCj4gd2FzIG9ubHkgYWRkZWQgcmVj
ZW50bHkgYW55d2F5Lg0KPiBCdXQgaXQgd2FzIGJhY2twb3J0ZWQgdG8gdGhlIHN0YWJsZSB0cmVl
cyBhbmQgRG9jdW1lbnRhdGlvbi9iaW5kaW5ncy9BQkkudHh0DQo+IHNheXMNCj4gDQo+ICAgICJC
aW5kaW5ncyBjYW4gYmUgYXVnbWVudGVkLCBidXQgdGhlIGRyaXZlciBzaG91bGRuJ3QgYnJlYWsg
d2hlbiBnaXZlbg0KPiAgICAgIHRoZSBvbGQgYmluZGluZy4gaWUuIGFkZCBhZGRpdGlvbmFsIHBy
b3BlcnRpZXMsIGJ1dCBkb24ndCBjaGFuZ2UgdGhlDQo+ICAgICAgbWVhbmluZyBvZiBhbiBleGlz
dGluZyBwcm9wZXJ0eS4gRm9yIGRyaXZlcnMsIGRlZmF1bHQgdG8gdGhlIG9yaWdpbmFsDQo+ICAg
ICAgYmVoYXZpb3VyIHdoZW4gYSBuZXdseSBhZGRlZCBwcm9wZXJ0eSBpcyBtaXNzaW5nLiINCj4g
DQo+IE15c2VsZiBJIHRoaW5rIHRoaXMgaXMgb3ZlcmtpbGwgaW4gdGhpcyBjYXNlIGFuZCBhbSBm
aW5lIHdpdGgganVzdCBjaGFuZ2luZyB0aGUNCj4gYmluZGluZyB3aXRob3V0IHRoZSBkcml2ZXIg
aGFuZGxpbmcgdGhlIG9sZCBjYXNlIGJ1dCB0aGF0J3MgUm9iJ3MgY2FsbCB0byBtYWtlIEkNCj4g
dGhpbmsuDQoNClRoZSBwYXRjaCBzZXQgaXMgdG8gYWRkIGFyZ3VtZW50IGJpbmRpbmcsIGFuZCBk
cml2ZXIgYWxzbyBkb2Vzbid0IHN1cHBvcnQgd29sDQp3aXRob3V0IGFyZ3VtZW50IGJpbmRpbmcu
DQoNCkFzIHlvdSBrbm93LCBjdXJyZW50IGRyaXZlciBvbmx5IHdvbCBmZWF0dXJlIHJlcXVlc3Rz
IHRoZSBwcm9wZXJ0eS4NCkkgYW0gbm90IHVuZGVyc3RhbmQgd2h5IHdlIG5lZWQgdG8gc3VwcG9y
dCB0aGUgb2xkIHdpdGhvdXQgYXJndW1lbnQgYmluZGluZy4NCg0KV2VsY29tZSB0byB5b3VyIHN1
Z2dlc3Rpb24gZm9yIHRoZSBzb2x1dGlvbi4NCg0KQW5kICdncHInIHN0cmluZyBpcyBub3QgZ29v
ZCBkZXNjcmlwdGlvbiBmb3Igc3RvcCBtb2RlLCBJIHdpbGwgY2hhbmdlIGl0IHRvIHRoZSBzdHJp
bmc6DQonIGZzbCxzdG9wLW1vZGUnLg0K
