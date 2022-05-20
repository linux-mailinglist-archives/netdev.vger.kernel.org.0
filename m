Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CD552E6AA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346698AbiETH53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbiETH51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:57:27 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7735B14AF70;
        Fri, 20 May 2022 00:57:23 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24K7upUfB003021, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24K7upUfB003021
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 15:56:51 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 15:56:51 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 15:56:51 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 20 May 2022 15:56:50 +0800
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
Subject: Re: [PATCH 08/10] rtw88: Add rtw8821cu chipset support
Thread-Topic: [PATCH 08/10] rtw88: Add rtw8821cu chipset support
Thread-Index: AQHYapDbtAOsOzqJ2UWnXTIaannuw60m4wsA
Date:   Fri, 20 May 2022 07:56:50 +0000
Message-ID: <3adb9f734408967f49245fb45ea4ca5fb6d71593.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-9-s.hauer@pengutronix.de>
In-Reply-To: <20220518082318.3898514-9-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.17.21]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMjAg5LiK5Y2IIDA2OjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <2279B04E8F827446A61419D402B6BEE7@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA1LTE4IGF0IDEwOjIzICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IEFkZCBzdXBwb3J0IGZvciB0aGUgcnR3ODgyMWN1IGNoaXBzZXQgYmFzZWQgb24NCj4gaHR0cHM6
Ly9naXRodWIuY29tL3VsbGkta3JvbGwvcnR3ODgtdXNiLmdpdA0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvS2NvbmZpZyAgICB8IDExICsrKw0KPiAgZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9NYWtlZmlsZSAgIHwgIDMgKw0KPiAgZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIxYy5jIHwgMjMgKysrKysrKw0K
PiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIxYy5oIHwgMjEgKysr
KysrDQo+ICAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWN1LmMgICAgfCA2
OSArKysrKysrKysrKysrKysrKysrDQo+ICAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgv
cnR3ODgyMWN1LmggICAgfCAxNSArKysrDQo+ICA2IGZpbGVzIGNoYW5nZWQsIDE0MiBpbnNlcnRp
b25zKCspDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydHc4OC9ydHc4ODIxY3UuYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWN1LmgNCj4gDQoNClsuLi5dDQoNCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWN1LmMNCj4g
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjFjdS5jDQo+IG5ldyBm
aWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMDAuLmU2NzEwYzVlYmRmYzgNCj4g
LS0tIC9kZXYvbnVsbA0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4
L3J0dzg4MjFjdS5jDQo+IEBAIC0wLDAgKzEsNjkgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wIE9SIEJTRC0zLUNsYXVzZQ0KPiArLyogQ29weXJpZ2h0KGMpIDIwMTgt
MjAxOSAgUmVhbHRlayBDb3Jwb3JhdGlvbg0KPiArICovDQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51
eC9tb2R1bGUuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC91c2IuaD4NCj4gKyNpbmNsdWRlICJtYWlu
LmgiDQo+ICsjaW5jbHVkZSAicnR3ODgyMWN1LmgiDQo+ICsjaW5jbHVkZSAidXNiLmgiDQo+ICsN
Cj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBydHdfODgyMWN1X2lkX3RhYmxl
W10gPSB7DQo+ICsJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhSVFdfVVNCX1ZFTkRP
Ul9JRF9SRUFMVEVLLA0KPiArCQkJCQkweGI4MmIsDQo+ICsJCQkJCTB4ZmYsIDB4ZmYsIDB4ZmYp
LA0KPiArCSAgLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSYocnR3ODgyMWNfaHdfc3Bl
YykgfSwgLyogODgyMUNVICovDQo+ICsJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhS
VFdfVVNCX1ZFTkRPUl9JRF9SRUFMVEVLLA0KPiArCQkJCQkweGI4MjAsDQo+ICsJCQkJCTB4ZmYs
IDB4ZmYsIDB4ZmYpLA0KPiArCSAuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpJihydHc4
ODIxY19od19zcGVjKSB9LCAvKiA4ODIxQ1UgKi8NCj4gKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVS
RkFDRV9JTkZPKFJUV19VU0JfVkVORE9SX0lEX1JFQUxURUssDQo+ICsJCQkJCTB4QzgyMSwNCj4g
KwkJCQkJMHhmZiwgMHhmZiwgMHhmZiksDQo+ICsJIC5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxv
bmdfdCkmKHJ0dzg4MjFjX2h3X3NwZWMpIH0sIC8qIDg4MjFDVSAqLw0KPiArCXsgVVNCX0RFVklD
RV9BTkRfSU5URVJGQUNFX0lORk8oUlRXX1VTQl9WRU5ET1JfSURfUkVBTFRFSywNCj4gKwkJCQkJ
MHhDODIwLA0KPiArCQkJCQkweGZmLCAweGZmLCAweGZmKSwNCj4gKwkgLmRyaXZlcl9pbmZvID0g
KGtlcm5lbF91bG9uZ190KSYocnR3ODgyMWNfaHdfc3BlYykgfSwgLyogODgyMUNVICovDQo+ICsJ
eyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhSVFdfVVNCX1ZFTkRPUl9JRF9SRUFMVEVL
LA0KPiArCQkJCQkweEM4MkEsDQo+ICsJCQkJCTB4ZmYsIDB4ZmYsIDB4ZmYpLA0KPiArCSAuZHJp
dmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpJihydHc4ODIxY19od19zcGVjKSB9LCAvKiA4ODIx
Q1UgKi8NCj4gKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFJUV19VU0JfVkVORE9S
X0lEX1JFQUxURUssDQo+ICsJCQkJCTB4QzgyQiwNCj4gKwkJCQkJMHhmZiwgMHhmZiwgMHhmZiks
DQo+ICsJICAuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpJihydHc4ODIxY19od19zcGVj
KSB9LCAvKiA4ODIxQ1UgKi8NCj4gKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFJU
V19VU0JfVkVORE9SX0lEX1JFQUxURUssDQo+ICsJCQkJCTB4QzgxMSwNCj4gKwkJCQkJMHhmZiwg
MHhmZiwgMHhmZiksDQo+ICsJIC5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmKHJ0dzg4
MjFjX2h3X3NwZWMpIH0sIC8qIDg4MTFDVSAqLw0KPiArCXsgVVNCX0RFVklDRV9BTkRfSU5URVJG
QUNFX0lORk8oUlRXX1VTQl9WRU5ET1JfSURfUkVBTFRFSywNCj4gKwkJCQkJMHg4ODExLA0KPiAr
CQkJCQkweGZmLCAweGZmLCAweGZmKSwNCj4gKwkuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25n
X3QpJihydHc4ODIxY19od19zcGVjKSB9LCAvKiA4ODExQ1UgKi8NCj4gKwkvKj09PSBDdXN0b21l
ciBJRCA9PT0qLw0KPiArCXsgVVNCX0RFVklDRSgweDBiZGEsIDB4MjAwNiksDQoNClVTQl9ERVZJ
Q0UoUlRXX1VTQl9WRU5ET1JfSURfUkVBTFRFSywgMHgyMDA2KSwNCg0KPiArCSAgLmRyaXZlcl9p
bmZvID0gKGtlcm5lbF91bG9uZ190KSYocnR3ODgyMWNfaHdfc3BlYykgfSwgLyogVG90b2xpbmsg
Ki8NCj4gKwl7IFVTQl9ERVZJQ0UoMHgwYmRhLCAweGM4MTEpLA0KDQpVU0JfREVWSUNFKFJUV19V
U0JfVkVORE9SX0lEX1JFQUxURUssIDB4YzgxMSksDQoNCg0KPiArCSAgLmRyaXZlcl9pbmZvID0g
KGtlcm5lbF91bG9uZ190KSYocnR3ODgyMWNfaHdfc3BlYykgfSwgLyogU2ltcGxlY29tIE5XNjAy
ICovDQo+ICsJe30sDQo+ICt9Ow0KPiArTU9EVUxFX0RFVklDRV9UQUJMRSh1c2IsIHJ0d184ODIx
Y3VfaWRfdGFibGUpOw0KPiArDQo+IA0KDQpbLi4uXQ0KDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjFjdS5oDQo+IGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIxY3UuaA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0
NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAwLi5iZGRiZDk2YWE0NWZhDQo+IC0tLSAvZGV2L251bGwN
Cj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIxY3UuaA0K
PiBAQCAtMCwwICsxLDE1IEBADQo+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MCBPUiBCU0QtMy1DbGF1c2UgKi8NCj4gKy8qIENvcHlyaWdodChjKSAyMDE4LTIwMTkgIFJlYWx0
ZWsgQ29ycG9yYXRpb24NCj4gKyAqLw0KPiArDQo+ICsjaWZuZGVmIF9fUlRXXzg4MjFDVV9IXw0K
PiArI2RlZmluZSBfX1JUV184ODIxQ1VfSF8NCj4gKw0KPiArLyogVVNCIFZlbmRvci9Qcm9kdWN0
IElEcyAqLw0KPiArI2RlZmluZSBSVFdfVVNCX1ZFTkRPUl9JRF9SRUFMVEVLCQkweDBCREENCg0K
bW92ZSB0byB1c2IuaA0KDQo+ICsjZGVmaW5lIFJUV19VU0JfUFJPRFVDVF9JRF9SRUFMVEVLXzg4
MTFDCTB4QzgxMQ0KPiArI2RlZmluZSBSVFdfVVNCX1BST0RVQ1RfSURfUkVBTFRFS184ODIxQwkw
eEM4MUMNCg0KVGhlc2UgdHdvIGFyZSBub3QgdXNlZC4NCg0KPiArDQo+ICtleHRlcm4gc3RydWN0
IHJ0d19jaGlwX2luZm8gcnR3ODgyMWNfaHdfc3BlYzsNCj4gKw0KPiArI2VuZGlmDQoNCg0KLS0N
ClBpbmctS2UNCg0K
