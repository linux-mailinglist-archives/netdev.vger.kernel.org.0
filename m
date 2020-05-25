Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C071A1E04C5
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbgEYCge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:36:34 -0400
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:24590
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388110AbgEYCgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 22:36:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPvpCGMh7lNXqHH1/GEglF+1LAe2NVNbUG2Cx6b3DwuwGieYKNO2nGZVjKIiHasTbG/IXdGNamOaFZ6SgvT2qIzsfmOcimzAdzeM8PZzHHO9F3vZHDdckgf8bMld0bR7kZWoCE/lv0LlW01LCoocsDNDWUvYQm8AZQPv5nY2rRKY8O3IAwSJ/XRZJKqZ+E1iELESno2tkQksUtCoal27G1hENrgRZa2S3af5bugLOyZXUY6JLRGhDlyhZFO6cIcNAvl2D+9V8F1aEtZIaTgrRK9nF5HywY1HpZGVdzN2MkQY3E7usmwf/rs/3SjEEuQe1X250Rtc0PccK+LCyeUBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2c8Pb1e3TIaf5M4XqpvxDyou3hkbHQDr76jyKenfNek=;
 b=gPPcdTt3u+4rPR+FYae7iEbDCitDQ4a4G7iToN151ydWT+ID4lta0JfoaBzJlckmL8iC3cEHXZ+x052sbEBcCN0rHRnROZMzhizGHZvQ1qE+S7FJGO+OBUH9uIMFw1/AI4TKgD63K7tcDX/Flambhr0125Pi8UtEf2ieaZiVZWgGkyJ3lpac68ScOtOqUXDPHDlsWnDn3raeTsZlcgR+/a25TEAwX9I709vZB+Yua/hjmtQLbaSQ/OQWvGhD/wX340HIZ03h3dLmKPKy7JErF5/JFDIZUNIJ2BGQfAvUgmkdUR1qTNZW0tHlE6xbvN0ALMH+r83vddyuS9CUYE20Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2c8Pb1e3TIaf5M4XqpvxDyou3hkbHQDr76jyKenfNek=;
 b=TWY1wpNkYDH77DI7I7RUVpIQbVPO8B3Suq+YyzsD7U5eOqubYfi8zUUoSHwQnYm39wz42Ba9XGWr7nbRIQxlCCBMYBqoOAJ1wTsg5x3jrCodiPbpFhqpiEkAXiUkdqPl010K5Aq/DKQxLM09Own0We60o7ZWIPpXov0SweKg1Y4=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3574.eurprd04.prod.outlook.com
 (2603:10a6:209:9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 02:36:29 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 02:36:29 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 1/4] net: ethernet: fec: move GPR register
 offset and bit into DT
Thread-Topic: [EXT] Re: [PATCH net 1/4] net: ethernet: fec: move GPR register
 offset and bit into DT
Thread-Index: AQHWLoHPjdUrXObnOkaNyQWAWrHig6i1c5IAgAKowkA=
Date:   Mon, 25 May 2020 02:36:29 +0000
Message-ID: <AM6PR0402MB36074B1C1417EBBE0B58FBC7FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-2-git-send-email-fugang.duan@nxp.com>
 <CANh8QzxuHAu+L0swPC5V4Oca21Z5zpiULTm22VPShX_T-JVznQ@mail.gmail.com>
In-Reply-To: <CANh8QzxuHAu+L0swPC5V4Oca21Z5zpiULTm22VPShX_T-JVznQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: flowbird.group; dkim=none (message not signed)
 header.d=none;flowbird.group; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c7d68309-72bf-4a71-73e7-08d800546e0c
