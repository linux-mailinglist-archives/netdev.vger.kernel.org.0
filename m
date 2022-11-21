Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB01D6329FC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiKUQuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiKUQuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:50:11 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DFC21251;
        Mon, 21 Nov 2022 08:50:09 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 2E4D45FD02;
        Mon, 21 Nov 2022 19:50:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669049408;
        bh=MXC0JM2w9sqpYVKU5cr/NMZAG7SIQpOwAsuxb+bPWwU=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=UV7qrI7j+lh3QwHzf5IxyNSB74pVHfHBL/UdSsS17/yVxmJFibgp/ujfBIrin3QEf
         WIYjuSoS+wPIu0v+Wt7PKJgcHWpG6vkdcGFfLJ5ghHPDvlL3eVrTb1xaoE4CxHMpva
         urn6R0jCb6TP4EFsYqpMA2KO7UEqL7gYxsrnlGE+iLyE9K/JcU8SjXZSxUCgasz8We
         YnRNXGVUte/GboR1g2cxLD9wPm8v+aSDsTsgs3U6ju86JQzr8Sy99QguTW7tOZEweP
         z1+7Bp6S/a3R7H80nio2fstzWnh8jwDt0vKrhb6SZBtM2MeA+lJhfcD3hAXZpMO9u0
         lDKQhr6gbyPqg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 21 Nov 2022 19:50:08 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 2/3] test/vsock: add big message test
Thread-Topic: [RFC PATCH v1 2/3] test/vsock: add big message test
Thread-Index: AQHY+TQwn9KcvFr2LUmtZTFuocc05q5JTSQAgAAggoA=
Date:   Mon, 21 Nov 2022 16:50:07 +0000
Message-ID: <ff71c2d3-9f61-d649-7ae5-cd012eada10d@sberdevices.ru>
References: <ba294dff-812a-bfc2-a43c-286f99aee0b8@sberdevices.ru>
 <f0510949-cc97-7a01-5fc8-f7e855b80515@sberdevices.ru>
 <20221121145248.cmscv5vg3fir543x@sgarzare-redhat>
