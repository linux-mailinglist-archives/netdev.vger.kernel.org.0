Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEA116F659
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 05:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgBZEKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 23:10:30 -0500
Received: from mail-db8eur05on2127.outbound.protection.outlook.com ([40.107.20.127]:38016
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbgBZEKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 23:10:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNppJYd+eJwmgTAqWRXHmDp51N78uuRIzMnudnCz38P2WhAqLemQPet3wJSQSEcNrtqh/0/ODXLuS+GC441f6nqk/oz3Ni8tRtBiROJSOxeq/Ey5B5b3h0WC6fTvBJDG/6VMAg4JXc6XXdz52xzXQ5NwoHLmfRuf2iQNbjlfUMkPQEbG4p/qGNzZHs9ycmB5dHiHG94altve2BURpZ5qWS3lKhBrvyK1mFcqCt8ese3O8oiBubGdR5qcplEivizJ6HAEBXxAS/g7AuhHfs8j4cu/zZW13PopOS2WoM6rGyBFB5LQmDZZR+KRuwhCJkb8BK3xFMM/13N8SGJeko4LyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvnE5WsA6piUIFvpnnnJpu1UfMUKeuT/IDqN94wEOD8=;
 b=GtaGKDvuR2GWO/Z0h/LBP++XHV0wZDvQuR4wriXGTLkXvE2a/Pp78KD9MCgCMADqC6Mc3Qtn7FrGfCarXaUvPiZnFMyd2sZ33NaE0amzADJljJJr1nWtBzx24EjvCEb+bNi7iWVl9YZoLUM2ElfmhLIMC+iVTfPvG9ega6XyfErGUHCzHT7/l2IxJUzuX4C7/E2adXhTU1bOE6V11DyHCLZ2oVyamj655TZq65pgLrmSrzjzuHD81hU7YsLUG7nhEB9OKXSBvXPESH/5UZ22T0uS1xTrfggyw0vWNVQ+Yk+EjlQTjfENLafrIWTsOx+Nq/bi+yyvzM5AT2h8gRPeaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvnE5WsA6piUIFvpnnnJpu1UfMUKeuT/IDqN94wEOD8=;
 b=AvjiEhmgOYMVyZ/xZRiJh64D2IkHVCxWyPrJ733a40+lWKIKRrHNjXv8p0Ztsaq3eNpR7XLDJERPpfRkAy7LSMKWFUwjy5VaeJZsoJw7ExMC2YbvyMkAD2nNrKXSvB2Tc5vptxJIwxeJbKV2Yi+0p5PkL/TFQePd7nEww9ECl8s=
Received: from DB6PR07MB4408.eurprd07.prod.outlook.com (10.168.24.141) by
 DB6PR07MB3352.eurprd07.prod.outlook.com (10.170.221.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.10; Wed, 26 Feb 2020 04:10:27 +0000
Received: from DB6PR07MB4408.eurprd07.prod.outlook.com
 ([fe80::d40c:1a36:d897:dd7b]) by DB6PR07MB4408.eurprd07.prod.outlook.com
 ([fe80::d40c:1a36:d897:dd7b%2]) with mapi id 15.20.2772.010; Wed, 26 Feb 2020
 04:10:27 +0000
From:   "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
To:     Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: net: UDP tunnel encapsulation module for tunnelling different
Thread-Topic: net: UDP tunnel encapsulation module for tunnelling different
Thread-Index: AQHV7DAG/YBMQAKwCkurzWA3QrmewKgs3Lzg
Date:   Wed, 26 Feb 2020 04:10:27 +0000
Message-ID: <DB6PR07MB440868B87E97D30584E315EFEDEA0@DB6PR07MB4408.eurprd07.prod.outlook.com>
References: <6a8cabb8-e371-d119-c2e6-d495eca016b7@canonical.com>
In-Reply-To: <6a8cabb8-e371-d119-c2e6-d495eca016b7@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=martin.varghese@nokia.com; 
x-originating-ip: [131.228.69.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10c680bf-e6f2-46cf-1e1b-08d7ba71cf92
x-ms-traffictypediagnostic: DB6PR07MB3352:
x-microsoft-antispam-prvs: <DB6PR07MB3352F5B436E1271E61EC75ECEDEA0@DB6PR07MB3352.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:343;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(189003)(199004)(6506007)(53546011)(71200400001)(316002)(110136005)(66946007)(66476007)(66556008)(4326008)(64756008)(76116006)(81166006)(66446008)(5660300002)(8936002)(33656002)(7696005)(52536014)(81156014)(8676002)(186003)(86362001)(478600001)(55016002)(26005)(9686003)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB6PR07MB3352;H:DB6PR07MB4408.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 38VgDBWI501SSKlcKOOdnD8H8HhkrKXdwsnDZnTijD8f9uBXjHA0wVmJL0t58L6x/ZUjilLv+M33P/m44LkmsZjQOxxCFzg8VtvrAzhSZM7+YMmsDuQTaUKYh/Mes4QNniAr4qF1GM8/SgoyDyNcj+L34bj0slAqSy/zygJ6FAvWZCs/0oql3yYH/d3TnMZdlE9UvbbFXP5mQQxbAmmLl6o6/+KAOarBWb16vos2jRKrFcihVjetvJTcuSk3ZqO2VpiSnFHxNKuQO0OlEngaq8zPsUPq0o/CFvGyGUTq46HMSjsElzYPtNOqpwxvS4OxaYXQHP49fCoSCn1W4vwhblMWBj9Gb6OwmrhhRV1/w+srY0JUvTal0UFCoibf5se9hLKGo2Y06IcLbV458qwMCHSUKTf8mzZVyAOiGIwijr/sMMjNi+KchtHXPLzMbsRq
x-ms-exchange-antispam-messagedata: 0rlPoptZiE+ss6CW9Vk926qAxPILgVd93KYK1IFKaK2000C4c+yYxikc/YGIJMnvlcCeNwLUSzCfD+9YVaR1kJiROADo4GPR9BuxWrXk3sy7e3d0RlSiuipEUFYnFfQayKTz6KiO6YQ35Adso8715w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c680bf-e6f2-46cf-1e1b-08d7ba71cf92
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2020 04:10:27.1765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7RfTPlAe8Y5Jb3WQWcCRogCUXHXWSKdeVAiN4qs8rO1VtBwVmNUVcy/JF7dPzqYhg7wlzErylSBZtmHafRLss6R5EMDX/5tDuJPK58LguMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR07MB3352
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEkgQ29saW4NCg0KRGF2aWQgaGFkIGZpeGVkIHRoaXMgaXNzdWUgaW4gdGhlIGJlbG93IGNvbW1p
dC4NCg0KYzEwMmI2ZiBiYXJldWRwOiBGaXggdW5pbml0aWFsaXplZCB2YXJpYWJsZSB3YXJuaW5n
cy4NCg0KUmVnYXJkcywNCk1hcnRpbg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJv
bTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4gDQpTZW50OiBXZWRu
ZXNkYXksIEZlYnJ1YXJ5IDI2LCAyMDIwIDQ6MzUgQU0NClRvOiBWYXJnaGVzZSwgTWFydGluIChO
b2tpYSAtIElOL0JhbmdhbG9yZSkgPG1hcnRpbi52YXJnaGVzZUBub2tpYS5jb20+OyBEYXZpZCBT
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJu
ZWwub3JnPjsgQWxleGV5IEt1em5ldHNvdiA8a3V6bmV0QG1zMi5pbnIuYWMucnU+OyBIaWRlYWtp
IFlPU0hJRlVKSSA8eW9zaGZ1amlAbGludXgtaXB2Ni5vcmc+OyBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnDQpDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogcmU6IG5ldDog
VURQIHR1bm5lbCBlbmNhcHN1bGF0aW9uIG1vZHVsZSBmb3IgdHVubmVsbGluZyBkaWZmZXJlbnQN
Cg0KSGksDQoNClN0YXRpYyBhbmFseXNpcyB3aXRoIENvdmVyaXR5IGRldGVjdGVkIGFuIGlzc3Vl
IGluIGZ1bmN0aW9uIGJhcmV1ZHBfeG1pdF9za2Igd2l0aCB0aGUgcmV0dXJuIG9mIGFuIHVuaW5p
dGlhbGl6ZWQgdmFsdWUgaW4gdmFyaWFibGUgZXJyIGluIHRoZSBmb2xsb3dpbmcgY29tbWl0Og0K
DQpjb21taXQgNTcxOTEyYzY5ZjBlZDczMWJkMWUwNzFhZGU5ZGM3Y2E0YWE1MjA2NQ0KQXV0aG9y
OiBNYXJ0aW4gVmFyZ2hlc2UgPG1hcnRpbi52YXJnaGVzZUBub2tpYS5jb20+DQpEYXRlOiAgIE1v
biBGZWIgMjQgMTA6NTc6NTAgMjAyMCArMDUzMA0KDQogICAgbmV0OiBVRFAgdHVubmVsIGVuY2Fw
c3VsYXRpb24gbW9kdWxlIGZvciB0dW5uZWxsaW5nIGRpZmZlcmVudCBwcm90b2NvbHMgbGlrZSBN
UExTLCBJUCwgTlNIIGV0Yy4NCg0KVGhlIGFuYWx5c2lzIGlzIGFzIGZvbGxvd3M6DQoNCnZhcl9k
ZWNsOiBEZWNsYXJpbmcgdmFyaWFibGUgZXJyIHdpdGhvdXQgaW5pdGlhbGl6ZXIuDQoNCjMwMSAg
ICAgICAgaW50IGVycjsNCjMwMg0KDQouLi4NCg0KMzQ0IGZyZWVfZHN0Og0KMzQ1ICAgICAgICBk
c3RfcmVsZWFzZSgmcnQtPmRzdCk7DQoNClVuaW5pdGlhbGl6ZWQgc2NhbGFyIHZhcmlhYmxlIChV
TklOSVQpDQp1bmluaXRfdXNlOiBVc2luZyB1bmluaXRpYWxpemVkIHZhbHVlIGVyci4NCg0KMzQ2
ICAgICAgICByZXR1cm4gZXJyOw0KMzQ3IH0NCg0KYW5kIGFsc28gaW4gZnVuY3Rpb24gYmFyZXVk
cDZfeG1pdF9za2I6DQoNCnZhcl9kZWNsOiBEZWNsYXJpbmcgdmFyaWFibGUgZXJyIHdpdGhvdXQg
aW5pdGlhbGl6ZXIuDQoNCjM2NCAgICAgICAgaW50IGVycjsNCjM2NQ0KDQouLi4NCg0KNDA0DQo0
MDUgZnJlZV9kc3Q6DQo0MDYgICAgICAgIGRzdF9yZWxlYXNlKGRzdCk7DQoNClVuaW5pdGlhbGl6
ZWQgc2NhbGFyIHZhcmlhYmxlIChVTklOSVQpDQp1bmluaXRfdXNlOiBVc2luZyB1bmluaXRpYWxp
emVkIHZhbHVlIGVyci4NCg0KNDA3ICAgICAgICByZXR1cm4gZXJyOw0KNDA4IH0NCg0KQ29saW4N
Cg==
