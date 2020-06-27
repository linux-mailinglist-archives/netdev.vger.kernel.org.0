Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AD320C431
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgF0UwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:52:10 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:43399
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbgF0UwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 16:52:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGi+27MTIXFBnvYW/48EFU7FNYuXMY/jEHC194hE+J6BmX87yEqiiHqJ++XV8H0KlcGJ3xSt0OtAnOOAxaNtXAqZUckK9dLDKBSy8pNIdOQ2/6p26UC1KgEtaqkEuzYBd4XAoyeDpwtfC2f1D+4Plg4fbGx42pmmsdt1rm7WhqZqHwhiVHKWewh2HCx6aPD0uo5YY9bmrbwLB4p2EFxASDS/IF3eBG2K629vcqXMp2pYrKVZnH0IQMgZ5pzztQbZQcgCzmFoQgsf/btbGwYGq3iKf1VoffkQ+FWVINf26i7v4Seg21LmTZFqQcmX1k3IGoybpyw6LK9fO/U06AGANQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBBMtOM8jo76WxsiLpzFNYQ33b1SiT0KbF5pMbKBkls=;
 b=Y4l6wZAv+jDQmSGxP2I4PcfWk1n8Iw2qEFiuKofzYeUTwbfKH26/2ad1ydWFiB50oUHqU1OaSgb11+cNIZLljDHeqmpXuoAZ2fQ0i3UzN0h2fFbN8wRMUqowvsPYLoL9E1MuANguAypbLarNLpXDYtnh5f5pV4EHdszyJ6xp6cZ3ZbcUHsH2s1/28Okgn/dxbej2GNe0maM2ZiUcgsA5aRh7i3MIznkshy2o12oPb6r8jgUjdhJ7PCKg217DCL1Gxwh7imIVh5v7y+7cO2zkwQElZRKagBjgjOpkf6fU371rd4wqPAsgr2qVx72atGUwwtyc/CjZpOEd9JL7kHq+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBBMtOM8jo76WxsiLpzFNYQ33b1SiT0KbF5pMbKBkls=;
 b=UPTggNCdv5AZgPjnplNXPJrxz1WB175lp4kVAYkOrk/suIECMF76EYhgOaPUaBrsMKwYA6xLrANC8zrnwgVSiRMrNqVlhdC21ugJkpNDn4aHBYikEius1v9g9RAz6PZsewcre3Ur0tToy7eKcjFmuVNP8m4kt6KRIQOJBIkh96Y=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6591.eurprd05.prod.outlook.com (2603:10a6:803:102::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Sat, 27 Jun
 2020 20:52:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 20:52:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/3] mlx5 next updates 2020-06-25
Thread-Topic: [PATCH mlx5-next 0/3] mlx5 next updates 2020-06-25
Thread-Index: AQHWS36eExRjwuaSM0K0EJH/t44pMajs8p+A
Date:   Sat, 27 Jun 2020 20:52:03 +0000
Message-ID: <6ac1d135036c439a2f862be54808d937808ea3f8.camel@mellanox.com>
References: <20200626055612.99645-1-saeedm@mellanox.com>
In-Reply-To: <20200626055612.99645-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 834aaf28-2688-43a4-a5f8-08d81adbf280
x-ms-traffictypediagnostic: VI1PR05MB6591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB65912B56DBEFB8A5090E5962BE900@VI1PR05MB6591.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0447DB1C71
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IWdUkzlu7OiKe1eslUhPW5XmfNrrUopMnEvl63UvOxpwNdHdCnpgy6RZ35A6LdUsy1Qj19w0zzhedl5u4O3jzzgb5NRbp45OZEeaZt//wIexYXXOggd5xHGYUjgqGjRfxmSFxauLz84FZsyOCKNutipHEmHX5jn5zGftH8cESDEI5trUXdxsoUXpe4PQJOGp4qRRqhMOB9nehwhQw9Ls4D6ZxmxkUZR3oKVyzaGvQ0bnbn4smGifbp3UjFicVPSChwvWyp24uUvl1Vt2jDd369fORe5rA9Pdp4keuiHerRD5ELSWz9AWtYchAguwlocEv5DmWH0gHp4TF5fM3rVvuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(346002)(136003)(366004)(376002)(66446008)(64756008)(66556008)(6862004)(71200400001)(6512007)(86362001)(6506007)(37006003)(8676002)(558084003)(478600001)(5660300002)(91956017)(36756003)(66476007)(8936002)(76116006)(66946007)(4326008)(186003)(450100002)(2616005)(26005)(54906003)(2906002)(6636002)(6486002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9OYI1HUWgtTRppq1cvN6ZFhf0wI8sEZurUhpKF0k6lQjlPh7fP0+zxcCd1tGXXO49gBfDfvskDgyfWmfjFcNkgv9zHJD3zFHJLgSoVtbEdEd6VnPpZJZbkW3xJu7A5/G583ZRvi7mXPOo9ICmhBdFpd1iY1YTEzZHNvSystPaD+M2uRZIug+uSwVvp3UfOvt9a2C+q5NaifI0JeXBpF7wMDsXDLRzcPhP6mJff/Ix42Y2vUdLQe1DZdK1Gwj8BqlXdd+9b3BZQooS5otZ020jnFUM9dUXGIP0USMruRsA4d6Nslk4RkGoNgj7ywLoBMUl/iBG4QPOfo52P17U2BucclG7b+OgZQqmhDCzSepJvtaYL8GTSf1StO122WB/JfNsPuEHOMhBo4lN+nWxTBvv1YRuQTWDU4VOS+hln/4LAD3FHQEVXoaLmx3r7M1fy95zkzQJoP1Peez/EAfyiwT3q8kp7Cd0wbUxtyLQsQtTbs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A06DE71B2173F4D90FFD7AEF28B4C0A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834aaf28-2688-43a4-a5f8-08d81adbf280
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2020 20:52:03.8894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EKlcgbGjwilofREJaeup7fiDcVDKseDpuxKt7pEfByAl5Z/HEsUzb5/jgTl4bf4/FrWZQ55jPiad5Hag4ig/IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6591
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA2LTI1IGF0IDIyOjU2IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gVGhpcyBzbWFsbCBwYXRjaHNldCBpbmNsdWRlcyAzIHBhdGNoZXMgdG8gbWx4NS1uZXh0IGJy
YW5jaC4NCj4gDQo+IDEpIEluY2x1ZGUgZGlyZWN0aXZlcyBjbGVhbnVwIGZyb20gUGFyYXYuDQo+
IDIpIFRMUyBIYXJkd2FyZSBsYXlvdXRzIGltcHJvdmVtZW50cyBmcm9tIFRhcmlxLg0KPiANCj4g
VGhhbmtzLA0KPiBTYWVlZC4NCj4gDQoNClNlcmllcyBhcHBsaWVkIA0K
