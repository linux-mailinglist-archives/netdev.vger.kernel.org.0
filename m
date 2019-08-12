Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A4089918
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfHLI5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:57:52 -0400
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:8709
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727167AbfHLI5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 04:57:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LphOiNyo2DSYpFIoSBWCsL3YqJjbhin/+/R+whzV1Hj6tlBh6epPZG90vLN8637ttzyW5foDTw9utNiL36yxmRYtC/jkLTmNqduQH8asJhE0c2efdAfxJzbt8vh0UBHsV0Rh8e8g+jwIbCZJIH8sSlL1M/YQjzmawm4hq68X5SrV5f3j72c77oQjD1+tS+sQuFKl6spsfx7L6eLhqHrieftVUBy3Hx3RBdQc9kzfNRj3AZhNKGCnsAUTzgF2Cn4T/rAycRVNg2dqT/6937eWduS0i2d947j9jInqdzPBVT7BoKsqnudFSas+syqxBsV0W53e+rh7siqUKHs4UI6Bmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smPCEycziKfuu9p9AClU3RWN9/MpgH75j1TR75EDibg=;
 b=mJdlwJ8juvtihS9SMMj7BzUryZxjkYhh7YqNEFb5/TNGjP3JNFW4tHTYEFIF6DurZNhi/ykLp1vFVhUWsJ2dhWNGbzlLvCyNzRgXzEh0I+Ap7wpBzPoIsJH9FlEssaXhkyj4r6W3BpBItKo7BU7WHDVJs4mq+9VQf6DKw2Kt4cSmlsfzTn0mXK1ztfQ6x9ZAy6c/YkpzvllMqG2eQg4hT5VqmKvOcFMaFPc10j+V68CxErbJeSLzxC7+8s0zq0gwT24FB1IkAY/UsxHHLTtpn/hTBAyc0fjIhqxnkpsa/Yj9Wm/HKq3I2vKHL0M3Z8gL2Dh+sfWI0/fN0iGNWG/tsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smPCEycziKfuu9p9AClU3RWN9/MpgH75j1TR75EDibg=;
 b=ekcqlaQ11FZhI/3ubYr6jVWRL7JxZr63usgPSDJt4RmRAZuVUuC6r0bMY9xW8i2jzIr+3rAJUz2VWZslOTpCFO0ztQBtcrXSPwH0OInhgf72UncQa+xui+g7aLLexzWXwUo06uAQi0ii+s3ifDM2aOo8MZ9K9GPdutFoIxiL72A=
Received: from DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM (20.179.12.155) by
 DB8PR10MB3481.EURPRD10.PROD.OUTLOOK.COM (10.186.166.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Mon, 12 Aug 2019 08:57:47 +0000
Received: from DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::51de:e266:582:d0c1]) by DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::51de:e266:582:d0c1%6]) with mapi id 15.20.2157.021; Mon, 12 Aug 2019
 08:57:47 +0000
From:   Fejes Ferenc <fejes@inf.elte.hu>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
Thread-Topic: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
Thread-Index: AQHVUOwCsMyGQq9J8Eq5fTM6eAC0Wg==
Date:   Mon, 12 Aug 2019 08:57:46 +0000
Message-ID: <CAAej5NbkQDpDXEtsROmLmNidSP8qN3VRE56s3z91zHw9XjtNZA@mail.gmail.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0070.namprd05.prod.outlook.com
 (2603:10b6:803:41::47) To DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:b2::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fejes@inf.elte.hu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUfDWcwhBS09qe1noD1s+UkegDQbgvn1fB3nATfgWAx8SBYcwSh
        tWfclx0z2ForbzuA8pp6VoMRHhXbktkpSe5xsuA=
x-google-smtp-source: APXvYqzdmTcy9CLD4KGJZMhrflCSkOCLr6SmSXG2n6SIVfRWBLhueKmv7yNYGXVyJbDGD4PhBaaQJ5I4B4rdkU+QbYk=
x-received: by 2002:a6b:b549:: with SMTP id e70mr25992554iof.95.1565600261294;
 Mon, 12 Aug 2019 01:57:41 -0700 (PDT)
