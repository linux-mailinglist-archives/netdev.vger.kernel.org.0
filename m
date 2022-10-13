Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16125FDEE8
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 19:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJMR21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 13:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJMR20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 13:28:26 -0400
X-Greylist: delayed 361 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Oct 2022 10:28:24 PDT
Received: from smtpout10.r2.mail-out.ovh.net (smtpout10.r2.mail-out.ovh.net [54.36.141.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEF47FE55
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 10:28:24 -0700 (PDT)
Received: from ex2.mail.ovh.net (unknown [10.111.172.130])
        by mo512.mail-out.ovh.net (Postfix) with ESMTPS id 8E77A24345;
        Thu, 13 Oct 2022 17:22:21 +0000 (UTC)
Received: from EX10.indiv2.local (172.16.2.10) by EX10.indiv2.local
 (172.16.2.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.2507.12; Thu, 13
 Oct 2022 19:22:20 +0200
Received: from EX10.indiv2.local ([fe80::62:7b97:e069:79e]) by
 EX10.indiv2.local ([fe80::62:7b97:e069:79e%13]) with mapi id 15.01.2507.012;
 Thu, 13 Oct 2022 19:22:20 +0200
From:   =?utf-8?B?Q2hyaXN0aWFuIFDDtnNzaW5nZXI=?= <christian@poessinger.com>
To:     'Stephen Hemminger' <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iproute2] u32: fix json formatting of flowid
Thread-Topic: [PATCH iproute2] u32: fix json formatting of flowid
Thread-Index: AQHY3xkL3eClx0YC8UucIKD0OSE+664MklGQ
Date:   Thu, 13 Oct 2022 17:22:20 +0000
Message-ID: <b0ef363f505c48d3b2f6c73e2cb33ee0@poessinger.com>
References: <f4806731521546b0bb7011b8c570b52b@poessinger.com>
 <20221013153240.108340-1-stephen@networkplumber.org>
In-Reply-To: <20221013153240.108340-1-stephen@networkplumber.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.249.217.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Ovh-Tracer-Id: 5281877939487844471
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeektddguddugecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufhtfffkfhgjihgtgfggsehtsghjtddttdejnecuhfhrohhmpeevhhhrihhsthhirghnucfrnphsshhinhhgvghruceotghhrhhishhtihgrnhesphhovghsshhinhhgvghrrdgtohhmqeenucggtffrrghtthgvrhhnpeelfeevjeegudfghfeiuedvkeevfffguedvheehvdelteefjeejudeviefgvedtvdenucfkphepuddvjedrtddrtddruddpvddujedrvdegledrvddujedrudejieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegthhhrihhsthhirghnsehpohgvshhsihhnghgvrhdrtghomheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepshhtvghphhgvnhesnhgvthifohhrkhhplhhumhgsvghrrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheduvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KSSBjYW4gY29uZmlybSB0aGlzIGZpeCB3b3JraW5nIQ0KDQpZb3UgbWF5
IGluY2x1ZGUgDQpUZXN0ZWQtYnk6IENocmlzdGlhbiBQw7Zzc2luZ2VyIDxjaHJpc3RpYW5AcG9l
c3Npbmdlci5jb20+DQoNClRoYW5rcywNCkNocmlzdGlhbg0KDQotLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KRnJvbTogU3RlcGhlbiBIZW1taW5nZXIgPHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIu
b3JnPiANClNlbnQ6IFRodXJzZGF5LCAxMyBPY3RvYmVyIDIwMjIgMTc6MzMNClRvOiBuZXRkZXZA
dmdlci5rZXJuZWwub3JnDQpDYzogU3RlcGhlbiBIZW1taW5nZXIgPHN0ZXBoZW5AbmV0d29ya3Bs
dW1iZXIub3JnPjsgQ2hyaXN0aWFuIFDDtnNzaW5nZXIgPGNocmlzdGlhbkBwb2Vzc2luZ2VyLmNv
bT4NClN1YmplY3Q6IFtQQVRDSCBpcHJvdXRlMl0gdTMyOiBmaXgganNvbiBmb3JtYXR0aW5nIG9m
IGZsb3dpZA0KDQpUaGUgY29kZSB0byBwcmludCBqc29uIHdhcyBub3QgZG9uZSBmb3IgdGhlIGZs
b3cgaWQuDQpUaGlzIHdvdWxkIGxlYWQgdG8gaW5jb3JyZWN0IEpTT04gZm9ybWF0IG91dHB1dC4N
Cg0KUmVwb3J0ZWQtYnk6IENocmlzdGlhbiBQw7Zzc2luZ2VyIDxjaHJpc3RpYW5AcG9lc3Npbmdl
ci5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTdGVwaGVuIEhlbW1pbmdlciA8c3RlcGhlbkBuZXR3b3Jr
cGx1bWJlci5vcmc+DQotLS0NCiB0Yy9mX3UzMi5jIHwgMTIgKysrKysrKy0tLS0tDQogMSBmaWxl
IGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L3RjL2ZfdTMyLmMgYi90Yy9mX3UzMi5jDQppbmRleCBkNzg3ZWI5MTU2MDMuLmU0ZTBhYjEyMWM1
NyAxMDA2NDQNCi0tLSBhL3RjL2ZfdTMyLmMNCisrKyBiL3RjL2ZfdTMyLmMNCkBAIC0xMjc1LDEy
ICsxMjc1LDE0IEBAIHN0YXRpYyBpbnQgdTMyX3ByaW50X29wdChzdHJ1Y3QgZmlsdGVyX3V0aWwg
KnF1LCBGSUxFICpmLCBzdHJ1Y3QgcnRhdHRyICpvcHQsDQogCQlmcHJpbnRmKHN0ZGVyciwgImRp
dmlzb3IgYW5kIGhhc2ggbWlzc2luZyAiKTsNCiAJfQ0KIAlpZiAodGJbVENBX1UzMl9DTEFTU0lE
XSkgew0KKwkJX191MzIgY2xhc3NpZCA9IHJ0YV9nZXRhdHRyX3UzMih0YltUQ0FfVTMyX0NMQVNT
SURdKTsNCiAJCVNQUklOVF9CVUYoYjEpOw0KLQkJZnByaW50ZihmLCAiJXNmbG93aWQgJXMgIiwN
Ci0JCQkhc2VsIHx8ICEoc2VsLT5mbGFncyAmIFRDX1UzMl9URVJNSU5BTCkgPyAiKiIgOiAiIiwN
Ci0JCQlzcHJpbnRfdGNfY2xhc3NpZChydGFfZ2V0YXR0cl91MzIodGJbVENBX1UzMl9DTEFTU0lE
XSksDQotCQkJCQkgIGIxKSk7DQotCX0gZWxzZSBpZiAoc2VsICYmIHNlbC0+ZmxhZ3MgJiBUQ19V
MzJfVEVSTUlOQUwpIHsNCisJCWlmIChzZWwgJiYgKHNlbC0+ZmxhZ3MgJiBUQ19VMzJfVEVSTUlO
QUwpKQ0KKwkJCXByaW50X3N0cmluZyhQUklOVF9GUCwgTlVMTCwgIioiLCBOVUxMKTsNCisNCisJ
CXByaW50X3N0cmluZyhQUklOVF9BTlksICJmbG93aWQiLCAiZmxvd2lkICVzICIsDQorCQkJICAg
ICBzcHJpbnRfdGNfY2xhc3NpZChjbGFzc2lkLCBiMSkpOw0KKwl9IGVsc2UgaWYgKHNlbCAmJiAo
c2VsLT5mbGFncyAmIFRDX1UzMl9URVJNSU5BTCkpIHsNCiAJCXByaW50X3N0cmluZyhQUklOVF9G
UCwgTlVMTCwgInRlcm1pbmFsIGZsb3dpZCAiLCBOVUxMKTsNCiAJfQ0KIAlpZiAodGJbVENBX1Uz
Ml9MSU5LXSkgew0KLS0gDQoyLjM1LjENCg0K
