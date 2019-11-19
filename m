Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6730110218C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKSKEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:04:21 -0500
Received: from mail-eopbgr690041.outbound.protection.outlook.com ([40.107.69.41]:44043
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfKSKEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 05:04:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaVpyO3uElg35/lwCudI/tHCkkMYyA01wZuwbqAMEpxULySVUXrGqtaw788gpgP6DjgoAfDjRh3GigaxAr8ZHZStd5IpIH7JYiUmZpnWpMWrh6DsxLciY+MmLBpdHqP5+I6YElJp4hl9DSRL46Jf94RlaHUlZDJYYv7riPODmWDA5YS6kGIPvprE6Di4SHzRB4OKlhsaV0CYAuBysipTMQifnI71NV+061XrxNvAq+lZ/SInADdRzmIG9toG+Sb0cNh+zpSQQLCa4686wE9AgvuScwTUbibmOiZVaLpaMA4eE54q8mDDYbF9A0cxB+FfY1dyRWE/Q8jXBmWmnz0H+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCqW7PndEfCy3kLnnndPGjlt4mH/3XChh6L+jdX3U/8=;
 b=WlkUM2Lm2dnUN6ZXKDFf1HKyhuUbfhqWZ4/04yV8QsyrrB3U+aD2jM2bnqAGBHdQV3pcKgznocqq2hYQARzv8FCPOHspcxmIBJvEPtPtSRu4MKgo0cnBI5TiKUvf7lhMxz4QB+Sb+iiyYv7S9ddgjxaaTstB6+tUDc7Pa35x/8HC9J4SeRRsFoEg1TbhpGVa99QDgIQ2fl61Wf/IRX4aP+vpZymPDpXn2FAFBwAAjwawoQjbS1TT9VKO27tGI4BhZ/vywZcGf8wkAqMGofHk+gIvnx6WR7/IYqeyPaI/4e4xVz1dn8s430jdwPWZNwy9whNXzXmSuoyY+F49uQuAYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCqW7PndEfCy3kLnnndPGjlt4mH/3XChh6L+jdX3U/8=;
 b=LLaJauLB5horllKRm7eDjwyVWKiFy2N3nnDgz9i6RvIF/36iSYRVs1m9Dsx9itKRkFLD3g01Bd3hbIsBcG/tSAmsMj00xnnowQjRcAP2KnRBMgtVCs5pNwLem8btbaMjBfoEDu7Dftc5fk3TgCeio/UkyEnQ6Z9OMQVDiNJaFpw=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.77.152) by
 BN8PR10MB3556.namprd10.prod.outlook.com (20.179.79.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Tue, 19 Nov 2019 10:04:15 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::d0b1:a3a7:699a:2e2]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::d0b1:a3a7:699a:2e2%6]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 10:04:15 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: PtoP IPv6 LL address with prefix 128 ?
Thread-Topic: PtoP IPv6 LL address with prefix 128 ?
Thread-Index: AQHVnsCzRFuo0HgoKEy8SvSP1KBlFQ==
Date:   Tue, 19 Nov 2019 10:04:15 +0000
Message-ID: <0f7739066d4f2ab0fbd15e019d4f42cff5a12cdd.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe2b1998-4385-4aed-0e4d-08d76cd7d5d8
x-ms-traffictypediagnostic: BN8PR10MB3556:
x-microsoft-antispam-prvs: <BN8PR10MB35562007EC34E21375EA23EBF44C0@BN8PR10MB3556.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(25786009)(8676002)(1730700003)(99286004)(316002)(81156014)(5660300002)(6486002)(6436002)(6506007)(66476007)(76116006)(91956017)(6116002)(14454004)(3846002)(66066001)(66946007)(26005)(102836004)(66446008)(66556008)(4744005)(8936002)(186003)(86362001)(7736002)(2351001)(64756008)(2501003)(2616005)(305945005)(81166006)(6512007)(486006)(476003)(256004)(71190400001)(36756003)(478600001)(2906002)(71200400001)(5640700003)(6916009)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3556;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rKBGAHMnY4BaiNXk6QEF1M3s+8Oq4rdfYcV1aIs/B86dUfzPNTNr6mayIYv2AJHf1lt/o7dEuF2+iuD1DNMRxoI8UtjhiKr0MNJ6BK0ppL/RieJs6gO47dElc9YAJIYb+OFEmvHC2joZ2i8mf6FZQ+rQ0+hqFfdhj29TYMaqVd2hb9Tu52rYMs9W7WodO6g4YvffWcwuEsxn8Q710q2uiEpGARIhX3EHKIYMDvcS/umGyDXMwJtGEmkfqpMxsPxczG13eB9xka2MABnhqtkLvskwLIVk9y7UDSxDiWAwjJ0HceSepJvmsyiKa/Y0P1hMy3LEfmtEjsAPWR6cj6ctz6qhBXNwjFQvWuX+WL9FLva5Kbi3mAZ+dqeWO2gUq6MqctZqZWAosnIaBgN6MwsUt3hjKN+4chNqAcQsfhLufzGU6cQWsA/4ygZ1N+pv7kVD
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FA4A6A6257BE0419D05F2E6E7450040@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2b1998-4385-4aed-0e4d-08d76cd7d5d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 10:04:15.4671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9aUlnb/0rYtL0TVepi7u9HCh+p1nv/vFChhMrSJAfic1H2XaRimCPy7IIUSzJ1iYYMbs13GhVJuejQL9gqB0rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3556
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gSVB2NCBpcyBpcyBjb21tb24gdG8gdXNlIGEgLzMyIG1hc2sgZm9yIFB0b1AgSVAgYWRkcmVz
c2VzKGFrYSB1bm51bWJlcmVkKQ0KVHJ5aW5nIHRvIGRvIHRoZSBzYW1lIGZvciBQdG9QIElQdjYg
TEwgYWRkcmVzcyAvMTI4IGRvZXMgbm90IHdvcmssIE9TUEYgc3RvcHMNCmZvcm1pbmcgbmVpZ2hi
b3VycyBvdmVyIHN1Y2ggbGlua3MsIHdoeT8NCklzIHRoZXJlIGEgZnVuZGFtZW50YWwgZGlmZmVy
ZW5jZSBiZXR3ZWVuIElQdjQgYW5kIElQdjYgaW4gdGhpcyBjYXNlPw0KDQpBbHNvLCBJIG5vdGUg
SSBjYW5ub3QgdGVsbmV0L3NzaCAoVW5hYmxlIHRvIGNvbm5lY3QgdG8gcmVtb3RlIGhvc3Q6IElu
dmFsaWQgYXJndW1lbnQpDQp0byBhIG5laWdoYm91ciB1c2luZyBpdHMgTEwgYWRkcmVzcyB3aXRo
b3V0IGFsc28gc3BlY2lmeWluZyB0aGUgaW50ZXJmYWNlKExMIGFkZHJlc3MlZXRoMCkuDQpJcyB0
aGVyZSBhIGtub2IgYXJvdW5kIHRoaXM/DQoNCiBKb2NrZQ0K