In-Reply-To: <20221121145248.cmscv5vg3fir543x@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7ED2029942DF274B9C719A6109FC15E1@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/21 12:27:00 #20594217
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEuMTEuMjAyMiAxNzo1MiwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBUdWUs
IE5vdiAxNSwgMjAyMiBhdCAwODo1MjozNVBNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBUaGlzIGFkZHMgdGVzdCBmb3Igc2VuZGluZyBtZXNzYWdlLCBiaWdnZXIgdGhhbiBwZWVy
J3MgYnVmZmVyIHNpemUuDQo+PiBGb3IgU09DS19TRVFQQUNLRVQgc29ja2V0IGl0IG11c3QgZmFp
bCwgYXMgdGhpcyB0eXBlIG9mIHNvY2tldCBoYXMNCj4+IG1lc3NhZ2Ugc2l6ZSBsaW1pdC4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNl
cy5ydT4NCj4+IC0tLQ0KPj4gdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA2MiAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDYyIGlu
c2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy92c29jay92c29j
a190ZXN0LmMgYi90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KPj4gaW5kZXggMTA3
YzExMTY1ODg3Li5iYjRlODY1N2YxZDYgMTAwNjQ0DQo+PiAtLS0gYS90b29scy90ZXN0aW5nL3Zz
b2NrL3Zzb2NrX3Rlc3QuYw0KPj4gKysrIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0
LmMNCj4+IEBAIC01NjAsNiArNTYwLDYzIEBAIHN0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X3Rp
bWVvdXRfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQo+PiDCoMKgwqDCoGNs
b3NlKGZkKTsNCj4+IH0NCj4+DQo+PiArc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfYmlnbXNn
X2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KPj4gK3sNCj4+ICvCoMKgwqAg
dW5zaWduZWQgbG9uZyBzb2NrX2J1Zl9zaXplOw0KPj4gK8KgwqDCoCBzc2l6ZV90IHNlbmRfc2l6
ZTsNCj4+ICvCoMKgwqAgc29ja2xlbl90IGxlbjsNCj4+ICvCoMKgwqAgdm9pZCAqZGF0YTsNCj4+
ICvCoMKgwqAgaW50IGZkOw0KPj4gKw0KPj4gK8KgwqDCoCBsZW4gPSBzaXplb2Yoc29ja19idWZf
c2l6ZSk7DQo+PiArDQo+PiArwqDCoMKgIGZkID0gdnNvY2tfc2VxcGFja2V0X2Nvbm5lY3Qob3B0
cy0+cGVlcl9jaWQsIDEyMzQpOw0KPiANCj4gTm90IGZvciB0aGlzIHBhdGNoLCBidXQgc29tZWRh
eSB3ZSBzaG91bGQgYWRkIGEgbWFjcm8gZm9yIHRoaXMgcG9ydCBhbmQgbWF5YmUgZXZlbiBtYWtl
IGl0IGNvbmZpZ3VyYWJsZSA6LSkNCj4gDQo+PiArwqDCoMKgIGlmIChmZCA8IDApIHsNCj4+ICvC
oMKgwqDCoMKgwqDCoCBwZXJyb3IoImNvbm5lY3QiKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0
KEVYSVRfRkFJTFVSRSk7DQo+PiArwqDCoMKgIH0NCj4+ICsNCj4+ICvCoMKgwqAgaWYgKGdldHNv
Y2tvcHQoZmQsIEFGX1ZTT0NLLCBTT19WTV9TT0NLRVRTX0JVRkZFUl9TSVpFLA0KPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJnNvY2tfYnVmX3NpemUsICZsZW4pKSB7DQo+PiArwqDC
oMKgwqDCoMKgwqAgcGVycm9yKCJnZXRzb2Nrb3B0Iik7DQo+PiArwqDCoMKgwqDCoMKgwqAgZXhp
dChFWElUX0ZBSUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+PiArDQo+PiArwqDCoMKgIHNvY2tfYnVm
X3NpemUrKzsNCj4+ICsNCj4+ICvCoMKgwqAgZGF0YSA9IG1hbGxvYyhzb2NrX2J1Zl9zaXplKTsN
Cj4+ICvCoMKgwqAgaWYgKCFkYXRhKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgcGVycm9yKCJtYWxs
b2MiKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiArwqDCoMKg
IH0NCj4+ICsNCj4+ICvCoMKgwqAgc2VuZF9zaXplID0gc2VuZChmZCwgZGF0YSwgc29ja19idWZf
c2l6ZSwgMCk7DQo+PiArwqDCoMKgIGlmIChzZW5kX3NpemUgIT0gLTEpIHsNCj4gDQo+IENhbiB3
ZSBjaGVjayBhbHNvIGBlcnJub2A/DQo+IElJVUMgaXQgc2hvdWxkIGNvbnRhaW5zIEVNU0dTSVpF
Lg0KPiANCj4+ICvCoMKgwqDCoMKgwqDCoCBmcHJpbnRmKHN0ZGVyciwgImV4cGVjdGVkICdzZW5k
KDIpJyBmYWlsdXJlLCBnb3QgJXppXG4iLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2Vu
ZF9zaXplKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoCBjb250cm9sX3dyaXRlbG4o
IkNMSVNFTlQiKTsNCj4+ICsNCj4+ICvCoMKgwqAgZnJlZShkYXRhKTsNCj4+ICvCoMKgwqAgY2xv
c2UoZmQpOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF9iaWdt
c2dfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQo+PiArew0KPj4gK8KgwqDC
oCBpbnQgZmQ7DQo+PiArDQo+PiArwqDCoMKgIGZkID0gdnNvY2tfc2VxcGFja2V0X2FjY2VwdChW
TUFERFJfQ0lEX0FOWSwgMTIzNCwgTlVMTCk7DQo+PiArwqDCoMKgIGlmIChmZCA8IDApIHsNCj4+
ICvCoMKgwqDCoMKgwqDCoCBwZXJyb3IoImFjY2VwdCIpOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGV4
aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0KPj4gK8KgwqDCoCBjb250cm9s
X2V4cGVjdGxuKCJDTElTRU5UIik7DQo+PiArDQo+PiArwqDCoMKgIGNsb3NlKGZkKTsNCj4+ICt9
DQo+PiArDQo+PiAjZGVmaW5lIEJVRl9QQVRURVJOXzEgJ2EnDQo+PiAjZGVmaW5lIEJVRl9QQVRU
RVJOXzIgJ2InDQo+Pg0KPj4gQEAgLTgzMiw2ICs4ODksMTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0
X2Nhc2UgdGVzdF9jYXNlc1tdID0gew0KPj4gwqDCoMKgwqDCoMKgwqAgLnJ1bl9jbGllbnQgPSB0
ZXN0X3NlcXBhY2tldF90aW1lb3V0X2NsaWVudCwNCj4+IMKgwqDCoMKgwqDCoMKgIC5ydW5fc2Vy
dmVyID0gdGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIsDQo+PiDCoMKgwqDCoH0sDQo+PiAr
wqDCoMKgIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCAubmFtZSA9ICJTT0NLX1NFUVBBQ0tFVCBiaWcg
bWVzc2FnZSIsDQo+PiArwqDCoMKgwqDCoMKgwqAgLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tl
dF9iaWdtc2dfY2xpZW50LA0KPj4gK8KgwqDCoMKgwqDCoMKgIC5ydW5fc2VydmVyID0gdGVzdF9z
ZXFwYWNrZXRfYmlnbXNnX3NlcnZlciwNCj4+ICvCoMKgwqAgfSwNCj4gDQo+IEkgd291bGQgYWRk
IG5ldyB0ZXN0cyBhbHdheXMgYXQgdGhlIGVuZCwgc28gaWYgc29tZSBDSSB1c2VzIC0tc2tpcCwg
d2UgZG9uJ3QgaGF2ZSB0byB1cGRhdGUgdGhlIHNjcmlwdHMgdG8gc2tpcCBzb21lIHRlc3RzLg0K
QWNrIHRoaXMgYW5kIGFsbCBhYm92ZQ0KPiANCj4+IMKgwqDCoMKgew0KPj4gwqDCoMKgwqDCoMKg
wqAgLm5hbWUgPSAiU09DS19TRVFQQUNLRVQgaW52YWxpZCByZWNlaXZlIGJ1ZmZlciIsDQo+PiDC
oMKgwqDCoMKgwqDCoCAucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1
ZmZlcl9jbGllbnQsDQo+PiAtLcKgDQo+PiAyLjI1LjENCj4gDQoNCg==