x-gmail-original-message-id: <CAAej5NbkQDpDXEtsROmLmNidSP8qN3VRE56s3z91zHw9XjtNZA@mail.gmail.com>
x-originating-ip: [209.85.210.44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df6b4107-9672-4504-a32f-08d71f03253f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7025125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR10MB3481;
x-ms-traffictypediagnostic: DB8PR10MB3481:
x-microsoft-antispam-prvs: <DB8PR10MB34812AA15A168200C2848372E1D30@DB8PR10MB3481.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39840400004)(366004)(136003)(189003)(199004)(8936002)(55446002)(95326003)(305945005)(8676002)(386003)(66446008)(7736002)(66946007)(102836004)(508600001)(52116002)(1730700003)(81156014)(81166006)(64756008)(66476007)(66556008)(6506007)(9686003)(6512007)(5640700003)(498394004)(256004)(14444005)(5024004)(6116002)(53936002)(25786009)(3846002)(86362001)(2906002)(14454004)(99286004)(54206008)(316002)(486006)(2501003)(6436002)(786003)(5660300002)(61266001)(61726006)(66066001)(476003)(6916009)(71200400001)(71190400001)(26005)(2351001)(6486002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR10MB3481;H:DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: inf.elte.hu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P/ZHRAoZSgpWtTuCuJ5R7k7Nc8+tymNfdxfY7J5Hn/srNQjzSJY/asc2t4udwx82CPQ4HaCswEYDPpSdgXRBxJLLVSt+/jMRqZ36cV9/bfbimaY/8Aa6CaosyPPwsna7z/qn0pATp+XTTSjg+6zSD0MVgMKN77Humc0I7B0UxdILe3QKfM8MtIQxEOeJ1Vp70ZrVTLKTENhqDGKXWA5BU8BDlkR6flP/jLqAUynZMQsFiGO+SY33BOhvZL0Bynf5dA9mdduAmEgrhZJYWCAiy+0wypzn5kb6qBT/PkEXrrHyZIFVQtrleXDmWIt6nkzI7DtJXxeRvb3VCKU8E/ZQv//ULqP4fRBcw3T1Yo+kJ3dn563W0751+HnBqt3hUzF+IrH8Pr8B9m9mDst9a5wFrne6t0z7/2HFzqG+99yrp7o=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD859A72AA88374A824D06E83CAC920D@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: df6b4107-9672-4504-a32f-08d71f03253f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 08:57:46.9113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +nATutpsJqqIA3ZjIPGmjRjwEiYPa82hfIbs7dFmm+n+1MxTE1FryJPszdGqJyFzr5C6M4SS5U9mwK3Dh8Diow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3481
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R3JlZXRpbmdzIQ0KDQpJIGZvdW5kIGEgc3RyYW5nZSBlcnJvciB3aGVuIEkgdHJpZWQgdG8gbG9h
ZCBhIEJQRl9DR1JPVVBfSU5FVF9FR1JFU1MNCnByb2cgd2l0aCBicGZ0b29sLiBMb2FkaW5nIHRo
ZSBzYW1lIHByb2dyYW0gZnJvbSBDIGNvZGUgd2l0aA0KYnBmX3Byb2dfbG9hZF94YXR0ciB3b3Jr
cyB3aXRob3V0IHByb2JsZW0uDQoNClRoZSBlcnJvciBtZXNzYWdlIEkgZ290Og0KYnBmdG9vbCBw
cm9nIGxvYWRhbGwgaGJtX2tlcm4ubyAvc3lzL2ZzL2JwZi9oYm0gdHlwZSBjZ3JvdXAvc2tiDQps
aWJicGY6IGxvYWQgYnBmIHByb2dyYW0gZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50DQpsaWJicGY6
IC0tIEJFR0lOIERVTVAgTE9HIC0tLQ0KbGliYnBmOg0KOyByZXR1cm4gQUxMT1dfUEtUIHwgUkVE
VUNFX0NXOw0KMDogKGI3KSByMCA9IDMNCjE6ICg5NSkgZXhpdA0KQXQgcHJvZ3JhbSBleGl0IHRo
ZSByZWdpc3RlciBSMCBoYXMgdmFsdWUgKDB4MzsgMHgwKSBzaG91bGQgaGF2ZSBiZWVuDQppbiAo
MHgwOyAweDEpDQpwcm9jZXNzZWQgMiBpbnNucyAobGltaXQgMTAwMDAwMCkgbWF4X3N0YXRlc19w
ZXJfaW5zbiAwIHRvdGFsX3N0YXRlcyAwDQpwZWFrX3N0YXRlcyAwIG1hcmtfcmVhZCAwDQoNCmxp
YmJwZjogLS0gRU5EIExPRyAtLQ0KbGliYnBmOiBmYWlsZWQgdG8gbG9hZCBwcm9ncmFtICdjZ3Jv
dXBfc2tiL2VncmVzcycNCmxpYmJwZjogZmFpbGVkIHRvIGxvYWQgb2JqZWN0ICdoYm1fa2Vybi5v
Jw0KRXJyb3I6IGZhaWxlZCB0byBsb2FkIG9iamVjdCBmaWxlDQoNCg0KTXkgZW52aXJvbm1lbnQ6
IDUuMy1yYzMgLyBuZXQtbmV4dCBtYXN0ZXIgKGJvdGggcHJvZHVjaW5nIHRoZSBlcnJvcikuDQpM
aWJicGYgYW5kIGJwZnRvb2wgaW5zdGFsbGVkIGZyb20gdGhlIGtlcm5lbCBzb3VyY2UgKGNsZWFu
ZWQgYW5kDQpyZWluc3RhbGxlZCB3aGVuIEkgdHJpZWQgYSBuZXcga2VybmVsKS4gSSBjb21waWxl
ZCB0aGUgcHJvZ3JhbSB3aXRoDQpDbGFuZyA4LCBvbiBVYnVudHUgMTkuMTAgc2VydmVyIGltYWdl
LCB0aGUgc291cmNlOg0KDQojaW5jbHVkZSA8bGludXgvYnBmLmg+DQojaW5jbHVkZSAiYnBmX2hl
bHBlcnMuaCINCg0KI2RlZmluZSBEUk9QX1BLVCAgICAgICAgMA0KI2RlZmluZSBBTExPV19QS1Qg
ICAgICAgMQ0KI2RlZmluZSBSRURVQ0VfQ1cgICAgICAgMg0KDQpTRUMoImNncm91cF9za2IvZWdy
ZXNzIikNCmludCBoYm0oc3RydWN0IF9fc2tfYnVmZiAqc2tiKQ0Kew0KICAgICAgICByZXR1cm4g
QUxMT1dfUEtUIHwgUkVEVUNFX0NXOw0KfQ0KY2hhciBfbGljZW5zZVtdIFNFQygibGljZW5zZSIp
ID0gIkdQTCI7DQoNCg0KSSBhbHNvIHRyaWVkIHRvIHRyYWNlIGRvd24gdGhlIGJ1ZyB3aXRoIGdk
Yi4gSXQgc2VlbXMgbGlrZSB0aGUNCnNlY3Rpb25fbmFtZXMgYXJyYXkgaW4gbGliYnBmLmMgZmls
bGVkIHdpdGggZ2FyYmFnZSwgZXNwZWNpYWxseSB0aGUNCmV4cGVjdGVkX2F0dGFjaF90eXBlIGZp
ZWxkcyAoaW4gbXkgY2FzZSwgdGhpcyBjb250YWlucw0KQlBGX0NHUk9VUF9JTkVUX0lOR1JFU1Mg
aW5zdGVhZCBvZiBCUEZfQ0dST1VQX0lORVRfRUdSRVNTKS4NCg0KVGhhbmtzIQ0K
