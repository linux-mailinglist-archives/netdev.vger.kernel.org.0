Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E242172B
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 12:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfEQKor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 06:44:47 -0400
Received: from mail-oln040092067065.outbound.protection.outlook.com ([40.92.67.65]:63299
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728390AbfEQKoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 06:44:46 -0400
Received: from AM5EUR02FT015.eop-EUR02.prod.protection.outlook.com
 (10.152.8.52) by AM5EUR02HT077.eop-EUR02.prod.protection.outlook.com
 (10.152.9.127) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.11; Fri, 17 May
 2019 10:44:44 +0000
Received: from AM0PR07MB4417.eurprd07.prod.outlook.com (10.152.8.53) by
 AM5EUR02FT015.mail.protection.outlook.com (10.152.8.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16 via Frontend Transport; Fri, 17 May 2019 10:44:44 +0000
Received: from AM0PR07MB4417.eurprd07.prod.outlook.com
 ([fe80::9046:9a59:4519:d984]) by AM0PR07MB4417.eurprd07.prod.outlook.com
 ([fe80::9046:9a59:4519:d984%3]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 10:44:44 +0000
From:   Philippe Mazenauer <philippe.mazenauer@outlook.de>
CC:     "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Philippe Mazenauer <philippe.mazenauer@outlook.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib: Correct comment of prandom_seed
Thread-Topic: [PATCH] lib: Correct comment of prandom_seed
Thread-Index: AQHVDJ2JrktfPZmdKU2E7C1BOPHbWQ==
Date:   Fri, 17 May 2019 10:44:44 +0000
Message-ID: <AM0PR07MB44176BAB0BA6ACAAA8C6DC88FD0B0@AM0PR07MB4417.eurprd07.prod.outlook.com>
Accept-Language: de-CH, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:300:d4::18) To AM0PR07MB4417.eurprd07.prod.outlook.com
 (2603:10a6:208:b8::26)
x-incomingtopheadermarker: OriginalChecksum:1526C49DCF19A1AF2281A7A8B1FFF74C1613D059FB95E761CD80E0C5C5FA80FD;UpperCasedChecksum:8FB927AB3F09B3F1D4768817067C5A90509C29872C4E30B87969D7CC7623E61F;SizeAsReceived:7477;Count:47
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-tmn:  [ZMEojfOnWahuAghcnLd7mLY5syu4NYZc]
x-microsoft-original-message-id: <20190517104419.26343-1-philippe.mazenauer@outlook.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 47
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(5050001)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR02HT077;
x-ms-traffictypediagnostic: AM5EUR02HT077:
x-microsoft-antispam-message-info: IQDpj6gkCGVqi1Xy+HCS6vd4q6RGROVpHZg44PkcXDTT7ua5pF0Fz7iJtgxEgOSb/J6Kfbqvm0Q8mw705rzAf4dTCI0Ntp8tAhX0w6rtA9G/Z7XzNMnXGsTjdU663sq/X9Z1ySItGD9dyZXnQhVJRAoedM11ToQat4CNDT0Y79vbv3C4ZuPaxp0ECkJ4Gzhh
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ec8b5c-c1da-494e-c165-08d6dab4ac3d
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 10:44:44.1808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR02HT077
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VmFyaWFibGUgJ2VudHJvcHknIHdhcyB3cm9uZ2x5IGRvY3VtZW50ZWQgYXMgJ3NlZWQnLCBjaGFu
Z2VkIGNvbW1lbnQgdG8NCnJlZmxlY3QgYWN0dWFsIHZhcmlhYmxlIG5hbWUuDQoNCi4uL2xpYi9y
YW5kb20zMi5jOjE3OTogd2FybmluZzogRnVuY3Rpb24gcGFyYW1ldGVyIG9yIG1lbWJlciAnZW50
cm9weScgbm90IGRlc2NyaWJlZCBpbiAncHJhbmRvbV9zZWVkJw0KLi4vbGliL3JhbmRvbTMyLmM6
MTc5OiB3YXJuaW5nOiBFeGNlc3MgZnVuY3Rpb24gcGFyYW1ldGVyICdzZWVkJyBkZXNjcmlwdGlv
biBpbiAncHJhbmRvbV9zZWVkJw0KDQpTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXplbmF1ZXIg
PHBoaWxpcHBlLm1hemVuYXVlckBvdXRsb29rLmRlPg0KLS0tDQogbGliL3JhbmRvbTMyLmMgfCA0
ICsrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0K
DQpkaWZmIC0tZ2l0IGEvbGliL3JhbmRvbTMyLmMgYi9saWIvcmFuZG9tMzIuYw0KaW5kZXggNGFh
YTc2NDA0ZDU2Li43NjNiOTIwYTYyMDYgMTAwNjQ0DQotLS0gYS9saWIvcmFuZG9tMzIuYw0KKysr
IGIvbGliL3JhbmRvbTMyLmMNCkBAIC0xNzEsOSArMTcxLDkgQEAgc3RhdGljIHZvaWQgcHJhbmRv
bV9zZWVkX2Vhcmx5KHN0cnVjdCBybmRfc3RhdGUgKnN0YXRlLCB1MzIgc2VlZCwNCiANCiAvKioN
CiAgKglwcmFuZG9tX3NlZWQgLSBhZGQgZW50cm9weSB0byBwc2V1ZG8gcmFuZG9tIG51bWJlciBn
ZW5lcmF0b3INCi0gKglAc2VlZDogc2VlZCB2YWx1ZQ0KKyAqCUBlbnRyb3B5OiBlbnRyb3B5IHZh
bHVlDQogICoNCi0gKglBZGQgc29tZSBhZGRpdGlvbmFsIHNlZWRpbmcgdG8gdGhlIHByYW5kb20g
cG9vbC4NCisgKglBZGQgc29tZSBhZGRpdGlvbmFsIGVudHJvcHkgdG8gdGhlIHByYW5kb20gcG9v
bC4NCiAgKi8NCiB2b2lkIHByYW5kb21fc2VlZCh1MzIgZW50cm9weSkNCiB7DQotLSANCjIuMTcu
MQ0KDQo=
