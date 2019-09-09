Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA1AD387
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbfIIHRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:17:35 -0400
Received: from mail-eopbgr100124.outbound.protection.outlook.com ([40.107.10.124]:1360
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731422AbfIIHRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 03:17:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwBPaOqOqq9EjxzCHh+s5LBjWJFwZZ4N9DtuyqHXeLXFoDpNjWfiY0fn6T1bIaX76duSQWAmylVUO+w6lwEyFEq7+u9dnYERuEDPQLctuk2ZLrm9+3xkpKhnG4x5hZMwZPI+4yICabYYkYvgC7xEolQLQB7cBsVL4z9Vmw+7+W/TixRTNzgXjcuy0krUrzoTVCk4jc31NQh7pXLGMqSTmHmm0Cfy6FBkVeiNY3nhipo9bpOwyBc6MEWkjvyZF9TUb9eNSPXdzb6x0NDtnZfGxIv4KLR1AWyIqb/pBjdtvOr7yq1pr0UYHdRIqzbiSvtwgkUTrVj+c5dJREyAt0tKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsO3GAgnqsIhmIp/wR3UxbpZg4aFmd0ps4HT1UiHABw=;
 b=bI4uyhzR/oaud567cmNEvORCC/9d/0VLK1iQdxBkp+dUPcKOQyxyinklIzVJ/ne6KcNi83m85/OLsV1oFBEndMoe6qxgOEmlp498BpXSDnpkuMCDamknmroFmRMaKQO2UPdlh7gwnh1XUqka4Tu+6CPxiXbM3ySbG0Q5eWC9mVNDQSBspXgJf1TKsb/8CDcYz8p1Om6ukR/YGXJtI76WttoBqvvLiIV8nnbIkhWlY2gYUy8fVI5K675S3wlAr4Ro00d4zwogP+wVlFq9Mnjt76hMmjHj6peVlg4z+vVVaGq/MK4lzXuhKyGbFmDy0oohMkbqv/I+as0T2tfDSYCjAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=potatocomputing.co.uk; dmarc=pass action=none
 header.from=potatocomputing.co.uk; dkim=pass header.d=potatocomputing.co.uk;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT4492442.onmicrosoft.com;
 s=selector2-NETORGFT4492442-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsO3GAgnqsIhmIp/wR3UxbpZg4aFmd0ps4HT1UiHABw=;
 b=eDWrdMznA1C6ltgTCZ7mZYvlMlzGxZnxEdtWLoSJwP0F+ZmIrAXsqWSFZF7B1F22RVK4xnS0e6EYDu2IL6W44i63PZb/t5CVihIXUQGcgZmYxx3Gs0vH9drsZNcsk6NDj7ybxOyrcbrmyIHjPHS8TgoyVt9Gb7ur823Rwdv/Myc=
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM (20.176.38.150) by
 CWLP265MB1763.GBRP265.PROD.OUTLOOK.COM (20.180.147.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 07:17:31 +0000
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547]) by CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 07:17:31 +0000
From:   Gowen <gowen@potatocomputing.co.uk>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: mta test
Thread-Topic: mta test
Thread-Index: AQHVZt6XfTvedCECRkq1GEKB1J8A0g==
Date:   Mon, 9 Sep 2019 07:17:31 +0000
Message-ID: <CWLP265MB15549102D8261326572729A1FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gowen@potatocomputing.co.uk; 
x-originating-ip: [51.141.34.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33dc39b9-157f-4599-d4c3-08d734f5c76d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP265MB1763;
x-ms-traffictypediagnostic: CWLP265MB1763:
x-microsoft-antispam-prvs: <CWLP265MB176362CB1AD5DCA8C40C903DFDB70@CWLP265MB1763.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(136003)(366004)(396003)(346002)(39830400003)(189003)(199004)(6436002)(2906002)(8936002)(4270600006)(2501003)(14454004)(66066001)(55016002)(5640700003)(558084003)(2351001)(99286004)(316002)(71190400001)(186003)(55236004)(86362001)(6506007)(476003)(3480700005)(102836004)(7736002)(305945005)(81156014)(81166006)(221733001)(25786009)(1730700003)(71200400001)(74316002)(8676002)(33656002)(52536014)(508600001)(256004)(6116002)(3846002)(6916009)(486006)(26005)(53936002)(7116003)(5660300002)(9686003)(7696005)(91956017)(76116006)(66556008)(66446008)(66476007)(64756008)(66946007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CWLP265MB1763;H:CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: potatocomputing.co.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2x6htZbOlYN+TmpcgHT25cmcMMFbwPRHbAOerJTgaHwGTF2olxjMyCK02SrfZoGNtSqt8B9hJ3fkXtueNfV2s7m4K50DrhBiEDcbfYw9GhwRFmdYNFFbDwpNupNMNAiAZl90PfQQuwH0ujz+7mRHk8nzJilW0BXplprPIYdq6SVBLl70NULvaI8lmv0s9+jXy9At3nhYBBqNsMvIUlNgpWoIgcPAkpvV6bSeqswovgr6JjBnw4C5q4aQNtyfI0es4nXLtYt5/gRAzoW+dAjah1PQXWdpsDAGW4oyNxNi9HVs9775ZqW9ynQIYxXmpyV9GsediAoomlAK4KpGIcPt8miH1spS3UJqE6Zn5hOpuZMnGsJnEWES9OH+5zq7srgycIG9jH63LQwbIgLuG9SVdmuvYjDSuVIJtUqWSAvbskc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: potatocomputing.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 33dc39b9-157f-4599-d4c3-08d734f5c76d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 07:17:31.1281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b0e486ce-86f8-410c-aa6d-e814c15cfeb8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6ofZhzKdYkR3cTBR5wZWLb69yf332Zfz6hQlDfptd1fBFBSIWvtiNa9Z8DgLOPUhjOpQy1NXZlQp0k3ZXbjD2QMUCPqy9/hRnveCNTIIYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB1763
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cannot get anything through the filter - another test=
