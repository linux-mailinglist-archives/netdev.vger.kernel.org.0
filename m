Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2142A3D2
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEYJ6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:58:01 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:59488
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbfEYJ6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 05:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXPtL5e07CvX31WZV1ram03soXeE67IDT1vJBBKHO18=;
 b=QBaZYCg47T+rFXwXJXrN5E/CG9KiSLyjODRNwiBOuE/+tzgLXHLkq4t9Z2eH3xFfXfLvgxyE4mCNM4kp4h6S/wVx3RDMn95UGDMiRbgD163lkGF2WRe//NQ7ANfrOOOFMxXwKQNEwNETFrpeofMEZ9QAgKxR0qSRmstNymJWmm0=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3017.namprd11.prod.outlook.com (20.177.218.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Sat, 25 May 2019 09:57:57 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1922.021; Sat, 25 May 2019
 09:57:57 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 0/4] net: aquantia: various fixes May, 2019
Thread-Topic: [PATCH net 0/4] net: aquantia: various fixes May, 2019
Thread-Index: AQHVEuBU64JvVLbAiU+hB1gFafjCnw==
Date:   Sat, 25 May 2019 09:57:57 +0000
Message-ID: <cover.1558777421.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0009.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:bc::19)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b18e668e-3565-4cb1-d924-08d6e0f77647
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR11MB3017;
x-ms-traffictypediagnostic: DM6PR11MB3017:
x-microsoft-antispam-prvs: <DM6PR11MB30171FDFFCB0F64C909ECA6298030@DM6PR11MB3017.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39850400004)(199004)(189003)(66946007)(71190400001)(486006)(53936002)(66476007)(2616005)(44832011)(71200400001)(66556008)(107886003)(66446008)(73956011)(64756008)(7736002)(6916009)(14454004)(478600001)(316002)(25786009)(6436002)(72206003)(6512007)(6486002)(386003)(36756003)(3846002)(4326008)(305945005)(52116002)(6506007)(186003)(26005)(2906002)(99286004)(14444005)(476003)(102836004)(256004)(86362001)(5660300002)(54906003)(66066001)(68736007)(81156014)(8676002)(81166006)(50226002)(8936002)(4744005)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3017;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cnmGDKY57VftYdnnpE9x+3XJlG75VbJbabTgJO49VcPQfd/B8DVncSIxoIYcBtm2AkJmRl3Ytl9fYiwo8WbR9f0eiPJ25IdU8W/lzkgH81Id2yXw9xzzt5wKHhl4nCTuy/zv0908M8T4oFw5a8YixOevuhsNRU2q5RaRgZdWfBMRYlgWsrH7Fd760OGGgJ94zyiJv9gIlEuCdeKVDoveiALpWRhAw1LCaeDPyLK1b6M7+sAUX3a1qQ9OUWGnkXw5ye/eCCo3w5oiTLbMHmw99OTa193ud3NGULVI4LFyiYsvjJXH9b0VdFKbppmqrellOlsWVFJRMsmMYfUBr56RqslKkq9CNN2+Goki+5MeYtnrwQruf9SNSzwr4amZfdgcy+t8J7bMKyrR+EPkm0d9r6c/SsBBiAKUcENtT3PixlU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18e668e-3565-4cb1-d924-08d6e0f77647
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 09:57:57.0904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVyZSBpcyBhIHNldCBvZiB2YXJpb3VzIGJ1ZyBmaXhlcyBmb3VuZCBvbiByZWNlbnQgdmVyaWZp
Y2F0aW9uIHN0YWdlLg0KDQoNCkRtaXRyeSBCb2dkYW5vdiAoMik6DQogIG5ldDogYXF1YW50aWE6
IGNoZWNrIHJ4IGNzdW0gZm9yIGFsbCBwYWNrZXRzIGluIExSTyBzZXNzaW9uDQogIG5ldDogYXF1
YW50aWE6IGZpeCBMUk8gd2l0aCBGQ1MgZXJyb3INCg0KSWdvciBSdXNza2lraCAoMSk6DQogIG5l
dDogYXF1YW50aWE6IHR4IGNsZWFuIGJ1ZGdldCBsb2dpYyBlcnJvcg0KDQpOaWtpdGEgRGFuaWxv
diAoMSk6DQogIG5ldDogYXF1YW50aWE6IHRjcCBjaGVja3N1bSAweGZmZmYgYmVpbmcgaGFuZGxl
ZCBpbmNvcnJlY3RseQ0KDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9y
aW5nLmMgIHwgNTEgKysrKysrKysrKy0tLS0tDQogLi4uL2FxdWFudGlhL2F0bGFudGljL2h3X2F0
bC9od19hdGxfYjAuYyAgICAgIHwgNjQgKysrKysrKysrKy0tLS0tLS0tLQ0KIDIgZmlsZXMgY2hh
bmdlZCwgNjggaW5zZXJ0aW9ucygrKSwgNDcgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xNy4xDQoN
Cg==
