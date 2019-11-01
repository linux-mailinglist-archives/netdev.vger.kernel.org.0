Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979C8EC523
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfKAOzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:55:38 -0400
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:12866
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727334AbfKAOzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 10:55:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k29hxXWXATXJfevysRj6WwU6aUmr4JLBd1nAHioSmpeAmS0EiJc9drnoLUfqndXiJ9IwDqlg/98lptwCTzfbYVkspAP2Fbd1ZFaBc0Jp9/gWVK/S/JWl1zSob+faDBRYs7HaJxINWzLVkaYZpU3fWtDE+oOxA+AShKfY8BgL9HQ8jSXMdu8UAvzW6mzyOE6HslKy/4wwGeBK74+iSG6ymF+Mm8dZngF2jyaWlL49bL9F64frh9Tx8zOf9Vz2EeA1hXgoifHygOsxPmEdPRVSmOtY9HvBzpwEjtVpceaZtnLZH8u7/roh1qY6hPjSSJcAkV7s+9kyY/GkcJmeheI5cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WljdqIIFgAXxSLqQ1wUSOFkfvG/TYMu2I9TEWFfPf10=;
 b=TnTefNkfXDC3/WYfRX2M4IJ2jtcjodGDGqJPbLtxIIaUCfemDIQbQGFh0SMsUew5ujGmsc1bVqDc4NnutoqzUEGTZit9x8O3O0IXXZeUfTPQIop4fZ0IYsPvSNCmMz/VFXlX+ZFSDMvrRjB4PN2Drnv7BKAATu3GfbpnIVcESTYSauPkpJTfjaX/i3MjkJl0+iAlYEeG+Hnfew1pEWmgmx7JVa1rsvhRSlDD3BNHANA6xmW8uaAu0dEPKnTjUmeR73KvlPt/qWH3pKTbbIlSgJE7Ttzzj0etsCOwfh5XV6lrgz0WNWd8JkQRWkDSFW11Kd8OkJ3NcekCcBgLbF3nMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WljdqIIFgAXxSLqQ1wUSOFkfvG/TYMu2I9TEWFfPf10=;
 b=qd6Ly/17mACxZWV/U1s84YOLftgrbAbwsEFSVNYriJz5vhbL6xe8284xHe+iPvYVv5I0srX1uGPcbdbhhKYKHhSxfmYvjzBF74ks7DilsH9hF1BI+SaBhofW77iMYGrVzc9dzybUR74T/68PpvpXVkf+4jg0D76fessgXVTiQzk=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3329.eurprd05.prod.outlook.com (10.171.189.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Fri, 1 Nov 2019 14:55:32 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 14:55:32 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1M/EA///bpACAAE2sAIABC0aA
Date:   Fri, 1 Nov 2019 14:55:32 +0000
Message-ID: <5ff9d99c-cf23-853d-06cd-80a3ed042b5b@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
 <20191031.133102.2235634960268789909.davem@davemloft.net>
 <74DE7158-E844-4CCD-9827-D0A5C59F8B32@mellanox.com>
 <20191031.155854.590623922622551708.davem@davemloft.net>
In-Reply-To: <20191031.155854.590623922622551708.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-originating-ip: [2604:2000:1342:488:c00e:ff58:82bb:ebf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ff8e2ccf-26c0-4f13-5325-08d75edb8b7c
x-ms-traffictypediagnostic: AM4PR05MB3329:|AM4PR05MB3329:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB33297B6C2A31E5144993A79EBA620@AM4PR05MB3329.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(8936002)(31686004)(4326008)(54906003)(6916009)(316002)(256004)(478600001)(71190400001)(6512007)(71200400001)(76176011)(25786009)(186003)(6116002)(14454004)(6486002)(99286004)(5660300002)(6506007)(53546011)(102836004)(6436002)(6246003)(305945005)(2616005)(476003)(81156014)(36756003)(446003)(76116006)(64756008)(66476007)(66556008)(91956017)(81166006)(2906002)(8676002)(31696002)(86362001)(486006)(66946007)(4744005)(11346002)(7736002)(46003)(229853002)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3329;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Z6PZckyj9eunt+YVlq32sIvjyIcEv84YXGYzi4A6cQ7we0kjurYEJ989q1jk6VDl81Z73Qg25hIoKZZkOGoEHN3enXyusBGdxhU0XNMtkOWx4fKAETQKagypmDZanaBkIIwDOQILeOquRsx3yix3nsGprPXXnF5LoxvSIAxl/Vw6dYWJHLKjOMAM9r+jXcnRa61IysaKr6c52uQ3WU/axWvqonMq+p1oQLSuIKMQV05XgQXGpQrNZg3jDypMZ7DMuqn6MJBbVBHiv8pCdPtitCwC8S39hqwW5GstFisdK7OgvY+sAO2NkYzYuaEWJxSX5ASghlVKb444N/IKBskC9wfYExCneBgghho8rM4fs4HRj6RdX05nBRYC/1HVekSevoQlxm39M2eqivCaYNB0ZFxtjo6oT6T/WPepdooneT0dXBGc957FtAeWS54l3nw
Content-Type: text/plain; charset="utf-8"
Content-ID: <55D95BF944C46E4F8CA43E1A98883B65@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff8e2ccf-26c0-4f13-5325-08d75edb8b7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 14:55:32.6394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B3puI0ONSZIK54Ilqjbkx8AV+91rgOOJLBiG0vAOCc5DhfOeMtVkRh/VocS9qgIoMBuwtsm8Yknxl3XgZm0brA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3329
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMzEvMTkgNjo1OCBQTSwgIkRhdmlkIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
IHdyb3RlOg0KPiBGcm9tOiBBcmllbCBMZXZrb3ZpY2ggPGxhcmllbEBtZWxsYW5veC5jb20+DQo+
IERhdGU6IFRodSwgMzEgT2N0IDIwMTkgMjI6MjA6NTUgKzAwMDANCj4NCj4+DQo+PiDvu79PbiAx
MC8zMS8xOSwgNDozMSBQTSwgIkRhdmlkIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+IHdy
b3RlOg0KPj4NCj4+ICAgICAgDQo+Pj4gICAgIFRoZSBwcmV2aW91cyBwb3N0ZWQgdmVyc2lvbiB3
YXMgYWxzbyB2Miwgd2hhdCBhcmUgeW91IGRvaW5nPw0KPj4gSSByZXN0YXJ0ZWQgdGhpcyBzZXJp
ZXMgc2luY2UgbXkgZmlyc3Qgc3VibWlzc2lvbiBoYWQgYSBtaXN0YWtlIGluIHRoZSBzdWJqZWN0
IHByZWZpeC4NCj4+IFRoaXMgaXMgdGhlIDJuZCB2ZXJzaW9uIG9mIHRoYXQgbmV3IHN1Ym1pc3Np
b24gd2hpbGUgcHJldmlvdXMgaGFzIGEgZGlmZmVyZW50IHN1YmplY3QNCj4+IGFuZCBjYW4gYmUg
aWdub3JlZC4NCj4gQWx3YXlzIGluY3JlbWVudCB0aGUgdmVyc2lvbiBudW1iZXIgd2hlbiB5b3Ug
cG9zdCBhIHBhdGNoIHNlcmllcyBhbmV3Lg0KPg0KPiBPdGhlcndpc2UgaXQgaXMgYW1iaWd1b3Vz
IHRvIG1lIHdoaWNoIG9uZSBpcyB0aGUgbGF0ZXN0Lg0KDQoNClVuZGVyc3Rvb2QuIFdpbGwgbWFr
ZSBzdXJlIG9mIHRoYXQuDQoNCg0K
