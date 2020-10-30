Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99342A0C66
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgJ3R1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:27:19 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:15174
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726297AbgJ3R1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 13:27:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZtvvkolFSsJpgfW4qIakGb/Tox6AfrZl65BjCMNYjqU6TSfYbj1Ci8x5UDlB3Wvg53krOdzM1QQH9lHkm5tP3TBMRRjMXt4xQ+PNA438Af19uwcALnAjHPgZGwX8E6roCrIklfcThVTxGam+ODuAGz8uMHyyUgxH+hVaWQybxk1tMZU+jQW1lKYFUzDgf1yoXwwHfn9nm5ZEd5LpSMtZ1TI/q9a8kq3PmekiICtuoc8qaqOmWm0jHBwNnJxEdJHtURbYViGHbMrX85LByA6blVfFmyJcUv5lr0qH+T6Ts5QLqRpd6yQ5z3gD7Ojfq3FdN7qSAjE4f5NEO8o9XRetw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YR4SoTsm9Zpi6qSgDGbLxOsw8i9QKDmBArB9+5T9gJ4=;
 b=Fq02zOssliLw0zadCHDSDlEIrCQWGJdhkN14g6LfVOlAD4J5uiHwUPt+81DVHErCP7LAuD7S27YzU5RZdvpwRUnfgQh7OZM1f0/megf25tIWpGgdMWEU03gxmsMNzkRjZJBy6vGbk5hbsQfFYtApY70battJuQt4Cyf6eFH5NaOTQEX0kayu/4X5ghbjcE+C0isctThpHAWYFIwPWl9rcEX/+digucP/7SUazfZbjVXlIuZ1ZUa/3QAJLx1oDVFWbsa7nnjUQgbzFjN1eRENrDx49cG6+3km+8xCixUyMbJexeeXV1iAqrMpJFnAtm14QoEpeKj9GfrGAmKV+NW/9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=5x9networks.com; dmarc=pass action=none
 header.from=5x9networks.com; dkim=pass header.d=5x9networks.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=smartn.onmicrosoft.com; s=selector2-smartn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YR4SoTsm9Zpi6qSgDGbLxOsw8i9QKDmBArB9+5T9gJ4=;
 b=Fp1ByLnKsVeZtL6SBCd4rF8NM+MkgeKm/PxtfaXqL2D5pgGeO90GTZn2RzlZ8W3F+yB2TaP7lK4CeJy+JtMxuTeSLlMe39iY5aTU53hvjKhwFQQlVLeuuHzqeeNe2z63hdTrSFR71Y0DKRrNAdpdAOnXPb7NbF8lIWc39+U5Ggc=
