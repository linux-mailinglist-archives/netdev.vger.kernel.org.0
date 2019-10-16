Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B677D9218
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393510AbfJPNND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:13:03 -0400
Received: from mail-eopbgr770048.outbound.protection.outlook.com ([40.107.77.48]:41673
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391688AbfJPNNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 09:13:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjmX15/DkX/lvFVqs3irh3GKEoo+EZBb8PRX9MS1AK2deDksMDzgcXhIWqnI9UCNuW7OVyCh3If0KRZYzB1oivBCGmVzHtf96h76O2+FaLv0PmqzezMaZmYULMxfOHgJj5WvjQgGqqHG0U1tdt7Su0NBb8Io61/PJT7yj6Km9e12VmK9jh2qItoBoaUBiLfTR4GR4pkAfU0n7cnSMLRw4FL89r6gRi+bxDx//sfpe9OAEkjFUFlJvZPImgIfABQfZB7qUDwv3uw2qXQsseqczhAnMr9KuFF90LHsxrLqO9q0gqQ9IylgXUKY+LUZgGlbKalh+YTE5y0OCL7vw3f1TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9g1ndxBBSRhrFhHeI3tfpZHMSBa4PwGGE8AK7uw6O0=;
 b=oMs/yA0Znqqxtt2f2c2mUsutQZnmTs3ewiBoJERuXjv214szAbry12Xy+1tPC7VeTeWJVHBn+Pjz94uqXFZpoxRMIYALQ8/40/cKG5G38NzxzHBZKNpe320GDuZiThgePrxEZ41Td5eda//zOTwsbEMHCBBLNs0Z/Hq/UI0YmIOehCCd4uMxDrvSQwQzfe8CwWSxj38L55Cwgn2khn0ekZi+F0ASKCtTq7Cv9mQawiHxLq7OQKAdlAXmwUrMuJ6xu7iyOGh3uvx+Lw/roO7UCEjO7d2HAydW09myjDCbWNRjQCh2B4RdZMeSUsrsXCtqhbN8vNLwZ1F1EetDCqnmLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9g1ndxBBSRhrFhHeI3tfpZHMSBa4PwGGE8AK7uw6O0=;
 b=MVDOGWpQz6TDEIKY+P2zdHRe2ROuJtQo2q5v4yLU/OhmYbBi2pPmNirKxjdIDW6YhuTL6uyoohU4oWWemMSorJeNFdZa9oPzkc1DWzLRPQFU34r7F6fqvrxDNA7LwgEvA7+wXSsRHbpDeounkxN6fHGNzFCpeAzLNSxYmp2TVAA=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3761.namprd11.prod.outlook.com (20.178.219.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 16 Oct 2019 13:12:54 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 13:12:54 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: Re: [PATCH v2 net-next 10/12] net: aquantia: add support for Phy
 access
Thread-Topic: [PATCH v2 net-next 10/12] net: aquantia: add support for Phy
 access
Thread-Index: AQHVfccaHm7vyqrB/0i0TJjnhG/Tmw==
Date:   Wed, 16 Oct 2019 13:12:54 +0000
Message-ID: <bfd14f97-de5c-feda-49e1-06451bd4ed80@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <09f7d525783b31730ca3bdbaa52c962a141284a5.1570531332.git.igor.russkikh@aquantia.com>
 <20191015121903.GK19861@lunn.ch>
In-Reply-To: <20191015121903.GK19861@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0016.eurprd09.prod.outlook.com
 (2603:10a6:101:16::28) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8af33a79-23e3-4d10-8672-08d7523a8e26
x-ms-traffictypediagnostic: BN8PR11MB3761:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3761678B243891712A4D594798920@BN8PR11MB3761.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(6506007)(229853002)(26005)(476003)(66066001)(2616005)(186003)(5660300002)(44832011)(6916009)(2906002)(36756003)(31696002)(478600001)(486006)(54906003)(316002)(386003)(446003)(102836004)(11346002)(66946007)(6512007)(86362001)(71190400001)(66556008)(66476007)(256004)(6116002)(31686004)(107886003)(6486002)(3846002)(6246003)(76176011)(64756008)(66446008)(99286004)(71200400001)(6436002)(8936002)(8676002)(14454004)(7736002)(14444005)(4326008)(81156014)(305945005)(25786009)(81166006)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3761;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9AzjyouYvqbOMSuFi22GW1RwtOLQncd54EwYWljYFIPubBr1vAqnlhDGxMWqUHegNJnKUtRRaTs9vAGCSZ9P5bSbJ2EtH81lcq2lXLp9P/WSYfcFI0plGVAnmmmnA7O1I18uJm+WC3Ffm0f6R7lHhSxsmtnp4aiBxv12Zgfu9sjS3gNVig0d6uBs4IsDMsXmQyB8Ny397EvpXMqO3Y8khyVrP2+MPvqud99pd0d9nt268DCjLQ1kQXU5MqM7V7p2QLKlyIiwLN2Wf/Ueold9OIg+lmvAI2tksIZrcyoPIIB1Tu1f6EDnS/zHDxvT3dbt7zFEg5nyGNBiuHypxJQyhck6b0NnkeOUjQWVlaoNQOHojsVeCzw672pTYb9ByeWWXGx5jtTHUtgvEstor/5oBAVxLD0EVv0okjVwBvkpYec=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FE0A44A53ADDB4AB0E34085FF1C85F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af33a79-23e3-4d10-8672-08d7523a8e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 13:12:54.4014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sjNg6xqtscKnDuLZgll/KEgHIgUArHSRDCOcElIecGKvmF3hNZNsPqzPMb96eUje1NfnDrLY3pp1lVZTEKJVZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3761
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEhpIElnb3INCj4gDQo+IElzIHRoZSBBdGxhbnRpYyBhIGNvbWJpbmVkIE1BQyBhbmQgUEhZ
IGluIG9uZSBzaWxpY29uLCBvciBhcmUgdGhlcmUNCj4gdHdvIGRldmljZXM/IENvdWxkIHRoZSBB
dGxhbnRpYyBNQUMgYmUgdXNlZCBpbiBjb21iaW5hdGlvbiB3aXRoIGZvcg0KPiBleGFtcGxlIGEg
TWFydmVsbCBQSFk/DQoNCkhpIEFuZHJldywNCk5vIGl0IGNhbid0LiBUaGlzIGlzIGEgbW9ub2xp
dGljIE1BQytQaHkgc29sdXRpb24uDQpXZSBkbyBoYXZlIE1BQyBvbmx5IE5JQyAoQVFDMTAwIHdp
dGggU0ZQKyBjb25uZWN0b3IpIC0gYnV0IGV2ZW4gdGhlcmUgU0ZQIFBoeSBpcw0KY29udHJvbGxl
ZCBieSBNQUMgZmlybXdhcmUgYW5kIHRoaXMgaXMgdG90YWxseSB0cmFuc3BhcmVudCBmb3IgZHJp
dmVyL09TLg0KDQo+PiArCWFxX21kaW9fd3JpdGVfd29yZChhcV9odywgbW1kLCBhZGRyZXNzLCBk
YXRhKTsNCj4+ICsJaHdfYXRsX3JlZ19nbGJfY3B1X3NlbV9zZXQoYXFfaHcsIDFVLCBIV19BVExf
RldfU01fTURJTyk7DQo+PiArfQ0KPiANCj4gWW91IGhhdmUgaGVyZSB0aGUgY29kZSBuZWVkZWQg
dG8gaW1wbGVtZW50IGEgcmVhbCBMaW51eCBNRElPIGJ1cw0KPiBkcml2ZXIuIEFyZSB0aGUgTURJ
TyBwaW5zIGV4cG9zZWQ/IENvdWxkIHNvbWVib2R5IGNvbWJpbmUgdGhlIGNoaXANCj4gd2l0aCBz
YXkgYSBNYXJ2ZWxsIEV0aGVybmV0IHN3aXRjaD8gWW91IHRoZW4gbmVlZCBhY2Nlc3MgdG8gdGhl
IE1ESU8NCj4gYnVzIHRvIGNvbnRyb2wgdGhlIHN3aXRjaC4gU28gYnkgdXNpbmcgYSBMaW51eCBN
RElPIGJ1cyBkcml2ZXIsIHlvdQ0KPiBtYWtlIGl0IGVhc3kgZm9yIHNvbWVib2R5IHRvIGRvIHRo
YXQuIFlvdSBjYW4ga2VlcCB3aXRoIHlvdXIgZmlybXdhcmUNCj4gbW9zdGx5IGRyaXZpbmcgdGhl
IFBIWS4NCg0KTm8sIHRoZXNlIGFyZSBub3QgZXhwb3NlZCBhcyBmYXIgYXMgSSBrbm93LiBUaGVy
ZWZvcmUgaXQgbWFrZXMgbm8gc2Vuc2UNCnRvIGV4cG9zZSB0aGF0IHRvIGxpbnV4Lg0KDQo+PiAr
CQlhcV9ody0+cGh5X2lkID0gSFdfQVRMX1BIWV9JRF9NQVg7DQo+PiArCQlyZXR1cm4gZmFsc2U7
DQo+PiArCX0NCj4gDQo+IEZvciBmdXR1cmUgcHJvb2ZpbmcsIHNob3VsZCB5b3Ugbm90IGNoZWNr
IGl0IGlzIGFjdHVhbGx5IG9uZSBvZiB5b3VyDQo+IFBIWXM/DQoNCkkgZG9uJ3QgdGhpbmsgdGhh
dCBtYWtlcyBzZW5zZSwgc2luY2UgdGhhdCdsbCBhbHdheXMgYmUgYSBoYXJkY29kZWQgbWFjL3Bo
eSBwYWlyLg0KDQpSZWdhcmRzLA0KICBJZ29yDQo=
