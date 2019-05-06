Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D2F14457
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 07:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfEFF53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 01:57:29 -0400
Received: from mail-eopbgr60102.outbound.protection.outlook.com ([40.107.6.102]:37894
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbfEFF52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 01:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdAMUsQAje7nuEOzerj0HI1cqJxQd3u5hLxZI1wNhhY=;
 b=PayFbe+Bh1DctS4cQju4N6B+DHIAMkniUo0jElnhV5KNY1jdne/HM4Nxt9RFmobrINrFCyAP13bqNj1OW9B/Gp+VagQAY9qPJ0ndh3fSsPJWNBiNLRxuHTn3h+U6w2cDkwPSKZg1IawU67iUuNXnLbmx+0+PTiIEwPyhfwgST8k=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB2640.EURPRD10.PROD.OUTLOOK.COM (20.178.126.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Mon, 6 May 2019 05:57:11 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 05:57:11 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 2/5] net: dsa: mv88e6xxx: rename smi read/write
 functions
Thread-Topic: [RFC PATCH 2/5] net: dsa: mv88e6xxx: rename smi read/write
 functions
Thread-Index: AQHVAFSSX8ZksdA+AkirAMJMhwKcSqZZ9cEAgAOqqQA=
Date:   Mon, 6 May 2019 05:57:11 +0000
Message-ID: <8d14f3e0-4b95-900c-55f0-dfff30ae655f@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-3-rasmus.villemoes@prevas.dk>
 <20190503175732.GB4060@t480s.localdomain>
In-Reply-To: <20190503175732.GB4060@t480s.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0359.eurprd05.prod.outlook.com
 (2603:10a6:7:94::18) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17392168-c6a2-4323-4ba3-08d6d1e7ae35
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB2640;
x-ms-traffictypediagnostic: VI1PR10MB2640:
x-microsoft-antispam-prvs: <VI1PR10MB2640B0747B106CE8CBB6C3CC8A300@VI1PR10MB2640.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(346002)(376002)(136003)(366004)(396003)(199004)(189003)(25786009)(476003)(36756003)(53936002)(31686004)(6246003)(6512007)(4326008)(256004)(486006)(71190400001)(71200400001)(4744005)(74482002)(66946007)(7736002)(73956011)(66446008)(64756008)(66556008)(66476007)(305945005)(478600001)(81166006)(8976002)(8936002)(8676002)(81156014)(42882007)(72206003)(102836004)(6506007)(386003)(44832011)(11346002)(446003)(2616005)(31696002)(229853002)(186003)(68736007)(6916009)(66066001)(6486002)(6436002)(26005)(2906002)(6116002)(3846002)(316002)(76176011)(99286004)(14454004)(54906003)(5660300002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2640;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xy4vVHdNSqjdIa2f4ut9cYa9PdO6R7CjGpasLWIhKWSOFQwDhsShjj8DWsWxIphmhMoi6PJBPJtdcQRR1O7cXhZGh0lPrY2rsyGojs3+7897tFDXCa2joRtZdftcJWOIM+LAHWXCyHfRi42V5SRBR7EIC1Vk6ZefdLrwm6b0H6Ix+bXBzD3jwIw8V8AP5sR0t8d3GV3/Wm/x5QcjklrX65MCb5DJ8/mmYm/niDO339GdCzjX25zzY9E+NYsKLFM5Qlgr4IG40Yf//2b6fP+ZasXHThxBIforb55znT7GEg/t/fpEpWa0LSkOnoewIljycOL6267YzXdGhOuNKl3vtdithRVXKlLPG5Qt8fLw2n7IF6q5KIgMCkSx6N//wy/kkynYfhEOvSElQe9FxKM9yoPIjoHPvnookhfnX+AGyZU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B17DFFB7F08C34CAE691E29C9D3C10D@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 17392168-c6a2-4323-4ba3-08d6d1e7ae35
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 05:57:11.2394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDMvMDUvMjAxOSAyMy41NywgVml2aWVuIERpZGVsb3Qgd3JvdGU6DQo+IEhpIFJhc211cywN
Cj4gDQo+IE9uIFdlZCwgMSBNYXkgMjAxOSAxOTozMjoxMSArMDAwMCwgUmFzbXVzIFZpbGxlbW9l
cyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+IHdyb3RlOg0KPiANCj4+IC1zdGF0aWMgaW50
IG12ODhlNnh4eF9zbWlfc2luZ2xlX2NoaXBfcmVhZChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNo
aXAsDQo+PiAtCQkJCQkgIGludCBhZGRyLCBpbnQgcmVnLCB1MTYgKnZhbCkNCj4+ICtzdGF0aWMg
aW50IG12ODhlNnh4eF9zbWlfZGlyZWN0X3JlYWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlw
LA0KPj4gKwkJCQkgICAgIGludCBhZGRyLCBpbnQgcmVnLCB1MTYgKnZhbCkNCj4gDQo+IEkgaGF2
ZSBhIHByZXBhcmF0b3J5IHBhdGNoIHdoaWNoIGRvZXMgYWxtb3N0IGV4YWN0bHkgdGhhdC4gSSdt
IHNlbmRpbmcgaXQNCj4gdG8gc2ltcGxpZnkgdGhpcyBwYXRjaHNldC4NCg0KT0ssIEknbGwgaG9s
ZCBvZmYgc2VuZGluZyBhIHYyIHVudGlsIEkgc2VlIGhvdyAxLzUgYW5kIDIvNSBhcmUgb2Jzb2xl
dGVkDQpieSB5b3VyIHBhdGNoKGVzKS4NCg0KPiBBbHNvIHBsZWFzZSB1c2UgbXkgR21haWwgYWRk
cmVzcyBhcyBkZXNjcmliZWQgYnkgZ2V0X21haW50YWluZXIucGwgcGxlYXNlLg0KDQpTb3JyeSwg
SSBtdXN0IGhhdmUgYmVlbiBydW5uaW5nICdnaXQgc2VuZC1lbWFpbCcgKHdoaWNoIGludm9rZXMN
CmdldF9tYWludGFpbmVyIHZpYSBhIC0tdG8tY21kIHNjcmlwdCkgZnJvbSB0aGUgNC4xOSB0cmVl
IEknbSBjdXJyZW50bHkNCnRhcmdldGluZy4gV2lsbCB0cnkgdG8gcmVtZW1iZXIuDQoNClRoYW5r
cywNClJhc211cw0K