Received: from VI1PR0201MB2448.eurprd02.prod.outlook.com
 (2603:10a6:800:52::19) by VI1PR0202MB3390.eurprd02.prod.outlook.com
 (2603:10a6:803:1d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 17:27:15 +0000
Received: from VI1PR0201MB2448.eurprd02.prod.outlook.com
 ([fe80::7d0b:44be:cb9a:1a49]) by VI1PR0201MB2448.eurprd02.prod.outlook.com
 ([fe80::7d0b:44be:cb9a:1a49%8]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 17:27:15 +0000
From:   Branimir Rajtar <branimir.rajtar@5x9networks.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] typos in rtnetlink
Thread-Topic: [PATCH] typos in rtnetlink
Thread-Index: AQHWrQzX5yVDsDd+FE6hbjcZzBx41Kmv0ReAgAAASQCAAIBbAIAAF/sA
Date:   Fri, 30 Oct 2020 17:27:15 +0000
Message-ID: <fc7a700c688268e130a915a3f4d30a160e99c121.camel@5x9networks.com>
References: <83c34b90a2f7c87e84b73911a7837de2e087ad8f.camel@5x9networks.com>
         <06351e24b36f55ee16fda8e34130a7a454c1cdea.camel@5x9networks.com>
         <6b9672e299364cc9b42829fc24774fb230346e46.camel@5x9networks.com>
         <20201030090124.5027220c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030090124.5027220c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=5x9networks.com;
x-originating-ip: [93.138.162.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4abb62cc-9af2-4d9d-2407-08d87cf90b8c
x-ms-traffictypediagnostic: VI1PR0202MB3390:
x-microsoft-antispam-prvs: <VI1PR0202MB3390F08631381EFA1F6D4A04FC150@VI1PR0202MB3390.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RfVGotCKFZg7lKudIXO5cQrP7MJ4RMSL+9pEFstQ9EXqQE0PDPPTwzqARk9ktm1xgSdY78rcN38nfCndPf8KVRfpqbydTooEvzev/AoMIzPKs9eMdYjOBpKrok4p92x9D5zRrCHzGS1sf6vGSSuL6yrT/OAHxpfS6D7/l05JWfFAsGg3sxrXavZmOidd7O7fy30fILGqckhu6xh551UT34hZ7KdtyJasnYyRAu6ekmnUJ/3T2OHLDyW2KWoLJn9FTeghvshAFWrMdOVm7nxfYzWhrxxvRlaiWpUkr1yPmqLx7nfPc4G0zpCUF0xJFosB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0201MB2448.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39840400004)(136003)(366004)(396003)(44832011)(6512007)(6916009)(66946007)(5660300002)(86362001)(36756003)(8676002)(6506007)(71200400001)(99936003)(8936002)(66616009)(76116006)(66446008)(66476007)(186003)(478600001)(6486002)(66556008)(316002)(2906002)(64756008)(2616005)(26005)(4326008)(4744005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ajjMgAFg65kJItWYimJQWxTjKsxzf1WYzs6bWA+kfPkKeuSkuKUbIQ1vp30mVbUZtC7gT5HA/lwWDKrSaPvXBl5wMO3wYPz5QAdmQtxYKTlRBWPGbA/9WpuzNVDAjlHF3MQemHaAFdbzDolCZjwrBEKQudhLmw9285SSfaAIdV035GAhQWTNwnRuR3P0ncpoAy9xwGBYj4LsuvUq9SX64kZjNImTqIBgZR/e6/NiWmxyDk6VQhqtrN3HTXIJSYKKZpJWE2f69K8p0vIou3HjRtSYReDH9U9ztef6STzr+tigHXUK9O3fvspsYEyBhvGYgBHNOzHdYVIlIhC88J8+G/K4GKbeAzh6O9+Spw3lD/l9NRKacodIeSYmH2662zlgPMMkgywMwUxWdJIm13RPTzi27+nlGCHSrqmmqbiuADyqfWYZIVMeSG1b5af4RJcRa/SISC8K/kIwXtrDGl2Zu47aD478iAWVqYfAhQCVieE8xz4z4q6hRTSflZIlfnHBRTi+qMEFn2hifCChLYahsM50ZUtiVz3sy2hBgHg45o9uVYzzJbbs7gaqcgPRiN8aY4Hir5GUyAKhBrmHJT1vNnQ/oUjynquqx5CUeYwkdo6Vs4uZBsv3zzcS1hwBy5HIVl7/z7nIZFm+Lqm9OKNYAQ==
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_fc7a700c688268e130a915a3f4d30a160e99c121camel5x9network_"
MIME-Version: 1.0
X-OriginatorOrg: 5x9networks.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0201MB2448.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abb62cc-9af2-4d9d-2407-08d87cf90b8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 17:27:15.4720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d7b4403-09d4-4db1-b2b2-3c5c42a4d68f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OmZf9nCIDdgyt/2uMuGRFuaaWGgytmIMSwPvERyqgBIH798HyFrHL2EUgIbhxRcqg62udwLme5rHtZLYf4+oLfpLKonUmQ4v+f7uq7zUYqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0202MB3390
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_fc7a700c688268e130a915a3f4d30a160e99c121camel5x9network_
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA286562E2967540AD5D1939AD93D64D@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64

U29ycnksIGZvcmdvdCB0byBhdHRhY2guDQoNCkJyYW5pbWlyDQoNCi0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQpGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KVG86IEJy
YW5pbWlyIFJhanRhciA8YnJhbmltaXIucmFqdGFyQDV4OW5ldHdvcmtzLmNvbT4NCkNjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnIDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPg0KU3ViamVjdDogUmU6
IFtQQVRDSF0gdHlwb3MgaW4gcnRuZXRsaW5rDQpEYXRlOiBGcmksIDMwIE9jdCAyMDIwIDA5OjAx
OjI0IC0wNzAwDQoNCk9uIEZyaSwgMzAgT2N0IDIwMjAgMDg6MjI6MDEgKzAwMDAgQnJhbmltaXIg
UmFqdGFyIHdyb3RlOg0KPiBIaSwNCj4gDQo+IEknbSByZXBlYXRpbmcgbXkgZW1haWwgc2luY2Ug
SSBoYWQgSFRNTCBpbiB0ZXh0IGFuZCB3YXMgdHJlYXRlZCBhcw0KPiBzcGFtLg0KDQpJIGRvbid0
IHNlZSBhbnkgcGF0Y2gsIHRyeSBnaXQtc2VuZC1lbWFpbD8NCg==

--_002_fc7a700c688268e130a915a3f4d30a160e99c121camel5x9network_
Content-Type: text/x-patch; name="patch"
Content-Description: patch
Content-Disposition: attachment; filename="patch"; size=870;
	creation-date="Fri, 30 Oct 2020 17:27:15 GMT";
	modification-date="Fri, 30 Oct 2020 17:27:15 GMT"
Content-ID: <E5F1B98890D80240A2CC5BDBE1976B45@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64

LS0tIGxpbnV4L2luY2x1ZGUvdWFwaS9saW51eC9ydG5ldGxpbmsuaC5vcmlnCTIwMjAtMTAtMjgg
MTA6MDc6NTYuMDg4Nzc2NDQzICswMTAwCisrKyBsaW51eC9pbmNsdWRlL3VhcGkvbGludXgvcnRu
ZXRsaW5rLmgJMjAyMC0xMC0yOCAxMDowOToyMS4yMzc4NTczMzUgKzAxMDAKQEAgLTM3NSw3ICsz
NzUsNyBAQCBlbnVtIHJ0YXR0cl90eXBlX3QgewogI2RlZmluZSBSVE1fUlRBKHIpICAoKHN0cnVj
dCBydGF0dHIqKSgoKGNoYXIqKShyKSkgKyBOTE1TR19BTElHTihzaXplb2Yoc3RydWN0IHJ0bXNn
KSkpKQogI2RlZmluZSBSVE1fUEFZTE9BRChuKSBOTE1TR19QQVlMT0FEKG4sc2l6ZW9mKHN0cnVj
dCBydG1zZykpCiAKLS8qIFJUTV9NVUxUSVBBVEggLS0tIGFycmF5IG9mIHN0cnVjdCBydG5leHRo
b3AuCisvKiBSVEFfTVVMVElQQVRIIC0tLSBhcnJheSBvZiBzdHJ1Y3QgcnRuZXh0aG9wLgogICoK
ICAqICJzdHJ1Y3QgcnRuZXh0aG9wIiBkZXNjcmliZXMgYWxsIG5lY2Vzc2FyeSBuZXh0aG9wIGlu
Zm9ybWF0aW9uLAogICogaS5lLiBwYXJhbWV0ZXJzIG9mIHBhdGggdG8gYSBkZXN0aW5hdGlvbiB2
aWEgdGhpcyBuZXh0aG9wLgpAQCAtNDAyLDcgKzQwMiw3IEBAIHN0cnVjdCBydG5leHRob3Agewog
CiAjZGVmaW5lIFJUTkhfQ09NUEFSRV9NQVNLCShSVE5IX0ZfREVBRCB8IFJUTkhfRl9MSU5LRE9X
TiB8IFJUTkhfRl9PRkZMT0FEKQogCi0vKiBNYWNyb3MgdG8gaGFuZGxlIGhleHRob3BzICovCisv
KiBNYWNyb3MgdG8gaGFuZGxlIG5leHRob3BzICovCiAKICNkZWZpbmUgUlROSF9BTElHTlRPCTQK
ICNkZWZpbmUgUlROSF9BTElHTihsZW4pICggKChsZW4pK1JUTkhfQUxJR05UTy0xKSAmIH4oUlRO
SF9BTElHTlRPLTEpICkK

--_002_fc7a700c688268e130a915a3f4d30a160e99c121camel5x9network_--
