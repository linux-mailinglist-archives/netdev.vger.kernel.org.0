Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E717A56947
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfFZMfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:35:41 -0400
Received: from mail-eopbgr720066.outbound.protection.outlook.com ([40.107.72.66]:27744
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727518AbfFZMfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJN5ryjYPQRi1zEXJjp/Hrg/d4NMwP5zgSUjG308r7k=;
 b=fgO8/b1Xo1LhcbDVoKNtNYh1Ud0OrlE4wIx3YpkchoEY4mDMbRjPXC5y/a0WksUSTERClaQCa1bqNc75p5kJUqg3vavE+VBQlRoqLFEwGW+wRXTCKeZDU+1OQbOZjGfiYj8+pTRnxyMVxDLjLetGNwipTfZOXY0svuW2t32ZLJU=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1535.namprd11.prod.outlook.com (10.172.54.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 12:35:37 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 12:35:37 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v3 3/8] maintainers: declare aquantia atlantic driver
 maintenance
Thread-Topic: [PATCH net-next v3 3/8] maintainers: declare aquantia atlantic
 driver maintenance
Thread-Index: AQHVLBuoGtQq5680D06I7SicweHaiA==
Date:   Wed, 26 Jun 2019 12:35:37 +0000
Message-ID: <ed116f825cf258ac11e2c539793e31c91ea40759.1561552290.git.igor.russkikh@aquantia.com>
References: <cover.1561552290.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561552290.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:7:16::14) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a53c8e90-0804-433e-e43c-08d6fa32ca79
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1535;
x-ms-traffictypediagnostic: MWHPR11MB1535:
x-microsoft-antispam-prvs: <MWHPR11MB1535046E54402FF65B5A20A898E20@MWHPR11MB1535.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(39850400004)(366004)(199004)(189003)(86362001)(25786009)(6486002)(102836004)(6436002)(72206003)(6116002)(66066001)(3846002)(386003)(5660300002)(36756003)(53936002)(478600001)(2906002)(305945005)(7736002)(6512007)(66446008)(73956011)(66556008)(66476007)(64756008)(66946007)(4744005)(26005)(118296001)(186003)(71190400001)(256004)(71200400001)(99286004)(6306002)(446003)(4326008)(11346002)(54906003)(2616005)(50226002)(476003)(14454004)(316002)(486006)(6506007)(6916009)(68736007)(8936002)(81166006)(81156014)(52116002)(107886003)(44832011)(8676002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1535;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SaY0Pv7bMSkXRSCi4vRXCb4ib0oMdkyYl3fEUhR0jL2alZefpLNGWjNHG3FdcCOwQNx5NDx3UaIxJb934+9Nv/N0/z0Yj6tzd77NT+Ki+MypQjdTHB+SEw2zbZIPVxuOq5FYxsOQ3p/mmU8CudsqLsbB7F0GGSDO0p/VoHcUmQVM4ulWKemhAge5ndGWyQlpWl5QJ6n2gHYI0qZSg/Vvd6MWDZitK0NKxJJDPRwjmFQjq0Ffvnf8hiRzjeDB07TzgUmYHI4QsQp+VS7kv27p+Rdk4wW+M+UdC6levZt8d/2WmnIR1mhPaoVmoqvFLIY9MHHdI9abI3fdOEeRp0x8hYsaYy6ojhFq9hzUhXDsuvX+j30Jy32k5/tad4veU+oxWbU9r0xFb3XeEZsMpjMlMBrBqWYQzu9xM/gPsP3GcGE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a53c8e90-0804-433e-e43c-08d6fa32ca79
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 12:35:37.7773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1535
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXF1YW50aWEgaXMgcmVzcG9zaWJsZSBub3cgZm9yIGFsbCBuZXcgZmVhdHVyZXMgYW5kIGJ1Z2Zp
eGVzLg0KUmVmbGVjdCB0aGF0IGluIE1BSU5UQUlORVJTLg0KDQpTaWduZWQtb2ZmLWJ5OiBJZ29y
IFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NClJldmlld2VkLWJ5OiBBbmRy
ZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQotLS0NCiBNQUlOVEFJTkVSUyB8IDkgKysrKysrKysr
DQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvTUFJTlRB
SU5FUlMgYi9NQUlOVEFJTkVSUw0KaW5kZXggNjA2ZDFmODBiYzQ5Li44MmY3NjJkZGJlN2EgMTAw
NjQ0DQotLS0gYS9NQUlOVEFJTkVSUw0KKysrIGIvTUFJTlRBSU5FUlMNCkBAIC0xMTQwLDYgKzEx
NDAsMTUgQEAgTDoJbGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnDQogUzoJTWFpbnRhaW5lZA0K
IEY6CWRyaXZlcnMvbWVkaWEvaTJjL2FwdGluYS1wbGwuKg0KIA0KK0FRVUFOVElBIEVUSEVSTkVU
IERSSVZFUiAoYXRsYW50aWMpDQorTToJSWdvciBSdXNza2lraCA8aWdvci5ydXNza2lraEBhcXVh
bnRpYS5jb20+DQorTDoJbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KK1M6CVN1cHBvcnRlZA0KK1c6
CWh0dHA6Ly93d3cuYXF1YW50aWEuY29tDQorUToJaHR0cDovL3BhdGNod29yay5vemxhYnMub3Jn
L3Byb2plY3QvbmV0ZGV2L2xpc3QvDQorRjoJZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEv
YXRsYW50aWMvDQorRjoJRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmljZV9kcml2ZXJzL2Fx
dWFudGlhL2F0bGFudGljLnR4dA0KKw0KIEFSQyBGUkFNRUJVRkZFUiBEUklWRVINCiBNOglKYXlh
IEt1bWFyIDxqYXlhbGtAaW50d29ya3MuYml6Pg0KIFM6CU1haW50YWluZWQNCi0tIA0KMi4xNy4x
DQoNCg==
