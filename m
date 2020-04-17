Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B530A1AE861
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 00:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgDQWsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 18:48:10 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:26340
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728482AbgDQWsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 18:48:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/WlrJ3CXA++lT7hB/9K7kqAaQqpSKEH5CvTm/a2CCJfg7vCcnrpop6lVgaeCn6taZH8JXBfi3pGXpLSpm4d/deAw26Xl28FH2SM6mnkt51ZSbOty/QQuzOdxPavEib4YOTXBp69Z8ucJK54oIHwnd3kcSxETefWTxQ9qf9s87ikHOYeXbZLEvpRR0o/rIvYm5YygGchcydXLVhQgnaMSsuzagRZ95IzNWJX/VLhJW4mq6zUej/9+9YJNhZTv2Y4xIlK//NDQrxRZYYRPGcpDyGq0T+++zH0QQCcjDlJ6Gh2vOAmPBO6ML8W8ipvMuLDLJ1xy2s7KJw/2QRPFcT1eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjwGTzeL25Mwk0wn+ASDN3HPDqwBahJBHfyj5CHk8kA=;
 b=MrG7NCFbUFaQb44AVfMyjn2PZSnjHA32lUGgnCsS1+4S1NaKK3ADtZmLoiUpomO2mIQse4VUcFtqYQay0yjT50RokbKOPVJawBu/OQ9i8hYcsPNBWcMA13/7HpP+qSNMSYgMbQ87zWp8w5WPQe4gfIbuQtJ3SDykgCBH9jqxbaThvMUlNWgsyYH7IHvToYGa+e6z//2SUcr4YOSDZGkuR910We9iybsTAGqLDsF958imw3tA6ZKl4PVTD2WF+hDlly6rhnxjhRpomSwtWvbW/ppM10YEFNgFKvwSl0HYJ+xbSU5/bOO7KH8dDj2wGXTQzTRp3am566WCMWMSYVwXFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjwGTzeL25Mwk0wn+ASDN3HPDqwBahJBHfyj5CHk8kA=;
 b=aVXDwUzZFlZCWz8Rbp8Vt6VTVUUA/KqylxOBZjrq4vFG7XbZ0V5NPl2xEreuvxTXk0VySv+fMlFleUDkiSCPUe00ixxXvvWKDSbADQdqPYLePB+9JvffWOODClP3xsUVbGQ4LaLiOL/3kbvNyGsBj6xVpMibOo6+9MKYo37nOAM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4317.eurprd05.prod.outlook.com (2603:10a6:803:41::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.28; Fri, 17 Apr
 2020 22:48:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 22:48:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>,
        "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: discussion mlx5e vlan forwarding
Thread-Topic: discussion mlx5e vlan forwarding
Thread-Index: AQHWFKcMayvtI5JN2EGwlTPAVdhLzqh96zKA
Date:   Fri, 17 Apr 2020 22:48:05 +0000
Message-ID: <5e5bc4248759f4a1bfc449fa2b8854dd56c0e281.camel@mellanox.com>
References: <CAMDZJNWm5Vu-G4_het+CyxdbZYPJuidihUPK0ZhPC1HfKXsM2A@mail.gmail.com>
In-Reply-To: <CAMDZJNWm5Vu-G4_het+CyxdbZYPJuidihUPK0ZhPC1HfKXsM2A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7a1c3733-d18b-4c9f-3e37-08d7e32164ba
x-ms-traffictypediagnostic: VI1PR05MB4317:|VI1PR05MB4317:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB431774E6F09C95C91F12AB94BED90@VI1PR05MB4317.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(71200400001)(4744005)(36756003)(4326008)(5660300002)(2906002)(64756008)(478600001)(66476007)(76116006)(91956017)(66446008)(86362001)(66946007)(66556008)(316002)(2616005)(6486002)(110136005)(81156014)(6506007)(8676002)(26005)(6512007)(186003)(8936002)(42413003)(32563001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xq44cT3A+qbF+qSSRUBP6S9hQt4D/Sk9E9BFBysC0a6bcTl/x6t1TZ383Bph1uvuVMsRIop78rO+9jBqvnYIX6WF33OBBATW3ESkSBJnGy1OI3Mu+iBtPJRMzkEsx9/kpryzALSULUMnkdveGE/ncliaqwXP/iuMSl9YpZpwfRTHh+JAVYtGyrT80YslAn1D2vx4BbOV9r3OW14+0UqtBkcOPCI2Z0JP/I0+EprLm0qTuKOHV2jbI0Px43zTXtdumUxpyOKhnWTbScrWsT77llL2z/2HW1qLK4Ot47+Poo8YsOfhj5tCkBr8pXQLEEjqhMleLPoRZ+H2ZntWPiX7A9ZixSoFvFAlY4RPZFYKD7qSx4vklTt/pcMtDIjut1+4JKTrf4gkk9IdqFpDNSWvx99C3qbYe0vBgfK0YUimvzwhNZl6XN2z5AkuL9omaKNDVnxWBGq87oc8EsZ0n8jdVBgxhDnDWTMyVVqIPs7UIUamvvxe3qcacOfZTMJsH5BZEtQEo076tJhgmYmz175/AA==
x-ms-exchange-antispam-messagedata: XHj7OVRVlmcvCZAJCWLo3lY/x3YqPkigoqRZuYhlMQ7FyztIOXLyF0g5TX+aR/KeRoeP9uQTQTVrO2I0SSVCg2Jlo/IxZp7/lXyZ84zscnOMmym2yWcwxQ4HQPi/tN8HqSHpVUEaZ5vW7OTCyPyRAQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <53FA4D8A47471A4D89FF5D24EDEEABEB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1c3733-d18b-4c9f-3e37-08d7e32164ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 22:48:05.7748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tIcs8dPByi4cTIX7udZtYd2oHsr0dwSxKR8YuZXfafThZwqf7N2Dw4XOXydJTbQHCnls24/Gld/JsS1Fb5w15w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4317
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTE3IGF0IDE4OjU3ICswODAwLCBUb25naGFvIFpoYW5nIHdyb3RlOg0K
PiBIaSBTYWVlZCBhbmQgbWFpbnRhaW5lcnMNCj4gDQo+IEluIG9uZSBjYXNlLCBJIHdhbnQgdG8g
cHVzaCB2bGFuIGFuZCBmb3J3YXJkIHRoZSBwYWNrZXRzIHRvIG9uZSBWRi4NCj4gVGMNCj4gY29t
bWFuZCBzaG93biBhcyBiZWxvdw0KPiAkIHRjIGZpbHRlciBhZGQgZGV2ICRQRjBfUkVQMCBwYXJl
bnQgZmZmZjogcHJvdG9jb2wgaXAgcHJpbyAxIGNoYWluIDANCj4gXA0KPiAgICAgZmxvd2VyIHNy
Y19tYWMgMGE6NDc6ZGE6ZDY6NDA6MDQgZHN0X21hYyAwMDoxMToyMjozMzo0NDo2NiBcDQo+ICAg
ICBhY3Rpb24gdmxhbiBwdXNoIGlkIDIwMCBwaXBlIGFjdGlvbiBtaXJyZWQgZWdyZXNzIHJlZGly
ZWN0IGRldg0KPiAkUEZfUkVQMQ0KPiANCj4gZG1lc2c6DQo+IG1seDVfY29yZSAwMDAwOjgyOjAw
LjA6IG1seDVfY21kX2NoZWNrOjc1NjoocGlkIDEwNzM1KToNCj4gU0VUX0ZMT1dfVEFCTEVfRU5U
UlkoMHg5MzYpIG9wX21vZCgweDApIGZhaWxlZCwgc3RhdHVzIGJhZA0KPiBwYXJhbWV0ZXIoMHgz
KSwgc3luZHJvbWUgKDB4YTljMDkwKQ0KPiANCj4gU28gZG8gd2Ugc3VwcG9ydCB0aGF0IGZvcndh
cmRpbmcgPw0KPiANCg0KSGkgVG9uZ2hhbywgDQoNCkNDJ2luZyBtb3JlIGV4cGVydHMsIE9yIGFu
ZCBSb2ksIHRoZXkgbWlnaHQgaGF2ZSBtb3JlIHVzZWZ1bCBpbmZvIGZvcg0KeW91Lg0KDQpidXQg
YXMgZmFyIGFzIGkgcmVjYWxsLCB0aGlzIGNhbiBvbmx5IHdvcmsgb24gdXBsaW5rIHBvcnQgYW5k
IG5vdCBhIFZGLg0KDQo+IGtlcm5lbCB2ZXJzaW9uOiA1LjYuMC1yYzcrIFtPRkVEIDUuMCBoYXMg
dGhhdCBpc3N1ZSB0b29dDQo+IGZpcm13YXJlLXZlcnNpb246IDE2LjI3LjEwMTYNCj4gTklDOiBN
ZWxsYW5veCBUZWNobm9sb2dpZXMgTVQyNzgwMCBGYW1pbHkgW0Nvbm5lY3RYLTVdDQo=