x-ms-traffictypediagnostic: AM6PR0402MB3574:
x-microsoft-antispam-prvs: <AM6PR0402MB3574C02CFCEB60D390A9EC2FFFB30@AM6PR0402MB3574.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UYuG7f84CGQDZ2wZsWBqyAI9BU53LYJbM0GptUZQXQ3j4If2eh+NjcrzZlcgq2M44UTenf90vX1wlVU2x8IVpD7IjeWbjjd3QL/ZkxqH+DNt+O2IcjMiBPWCfmjucnNhICoxfysPs5DBlGMOhg85n/4exIA0a5yR01qlfHjbaPSr6IilZ+D4OHYZQAdKHALPb4WQXWOPhZO6hvHIQg7s/bkSrSyo6vbZbz8B/HLFSAKDdLtF2lxCMNa2GGc8PJTx0Ybdw6nRLaUOl0qFpR9ZRmY1r9nfMMaHZHx9KcqgqGqDPShJJRrjcY/Mb80Iy4plzLQFERtTgcjW8XwSI8RP6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(66446008)(66476007)(66556008)(76116006)(66946007)(64756008)(478600001)(52536014)(186003)(4326008)(5660300002)(9686003)(26005)(6506007)(7696005)(71200400001)(8936002)(8676002)(55016002)(2906002)(54906003)(86362001)(6916009)(316002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fW2LjlXj/ibNZxEFES/s1p/+Z0gWJheUcvNhc0cCTf08S+xO/pPBbTMzdKWF94LHncYf9RnwCEYqgD6cbdeuF3v3xiENVSMG9oUpXZoXZKatPnESd4My3DQoy+fxWyUv2WoUNXO3dg0i5gmSHKGkeYpPR02EDfuRWKrLDWTX5Rzz9BF3UeVGqVQOLtcXaOvkdLxjJDnBWUroIy5SK7wkLezCJKEAZCBaCmMPHddsX4RE/vDbpL2IRdn2Zc/1ST4Vy5vvenoGRLm9TcFRhzlqBXCHMFy9xSLCCZgJCWeBv0nY5DsS0YoOQPY5x/+n8OzXUubie1RuGyT1gXUGMGfNRfsUe/l7XR4pQSE7jfta5jIQszseN2turrOKR8TZ8/osa/lfkk4fRMNV7Pf+QYOflp8d6BeSj9qDx5jV3rCtLNou3FZ+ymQN2tXeHcEysuMdAlYq0avtlX2SDmNbYuwsdIAwcU8WEEhelLlTRPnH7C8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d68309-72bf-4a71-73e7-08d800546e0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 02:36:29.6278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbHtZC2u3WvLsKeBpejUB/4DyJ2qQWvY9xyfXJU9CnAui109JKprhinj52MuWvn0AL2TPPB9KRwyTQlUG95iWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3574
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRnV6emV5LCBNYXJ0aW4gPG1hcnRpbi5mdXp6ZXlAZmxvd2JpcmQuZ3JvdXA+IFNlbnQ6
IFNhdHVyZGF5LCBNYXkgMjMsIDIwMjAgNTo1NiBQTQ0KPiBIaSBBbmR5LA0KPiANCj4gPiBGaXhl
czogZGE3MjIxODZmNjU0KG5ldDogZmVjOiBzZXQgR1BSIGJpdCBvbiBzdXNwZW5kIGJ5IERUDQo+
ID4gY29uZmlndXJhdGlvbikNCj4gDQo+IEp1c3QgYSBuaXRwaWNrIG1heWJlIGJ1dCBJIGRvbid0
IHJlYWxseSB0aGluayB0aGlzIG5lZWQgYXMgRml4ZXM6IHRhZy4NCj4gVGhhdCBjb21taXQgZGlk
bid0IGFjdHVhbGx5ICpicmVhayogYW55dGhpbmcgQUZBSUsuDQo+IEl0IGFkZGVkIFdvTCBzdXBw
b3J0IGZvciAqc29tZSogU29DcyB0aGF0IGRpZG4ndCBoYXZlIGFueSBpbiBtYWlubGluZSBhbmQN
Cj4gZGlkbid0IGh1cnQgdGhlIG90aGVycy4NCj4gT2YgY291cnNlIGl0IHR1cm5lZCBvdXQgdG8g
YmUgaW5zdWZmaWNpZW50IGZvciB0aGUgbXVsdGlwbGUgRkVDIGNhc2Ugc28gdGhpcw0KPiBwYXRj
aCBzZXJpZXMgaXMgYSB3ZWxjb21lIGltcHJvdmVtZW50Lg0KU29ycnksIG5vdCB0byBodXJ0IHlv
dSBpbnRlbnRpb25hbGx5LCBJIHRoaW5rIHRoZSBjb21taXQgZGE3MjIxODZmNjU0IGJyZWFrIG11
bHRpcGxlIGluc3RhbmNlcy4NClRvdGFsbHkgSSBhY2NlcHQgeW91ciBzdWdnZXN0aW9uLCBpdCBz
aG91bGQgYmUgaW1wcm92ZW1lbnQgIQ0KDQo+IA0KPiANCj4gPiAgc3RydWN0IGZlY19kZXZpbmZv
IHsNCj4gPiAgICAgICAgIHUzMiBxdWlya3M7DQo+ID4gLSAgICAgICB1OCBzdG9wX2dwcl9yZWc7
DQo+ID4gLSAgICAgICB1OCBzdG9wX2dwcl9iaXQ7DQo+ID4gIH07DQo+IA0KPiBUaGlzIHN0cnVj
dHVyZSBoYXMgYmVjb21lIHJlZHVuZGFudCBub3cgdGhhdCBpdCBvbmx5IGNvbnRhaW5zIGEgc2lu
Z2xlDQo+IHUzMiBxdWlya3MgZmllbGQuDQo+IFNvIHdlICpjb3VsZCogZ28gYmFjayB0byBzdG9y
aW5nIHRoZSBxdWlya3MgYml0bWFzayBkaXJlY3RseSBpbiAuZHJpdmVyX2RhdGEgYXMNCj4gd2Fz
IGRvbmUgYmVmb3JlLg0KPiANCj4gSXQncyBhIHNsaWdodCB3YXN0YWdlIHRvIGtlZXAgdGhlLCBu
b3cgdW5uZWNlc3NhcnksIGluZGlyZWN0aW9uLCB0aG91Z2ggdGhlDQo+IHNpemUgaW1wYWN0IGlz
IHNtYWxsIGFuZCBpdCdzIG9ubHkgdXNlZCBhdCBwcm9iZSgpIHRpbWUgbm90IG9uIGEgaG90IHBh
dGguDQo+IA0KPiBCdXQgc3dpdGNoaW5nIGJhY2sgY291bGQgYmUgc2VlbiBhcyBjb2RlIGNodXJu
IHRvby4uLg0KPiANCj4gSSBkb24ndCBoYXZlIGEgc3Ryb25nIG9waW5pb24gb24gdGhpcywgc28g
anVzdCBub3RpbmcgaXQgdG8gc2VlIHdoYXQgb3RoZXJzIHRoaW5rLg0KPiANCj4gTWFydGluDQoN
ClRvIG1ha2UgY29kZSBjbGVhbiwgd2Ugc2hvdWxkIHN3aXRjaCBiYWNrLiBJIHdpbGwgY2hhbmdl
IGl0IGluIFYyLg0KVGhhbmtzIGFnYWluIGZvciB5b3VyIHJldmlldy4NCg==
