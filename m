Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609601CBE73
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgEIHkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:40:39 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:19683
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbgEIHki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 03:40:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLiQvmxt3sEX8ne/KOIwj0kmZjrjKx4FtZx34bFYqmmV6JoQ1eult65zgxndVNob6FcSWKWSc+P4FDYkLBhmYcHMsVNlYBxWDxXQNwQr6IadflGRrGxYYKdFqH85p+KqaJaMXcM1GnVzM+buSkw/Bx9Gd5jZasmpN9jCmMEo5GB4GUk9plTNNUwHQpUZuw57rMcMLOhiVr5ZNrhhUCqbfjXDIMTPsnhy3AcpSZO75Sux7g16VjWTH1cbtz7+xohTbnPhOkPaygQobIEdGnYI8b9n6UExXvYVr07sdhdnAPy7d/YjcClB9vwbzEbcJyfDh19GFSf3yAaavx/b6Xh/qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npbLoiRmQDOKeFbXPZz01SuahXe3S56M+aQ+7fQVSag=;
 b=Dk2uKSbF1xIXvQ6JpH0GeEoP24+VC9fxu4qQ27hUeElE8bVj0DK66WUBH8F5md9UXl7rJUuNMmB8P8GjqO4ZYiUkgGyed+fVfrgsuYBG7J1Zsetn7t5vIiHuE3QzbmvETM2aneHyDtnYIGciGM5tcTtbhTqjm99PtM1AdPdRrvJnh0m2qBUW/pBYgB+PIWPDMYiUJwGHswVWd2uB8K/PSAzLEQ1nrnhhjIzCPUwvftb9PiucYLJsDxwGG4O6jxu2oQr9Icrl/FRFVxyNRk0og5YnDacumCnJ8aJXHQ05qm26v33PcYfdAFvyAkDGODN1E36rpaUb++nRubJIx4kLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npbLoiRmQDOKeFbXPZz01SuahXe3S56M+aQ+7fQVSag=;
 b=bL03iyjI7t3aoL9kbSEn/iCB7nPvLEqu5j8X7ku+pyHPrLvs+2S1Uq8bV9hhuRtnN5PmalSfBt8T3Ik8BazjNka4UnB7rklY72Lm/RNeUZLbPFNrCgGZkyUBcRAQqvFuTSakApNl3Wo5flkDDu0va6dLOOg9uof4gNh+sXBzXbI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5038.eurprd05.prod.outlook.com (2603:10a6:803:61::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sat, 9 May
 2020 07:40:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 07:40:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma tree
Thread-Topic: linux-next: manual merge of the net-next tree with the rdma tree
Thread-Index: AQHWJOdqvf+wE0yjPU+ZM+uXTwctcaifYFoA
Date:   Sat, 9 May 2020 07:40:32 +0000
Message-ID: <e24d65c568803c48fa15524d6395655c98010979.camel@mellanox.com>
References: <20200508131851.5818d84d@canb.auug.org.au>
In-Reply-To: <20200508131851.5818d84d@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9417aa0e-9958-49fd-f91b-08d7f3ec417c
x-ms-traffictypediagnostic: VI1PR05MB5038:|VI1PR05MB5038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5038517B47AD7D3B85F27B47BEA30@VI1PR05MB5038.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03982FDC1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qsac5T0tFco1c1fR/eka5NYlp+G0UGXbAXcqkZTEOtFdOO9hAzPdeWu1oZpy8UlqBJssTLHr4pYA/xASrv+xTWtIl2oR6MlaDRBKoMJQ/6PVyze1pUQ+dhd9WTxUhZ/sxxXSYb2121/CTnEdY7uF5TD0MH8YjnkTLEkf0b3+8mVwx3MJ4u4geii2kU7FZeneViUCVxzWHTL8DOw/BkrREffa/oSNpFqlSUs478/G0XQfSSEpisoQ/FfNTtH38lpC0GzE9JR37MQfxsdHY8Wqxk3cHmk62NRxP31qLsghtHB0jtSrYCA65T53QUBX8dDw/ChJvqzjJ4Y/lTJGiQ7Fe3YjaTHHpa9jFE1CcT81oOpOJhvGjSyb9MBPm41H4LgOvwLfKWDrMII7vQmMIsm4WlWkaWC1H0I3E36UXzMlzvQhrP7Oa/BJaxQz79ab42R1fMuabfEE6loctaHJPCqihNbWo59rTpIZuhDBlDnHUbTSwsN6ng3C3vICMqfexFBGWNs1Cbi3KHPNvSljmvQVRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(33430700001)(110136005)(66446008)(6512007)(2616005)(33440700001)(8936002)(186003)(4326008)(26005)(76116006)(91956017)(71200400001)(54906003)(5660300002)(2906002)(6486002)(36756003)(64756008)(86362001)(66476007)(8676002)(6506007)(66946007)(66556008)(316002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: U2dDqMKDQwxCWOR3wAQFEIDm6qLc1P17wa9FxbxJf0FQuz+Fau+g2of94aHmBs/+kJCrZGCvdp4nh+3786YQ0hIu8eIwdjXEcT10ZdoDv6y8eUKIZlfgk0dLQycNu8RHhk+dSAOXz3SALWrxX1KbP9F5ycUEqgpTblSliWGZ9qwBqYZ9lG7td8cZ5Fpcyd/SacIFv31I///R+ZQyJr6CjrdJVOFez2eWT61VCxv58lswOwe7BtmiJ05J81lta0OG4IskPOAlQg5C4QNwNqw4hOKBNBHy199qrT1kjTeKHHTY7KWHyHVmL5segHO2Sn8WATi0PIkr4GZg4x/dOYg6Xp4qaM41qKpRXc9HQAt7P8Ke9t989xNjspS9rSXe/4pNE+0nSFPqGwMUbDDdlSRRUBGXhY18HHv0R3R6ifKTALV6eQPYSxh+2/l9dxFCbGRcxzAFNvkDzrBKXJ0APGDpV/BVBYf8jn2gZlPxRap7Wdg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99A37935A22DAC46961A78453C04F1D1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9417aa0e-9958-49fd-f91b-08d7f3ec417c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2020 07:40:33.1116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kgYNfE/zRVtLZGN9FP1VZ9YLP4ukaD85BfL5EX2dL1fcz3fmt7IR4GZedItECym9cb+LnmDnVK7Cgd/bWnnY7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTA4IGF0IDEzOjE4ICsxMDAwLCBTdGVwaGVuIFJvdGh3ZWxsIHdyb3Rl
Og0KPiBIaSBhbGwsDQo+IA0KPiBUb2RheSdzIGxpbnV4LW5leHQgbWVyZ2Ugb2YgdGhlIG5ldC1u
ZXh0IHRyZWUgZ290IGEgY29uZmxpY3QgaW46DQo+IA0KPiAgIGRyaXZlcnMvbmV0L2JvbmRpbmcv
Ym9uZF9tYWluLmMNCj4gDQo+IGJldHdlZW4gY29tbWl0czoNCj4gDQo+ICAgZWQ3ZDRmMDIzYjFh
ICgiYm9uZGluZzogUmVuYW1lIHNsYXZlX2FyciB0byB1c2FibGVfc2xhdmVzIikNCj4gICBjMDcx
ZDkxZDJhODkgKCJib25kaW5nOiBBZGQgaGVscGVyIGZ1bmN0aW9uIHRvIGdldCB0aGUgeG1pdCBz
bGF2ZQ0KPiBiYXNlZCBvbiBoYXNoIikNCj4gICAyOWQ1YmJjY2IzYTEgKCJib25kaW5nOiBBZGQg
aGVscGVyIGZ1bmN0aW9uIHRvIGdldCB0aGUgeG1pdCBzbGF2ZQ0KPiBpbiByciBtb2RlIikNCj4g
DQo+IGZyb20gdGhlIHJkbWEgYW5kIG1seDUtbmV4dCB0cmVlcyBhbmQgY29tbWl0Og0KPiANCj4g
ICBhZTQ2ZjE4NGJjMWYgKCJib25kaW5nOiBwcm9wYWdhdGUgdHJhbnNtaXQgc3RhdHVzIikNCj4g
DQo+IGZyb20gdGhlIG5ldC1uZXh0IHRyZWUuDQo+IA0KPiBJIGZpeGVkIGl0IHVwIChJIHRoaW5r
IC0gc2VlIGJlbG93KSBhbmQgY2FuIGNhcnJ5IHRoZSBmaXggYXMNCj4gbmVjZXNzYXJ5LiBUaGlz
IGlzIG5vdyBmaXhlZCBhcyBmYXIgYXMgbGludXgtbmV4dCBpcyBjb25jZXJuZWQsIGJ1dA0KPiBh
bnkNCj4gbm9uIHRyaXZpYWwgY29uZmxpY3RzIHNob3VsZCBiZSBtZW50aW9uZWQgdG8geW91ciB1
cHN0cmVhbSBtYWludGFpbmVyDQo+IHdoZW4geW91ciB0cmVlIGlzIHN1Ym1pdHRlZCBmb3IgbWVy
Z2luZy4gIFlvdSBtYXkgYWxzbyB3YW50IHRvDQo+IGNvbnNpZGVyDQo+IGNvb3BlcmF0aW5nIHdp
dGggdGhlIG1haW50YWluZXIgb2YgdGhlIGNvbmZsaWN0aW5nIHRyZWUgdG8gbWluaW1pc2UNCj4g
YW55DQo+IHBhcnRpY3VsYXJseSBjb21wbGV4IGNvbmZsaWN0cy4NCj4gDQoNCkhpIFN0ZXBoZW4g
YW5kIHRoYW5rcyBmb3IgdGhlIHJlcG9ydC4gDQoNCllvdXIgZml4IHNlZW1zIHRvIGJlIG9rLCBp
IHRoaW5rIGl0IGlzIG1pc3Npbmcgc29tZSBodW5rcyBmb3INCmJvbmRfZ2V0X3NsYXZlX2J5X2lk
IGZ1bmN0aW9uIGFuZCBzb21lICJsaWtlbHkiIGRpcmVjdGl2ZXMgYXJlIG1pc3NpbmcsDQp3aGlj
aCB3ZXJlIGFkZGVkIGJ5IE1hb3IncyBvciBFcmljJ3MgcGF0Y2hlcy4NCg0KQW55d2F5IHRoaXMg
aXMgYWxyZWFkeSBmaXhlZCB1cCBpbiBteSBuZXQtbmV4dC1tbHg1IHRyZWUgYW5kIHdpbGwgYmUN
CnN1Ym1pdHRlZCB2ZXJ5IHNvb24gdG8gbmV0LW5leHQgd2l0aCB0aGUgY29uZmxpY3QgZml4dXAg
Li4gDQoNClRoYW5rcywNClNhZWVkLg0K
