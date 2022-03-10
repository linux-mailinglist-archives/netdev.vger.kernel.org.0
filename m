Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3604D4719
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 13:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242048AbiCJMhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 07:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242041AbiCJMhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 07:37:08 -0500
X-Greylist: delayed 110 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 04:36:05 PST
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BC5141E0A;
        Thu, 10 Mar 2022 04:36:05 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 5F84F5FD0B;
        Thu, 10 Mar 2022 15:36:03 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1646915763;
        bh=sAYFudhND3JlipbN3vSkDC50/DPj1pm3r26FdfVkax4=;
        h=From:To:Subject:Date:Message-ID:Reply-To:Content-Type:
         MIME-Version;
        b=dsTdKg7P9XYY0xTqRk9ZJ2V+xj0OHIYXQVcgFO3MBFH0LsqwBFmjtfq1yTnOPWBOH
         ezCI1mn7LRQiZGBmgxhRb6adWdpgkx7lkewq1oY8b/3YbAbSp0RqNq33fhN13F7ui3
         FJGhM2VHhnr8dzZ4YtgqCvhQ2uP9lKVgwaWQMfv8YRmbT+P8+WgcCLV6jICiGijAyr
         s32lmCAgcdqJongEeF7rc2L74NJoxYJmT7wnIN6FduTEXHJ6rclv1qHWysB6jJfGcc
         P9gQHbF977Ny8Qy88SLufkm5T9B/SigrwHKMTqEfPuMsToZFdFDHBew1LU67KIC2Nc
         uSSAvoQ1SJjmA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 10 Mar 2022 15:36:03 +0300 (MSK)
From:   =?utf-8?B?0JrRgNCw0YHQvdC+0LIg0JDRgNGB0LXQvdC40Lkg0JLQu9Cw0LTQuNC80Lg=?=
         =?utf-8?B?0YDQvtCy0LjRhw==?= <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        =?utf-8?B?0KDQvtC60L7RgdC+0LIg0JTQvNC40YLRgNC40Lkg0JTQvNC40YLRgNC40LU=?=
         =?utf-8?B?0LLQuNGH?= <DDRokosov@sberdevices.ru>
