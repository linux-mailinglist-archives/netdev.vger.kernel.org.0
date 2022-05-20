Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4952E35E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 05:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345225AbiETDtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 23:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239371AbiETDtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 23:49:51 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3EC5A081;
        Thu, 19 May 2022 20:49:50 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24K3n7v95032211, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24K3n7v95032211
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 11:49:07 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 11:49:07 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 11:49:06 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 20 May 2022 11:49:06 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 02/10] rtw88: Drop rf_lock
Thread-Topic: [PATCH 02/10] rtw88: Drop rf_lock
Thread-Index: AQHYapDlgq6QOJi2/ECBVrobkErMtK0mndSA
Date:   Fri, 20 May 2022 03:49:06 +0000
Message-ID: <af80039404cb3eb9dd036ab5734ddea95d31cf49.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-3-s.hauer@pengutronix.de>
In-Reply-To: <20220518082318.3898514-3-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.17.21]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMTkg5LiL5Y2IIDEwOjI2OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FF09FC40C091947BB12E5E2F37A7C6C@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA1LTE4IGF0IDEwOjIzICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IFRoZSBydHdkZXYtPnJmX2xvY2sgc3BpbmxvY2sgcHJvdGVjdHMgdGhlIHJmIHJlZ2lzdGVyIGFj
Y2Vzc2VzIGluDQo+IHJ0d19yZWFkX3JmKCkgYW5kIHJ0d193cml0ZV9yZigpLiBNb3N0IGNhbGxl
cnMgb2YgdGhlc2UgZnVuY3Rpb25zIGhvbGQNCj4gcnR3ZGV2LT5tdXRleCBhbHJlYWR5IHdpdGgg
dGhlIGV4Y2VwdGlvbiBvZiB0aGUgY2FsbHNpdGVzIGluIHRoZSBkZWJ1Z2ZzDQo+IGNvZGUuIFRo
ZSBkZWJ1Z2ZzIGNvZGUgZG9lc24ndCBqdXN0aWZ5IGFuIGV4dHJhIGxvY2ssIHNvIGFjcXVpcmUg
dGhlIG11dGV4DQo+IHRoZXJlIGFzIHdlbGwgYmVmb3JlIGNhbGxpbmcgcmYgcmVnaXN0ZXIgYWNj
ZXNzb3JzIGFuZCBkcm9wIHRoZSBub3cNCj4gdW5uZWNlc3Nhcnkgc3BpbmxvY2suDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBTYXNjaGEgSGF1ZXIgPHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU+DQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9kZWJ1Zy5jIHwgMTEgKysr
KysrKysrKysNCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvaGNpLmggICB8
ICA5ICsrKy0tLS0tLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9tYWlu
LmMgIHwgIDEgLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9tYWluLmgg
IHwgIDMgLS0tDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDEwIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvZGVidWcuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvZGVi
dWcuYw0KPiBpbmRleCAxYTUyZmY1ODVmYmM3Li5iYTViYTg1MmVmYjhjIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L2RlYnVnLmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9kZWJ1Zy5jDQo+IA0KDQpbLi4uXQ0KDQo+
IEBAIC01MjMsNiArNTI3LDggQEAgc3RhdGljIGludCBydHdfZGVidWdfZ2V0X3JmX2R1bXAoc3Ry
dWN0IHNlcV9maWxlICptLCB2b2lkICp2KQ0KPiAgCXUzMiBhZGRyLCBvZmZzZXQsIGRhdGE7DQo+
ICAJdTggcGF0aDsNCj4gIA0KPiArCW11dGV4X2xvY2soJnJ0d2Rldi0+bXV0ZXgpOw0KPiArDQo+
ICAJZm9yIChwYXRoID0gMDsgcGF0aCA8IHJ0d2Rldi0+aGFsLnJmX3BhdGhfbnVtOyBwYXRoKysp
IHsNCj4gIAkJc2VxX3ByaW50ZihtLCAiUkYgcGF0aDolZFxuIiwgcGF0aCk7DQo+ICAJCWZvciAo
YWRkciA9IDA7IGFkZHIgPCAweDEwMDsgYWRkciArPSA0KSB7DQo+IEBAIC01MzcsNiArNTQzLDgg
QEAgc3RhdGljIGludCBydHdfZGVidWdfZ2V0X3JmX2R1bXAoc3RydWN0IHNlcV9maWxlICptLCB2
b2lkICp2KQ0KPiAgCQlzZXFfcHV0cyhtLCAiXG4iKTsNCj4gIAl9DQo+ICANCj4gKwltdXRleF91
bmxvY2soJnJ0d2Rldi0+bXV0ZXgpOw0KPiArDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IA0KDQpU
aGlzIHdpbGwgdGFrZSB0aW1lIHRvIGR1bXAgYWxsIFJGIHJlZ2lzdGVycyBmb3IgZGVidWdnaW5n
DQpwdXJwb3NlLiBGb3IgUENJIGludGVyZmFjZSwgSSB0aGluayB0aGlzIHdvdWxkIGJlIG9rYXku
DQpDb3VsZCB5b3UgdHJ5IHRvIGR1bXAgcmVnaXN0ZXJzIHZpYSBkZWJ1ZnMgd2hpbGUgeW91IGFy
ZQ0KdXNpbmcgYSBVU0IgV2lGaSBkZXZpY2UsIHN1Y2ggYXMgcGxheSBZb3V0dWJlIG9yIGRvd25s
b2FkIGZpbGVzLi4uDQoNCklmIGl0IGRvZXNuJ3Qgd29yayB2ZXJ5IHdlbGwsIEkgc3VnZ2VzdCB0
byB1c2UgcmZfbXV0ZXggdG8NCnJlcGxhY2UgcmZfbG9jayBpbnBsYWNlLCBidXQgbm90IGp1c3Qg
cmVtb3ZlIHJmX2xvY2suDQoNCi0tDQpQaW5nLUtlDQoNCg0K
