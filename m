Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721671210DD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLPRGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:34 -0500
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:49121
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726881AbfLPRDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7RzTx+FaQRhnzyeAoRMiKl0Ehy+3dstutNDusyFoABpkFYzWt5J++no2/T4WrJXtD+5hAmrIw2dFD+/l1UG9WYNINGZXGnr5LyZaa/p6n+PoK154Yhp99LE4C+9BSbxCXykKahoJnfC5H7wdpgff+uOx/s5QPgJIAv7hRdVZDq8UTlOFdMoQl3Y9E0/5kpglKpgmbhycbEnZodHv50H1A6ZKgjvqnH1AZ/TZMl7fQFNz5nioNRoBn8HPu9aObXBZPCY5ZGzfmu/ehitUHunY+jJiuV+fAB7MqgtY5Lwcq/NJFh8ZbfYNBTN5Z/Y35EkoUs03xf8E6AsbGvwvSzjYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTVxThjHPp7A2J8r0FnOTY1OMMQuMr5YdLrVCSr3MN8=;
 b=oN7Buq6wxVXF0Jvn3jFa0BEB2O53qXVLjN+JPTGSXWGK48meRycQS3n5JuE4bMKpOKziXUSRUHDOsPMUqPpuoZUT3o2GLEzY61+wbR0arwIgf0SSUxJ7MXtcixoxXl80u4QdfUZYMujQDs8I3OudWwt/fTsR8w39yKaic9jWAohOjQj5ZR5BnOT/Rgzm6MfRXUOProg4kKR5ergl9L7NMgQl5TtMZBYTQu4sWbVcrCnKeUhCwMoGRIOD22damFgDphWLQ4VaC61p2L9fpYDDMQ5fxCR39aIiqmjvd7xR3+Em6WTHu61XjRTYMEGUF7hVc1dj7qClDh7S5vZzsR/vfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTVxThjHPp7A2J8r0FnOTY1OMMQuMr5YdLrVCSr3MN8=;
 b=KKWYwz1hZqoP4npe97UYC5eBq3rdJphhwzuQcyyQ0WD2pN8d/zLn6ACl6rqR1wQEZtQ94aHTUJTXm8IiE8gGO60TxT3JyxS6E1iBWhcOlWMAiiRaX8M3zW8rfqhwgEcQsJZcwsVK4l2hsiaMYR6mr2h7Xc02V+65vx/WJsBvnGg=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:46 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 10/55] staging: wfx: fix wrong error message
Thread-Topic: [PATCH 10/55] staging: wfx: fix wrong error message
Thread-Index: AQHVtDLCZKW4yzlWmUyCoKdTHIB+DA==
Date:   Mon, 16 Dec 2019 17:03:38 +0000
Message-ID: <20191216170302.29543-11-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92979376-5e99-4839-86bf-08d78249e9f8
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4351142D33AF13CBBEB71C9E93510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(4744005)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lJX3Ixp6fpSP91nkY3IquSTq8ORs4QGcMRY1HWBEE7RiOopEzIw+QVa1ITgF/TIHzxusnsMt9mRC/bMK1OAHbqh1BOCLavmpsJcUojvtMqWzfz6yIMqmMgHsb7mpZWNp+5q9Hb6P3PuNzlIdpRUOQOxERYJUvAe1l1vQExYM/usASYIEVvAlBOA6RL9txGUh0aC6VFB4s26omh0GyovzTnnvU2KvEkXETRQtc9DwRDudwGpdWjFBztBPHDybKFZD3UflWZ2NbALJY0MuQxTzcjuGmSyErIs7mEnDMjcMZO9AGCbheZl454SqBG+m/K0Syuvx90WpWjEVUbeytLixlPblAo4ImGLTbzZBCRWvHdJfcFZNF7epon1ztZtVEVucl2E0UNn8j9Qg0bNNBA+4oZLXXMCkyDJwtd7bDmA85K8iEoXUXWLrGjX7RAyspXPy
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD5E3740047EFD4E92F4D14062458320@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92979376-5e99-4839-86bf-08d78249e9f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:38.6242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hXfpOBwBXN/uT7/D3crJ0NrGmFeeCTU0M1lokA7e7rI2GXZWW9wEjhz9YeZTUfm0CMbgk7eRU2su2FVFJ3zYyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgZHJpdmVyIGNoZWNrcyB0aGF0IHRoZSBudW1iZXIgb2YgcmV0cmllcyBtYWRlIGJ5IHRoZSBk
ZXZpY2UgaXMNCmNvaGVyZW50IHdpdGggdGhlIHJhdGUgcG9saWN5LiBIb3dldmVyLCB0aGlzIGNo
ZWNrIG1ha2Ugc2Vuc2Ugb25seSBpZg0KdGhlIGRldmljZSBoYXMgcmV0dXJuZWQgUkVUUllfRVhD
RUVERUQuDQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxs
ZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgNCAr
KystDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYw0KaW5kZXggNzM4YTZjYTVlZGFkLi4zMmUyNjliZWNkNzUgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYw0KKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9kYXRhX3R4LmMNCkBAIC03NDgsNyArNzQ4LDkgQEAgdm9pZCB3ZnhfdHhfY29uZmly
bV9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGhpZl9jbmZfdHggKmFyZykNCiAJCXJh
dGUgPSAmdHhfaW5mby0+c3RhdHVzLnJhdGVzW2ldOw0KIAkJaWYgKHJhdGUtPmlkeCA8IDApDQog
CQkJYnJlYWs7DQotCQlpZiAodHhfY291bnQgPCByYXRlLT5jb3VudCAmJiBhcmctPnN0YXR1cyAm
JiBhcmctPmFja19mYWlsdXJlcykNCisJCWlmICh0eF9jb3VudCA8IHJhdGUtPmNvdW50ICYmDQor
CQkgICAgYXJnLT5zdGF0dXMgPT0gSElGX1NUQVRVU19SRVRSWV9FWENFRURFRCAmJg0KKwkJICAg
IGFyZy0+YWNrX2ZhaWx1cmVzKQ0KIAkJCWRldl9kYmcod3ZpZi0+d2Rldi0+ZGV2LCAiYWxsIHJl
dHJpZXMgd2VyZSBub3QgY29uc3VtZWQ6ICVkICE9ICVkXG4iLA0KIAkJCQlyYXRlLT5jb3VudCwg
dHhfY291bnQpOw0KIAkJaWYgKHR4X2NvdW50IDw9IHJhdGUtPmNvdW50ICYmIHR4X2NvdW50ICYm
DQotLSANCjIuMjAuMQ0K
