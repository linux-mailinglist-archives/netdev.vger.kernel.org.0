Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C8EE7C46
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfJ1WY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:24:59 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:42660
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfJ1WY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 18:24:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irXl96XIEb5rZJhnLsHJdqo/s9EQMqiVq5Jkfep8vmO4eC86MF3z4ZS4NQrtoWtRzDMUmHu18dScgQWk0Szch163uTNeBwU3AnP47hQbmynQSQn35FyUb1lpnWXyaGZhLybCQXkD34emPRW5PbsaOWDq5R/buLT6lhikcjWR82y/ZZU4q2BWZL/HxxRg8Oo5bCnW7G3FOZPDT0AROSJqZ09SfrEGwZ7wUNW+cXpxlLTlIkiO1BM1iE3TPgYg1c+aXArbH26w+NpGI/gwVav62SqxwbS/qxCQ3Rq1MU1YE8CNZZ3sqNFOIQ/zXLbsk28jI4YUSNlxLqojATFbiNVbdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdz54+G8iWBgC0A7s+hLxs8iH5+LveLakXUOCPnmFuw=;
 b=PIJSbOGnu9m9OXIbVSJl+upJrzBhfRxLPTa9TKc2it5h9RxCUIFQdKQ0MfMzT389q1UaqfGO/CZyseRpRCr3mAySfx+S8kUS1Cjl9qSw4S7Xe2E6v9lLHYKFemkHpb8USuN8TMEUGndDYm+2yBNe4BBz0zFZrtLWLu5KAPwouu7c7bKXj2+aXHeposj2sdTGxVAMgqFIBqmKRp6jlOgTGl7tvRfVwdhnRQ9gggexgYgioV/yooe+G94Tlxd2NsiVxscX3jznmzlQwP6+l8isJ2JkHC6MKxyve7mgzVvFm3Ulm4gve16TUAuLa67CXcmEHU5yUA3PH6z7O1rctpnOiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdz54+G8iWBgC0A7s+hLxs8iH5+LveLakXUOCPnmFuw=;
 b=nHBLLmLgeAw6K0+CeyDdVACAAG0wi3nmyoIxlNTnInsZJ9rIuWyqqYBXuY3DpSKL3BMCATUjYHGwRU+7WrhlKgGtFfmVWY3eHeutylRLodE/+/ZuGcVLHHD+O81qVeFOZ71DS8CFHGVF99Fyv03BLf1DX0nvOIn7pBrVMPpYnuI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3197.eurprd05.prod.outlook.com (10.170.239.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 22:24:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 22:24:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        Li Rongqing <lirongqing@baidu.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH][net-next] net/mlx5: rate limit alloc_ent error messages
Thread-Topic: [PATCH][net-next] net/mlx5: rate limit alloc_ent error messages
Thread-Index: AQHVikSMOg43rHdSRUi/KFNF8UE98qdwic8AgAAesAA=
Date:   Mon, 28 Oct 2019 22:24:54 +0000
Message-ID: <79ff25f57f6616ee5dfdfe75010d83cf8f43f031.camel@mellanox.com>
References: <1571905413-28405-1-git-send-email-lirongqing@baidu.com>
         <20191028.133502.1532748858682850578.davem@davemloft.net>
In-Reply-To: <20191028.133502.1532748858682850578.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 959791cf-5d41-4ea3-4750-08d75bf5a885
x-ms-traffictypediagnostic: VI1PR05MB3197:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB3197B2535F667590CDC812CABE660@VI1PR05MB3197.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(189003)(199004)(118296001)(6436002)(4001150100001)(54906003)(446003)(476003)(110136005)(11346002)(2616005)(26005)(229853002)(71190400001)(486006)(71200400001)(6486002)(76176011)(91956017)(6506007)(99286004)(186003)(102836004)(478600001)(76116006)(3846002)(316002)(6116002)(14454004)(6512007)(15650500001)(66946007)(5660300002)(66446008)(36756003)(86362001)(64756008)(66556008)(66476007)(256004)(8676002)(2501003)(25786009)(6246003)(81166006)(81156014)(4326008)(58126008)(2906002)(8936002)(66066001)(7736002)(305945005)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3197;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u9LuBg+bMsPRE/lTaQuIlv1YqznPg4OMzV4lLvVLZPqIstL6SPr2SNpU2WPlT7gx0kDbdFHaoJ1WW8PbIjLPsZottxRd+VF65VxZi0dj3KyGFWwOabbP4p4Rujz3JSUrlIQbEb1cwDYrq8ESFRxESoh9FnCF5pFMHXYS/9JGXgjhpV9Ztg3irC2lL5lN+VTVVep5A8yvL6imhgZTWF5GgPjCGlsTjtaeag4zigc8g8rk0Zqrb+4FvwcIQ7nrDb9T1LcfCKpSUNXGD0x8i9XRxZuj14GOjvuFc6f0bjkks2Ilgauhxn6CqFsp55RL6RxVVfAWpENRHOrW/Jx4uAtfiUfOvfo7MmTZO0ROPsYWs8cBNf2+TnrDDcSJD2kh6J3x8aq0e7eYqJGPXyC+FBfhOX2+iC6UKJ/Zml2axt67tLNmRk3yxUjnsPEOXc1Y8hTH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F17D805171D9A445BF8826E73EAF7320@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959791cf-5d41-4ea3-4750-08d75bf5a885
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 22:24:54.7467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jC/gN2Pl1CF7hs/d11RgeyMgrOseySY3761e1DQWyotEhkNL0lFDFqGGWKruU4vyRp9Zu8EjfrAHgoNU7laf3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTEwLTI4IGF0IDEzOjM1IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gRGF0ZTogVGh1LCAy
NCBPY3QgMjAxOSAxNjoyMzozMyArMDgwMA0KPiANCj4gPiB3aGVuIGRlYnVnIGEgYnVnLCB3aGlj
aCB0cmlnZ2VycyBUWCBoYW5nLCBhbmQga2VybmVsIGxvZyBpcw0KPiA+IHNwYW1tZWQgd2l0aCB0
aGUgZm9sbG93aW5nIGluZm8gbWVzc2FnZQ0KPiA+IA0KPiA+ICAgICBbIDExNzIuMDQ0NzY0XSBt
bHg1X2NvcmUgMDAwMDoyMTowMC4wOg0KPiBjbWRfd29ya19oYW5kbGVyOjkzMDoocGlkIDgpOg0K
PiA+ICAgICBmYWlsZWQgdG8gYWxsb2NhdGUgY29tbWFuZCBlbnRyeQ0KPiA+IA0KPiA+IFNpZ25l
ZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gDQo+IFNhZWVk
LCBwbGVhc2UgcGljayB0aGlzIHVwIGlmIHlvdSBoYXZlbid0IGFscmVhZHkuDQo+IA0KPiBUaGFu
ayB5b3UuDQoNClNvcnJ5IGZvciB0aGUgZGVsYXlzLCBhcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUs
IHdpbGwgYmUgc3VibWl0dGVkIHRvDQpuZXQtbmV4dCBzaG9ydGx5Lg0K
