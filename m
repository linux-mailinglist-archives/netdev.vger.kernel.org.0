Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816654F8B9D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiDHATK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 20:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiDHATI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 20:19:08 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDB76E4FC;
        Thu,  7 Apr 2022 17:17:06 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 2380GitoE019844, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 2380GitoE019844
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 8 Apr 2022 08:16:45 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 08:16:44 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 08:16:44 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34]) by
 RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34%5]) with mapi id
 15.01.2308.021; Fri, 8 Apr 2022 08:16:44 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "joe@perches.com" <joe@perches.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtw89: rtw89_ser: add const to struct state_ent and event_ent
Thread-Topic: [PATCH] rtw89: rtw89_ser: add const to struct state_ent and
 event_ent
Thread-Index: AQHYSrwlBPHfiXY/J06wP5rR38YoOKzkoEKA
Date:   Fri, 8 Apr 2022 00:16:44 +0000
Message-ID: <9455b32da137028a5c0d6dd010a247094d19309a.camel@realtek.com>
References: <2fd88e6119f62b968477ef9781abb1832d399fd6.camel@perches.com>
In-Reply-To: <2fd88e6119f62b968477ef9781abb1832d399fd6.camel@perches.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.21.190]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzQvNyDkuIvljYggMTA6MDA6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1A233ED2F9A6849B8B2CEC26AF13016@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA0LTA3IGF0IDEzOjE0IC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
Q2hhbmdlIHRoZSBzdHJ1Y3QgYW5kIHRoZSB1c2VzIHRvIGNvbnN0IHRvIHJlZHVjZSBkYXRhLg0K
PiANCj4gJCBzaXplIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvc2VyLm8qICh4
ODYtNjQgZGVmY29uZmlnIHcvIHJ0dzg5KQ0KPiAgICB0ZXh0CSAgIGRhdGEJICAgIGJzcwkgICAg
ZGVjCSAgICBoZXgJZmlsZW5hbWUNCj4gICAgMzc0MQkgICAgICA4CSAgICAgIDAJICAgMzc0OQkg
ICAgZWE1CWRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvc2VyLm8ubmV3DQo+ICAg
IDM0MzcJICAgIDMxMgkgICAgICAwCSAgIDM3NDkJICAgIGVhNQlkcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg5L3Nlci5vLm9sZA0KPiANCj4gU2lnbmVkLW9mZi1ieTogSm9lIFBlcmNo
ZXMgPGpvZUBwZXJjaGVzLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJl
YWx0ZWsuY29tPg0KDQpUaGFuayB5b3UuDQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg5L2NvcmUuaCB8IDQgKystLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OS9zZXIuYyAgfCA0ICsrLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvY29yZS5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OS9jb3JlLmgNCj4gaW5kZXggNzcxNzIyMTMyYzUzYi4uOWJmNTZjZTVhYjQzZiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9jb3JlLmgN
Cj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9jb3JlLmgNCj4gQEAg
LTI4NTMsOCArMjg1Myw4IEBAIHN0cnVjdCBydHc4OV9zZXIgew0KPiAgDQo+ICAJc3RydWN0IHdv
cmtfc3RydWN0IHNlcl9oZGxfd29yazsNCj4gIAlzdHJ1Y3QgZGVsYXllZF93b3JrIHNlcl9hbGFy
bV93b3JrOw0KPiAtCXN0cnVjdCBzdGF0ZV9lbnQgKnN0X3RibDsNCj4gLQlzdHJ1Y3QgZXZlbnRf
ZW50ICpldl90Ymw7DQo+ICsJY29uc3Qgc3RydWN0IHN0YXRlX2VudCAqc3RfdGJsOw0KPiArCWNv
bnN0IHN0cnVjdCBldmVudF9lbnQgKmV2X3RibDsNCj4gIAlzdHJ1Y3QgbGlzdF9oZWFkIG1zZ19x
Ow0KPiAgCXNwaW5sb2NrX3QgbXNnX3FfbG9jazsgLyogbG9jayB3aGVuIHJlYWQvd3JpdGUgc2Vy
IG1zZyAqLw0KPiAgCURFQ0xBUkVfQklUTUFQKGZsYWdzLCBSVFc4OV9OVU1fT0ZfU0VSX0ZMQUdT
KTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvc2Vy
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3Nlci5jDQo+IGluZGV4IDgz
N2NkYzM2NmE2MWEuLjdmYmRhN2VmOTZiYmIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnR3ODkvc2VyLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OS9zZXIuYw0KPiBAQCAtMzk2LDcgKzM5Niw3IEBAIHN0YXRpYyB2b2lkIHNl
cl9sMl9yZXNldF9zdF9oZGwoc3RydWN0IHJ0dzg5X3NlciAqc2VyLCB1OCBldnQpDQo+ICAJfQ0K
PiAgfQ0KPiAgDQo+IC1zdGF0aWMgc3RydWN0IGV2ZW50X2VudCBzZXJfZXZfdGJsW10gPSB7DQo+
ICtzdGF0aWMgY29uc3Qgc3RydWN0IGV2ZW50X2VudCBzZXJfZXZfdGJsW10gPSB7DQo+ICAJe1NF
Ul9FVl9OT05FLCAiU0VSX0VWX05PTkUifSwNCj4gIAl7U0VSX0VWX1NUQVRFX0lOLCAiU0VSX0VW
X1NUQVRFX0lOIn0sDQo+ICAJe1NFUl9FVl9TVEFURV9PVVQsICJTRVJfRVZfU1RBVEVfT1VUIn0s
DQo+IEBAIC00MTIsNyArNDEyLDcgQEAgc3RhdGljIHN0cnVjdCBldmVudF9lbnQgc2VyX2V2X3Ri
bFtdID0gew0KPiAgCXtTRVJfRVZfTUFYWCwgIlNFUl9FVl9NQVgifQ0KPiAgfTsNCj4gIA0KPiAt
c3RhdGljIHN0cnVjdCBzdGF0ZV9lbnQgc2VyX3N0X3RibFtdID0gew0KPiArc3RhdGljIGNvbnN0
IHN0cnVjdCBzdGF0ZV9lbnQgc2VyX3N0X3RibFtdID0gew0KPiAgCXtTRVJfSURMRV9TVCwgIlNF
Ul9JRExFX1NUIiwgc2VyX2lkbGVfc3RfaGRsfSwNCj4gIAl7U0VSX1JFU0VUX1RSWF9TVCwgIlNF
Ul9SRVNFVF9UUlhfU1QiLCBzZXJfcmVzZXRfdHJ4X3N0X2hkbH0sDQo+ICAJe1NFUl9ET19IQ0lf
U1QsICJTRVJfRE9fSENJX1NUIiwgc2VyX2RvX2hjaV9zdF9oZGx9LA0KPiANCj4gDQo+IC0tLS0t
LVBsZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1t
YWlsLg0KDQoNCg==
