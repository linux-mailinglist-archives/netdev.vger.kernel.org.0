Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D72977A0
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfHUKzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:55:39 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:6528
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbfHUKzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 06:55:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNMo28ia3XT/25Nw6rKI0k6gTyJQyGiR8/mAEGvbFCacU6LU6epIcIWS91jUpavQqM+asNlF44uW5IvFnlYfvHwjMgg3RYsttFwrPHeK7DIIj6RY7VzGp5WqNdsjECzN1TNbtcVSWQ7ZAKAm2GUil33FZg6RBt3o+gPC6x/WbrqPpTt+MGrel1vQ5ewFQAglwY7FjuUul4RresBsm/5Wa+PshzDwSffchBsYvNZpouS8vxnBlRTeryilYpYZHdbTcA56dFLlinvefruOZnnemMRr7YLxxdEeuw7ohd6rqoc/HgTjQm/+fYowbanvAv9CWVNxBncQYwmPEh2VKzmVaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRQPlpDyatKoCGh69MRC9/0UDjCQMbn3XeuzWtuVON4=;
 b=Fw6pwXVC9bkWp0WVDL4jkGO1qV78LJ86/9i1M+R6pRuSerJBKOD91MpdMiVM+wukXmi+RSmDoeOVmXvqVjrWXIHhBtqsEA1BaFRUQQhdTHq83/NtJHjsY7zf3IE+637GY5qjEiK2ilqXlHqlSJNC3ohZJOE7bCc4QkPcmInpC0Bid2hvMrOnhRTANd0Pgdu0mEXOIJZ//TiGyaLjKSqxeO4ul6xIkyJw+6922NbS7fMbj+cKACwuCkx8OYYb3LG3xnqd7E4Go9TEryzoOiOc8hhiXTv3tmLs5rEZWmUiLGvFoKksdw5xMFEtvakVImGIOqWfw9PFX1LJrUATdVbNnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRQPlpDyatKoCGh69MRC9/0UDjCQMbn3XeuzWtuVON4=;
 b=MFHej3PmIZwx7NhlM4okVm4ImyOcYUQw4vGDfMlAZvNwiBJ8U1NVsX3qXtl6+qTtJC+k91yytlgVVC2QISMgY2wlMDwi2ThRkjbTZuE82Kunup6WL4r8NgWRBBYSuKJQMCahdDOkpf6uWTmIcYMyV4pclz6ApD6taNLb89wuFwE=
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com (10.172.248.19) by
 DB6PR0402MB2934.eurprd04.prod.outlook.com (10.172.248.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 10:55:34 +0000
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90]) by DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90%2]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 10:55:34 +0000
From:   Marco Hartmann <marco.hartmann@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Christian Herber <christian.herber@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] Add genphy_c45_config_aneg() function to
 phy-c45.c
Thread-Topic: [PATCH net-next 1/1] Add genphy_c45_config_aneg() function to
 phy-c45.c
Thread-Index: AQHVVrbpfZ9KYVWYg0SQSycjaz4AZqcC4ZsAgAKO34A=
Date:   Wed, 21 Aug 2019 10:55:34 +0000
Message-ID: <136fbd85-4bdb-b4a2-c68e-3ed9922b5b60@nxp.com>
References: <1566237157-9054-1-git-send-email-marco.hartmann@nxp.com>
 <1566237157-9054-2-git-send-email-marco.hartmann@nxp.com>
 <3b16b8b6-7a9f-0376-ba73-96d23262dd6e@gmail.com>
