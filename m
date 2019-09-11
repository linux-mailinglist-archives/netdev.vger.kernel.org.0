Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB4FAF53B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 07:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfIKFJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 01:09:31 -0400
Received: from mail-eopbgr100135.outbound.protection.outlook.com ([40.107.10.135]:46624
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbfIKFJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 01:09:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9JUQ//LQl1o1gFdYTKiVrUML8jc4PiHTmncjEd5lFmhWDaNoDP6fA4je+sr7b+Xj8lblciakR3gPOt5Zcfh+jkdcsZaZP8Ow398Pzv4G5Ihv7edz3yjP1Wf/09zUyOLZT5TBFDdxDZbxBLihaA9qe3TCqeuMlv1JARBDtWmdwDnRQBD0SNOePaJNzbl6Geo23fOFWkBjBE4y54k0OTJ3qOp8JWGEOJKU4Z59gxoRTNfxDU/y1tiMGpWtBiG5hs0TUZBX2uCKCnS9Jxw9jO81u6waIfZx7xknouPwWugb3OI5ZGS41zHEqpBBYLcsKgurjG1F3WQxqAXpqPiFuMN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6fktCPQLO3aYEmVPFAxsVD2XOKPrO+19d8u/SJacNE=;
 b=PH71QivvNev164o3gZPD+BORho/eB8NMYLUsgoW/LJn2vjLxAKXvrFor15ko8TXjWrL0bDoE+2GtE/jBy1LWJ2b9o+UCs+96zLGeXLkYqrs89vDesDelMbsNJyhcEjxV4QrgZgz577RByI7udumOGpWsi/hepwn0rLYTzjaTG5aINs1w/94AAKYcQOmbQ9ApOB1nIQlIO5n/DFACz4ZcfTZrjyjZyA7JwFBegI1CB3ZZU1piKKQhAHtY+VFWs2waQXccXEakWCVwD9ZZBuxNxhmk2LzRjnr6mgQF4qlRLfi5GbFujK1wTfddB99Zt29lGqQLFjzA7HijglVcRcVV8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=potatocomputing.co.uk; dmarc=pass action=none
 header.from=potatocomputing.co.uk; dkim=pass header.d=potatocomputing.co.uk;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT4492442.onmicrosoft.com;
 s=selector2-NETORGFT4492442-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6fktCPQLO3aYEmVPFAxsVD2XOKPrO+19d8u/SJacNE=;
 b=I+ogoU7MTv1gsfdEv93aRlla9gz22eYqyN2W1VpNf57hpObP+5dJH7Em4e9AZCMVlvqb7PGMnQlQDqy7Qfyf1jOzcqwV42hOWX5ffT8FPJvu3dx7pD0KHO2ybt52BN9pNFBhYu72DM3FbR7dcdiJx0wsp7M7oNuuxWwbaRgpRWU=
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM (20.176.38.150) by
 CWLP265MB0820.GBRP265.PROD.OUTLOOK.COM (10.166.19.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Wed, 11 Sep 2019 05:09:27 +0000
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547]) by CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547%7]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 05:09:27 +0000
From:   Gowen <gowen@potatocomputing.co.uk>
To:     David Ahern <dsahern@gmail.com>, Alexis Bauvin <abauvin@online.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: VRF Issue Since kernel 5
Thread-Topic: VRF Issue Since kernel 5
Thread-Index: AQHVZuKrrHmXIhazUku6D0pNIn18H6cjFD4AgAAH2kGAACLagIAB3vUAgADR7HA=
Date:   Wed, 11 Sep 2019 05:09:27 +0000
Message-ID: <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
In-Reply-To: <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gowen@potatocomputing.co.uk; 
x-originating-ip: [86.31.175.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebd45733-fd95-4587-f56e-08d736763869
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP265MB0820;
x-ms-traffictypediagnostic: CWLP265MB0820:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CWLP265MB0820775F9F02920C8DEBFF6AFDB10@CWLP265MB0820.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39830400003)(396003)(376002)(366004)(346002)(13464003)(189003)(199004)(51914003)(316002)(229853002)(66556008)(6306002)(53936002)(14444005)(71190400001)(71200400001)(52536014)(110136005)(74316002)(7736002)(305945005)(508600001)(14454004)(966005)(4744005)(7696005)(11346002)(5660300002)(66066001)(3846002)(6116002)(33656002)(2906002)(66476007)(76116006)(53376002)(53366004)(9686003)(66946007)(256004)(64756008)(446003)(6246003)(86362001)(6436002)(8676002)(102836004)(6506007)(53546011)(81156014)(55236004)(76176011)(26005)(66446008)(4326008)(186003)(476003)(486006)(81166006)(55016002)(8936002)(99286004)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:CWLP265MB0820;H:CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: potatocomputing.co.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4VTQ8o9eE0BaoRBd6Ec9ilgJymNOHc5WL5LHGGW4a0evhFcLLTshU7p8IBpjqNL9wfQEkcbZPsUWlwtpatkX8h7mYp/VC0wFAmZeN/XePy0FlBxfXLh5+FHiXeALEsRx9i1/ohnHN6tZS1LBNpaqFsq+u9xzLN/WYDZioSV8liJtx1DHtalVxzOuPdCeNaNT8drZZSgOCejcqyOT/w72Qq8yU13ZBbnfh37aN5q4VRT8vbXAD0I7YhKnnhWme6grJvTreKogq4v1lrbMmU/xycMv80iEVP5mpIK6DLPX8VmUo8CQZvVofQan4m0Ip+nw1FnT5Syg93850Y1ZMCiP6pZ+pCXNSlOJXBmqVEcxZFmP95MlW3FGdgfIQZIOHfaTjbphBtEmnex5c9vhG1ux2TcR8HgDnJzdx+00JELtclY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: potatocomputing.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd45733-fd95-4587-f56e-08d736763869
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 05:09:27.5494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b0e486ce-86f8-410c-aa6d-e814c15cfeb8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPS7bkt8BXrcAsy/UiOU0xlx6oP0GP+LtzJrCPfs/N1E0Gv0Vw3ZND1g2jqUX4UGyAPxqDEQermoeKLhavne9QEUkl8aAYP4nbq7rKmWwDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB0820
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB0aGUgbGluayAtIHRoYXQncyByZWFsbHkgdXNlZnVsLiBJIGRpZCByZS1vcmRl
ciBpcCBydWxlcyBGcmlkYXkgKEkgdGhpbmspIC0gbm8gY2hhbmdlDQoNCi0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+IA0KU2Vu
dDogMTAgU2VwdGVtYmVyIDIwMTkgMTc6MzYNClRvOiBBbGV4aXMgQmF1dmluIDxhYmF1dmluQG9u
bGluZS5uZXQ+OyBHb3dlbiA8Z293ZW5AcG90YXRvY29tcHV0aW5nLmNvLnVrPg0KQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBWUkYgSXNzdWUgU2luY2Uga2VybmVsIDUN
Cg0KT24gOS85LzE5IDE6MDEgUE0sIEFsZXhpcyBCYXV2aW4gd3JvdGU6DQo+IENvdWxkIHlvdSB0
cnkgc3dhcHBpbmcgdGhlIGxvY2FsIGFuZCBsM21kZXYgcnVsZXM/DQo+IA0KPiBgaXAgcnVsZSBk
ZWwgcHJlZiAwOyBpcCBydWxlIGFkZCBmcm9tIGFsbCBsb29rdXAgbG9jYWwgcHJlZiAxMDAxYA0K
DQp5ZXMsIHRoZSBydWxlcyBzaG91bGQgYmUgcmUtb3JkZXJlZCBzbyB0aGF0IGxvY2FsIHJ1bGUg
aXMgYWZ0ZXIgbDNtZGV2IHJ1bGUgKFZSRiBpcyBpbXBsZW1lbnRlZCBhcyBwb2xpY3kgcm91dGlu
ZykuIEluIGdlbmVyYWwsIEkgd291bGQgcmV2ZXJzZSB0aGUgb3JkZXIgb2YgdGhvc2UgY29tbWFu
ZHMgdG8gZW5zdXJlIG5vIGJyZWFrYWdlLg0KDQpBbHNvLCA1LjAgSSB0aGluayBpdCB3YXMgKHRv
byBtYW55IGtlcm5lbCB2ZXJzaW9ucykgYWRkZWQgYSBuZXcgbDNtZGV2IHN5c2N0bCAocmF3X2wz
bWRldl9hY2NlcHQpLiBDaGVjayBhbGwgMyBvZiB0aGVtIGFuZCBubWFrZSBzdXJlIHRoZXkgYXJl
IHNldCBwcm9wZXJseSBmb3IgeW91ciB1c2UgY2FzZS4NCg0KVGhlc2Ugc2xpZGVzIGRvIG5vdCBj
b3ZlciA1LjAgY2hhbmdlcyBidXQgYXJlIHN0aWxsIHRoZSBiZXN0IGNvbGxlY3Rpb24gb2Ygbm90
ZXMgb24gVlJGOg0KaHR0cDovL3NjaGQud3MvaG9zdGVkX2ZpbGVzL29zc25hMjAxNy9mZS92cmYt
dHV0b3JpYWwtb3NzLnBkZg0K
