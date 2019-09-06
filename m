Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353FCAB319
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391748AbfIFHRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:17:42 -0400
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:45893
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727768AbfIFHRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:17:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7L4IrJpe5wygAHaA7tu7z/G4RlyWnxjb/vPifmSCkkIpvQTqj8CjeLbwCLvFaBJ8xtFzWDB7GtFNw2VAWt+Q1h/bohMUNLOgWFG4srASgug1xhpULFZfchPYcmEyWAWG7hxA4jEJFZd/jSi+Mu3zZuD+CtKn1CyUDyvoD+4k6b1IAsGWmyvn8leKZ9MgsLcCPs/pNXKmPbgwG0nWgj/v4sUAUy7xuoMrBme4RSrAO64OvnEtQxN58zahRdWtJRIoc8SW6WQJQ5oVu+eHRz70WDJX8xaqE1g7qiTeWaMhKENlrMSfZ3OHiFmJLq2Q+F5LO4STSsD/Boc91BIkTTYJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7G6dkgwLNOYQu6DA+tLuLMrlscjZ0xpS3ae/fyyPX14=;
 b=kTvh6Itc3k4wgMnYPvvi8/pXzJIbQHwFLKYAiw64fsigjljb5rnZG2eU7bvw3vZ71zxhkDojf6z4SwdgI6Yk4aN/HHW4uOS3TA3ap7MOKoZ84Js1IABuXCqEDXh/LZUdZauU9o13Zi8977ojubNd8WWBqw99o96YON6saWJtvVxE3G84KfaGg1dd8ueyqBD4Uu0+PaXzpahDIojzczCrNl3/fpzoNR12JuqHBqFzWo36RykHfpY3U/JMhSOP9npvxIMEVy5v9Yb1z+QK2vcm8SuYuU1gNGO+woZfUzUdJzhuYIIodPVQPXlsth1KL1VF8es0aMd0fSyWw6gQjE9FzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7G6dkgwLNOYQu6DA+tLuLMrlscjZ0xpS3ae/fyyPX14=;
 b=suO9EVZvgoqQC2WksRRe2SP+EmnzzAtRuoTwGasKvdTgHfvUg3OF8/MJ6CdaS2g3ALKJR+OjSj/Tm0/m6UAYAI7MqFHzjA1B0sPPue3KC3MmnBnpCOWwwXqn/Dk9ukxlDKEA7lVu0P44x/Et8Gv/HfdqgdflIHmMLYxkFXMmXMU=