In-Reply-To: <3b16b8b6-7a9f-0376-ba73-96d23262dd6e@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=marco.hartmann@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4992d553-fe17-49e2-10a3-08d7262617c4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0402MB2934;
x-ms-traffictypediagnostic: DB6PR0402MB2934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB29340505D705549D958E32418CAA0@DB6PR0402MB2934.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(199004)(189003)(7736002)(102836004)(53546011)(55236004)(2616005)(186003)(316002)(6506007)(476003)(6436002)(99286004)(26005)(71190400001)(71200400001)(486006)(6486002)(76116006)(446003)(64756008)(66446008)(66556008)(110136005)(66476007)(11346002)(44832011)(6512007)(229853002)(2501003)(66946007)(31686004)(6246003)(3846002)(81166006)(91956017)(76176011)(31696002)(53936002)(2201001)(8676002)(81156014)(6116002)(2906002)(478600001)(25786009)(8936002)(305945005)(256004)(14454004)(66066001)(5660300002)(86362001)(14444005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0402MB2934;H:DB6PR0402MB2936.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Abgd71g/HX+T+fH9524Z81lHC4VUBYze7C5mPKEBwXZ849G7krAqB+o8Tnyft8onihSMy1J2/05Jciu5yA2xFTlIWJEisLBPlbdhmrSjdZcSSDeuVnL4DRfvIgXa8MhLUgCMgx82cNjBPP7AgUq5cKxMVXOt4zRv7dRAjRRcaGoC1iKr1ZWMugFNHhAQqb/sgE/I/nK9QJcSptW0IrAQweQe726oA+bGXEHY1zCBfizgZmzuKVd1CNz85GIw7FH4reNGSwjrZ6KkIBFk8dB31obv3gDN+e57oK6UlmyaB30HqVDaBWpSpp8x7vah/7kD5/1gHET8C0IF34TLJJuFzXvkrH+r3zzeW6Hyo+WYpPwZ7Nh6FZrbWSiL4vytOvnmfmYxhzT9h1tYo4GLFYx6tQRkIKm7ae2V3FrGf6PBhxg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1B11CA29984E6459120EBD9B56ECF21@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4992d553-fe17-49e2-10a3-08d7262617c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 10:55:34.2234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUmY3XzZ0m71rPRjwdFnVC/rH9DsXSJd40F7qLzolTeN67gULib8q3rgEchFtqrNxXWYzYBhzceQwe7AiWMbRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTkuMDguMTkgMjE6NTEsIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gT24gMTkuMDguMjAx
OSAxOTo1MiwgTWFyY28gSGFydG1hbm4gd3JvdGU6DQo+PiBhbmQgY2FsbCBpdCBmcm9tIHBoeV9j
b25maWdfYW5lZygpLg0KPj4NCj4gSGVyZSBzb21ldGhpbmcgd2VudCB3cm9uZy4NCj4gDQo+PiBj
b21taXQgMzQ3ODYwMDVlY2EzICgibmV0OiBwaHk6IHByZXZlbnQgUEhZcyB3L28gQ2xhdXNlIDIy
IHJlZ3MgZnJvbQ0KPj4gY2FsbGluZyBnZW5waHlfY29uZmlnX2FuZWciKSBpbnRyb2R1Y2VkIGEg
Y2hlY2sgdGhhdCBhYm9ydHMNCj4+IHBoeV9jb25maWdfYW5lZygpIGlmIHRoZSBwaHkgaXMgYSBD
NDUgcGh5Lg0KPj4gVGhpcyBjYXVzZXMgcGh5X3N0YXRlX21hY2hpbmUoKSB0byBjYWxsIHBoeV9l
cnJvcigpIHNvIHRoYXQgdGhlIHBoeQ0KPj4gZW5kcyB1cCBpbiBQSFlfSEFMVEVEIHN0YXRlLg0K
Pj4NCj4+IEluc3RlYWQgb2YgcmV0dXJuaW5nIC1FT1BOT1RTVVBQLCBjYWxsIGdlbnBoeV9jNDVf
Y29uZmlnX2FuZWcoKQ0KPj4gKGFuYWxvZ291cyB0byB0aGUgQzIyIGNhc2UpIHNvIHRoYXQgdGhl
IHN0YXRlIG1hY2hpbmUgY2FuIHJ1bg0KPj4gY29ycmVjdGx5Lg0KPj4NCj4+IGdlbnBoeV9jNDVf
Y29uZmlnX2FuZWcoKSBjbG9zZWx5IHJlc2VtYmxlcyBtdjMzMTBfY29uZmlnX2FuZWcoKQ0KPj4g
aW4gZHJpdmVycy9uZXQvcGh5L21hcnZlbGwxMGcuYywgZXhjbHVkaW5nIHZlbmRvciBzcGVjaWZp
Yw0KPj4gY29uZmlndXJhdGlvbnMgZm9yIDEwMDBCYXNlVC4NCj4+DQo+PiBGaXhlczogMzQ3ODYw
MDVlY2EzICgibmV0OiBwaHk6IHByZXZlbnQgUEhZcyB3L28gQ2xhdXNlIDIyIHJlZ3MgZnJvbQ0K
Pj4gY2FsbGluZyBnZW5waHlfY29uZmlnX2FuZWciKQ0KPj4NCj4gVGhpcyB0YWcgc2VlbXMgdG8g
YmUgdGhlIHdyb25nIG9uZS4gVGhpcyBjaGFuZ2Ugd2FzIGRvbmUgYmVmb3JlDQo+IGdlbnBoeV9j
NDVfZHJpdmVyIHdhcyBhZGRlZC4gTW9zdCBsaWtlbHkgdGFnIHNob3VsZCBiZToNCj4gMjJiNTZl
ODI3MDkzICgibmV0OiBwaHk6IHJlcGxhY2UgZ2VucGh5XzEwZ19kcml2ZXIgd2l0aCBnZW5waHlf
YzQ1X2RyaXZlciIpDQo+IEFuZCBiZWNhdXNlIGl0J3MgYSBmaXggYXBwbHlpbmcgdG8gcHJldmlv
dXMga2VybmVsIHZlcnNpb25zIGl0IHNob3VsZA0KPiBiZSBhbm5vdGF0ZWQgIm5ldCIsIG5vdCAi
bmV0LW5leHQiLg0KPiANCllvdSBhcmUgY29ycmVjdCwgSSBmaXhlZCB0aGUgdGFnIGFuZCBhbm5v
dGF0aW9uLg0KDQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjbyBIYXJ0bWFubiA8bWFyY28uaGFydG1h
bm5AbnhwLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL25ldC9waHkvcGh5LWM0NS5jIHwgMjYg
KysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+ICAgZHJpdmVycy9uZXQvcGh5L3BoeS5jICAg
ICB8ICAyICstDQo+PiAgIGluY2x1ZGUvbGludXgvcGh5LmggICAgICAgfCAgMSArDQo+PiAgIDMg
ZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvcGh5LWM0NS5jIGIvZHJpdmVycy9uZXQvcGh5L3Bo
eS1jNDUuYw0KPj4gaW5kZXggYjlkNDE0NTc4MWNhLi5mYTkwNjJmZDkxMjIgMTAwNjQ0DQo+PiAt
LS0gYS9kcml2ZXJzL25ldC9waHkvcGh5LWM0NS5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9waHkv
cGh5LWM0NS5jDQo+PiBAQCAtNTA5LDYgKzUwOSwzMiBAQCBpbnQgZ2VucGh5X2M0NV9yZWFkX3N0
YXR1cyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPj4gICB9DQo+PiAgIEVYUE9SVF9TWU1C
T0xfR1BMKGdlbnBoeV9jNDVfcmVhZF9zdGF0dXMpOw0KPj4gICANCj4+ICsvKioNCj4+ICsgKiBn
ZW5waHlfYzQ1X2NvbmZpZ19hbmVnIC0gcmVzdGFydCBhdXRvLW5lZ290aWF0aW9uIG9yIGZvcmNl
ZCBzZXR1cA0KPj4gKyAqIEBwaHlkZXY6IHRhcmdldCBwaHlfZGV2aWNlIHN0cnVjdA0KPj4gKyAq
DQo+PiArICogRGVzY3JpcHRpb246IElmIGF1dG8tbmVnb3RpYXRpb24gaXMgZW5hYmxlZCwgd2Ug
Y29uZmlndXJlIHRoZQ0KPj4gKyAqICAgYWR2ZXJ0aXNpbmcsIGFuZCB0aGVuIHJlc3RhcnQgYXV0
by1uZWdvdGlhdGlvbi4gIElmIGl0IGlzIG5vdA0KPj4gKyAqICAgZW5hYmxlZCwgdGhlbiB3ZSBm
b3JjZSBhIGNvbmZpZ3VyYXRpb24uDQo+PiArICovDQo+PiAraW50IGdlbnBoeV9jNDVfY29uZmln
X2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+ICt7DQo+PiArCWludCByZXQ7DQo+
PiArCWJvb2wgY2hhbmdlZCA9IGZhbHNlOw0KPiANCj4gUmV2ZXJzZSB4bWFzIHRyZWUgcGxlYXNl
Lg0KPiANCm9rLg0KDQo+PiBbLi4uXQ0KPiANCj4gT3ZlcmFsbCBsb29rcyBnb29kIHRvIG1lLiBG
b3IgYSBzaW5nbGUgcGF0Y2ggeW91IGRvbid0IGhhdmUgdG8gcHJvdmlkZQ0KPiBhIGNvdmVyIGxl
dHRlci4NCj4gDQoNClRoYW5rIHlvdSBmb3IgeW91ciBmZWVkYmFjaywNCkkgd2lsbCBwcm92aWRl
IGEgdjIgb2YgdGhlIHBhdGNoIHdpdGggdGhlIGFib3ZlIGZpeGVzLg0KDQpSZWdhcmRzLA0KTWFy
Y28=
