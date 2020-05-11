Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7191D1CCEFC
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 03:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgEKBGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 21:06:38 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:25701
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbgEKBGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 21:06:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg9QzYXX3M7V1nF9S70VIw6w1M0kzY47hZHs/2pg1b8dRY4K6ViZF+mjFNfiEQSTkdONWwXFjakemZG1bBvaN9obWgu9CXmpX+QmULz7dRwUaTAecgGZ5dRbY/KuQiadufktJ9fand4hMi2ERhbOdcAK3JPjJoZ2CGhpM2YEaoNt2LIFduCIHwtEQbyjA6l7aGXgID8pFPiE1NdNS+jVwoR/2Fhy1hlwFquPv8XUIJhWskoT5tHZK/nMpirbImrP7fXxmZbMuY1J8iIOyQFLTCLlVxyjL1iOqbJ4249GoPkRkZRGNP0bHsvlgc0IbbcVsXkH8zOsgeMXSjNiL013aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+r5HKe70mwUWcb+w4F+gTuWOIx5RteRZL9h7h8yY/7g=;
 b=ibTWJbCAHqJZwIsTaYMEujyHf378K5RR2XzftB9nA5ylKa4ozLZEeauPno4IvH/dcTo1inUMFdFwodz/N9l9pbRLlOR04LaYn6h2IahtyICkJt2+wt8tiK11LHdSZbu0QWyfKDCH9iSFd68LlF+txLHuuUPjNpso86H07ApbOG0IVB0WJuRtDwj7wG5E/Kz3i3ZRlXtC0opdPmETcf7idJLPc9udEa+eMDnPM6fAI1yT/a4jFGywamftOIffwsIvi4KStM5pBqpgqBbGbE85eTnuqlXjNMWMELvX1YFYUCUsY8fMvpxOFdTuX0+oYLhJYXfnpxmdy1I1TUBEmSej0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+r5HKe70mwUWcb+w4F+gTuWOIx5RteRZL9h7h8yY/7g=;
 b=GrPq3aTO2NlSGHxqsFTFzDjiFW2VD6zj4KeXREYbD/O/ShiOrytLtR5wkZuDePooexGZsPViCeNrNlArt0N3ybcVKiAUs/iIOawl7CL+nVFfR3ze14pqRLDWczAOcRGfBArN1F7H1mAQjTQqgSjCIlY3jHlARoN3fjcFu9nkOt8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5037.eurprd05.prod.outlook.com (2603:10a6:803:54::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.35; Mon, 11 May
 2020 01:06:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 01:06:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Replace zero-length array with flexible-array
Thread-Topic: [PATCH] net/mlx5: Replace zero-length array with flexible-array
Thread-Index: AQHWJKEJ3r6Bytxqlka8je+nQhb84qiiF4wA
Date:   Mon, 11 May 2020 01:06:32 +0000
Message-ID: <950d233a9fde390c31e0b8e55ac607bf8ca87c07.camel@mellanox.com>
References: <20200507185935.GA15169@embeddedor>
In-Reply-To: <20200507185935.GA15169@embeddedor>
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
x-ms-office365-filtering-correlation-id: 4ae6bafc-e651-443b-9fd1-08d7f5478b9f
x-ms-traffictypediagnostic: VI1PR05MB5037:|VI1PR05MB5037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5037A19A90996215FBB125DCBEA10@VI1PR05MB5037.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 04004D94E2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y4WUyt66tPatUMivAcx02J5v7vlxrxiyoaE9F1sNtvzElIPPV+HkkpKgrWPDDgOQemKyr/07p9LXpnzpYAlRjTxMknTk2UdH432pz8VfQbg5R1xDkqawCGS8/8w9NiooGDp0oBlzegqUKmPbOuYgYKzuWwfkwblTvHoXW4j/uyTbZ/651A8JYYE3jJPG99mIFG8apqeYiFezAVvAIel56dWw5Nr96pLtOe0ppULiSfT8L2LwYmvpxaranw2/lW5exHm31oZMS8WCU0hYOQlHJAZDupRozNrSzIOhisVv3/bLZdZy3KbJW9C0U5kN2jj0ZBWYvJhwiWlnpkYMh5SeDFE8Yj49Y6j9k5gmfup2qLiaCoMqwo5wC598SBn9FimeRq33joKYk2prrizk6wde4RmAq30ewIu3NUfsE3pfLicrH9bjt2Q0s96gUdjW9b4Qrf6ZutjcdvLsR8PNW7IJfrrFZQeuD8ItDQukLx2K1ICFyC1feoS9kmAK7t6eBMpk/m6rMgzQjDMtfgaL3WOUQULPsn75FZqsjfhvUFp6uxvnK+7l31ygocYMEgnATGpJLG8pRcxHJkw8+LJ5ovwNJhifjCndeI5gN0f5ez1CkQM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(33430700001)(6506007)(33440700001)(5660300002)(54906003)(110136005)(186003)(8936002)(76116006)(66476007)(66556008)(64756008)(91956017)(6512007)(6486002)(66446008)(8676002)(86362001)(66946007)(26005)(4326008)(316002)(2616005)(478600001)(966005)(2906002)(71200400001)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hDPP2dZs2b/XCZCiUGKQ1t5PsEFQcuN6vAFHhIfbOU0W/hW9oZ/CGntVT/Qf1bEOlSGIjZa871KqDOWV8aXOXEjWmDGqy/iAyzo6mB56VVkW4wP40wQRWimvbT6rnLBrBoahcmfF6Io5xdt3O7NPEHMC2UbyR7cgLDLmEFS17eswQQrZ9Up2euZGdHyCUFEctdiETH3jdl4tOgQXgR1idPWkMzmK46azQlktlqL4vMdb3hrum4P4m9V46CCEijXRNvsvuXeFOb79z4NXCZ0smF/eDC3axwvjXxnPMCVjWnXm5PvCt+W2FBnjWpfY3FutvyaAv+qwha5wXeyozpEIVnM9mLfnALyeMzfRtHGvQpqhlkqE7wHe0KSuskAd4T//2vtU53QeIEJZRrSWw5amhrWn9iYPpBvdQJOU9UfIAVXM+iPQPYeko1EWZ6T0T701SZRIBOoAK63+LHKBvKuaK3h39fBPP2B+n4YwSofJtT8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FC9E0D1B563EE41B7BDACCE5AF773C6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae6bafc-e651-443b-9fd1-08d7f5478b9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2020 01:06:32.6643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lX4Wpu+U0UkbEFPGvnyvehwJfyuRGIRhEYXQP+GpaGn2xy5A8t8AteULz9CVMDCCtZ+eYfTeYzP+B+OQ14ePuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA1LTA3IGF0IDEzOjU5IC0wNTAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiBUaGUgY3VycmVudCBjb2RlYmFzZSBtYWtlcyB1c2Ugb2YgdGhlIHplcm8tbGVuZ3Ro
IGFycmF5IGxhbmd1YWdlDQo+IGV4dGVuc2lvbiB0byB0aGUgQzkwIHN0YW5kYXJkLCBidXQgdGhl
IHByZWZlcnJlZCBtZWNoYW5pc20gdG8gZGVjbGFyZQ0KPiB2YXJpYWJsZS1sZW5ndGggdHlwZXMg
c3VjaCBhcyB0aGVzZSBvbmVzIGlzIGEgZmxleGlibGUgYXJyYXkNCj4gbWVtYmVyWzFdWzJdLA0K
PiBpbnRyb2R1Y2VkIGluIEM5OToNCj4gDQo+IHN0cnVjdCBmb28gew0KPiAgICAgICAgIGludCBz
dHVmZjsNCj4gICAgICAgICBzdHJ1Y3QgYm9vIGFycmF5W107DQo+IH07DQo+IA0KPiBCeSBtYWtp
bmcgdXNlIG9mIHRoZSBtZWNoYW5pc20gYWJvdmUsIHdlIHdpbGwgZ2V0IGEgY29tcGlsZXIgd2Fy
bmluZw0KPiBpbiBjYXNlIHRoZSBmbGV4aWJsZSBhcnJheSBkb2VzIG5vdCBvY2N1ciBsYXN0IGlu
IHRoZSBzdHJ1Y3R1cmUsDQo+IHdoaWNoDQo+IHdpbGwgaGVscCB1cyBwcmV2ZW50IHNvbWUga2lu
ZCBvZiB1bmRlZmluZWQgYmVoYXZpb3IgYnVncyBmcm9tIGJlaW5nDQo+IGluYWR2ZXJ0ZW50bHkg
aW50cm9kdWNlZFszXSB0byB0aGUgY29kZWJhc2UgZnJvbSBub3cgb24uDQo+IA0KPiBBbHNvLCBu
b3RpY2UgdGhhdCwgZHluYW1pYyBtZW1vcnkgYWxsb2NhdGlvbnMgd29uJ3QgYmUgYWZmZWN0ZWQg
YnkNCj4gdGhpcyBjaGFuZ2U6DQo+IA0KPiAiRmxleGlibGUgYXJyYXkgbWVtYmVycyBoYXZlIGlu
Y29tcGxldGUgdHlwZSwgYW5kIHNvIHRoZSBzaXplb2YNCj4gb3BlcmF0b3INCj4gbWF5IG5vdCBi
ZSBhcHBsaWVkLiBBcyBhIHF1aXJrIG9mIHRoZSBvcmlnaW5hbCBpbXBsZW1lbnRhdGlvbiBvZg0K
PiB6ZXJvLWxlbmd0aCBhcnJheXMsIHNpemVvZiBldmFsdWF0ZXMgdG8gemVyby4iWzFdDQo+IA0K
PiBzaXplb2YoZmxleGlibGUtYXJyYXktbWVtYmVyKSB0cmlnZ2VycyBhIHdhcm5pbmcgYmVjYXVz
ZSBmbGV4aWJsZQ0KPiBhcnJheQ0KPiBtZW1iZXJzIGhhdmUgaW5jb21wbGV0ZSB0eXBlWzFdLiBU
aGVyZSBhcmUgc29tZSBpbnN0YW5jZXMgb2YgY29kZSBpbg0KPiB3aGljaCB0aGUgc2l6ZW9mIG9w
ZXJhdG9yIGlzIGJlaW5nIGluY29ycmVjdGx5L2Vycm9uZW91c2x5IGFwcGxpZWQgdG8NCj4gemVy
by1sZW5ndGggYXJyYXlzIGFuZCB0aGUgcmVzdWx0IGlzIHplcm8uIFN1Y2ggaW5zdGFuY2VzIG1h
eSBiZQ0KPiBoaWRpbmcNCj4gc29tZSBidWdzLiBTbywgdGhpcyB3b3JrIChmbGV4aWJsZS1hcnJh
eSBtZW1iZXIgY29udmVyc2lvbnMpIHdpbGwNCj4gYWxzbw0KPiBoZWxwIHRvIGdldCBjb21wbGV0
ZWx5IHJpZCBvZiB0aG9zZSBzb3J0cyBvZiBpc3N1ZXMuDQo+IA0KPiBUaGlzIGlzc3VlIHdhcyBm
b3VuZCB3aXRoIHRoZSBoZWxwIG9mIENvY2NpbmVsbGUuDQo+IA0KPiBbMV0gaHR0cHM6Ly9nY2Mu
Z251Lm9yZy9vbmxpbmVkb2NzL2djYy9aZXJvLUxlbmd0aC5odG1sDQo+IFsyXSBodHRwczovL2dp
dGh1Yi5jb20vS1NQUC9saW51eC9pc3N1ZXMvMjENCj4gWzNdIGNvbW1pdCA3NjQ5NzczMjkzMmYg
KCJjeGdiMy9sMnQ6IEZpeCB1bmRlZmluZWQgYmVoYXZpb3VyIikNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4NCj4gDQoNCkFw
cGxpZWQgdG8gbWx4NS1uZXh0LCB0aGFua3MgIQ0K