Subject: 
Thread-Index: AQHYNHtecbA/6LWnrk+GBWwyAuzxZQ==
Date:   Thu, 10 Mar 2022 12:35:53 +0000
Message-ID: <1a92beea-6c77-69b6-07e0-1e8f0242d898@sberdevices.ru>
Reply-To: "17514ec6-6e04-6ef9-73ba-b21da09f0f6f@sberdevices.ru" 
          <17514ec6-6e04-6ef9-73ba-b21da09f0f6f@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1DD52A50505C44A82EACBB6B1B31C19@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/10 08:46:00 #18933400
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSAzZDdmYTJhNTdhMmRkNjBhMThiMjAxZjg1MzdiNzE3YjVmYzQzY2YzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmlj
ZXMucnU+DQpEYXRlOiBNb24sIDMgSmFuIDIwMjIgMTQ6NDQ6MDIgKzAzMDANClN1YmplY3Q6IFtS
RkMgUEFUQ0ggdjEgMi8zXSBhZl92c29jazogU09DS19TRVFQQUNLRVQgcmVjZWl2ZSB0aW1lb3V0
IHRlc3QNCg0KVGVzdCBmb3IgcmVjZWl2ZSB0aW1lb3V0IGNoZWNrOiBjb25uZWN0aW9uIGlzIGVz
dGFibGlzaGVkLA0KcmVjZWl2ZXIgc2V0cyB0aW1lb3V0LCBidXQgc2VuZGVyIGRvZXMgbm90aGlu
Zy4gUmVjZWl2ZXIncw0KJ3JlYWQoKScgY2FsbCBtdXN0IHJldHVybiBFQUdBSU4uDQoNClNpZ25l
ZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0t
DQogdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA0OSArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA0OSBpbnNlcnRpb25zKCspDQoNCmRp
ZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3Rp
bmcvdnNvY2svdnNvY2tfdGVzdC5jDQppbmRleCAyYTM2MzhjMGEwMDguLmFhMmRlMjdkMGY3NyAx
MDA2NDQNCi0tLSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQorKysgYi90b29s
cy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KQEAgLTM5MSw2ICszOTEsNTAgQEAgc3RhdGlj
IHZvaWQgdGVzdF9zZXFwYWNrZXRfbXNnX3RydW5jX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9v
cHRzICpvcHRzKQ0KIAljbG9zZShmZCk7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFj
a2V0X3RpbWVvdXRfY2xpZW50KGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwlp
bnQgZmQ7DQorCXN0cnVjdCB0aW1ldmFsIHR2Ow0KKwljaGFyIGR1bW15Ow0KKw0KKwlmZCA9IHZz
b2NrX3NlcXBhY2tldF9jb25uZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0KTsNCisJaWYgKGZkIDwg
MCkgew0KKwkJcGVycm9yKCJjb25uZWN0Iik7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0N
CisNCisJdHYudHZfc2VjID0gMTsNCisJdHYudHZfdXNlYyA9IDA7DQorDQorCWlmIChzZXRzb2Nr
b3B0KGZkLCBTT0xfU09DS0VULCBTT19SQ1ZUSU1FTywgKHZvaWQgKikmdHYsIHNpemVvZih0dikp
ID09IC0xKSB7DQorCQlwZXJyb3IoInNldHNvY2tvcHQgJ1NPX1JDVlRJTUVPJyIpOw0KKwkJZXhp
dChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWlmICgocmVhZChmZCwgJmR1bW15LCBzaXplb2Yo
ZHVtbXkpKSAhPSAtMSkgfHwNCisJICAgIChlcnJubyAhPSBFQUdBSU4pKSB7DQorCQlwZXJyb3Io
IkVBR0FJTiBleHBlY3RlZCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNv
bnRyb2xfd3JpdGVsbigiV0FJVERPTkUiKTsNCisJY2xvc2UoZmQpOw0KK30NCisNCitzdGF0aWMg
dm9pZCB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRz
ICpvcHRzKQ0KK3sNCisJaW50IGZkOw0KKw0KKwlmZCA9IHZzb2NrX3NlcXBhY2tldF9hY2NlcHQo
Vk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3Io
ImFjY2VwdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRyb2xfZXhw
ZWN0bG4oIldBSVRET05FIik7DQorCWNsb3NlKGZkKTsNCit9DQorDQogc3RhdGljIHN0cnVjdCB0
ZXN0X2Nhc2UgdGVzdF9jYXNlc1tdID0gew0KIAl7DQogCQkubmFtZSA9ICJTT0NLX1NUUkVBTSBj
b25uZWN0aW9uIHJlc2V0IiwNCkBAIC00MzEsNiArNDc1LDExIEBAIHN0YXRpYyBzdHJ1Y3QgdGVz
dF9jYXNlIHRlc3RfY2FzZXNbXSA9IHsNCiAJCS5ydW5fY2xpZW50ID0gdGVzdF9zZXFwYWNrZXRf
bXNnX3RydW5jX2NsaWVudCwNCiAJCS5ydW5fc2VydmVyID0gdGVzdF9zZXFwYWNrZXRfbXNnX3Ry
dW5jX3NlcnZlciwNCiAJfSwNCisJew0KKwkJLm5hbWUgPSAiU09DS19TRVFQQUNLRVQgdGltZW91
dCIsDQorCQkucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X3RpbWVvdXRfY2xpZW50LA0KKwkJ
LnJ1bl9zZXJ2ZXIgPSB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlciwNCisJfSwNCiAJe30s
DQogfTsNCiANCi0tIA0KMi4yNS4xDQo=