Received: from VI1PR05MB5104.eurprd05.prod.outlook.com (20.177.49.142) by
 VI1PR05MB5630.eurprd05.prod.outlook.com (20.178.120.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Fri, 6 Sep 2019 07:17:37 +0000
Received: from VI1PR05MB5104.eurprd05.prod.outlook.com
 ([fe80::d91c:613f:c858:91f4]) by VI1PR05MB5104.eurprd05.prod.outlook.com
 ([fe80::d91c:613f:c858:91f4%2]) with mapi id 15.20.2220.024; Fri, 6 Sep 2019
 07:17:37 +0000
From:   Aya Levin <ayal@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [iproute2, master 2/2] devlink: Add a new time-stamp format for
 health reporter's dump
Thread-Topic: [iproute2, master 2/2] devlink: Add a new time-stamp format for
 health reporter's dump
Thread-Index: AQHVWNmTpMfiqPEwqE+hhGe+cYym/KcS0OoAgAuDrwA=
Date:   Fri, 6 Sep 2019 07:17:36 +0000
Message-ID: <b0a8529d-a05f-464f-e9c9-191d2dad9e37@mellanox.com>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
 <1566471942-28529-1-git-send-email-ayal@mellanox.com>
 <1566471942-28529-3-git-send-email-ayal@mellanox.com>
 <20190829162722.6275fb02@hermes.lan>
In-Reply-To: <20190829162722.6275fb02@hermes.lan>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0158.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::26) To VI1PR05MB5104.eurprd05.prod.outlook.com
 (2603:10a6:803:56::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ayal@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b8b23fe-a5c6-4ed0-24ce-08d7329a4a9b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5630;
x-ms-traffictypediagnostic: VI1PR05MB5630:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5630273B2190E513FF697C2CB0BA0@VI1PR05MB5630.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(189003)(199004)(6246003)(7736002)(6506007)(53936002)(386003)(316002)(486006)(53546011)(36756003)(14444005)(6486002)(76176011)(2906002)(102836004)(66446008)(66066001)(107886003)(66476007)(6436002)(66556008)(6916009)(8676002)(25786009)(3846002)(6116002)(86362001)(81166006)(66946007)(81156014)(31696002)(478600001)(64756008)(54906003)(4744005)(229853002)(4326008)(5660300002)(305945005)(52116002)(8936002)(2616005)(26005)(14454004)(256004)(31686004)(71190400001)(6512007)(99286004)(11346002)(446003)(186003)(71200400001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5630;H:VI1PR05MB5104.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Zf+FNXAGLQApIIo/YuMHoQ6OQQ/+Yd3B0xlXeNSJiKdG/AHuQGi8Tv2PvN6HQKZ7BFyWN+PlZJNjMUA00MqTu3vxk/ycBzV6jcyEPD/DO1yREGUF3f/HL3HgHPTdz56PRhBjIXSZqRRjMueFIXFfQU68nijAp3P/LHrDtVniD/t0hbGsepND4b1XbhL6JWmxwUbK3oqfDJQYPLeS0IuO2H3RySUKMZcRtM3BNN394CwBRXQdbli95s7SbyIvKxNjgz/+4XJZXR4OvNTiBP5/bIGKthFvObOaPtlacGx6+RLysUimJsiqnQtw+5YFfXwmNk0vLY9HCx5GaxQ4b+FWo4yl+ubYC0bIwrEDKRr3o91YRW9qqNoIoqSVQw2DNztVnzpVoQMioYCKLzCnZNR7GCyKBwkkuNqGCaY6VUIXMo4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CF4B7C1719F7242A645D2A4630899F9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8b23fe-a5c6-4ed0-24ce-08d7329a4a9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 07:17:37.0129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VLUeKUf3Wy2z2glAaaHY3C3PuGJpPQ5y0liOMGNLBS2d5nxvPJi33bj1Jh4Ja9HVW9nxg7tzhjwdIwO53+fMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5630
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMzAvMjAxOSAyOjI3IEFNLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90ZToNCj4gT24g
VGh1LCAyMiBBdWcgMjAxOSAxNDowNTo0MiArMDMwMA0KPiBBeWEgTGV2aW4gPGF5YWxAbWVsbGFu
b3guY29tPiB3cm90ZToNCj4gDQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2Rl
dmxpbmsuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9kZXZsaW5rLmgNCj4+IGluZGV4IGZjMTk1Y2Jk
NjZmNC4uM2Y4NTMyNzExMzE1IDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2Rl
dmxpbmsuaA0KPj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2RldmxpbmsuaA0KPj4gQEAgLTM0
OCw2ICszNDgsOCBAQCBlbnVtIGRldmxpbmtfYXR0ciB7DQo+PiAgIAlERVZMSU5LX0FUVFJfUE9S
VF9QQ0lfUEZfTlVNQkVSLAkvKiB1MTYgKi8NCj4+ICAgCURFVkxJTktfQVRUUl9QT1JUX1BDSV9W
Rl9OVU1CRVIsCS8qIHUxNiAqLw0KPj4gICANCj4+ICsJREVWTElOS19BVFRSX0hFQUxUSF9SRVBP
UlRFUl9EVU1QX1RTUEVDLA0KPj4gKw0KPj4gICAJLyogYWRkIG5ldyBhdHRyaWJ1dGVzIGFib3Zl
IGhlcmUsIHVwZGF0ZSB0aGUgcG9saWN5IGluIGRldmxpbmsuYyAqLw0KPj4gICANCj4+ICAgCV9f
REVWTElOS19BVFRSX01BWCwNCj4+IC0tIA0KPiANCj4gU2luY2UgdGhpcyBpcyBub3QgdXBzdHJl
YW0sIHRoaXMgcGF0Y2ggbmVlZHMgdG8gZ28gdG8gaXByb3V0ZTItbmV4dC4NCj4gV2hpY2ggbWVh
bnMgaWYgeW91IHdhbnQgdGhlIG90aGVyIGJ1ZyBmaXgsIHNlbmQgaXQgYWdhaW4gYWdhaW5zdCBt
YXN0ZXIuDQpUaGFua3MsDQpXaWxsIGRvIHRoYXQNCj4gDQo=
