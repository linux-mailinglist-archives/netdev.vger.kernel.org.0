Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F511C493E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 23:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgEDVqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 17:46:17 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:15462
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726334AbgEDVqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 17:46:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXIzgLcFhaoVFrwAThPpHUQupoM2ub/UVZL1heC3l0vB6zJXDzmwJXfICe6OOpYuNjeTFgSh7zrpUjJ3rQKTLsdFiykuq9i87E1W5D0A9bqfaTXtllsCkWFMehd8t0RXAlxQasbCJYH7zBRnyhld66neBgcKYZj+otYBuhSj6guUStKO0ff5Lpzw+mpNMLAIv/DekOzAJ2mMuuEQtanezcnCRmjdF8jVYLFt6dcJrKxluBILywKPF0jGgwXc5Y2kcmNa1ND8UQy7WJnGUtLJ0iHrdThZGOBDR8HFDAp4TFgphbLtHBfckehQS061g69hsh1wUQb4+WjbHbAqJZXL9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQrM+Lryrjh0NdoigkuhbLETBOyFExaZAAuH5lF+Uy4=;
 b=kfZfC79RSDrRX5tTmlxlLyw4OoQPErPq4QvLOycaLMFpxGSdcR0N6d67EPmbHRFPaHrB31yZos+MVHBkHL/ZjoRiylVl3jzRggZVJeBkbQzcBoUyBh//RYaUzB/Mg7olBXHE97wsRuH/9qOmBNjIqQNOeOc6XYostvLFwoM8XeuLiy7UoEHxAhOqoJyve+HrAjlZ4lnKfXXK8Lphd570miQ/7fVoSD8Z01Ay0aX4atKVMbwWC/1P/0jQX9t0WRe1isCKtjIcC8gDWJcdsIpO70nNJB7WJSAKFLwY3+joGSNIWmVf1WhppJGnn7RTYuNInywiUmsCkroL0StxCm3PRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQrM+Lryrjh0NdoigkuhbLETBOyFExaZAAuH5lF+Uy4=;
 b=CTwTflcBOrpRcaXdvcRdktGx/EqtYRtjKf7FYeRL0MF+8IAM9Ti/O967tyIkdDm6yJD3BGpGanZcVl/O2v87AiFePUA9cpvgWgkUsF3z2IP2Lewvp7yp+KyFsJgW6C4zrU3abjduMISh7NRvnJ6cdpeBydbba+Adg7rne/59+qs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3341.eurprd05.prod.outlook.com (2603:10a6:802:1c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Mon, 4 May
 2020 21:46:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 21:46:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: max channels for mlx5
Thread-Topic: max channels for mlx5
Thread-Index: AQHWIazK1txymRaDyUaTKYlGwtaxXaiYd4CA
Date:   Mon, 4 May 2020 21:46:13 +0000
Message-ID: <2f5110e579a21737e5c13b23482eff6fdb6f3808.camel@mellanox.com>
References: <198081c2-cb0d-e1d5-901c-446b63c36706@gmail.com>
In-Reply-To: <198081c2-cb0d-e1d5-901c-446b63c36706@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 044d27a1-76c3-4a91-ca2c-08d7f07490ff
x-ms-traffictypediagnostic: VI1PR05MB3341:
x-microsoft-antispam-prvs: <VI1PR05MB3341EF265674A90DBC1BFAA0BEA60@VI1PR05MB3341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 03932714EB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pqWwTYMkIjb4+J5oj4FLtv9tTVQeSybqZDqEOfppHp6fg+sk1zUfheATOmgxnTGrEzquNrIQ8jOV5n2wdClO6uzQdcTdd2uTCEIjQJA4rcqChdiZKXId27N6WrEQUCfBVUfoa6RdeI1DHk78TRkmZ/RxDKlelv3YOIvS2fNcUXk7rgWybdS0NaLjbTd1b8wkEyp8yOOZseRv+Iqv49Jk1RV/CvPkjqXvNKXsaSW9NcE+B4Jdxcn1HG7ViVhOt4BnQbyfrlGncWbgDU6RYCLaXckUjTBFPF/HV6BuXDwyj2v5cHVZPUNYVOIiSHHamz7QhOz9XHSnxDfa0kRdYBTVDDk0BWFElayOP+voq4CrE24xuK4Y42dBOZk2MuuMVSEYnniqTSz10fJdaNxm7fctJPAz11hgloyipAq7XkGWCPQ7MvwO25lMugQRGYrxgVBQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(91956017)(86362001)(76116006)(66476007)(66556008)(478600001)(6506007)(26005)(64756008)(186003)(66946007)(66446008)(2616005)(5660300002)(71200400001)(6512007)(2906002)(36756003)(316002)(110136005)(8676002)(6486002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sG4rLxga2M/C3dTWTAbt6qSv5On76j6Ipdqz+WBD+GF7meq+qxGNGKo/IxnutYssael4E95q/dr9h1Mwmdg5zmkoAzMtpL5gq9BVfM5CSr40gXirBuuScEMS64dSXtQkAxpgRzUVYJHkJLZB0no7ZQyAG/unpHXvhH9lKLAXLcm6liOHUZ2+r98PA7mzq5Lnmh9NVqAxRsWoBL5ACow0SYjSHqDfPXY3OzaIn8Wm3J6XykJqgBDIFOuivxzKM0NqdhCDPjXxfamfMiu7ln4khFvvPhB3YhCG+3dbVlQiLjvpdeO9c050B6MgYf8faUos/u32S5esNOwERoRtQrWpqvw7WCn6WT/WV/fMxbyDBnBz+oeOoD7M+d8P1T7oImF6rJGBoyim9X50/XHwetu9TWJCnmBswXdCzo98s4dgUXLYUAOhyz+b8m0fhbOCCxFsFfolIC/f7Gs+YllwQphstUUpwanDcrDnoW52yD9IhlhFs8Qdk07pD87x7H2yNbRpRVa2zhUviRdgwbjtDV5IO21VMuKoSHUdvjpWPa47qdgX+tKg2SMkQ4f5/sQx7vS1Q5Di2pvDZGcFHfDbNT6JkMiKYiJ7UUn5kJC6RoYGOv9a1gNvvNFJQozfc3st9rITwJXetCt/gKLeo5A0Fj/RoAz5M2xrL6YD4YlkBUeR3ZtprBdiHyIIEhe/1jUOxMF/LLGzQnCuJfdWeYFhE4oVIZ7URqM3QQA2xPuiOcO77sDEygijhxJ0Zd3WxNucjLi6OSCPSB/akWR8PM+uepCYOwaUkNAsLK062VR3d6kpvtI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D85C521FEA4DFE4BAA7924C96E070A2B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044d27a1-76c3-4a91-ca2c-08d7f07490ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2020 21:46:13.4550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mhncq91/q3UH+Lhf4f1Q8vadNqkKiZggF8UJEa8UHqvrhALIJnyMwtLneMY6OBpzsjmE+g5SXXVcwpHpAMX60g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA1LTAzIGF0IDE4OjQxIC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
SGkgU2FlZWQ6DQo+IA0KPiBXaGVuIEkgc2F3IHRoaXMgY29tbWl0IGxhc3QgeWVhcjoNCj4gDQo+
IGNvbW1pdCA1N2M3ZmNlMTRiMWFkNTEyYTQyYWJlMzNjYjcyMWEyZWEzNTIwZDRiDQo+IEF1dGhv
cjogRmFuIExpIDxmYW5sQG1lbGxhbm94LmNvbT4NCj4gRGF0ZTogICBNb24gRGVjIDE2IDE0OjQ2
OjE1IDIwMTkgKzAyMDANCj4gDQo+ICAgICBuZXQvbWx4NTogSW5jcmVhc2UgdGhlIG1heCBudW1i
ZXIgb2YgY2hhbm5lbHMgdG8gMTI4DQo+IA0KPiBJIHdhcyBleHBlY3RpbmcgdG8gYmUgYWJsZSB0
byBpbmNyZWFzZSB0aGUgbnVtYmVyIG9mIGNoYW5uZWxzIG9uDQo+IGxhcmdlcg0KPiBzeXN0ZW1z
IChlLmcuLCA5NiBjcHVzKSwgYnV0IHRoYXQgaXMgbm90IHdvcmtpbmcgYXMgSSBleHBlY3RlZC4N
Cj4gDQoNCnRoaXMgcGF0Y2ggc2hvdWxkIGhlbHAsIHVubGVzcyB5b3UgYXJlIGxpbWl0ZWQgYnkg
Rlcvc3lzdGVtIE1TSS14IC4uIA0KDQp3aGF0IGlzIHRoZSBhbW91bnQgb2YgbXNpeCBhdmFpYWJs
ZSBmb3IgZXRoMCBwb3J0ID8NCg0KYnVzaW5mbz0kKGV0aHRvb2wgLWkgZXRoMCB8IGdyZXAgYnVz
LWluZm8gfCBjdXQgLWQiOiIgLWYyLSkNCmNhdCAvcHJvYy9pbnRlcnJ1cHRzIHwgZ3JlcCAkYnVz
aW5mbyB8IHdjIC1sDQoNCj4gVGhpcyBpcyBvbiBuZXQtbmV4dCBhcyBvZiB0b2RheToNCj4gICAg
IDYwYmNiYzQxZmZiMyAoIk1lcmdlIGJyYW5jaCAnbmV0LXNtYy1hZGQtYW5kLWRlbGV0ZS1saW5r
LQ0KPiBwcm9jZXNzaW5nJyIpDQo+IA0KPiAkIHN1ZG8gZXRodG9vbCAtTCBldGgwIGNvbWJpbmVk
IDk1DQo+IENhbm5vdCBzZXQgZGV2aWNlIGNoYW5uZWwgcGFyYW1ldGVyczogSW52YWxpZCBhcmd1
bWVudA0KPiANCj4gQXMgaXQgc3RhbmRzIHRoZSBtYXhpbXVtIGlzIDYzIChvciBpcyBpdCA2NCBh
bmQgY3B1cyAwLTYzPyk6DQo+ICQgc3VkbyBldGh0b29sIC1sIGV0aDANCj4gQ2hhbm5lbCBwYXJh
bWV0ZXJzIGZvciBldGgwOg0KPiBQcmUtc2V0IG1heGltdW1zOg0KPiBSWDoJCTANCj4gVFg6CQkw
DQo+IE90aGVyOgkJMA0KPiBDb21iaW5lZDoJNjMNCj4gQ3VycmVudCBoYXJkd2FyZSBzZXR0aW5n
czoNCj4gUlg6CQkwDQo+IFRYOgkJMA0KPiBPdGhlcjoJCTANCj4gQ29tYmluZWQ6CTYzDQo+IA0K
DQpTbyBpZiBudW1iZXIgb2YgbXNpeCBpcyA2NCwgd2UgY2FuIG9ubHkgdXNlIDYzIGZvciBkYXRh
IHBhdGgNCmNvbXBsZXRpb25zIC4uIA0KDQpkbyB5b3UgaGF2ZSBzcmlvdiBlbmFibGVkID8gDQoN
CndoYXQgaXMgdGhlIEZXIHZlcnNpb24geW91IGhhdmUgPw0Kd2UgbmVlZCB0byBmaWd1cmUgb3V0
IGlmIHRoaXMgaXMgYSBzeXN0ZW0gTVNJWCBsaW1pdGF0aW9uIG9yIGEgRlcNCmxpbWl0YXRpb24u
DQoNCj4gQSBzaWRlIGVmZmVjdCBvZiB0aGlzIGxpbWl0IGlzIFhEUF9SRURJUkVDVCBkcm9wcyBw
YWNrZXRzIGlmIGEgdmhvc3QNCj4gdGhyZWFkIGdldHMgc2NoZWR1bGVkIG9uIGNwdXMgNjQgYW5k
IHVwIHNpbmNlIHRoZSB0eCBxdWV1ZSBpcyBiYXNlZA0KPiBvbg0KPiBwcm9jZXNzb3IgaWQ6DQo+
IA0KPiBpbnQgbWx4NWVfeGRwX3htaXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgaW50IG4sIHN0
cnVjdCB4ZHBfZnJhbWUNCj4gKipmcmFtZXMsDQo+ICAgICAgICAgICAgICAgICAgICB1MzIgZmxh
Z3MpDQo+IHsNCj4gCS4uLg0KPiAgICAgICAgIHNxX251bSA9IHNtcF9wcm9jZXNzb3JfaWQoKTsN
Cj4gICAgICAgICBpZiAodW5saWtlbHkoc3FfbnVtID49IHByaXYtPmNoYW5uZWxzLm51bSkpDQo+
ICAgICAgICAgICAgICAgICByZXR1cm4gLUVOWElPOw0KPiANCj4gU28gaW4gbXkgZXhhbXBsZSBp
ZiB0aGUgcmVkaXJlY3QgaGFwcGVucyBvbiBjcHVzIDY0LTk1LCB3aGljaCBpcyAxLzMNCj4gb2YN
Cj4gbXkgaGFyZHdhcmUgdGhyZWFkcywgdGhlIHBhY2tldCBpcyBqdXN0IGRyb3BwZWQuDQo+IA0K
DQpLbm93IFhEUCByZWRpcmVjdCBpc3N1ZSwgIHlvdSBuZWVkIHRvIHR1bmUgdGhlIFJTUyBhbmQg
YWZmaW5pdHkgb24gUlgNCnNpZGUgYW5kIG1hdGNoIFRYIGNvdW50IGFuZCBhZmZpbml0eSBvbiBU
WCBzaWRlLCBzbyB5b3Ugd29uJ3QgZW5kIHVwIG9uDQphIHdyb25nIENQVSBvbiB0aGUgVFggc2lk
ZQ0KIA0KPiBBbSBJIG1pc3Npbmcgc29tZXRoaW5nIGFib3V0IGhvdyB0byB1c2UgdGhlIGV4cGFu
ZGVkIG1heGltdW0/DQo+IA0KPiBEYXZpZA0K
