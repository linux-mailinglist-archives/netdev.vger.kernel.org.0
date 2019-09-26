Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9ABF79E
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfIZRcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:32:50 -0400
Received: from mail-eopbgr680077.outbound.protection.outlook.com ([40.107.68.77]:7491
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbfIZRct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 13:32:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vfj+Rgr99vcyWlsDcFX3Mb/UQtywwNE0rQwTNntORSZ7w05gukim1RBRIirS9JAlPh7l3V80cHU/y4nwJ8IkWBnB3NqFAXGmByDLrum0VJtFmitImFx6VZyVVlSK3VZEMFk0nwW6n3V7z5wtWPjZobWLvHOhmQpXrbzPa+zkmABRLkOSzpHBtFx8wXOytsDUd37LikYbwD5qCYYhgvmAt3MripirI7eszHd11y6fmJUUSC+yOkvLVUZmXHhFbA+73XyWgMbliejMtleH5Ulv2g/EB7h97icKT25+UQ9jQZwzOrSeZsHrfZta4nXgSJ2dDs9YgNVRfe8jTE+vOdvkPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EITH3E2hZR+vGPId9tVIgjVzkUqoK/JHu3FGikmnRwQ=;
 b=IFey5bemklktjqLODy2fAk3c0A2jDR33V6m+ye2nagGgKIHPgCAzE2ckH1RwK7UGszgstm80Jpbd3OrujS4/gBXh+olixB9idA1SBdkgR19gD4tShOWMxoOjnJPg8sBMdH5aN22czIRK21CyWYSbqieULKZ7lEttbFd2dOVrnbKs2lfWJMa5UZ+f1bgyICJ+yLw2uPLRwKrMQccy935LT9zQ8g0nBgJBQaoalICc+k5ZAugQ7M5z0t3LNwQQV6Mzttq+yRznmdT1Qi2ig3+9KEeZely2qrowfo3FRyUaWqMo+a5dB85Xj0OH6y72K1qJ17Q52nT63QtloC7SWYyZMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arrcus.com; dmarc=pass action=none header.from=arrcus.com;
 dkim=pass header.d=arrcus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT1331857.onmicrosoft.com;
 s=selector2-NETORGFT1331857-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EITH3E2hZR+vGPId9tVIgjVzkUqoK/JHu3FGikmnRwQ=;
 b=MoKAMHU3eq0dkzDAEHqLJOQL4qw7WcM0NBwCY52f0tVwWnpJeWjrYyxuXUH5XEtWvDFtl+1+RdZP+cfuBNbhB0gzku2xAKap1g6APCL6nQKz7BwyJUGJ1soofrlULF3W2Axm5q72B+3u35kdCepYPQFDVK8i6ngzFFn/bQJrDPk=
Received: from BYAPR18MB3064.namprd18.prod.outlook.com (20.179.58.19) by
 BYAPR18MB2583.namprd18.prod.outlook.com (20.179.93.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.26; Thu, 26 Sep 2019 17:32:45 +0000
Received: from BYAPR18MB3064.namprd18.prod.outlook.com
 ([fe80::dc62:7762:822b:1607]) by BYAPR18MB3064.namprd18.prod.outlook.com
 ([fe80::dc62:7762:822b:1607%3]) with mapi id 15.20.2284.023; Thu, 26 Sep 2019
 17:32:45 +0000
From:   Madhavi Joshi <madhavi@arrcus.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lalit-arrcus <notifications@github.com>
Subject: Re: Question on LACP Bypass feature
Thread-Topic: Question on LACP Bypass feature
Thread-Index: AQHVdI/29bFFNJoRCk+QgVHbJUoCr6c9wleA
Date:   Thu, 26 Sep 2019 17:32:45 +0000
Message-ID: <6390BF88-7D04-41CC-8D57-844FC6A742FE@arrcus.com>
References: <EC009050-F472-4D97-AC9B-F60BE5876176@arrcus.com>
In-Reply-To: <EC009050-F472-4D97-AC9B-F60BE5876176@arrcus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madhavi@arrcus.com; 
x-originating-ip: [2600:1700:470:6f3f:707e:ffa4:a9ae:49b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7002053-2877-40c4-7d46-08d742a78b0d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR18MB2583;
x-ms-traffictypediagnostic: BYAPR18MB2583:
x-microsoft-antispam-prvs: <BYAPR18MB2583F8D490743B40CDF728FCCF860@BYAPR18MB2583.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(366004)(396003)(346002)(376002)(136003)(199004)(189003)(76116006)(2616005)(66446008)(66946007)(64756008)(6116002)(66476007)(76176011)(33656002)(6486002)(5660300002)(66556008)(6512007)(6246003)(36756003)(99286004)(2906002)(4744005)(25786009)(229853002)(7736002)(71200400001)(71190400001)(508600001)(110136005)(6436002)(14454004)(2501003)(305945005)(186003)(8936002)(81166006)(81156014)(8676002)(476003)(316002)(446003)(46003)(256004)(86362001)(6506007)(11346002)(102836004)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2583;H:BYAPR18MB3064.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arrcus.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B7FUYrT2Xm40vRfQGjQXXEkCLD7XFYYEMBlvKjedsDMflpCanygC/BALfGQbmr9bErsPNiIG3u5XdBRpRPECNpN34hAIsC98bQ/PIE0YkQ6lFWSZuPrcnCOSHs4n12egvC6QrfQqoQqRAFFoEgcYa5BA/kUNLp+3dVtN4FwxgOtVfuEyxdYAz4+OoPn3b+2mNio1PktTaTLZRSL3z3UVCPhs75zMG1HnsvGChIwSrAAijMb7XAcOUvkKbW2TDUq4MTVK1i8PqGLLuT0LDXxzj2ekz3cDWMsrdIkBWN5D2PoneuAYkEKLzfczTUr9vBS3MzalnG43cn9w072Z8fDM5FQqln3SiGGYRi5Non/cUB5fHkrzXpaWi9APZjj/LpE0+NDdB4LPEmISZvrPYIIWXs7yKN/ItivdKI3pKBjdCe8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <540A45D03753684784A4816F0115CF54@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: arrcus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7002053-2877-40c4-7d46-08d742a78b0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 17:32:45.4534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 697b3529-5c2b-40cf-a019-193eb78f6820
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V8dU6XkW2IcbnFizdPjWD06Xm7REtx3i9jnePE07fUH7yL6l8EJW0Ni/+MKI3AR4cHD4so5XayrzbHdsijMkwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2583
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQrCoA0KwqAgV2UgaGF2ZSBhIHF1ZXN0aW9uIHJlZ2FyZGluZyBMQUNQIEJ5cGFzcyBm
ZWF0dXJlIC4gSXQgYXBwZWFycyB0aGF0IGJ5IGRlZmF1bHQsIHRoaXMgZmVhdHVyZSBpcyBlbmFi
bGVkIGluIHRoZSBrZXJuZWwgKHdlIGFyZSBvbiA0LjEuMTI3NCB2ZXJzaW9uIGtlcm5lbCkuIA0K
SGF2aW5nIHNhaWQgdGhhdCwgd2UgZG8gbm90IHNlZSBhbnkgc3lzY3RsIG9yIGRpcmVjdG9yeSBv
biB0aGUgbGluZXMgb2YgL3N5cy9jbGFzcy9uZXQvPGJvbmQ+L2JvbmRpbmcvbGFjcF9ieXBhc3Mu
DQrCoA0KUmVhbGx5IGFwcHJlY2lhdGUgeW91ciBoZWxwIHdpdGggdGhpcy4NCsKgDQpUaGFua3Mg
YW5kIFJlZ2FyZHMsDQpNYWRoYXZpDQoNCg==
