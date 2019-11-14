Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1213CFC17D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 09:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfKNIYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 03:24:40 -0500
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:57934
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725920AbfKNIYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 03:24:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpOwN6XUxTO2MoK6dWQZiHn+eNwzt66/DLJ5Pu2AM3ZV4kEoL1hoy5ug4fltg+CQDRqH9H7tLXV/vCuPBrdgs7xUvWXk52uqdtAh4SS69k3jlJilOCSPo750Rw7jycTJCv1815Qb3qQtKH0kw3ES0C/4cuORgf5G7LqZQh+KmDTzaIEjaAyWvyEueICcibvNdRIldXcX7Ptx2/ALKP/+Ogx5kq/OGSmdSEVGSiKzbO5oR/MMDImxDqOn0vXF26X44UqlVeI76Y/3nT36JMowBrsYMHA47K5xoHxRi5EJV8oTC96IaF+I6f5MUTY9xRdqfNj1NTNavVVMPoxz+wRSdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BseJCpG3uk6A5+d9pByUY1xbjTSxBpgAWw9Iis09Spk=;
 b=XKzVoDPUajP5S8vMV3GOKmDS/KdZJL0p3wqcYmKYbAcDGCUCwpp/63gOraZVHL0tcSHvdXGm2T66WXtLMTeaaXpsPtVpMn0MzLJZ6NmSHz6J7iu4H8RrRONnHE4YKrqRampkDoGLFe6lhRDfScCce83jF1PsPUnfJTssz1JrKnK9/Pgi+e2LoMaU+IcBbTSPd1+uBY5Ob5TOUJ2CYi/4jkWDOB50UJ0bHEnGhQiIM7cdpcamg7knMu5enDEnbRqKhub8RD+4ulNMcnCAGuFkfRnDjhO6cOIx4x9/iaG+mCgo1sYLh4ClHR+pLDzEYyhCxnBDhjgQtdX3DwXlhy6LcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BseJCpG3uk6A5+d9pByUY1xbjTSxBpgAWw9Iis09Spk=;
 b=qVeYGbidVgetMPj7816GegW3NQEjSVWbwrQrEi6YOgXFst0dUr3dnudp2h3mU/Ag8F0ugQhcFy/dbcrsQ4DiSk3rlr71SFQ6jm5oIBVsJ37RDaUhIUzx7J+g23ZnInvEe8e+f4j+s3dqQwuAdF/niGL5f/ahDIRtTaG5sHWrm7k=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB5319.eurprd05.prod.outlook.com (20.177.198.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 14 Nov 2019 08:24:31 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e%7]) with mapi id 15.20.2430.028; Thu, 14 Nov 2019
 08:24:31 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Thread-Topic: [PATCH iproute2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Thread-Index: AQHVmgsbT5eSD/f+hU6my+fa44wqGaeJWKCAgAD9JgA=
Date:   Thu, 14 Nov 2019 08:24:31 +0000
Message-ID: <0e9f41a9-e09c-9e28-7df1-efbe2eb69bbb@mellanox.com>
References: <20191113101245.182025-1-roid@mellanox.com>
 <20191113101245.182025-2-roid@mellanox.com>
 <20191113091825.5cfba26e@shemminger-XPS-13-9360>
In-Reply-To: <20191113091825.5cfba26e@shemminger-XPS-13-9360>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
x-clientproxiedby: AM0PR06CA0034.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::47) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ecc2b2f-1933-4ed1-b3ee-08d768dc12ec
x-ms-traffictypediagnostic: AM6PR05MB5319:|AM6PR05MB5319:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5319B605C11ECAF67DE00701B5710@AM6PR05MB5319.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(51914003)(8936002)(66476007)(25786009)(66446008)(102836004)(4001150100001)(305945005)(31686004)(64756008)(26005)(6506007)(386003)(7736002)(53546011)(2906002)(11346002)(6916009)(107886003)(6436002)(71190400001)(256004)(6246003)(66556008)(4326008)(6512007)(446003)(66946007)(71200400001)(6116002)(3846002)(65806001)(66066001)(65956001)(4744005)(5660300002)(186003)(58126008)(6486002)(229853002)(81156014)(478600001)(54906003)(36756003)(316002)(76176011)(8676002)(14454004)(2616005)(31696002)(476003)(86362001)(81166006)(99286004)(52116002)(486006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5319;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZKridImBElQ64RrPtxiUoYzyiPMVJUTHFQU1KHDZy5HmfiliMj2G9Qc17yZgol7Svw2vJKtptvKWiEn9y9Te3yBpOulWB8TwiV203CX+hpwmheZEqirhrkg7Rs7+MB410Q8TGPfaz3igG1EduzbWEezESnSCSq95ogpFl+uKmVRb3YB+wmoB+CI+TyjQEOH/Xk6BW6KgZ5m3GMKsXUKLnZ5Vf5xVHypb6BvME1uqKahHVkKpI3+srnhisFTtxnuYQ1tlSadXuSIoGAs2gAvYxdOIrXM+CyQCJpjXyH4OkmKIKSCTVYz6oHG32I2QGHHoJ/fVTt2+bOCOSWQoFOI1h3CZ4lvfc+pARUIHsun6V9xQ61soJZkJ3uipSfspMgAIAyS4ZUbV7bFXpP8PoMDH6dIjq8WQeelDuzu/IVv/u4av6Y3eJjeGptPIevjNq2A8
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1E398E0F45640438BB815650D02215D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ecc2b2f-1933-4ed1-b3ee-08d768dc12ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 08:24:31.8319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4CTZAVKClpH5VhACUt25Sraut3vjiE5C1qaxH9Eu5p/rfwB9HVUmSx621x3EducmZRmucJnTYgwdjmcaumrvZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5319
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTktMTEtMTMgNzoxOCBQTSwgU3RlcGhlbiBIZW1taW5nZXIgd3JvdGU6DQo+IE9u
IFdlZCwgMTMgTm92IDIwMTkgMTI6MTI6NDEgKzAyMDANCj4gUm9pIERheWFuIDxyb2lkQG1lbGxh
bm94LmNvbT4gd3JvdGU6DQo+IA0KPj4gK3N0YXRpYyB2b2lkIHByaW50X21hc2tlZF90eXBlKF9f
dTMyIHR5cGVfbWF4LA0KPj4gKwkJCSAgICAgIF9fdTMyICgqcnRhX2dldGF0dHJfdHlwZSkoY29u
c3Qgc3RydWN0IHJ0YXR0ciAqKSwNCj4+ICsJCQkgICAgICBjb25zdCBjaGFyICpuYW1lLCBzdHJ1
Y3QgcnRhdHRyICphdHRyLA0KPj4gKwkJCSAgICAgIHN0cnVjdCBydGF0dHIgKm1hc2tfYXR0cikN
Cj4+ICt7DQo+PiArCVNQUklOVF9CVUYobmFtZWZybSk7DQo+PiArCV9fdTMyIHZhbHVlLCBtYXNr
Ow0KPj4gKwlTUFJJTlRfQlVGKG91dCk7DQo+PiArCXNpemVfdCBkb25lOw0KPj4gKw0KPj4gKwlp
ZiAoYXR0cikgew0KPiANCj4gY29kZSBpcyBjbGVhbmVyIGlmIHlvdSB1c2Ugc2hvcnQgY2lyY3Vp
dCByZXR1cm4gaGVyZS4gaS5lDQo+IA0KPiAJaWYgKCFhdHRyKQ0KPiAJCXJldHVybjsNCj4gDQo+
IC4uLg0KPiANCg0KcmlnaHQuIHRoYW5rcyBmb3IgdGhlIGNvbW1lbnRzLiB3ZSdsbCBmaXggaXQu
DQo=
