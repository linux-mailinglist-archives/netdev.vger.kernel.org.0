Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E0931B94B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 13:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhBOMbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 07:31:17 -0500
Received: from mail.a-eberle.de ([213.95.140.213]:60056 "EHLO mail.a-eberle.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhBOMbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 07:31:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.a-eberle.de (Postfix) with ESMTP id ADDF9380558
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:30:00 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aeberle-mx.softwerk.noris.de
Received: from mail.a-eberle.de ([127.0.0.1])
        by localhost (ebl-mx-02.a-eberle.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BiIwAyg_q4BQ for <netdev@vger.kernel.org>;
        Mon, 15 Feb 2021 13:29:59 +0100 (CET)
Received: from gateway.a-eberle.de (unknown [178.15.155.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "sg310.eberle.local", Issuer "A. Eberle GmbH & Co. KG WebAdmin CA" (not verified))
        (Authenticated sender: postmaster@a-eberle.de)
        by mail.a-eberle.de (Postfix) with ESMTPSA
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:29:59 +0100 (CET)
Received: from exch-svr2013.eberle.local ([192.168.1.9]:29336 helo=webmail.a-eberle.de)
        by gateway.a-eberle.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Marco.Wenzel@a-eberle.de>)
        id 1lBd0e-0006j2-2T; Mon, 15 Feb 2021 13:29:48 +0100
Received: from EXCH-SVR2013.eberle.local (192.168.1.9) by
 EXCH-SVR2013.eberle.local (192.168.1.9) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Feb 2021 13:29:49 +0100
Received: from EXCH-SVR2013.eberle.local ([::1]) by EXCH-SVR2013.eberle.local
 ([::1]) with mapi id 15.00.1497.006; Mon, 15 Feb 2021 13:29:48 +0100
From:   "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
To:     George McCollister <george.mccollister@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: AW: HSR/PRP sequence counter issue with Cisco Redbox
Thread-Topic: HSR/PRP sequence counter issue with Cisco Redbox
Thread-Index: Adb0oMB5N/nh+lgRSvKGIOcbXjKnGABIcvMAA3RX9HA=
Date:   Mon, 15 Feb 2021 12:29:48 +0000
Message-ID: <11291f9b05764307b660049e2290dd10@EXCH-SVR2013.eberle.local>
References: <69ec2fd1a9a048e8b3305a4bc36aad01@EXCH-SVR2013.eberle.local>
 <CAFSKS=MTUD_h0RFQ7R80ef-jT=0Zp1w5Ptt6r8+GkaboX3L_TA@mail.gmail.com>
In-Reply-To: <CAFSKS=MTUD_h0RFQ7R80ef-jT=0Zp1w5Ptt6r8+GkaboX3L_TA@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.242.2.55]
x-kse-serverinfo: EXCH-SVR2013.eberle.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 15.02.2021 09:01:00
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIEphbiAyNywgMjAyMSBhdCA2OjMyIEFNIFdlbnplbCwgTWFyY28gPE1hcmNvLldl
bnplbEBhLQ0KPiBlYmVybGUuZGU+IHdyb3RlOg0KPiA+DQo+ID4gSGksDQo+ID4NCj4gPiB3ZSBo
YXZlIGZpZ3VyZWQgb3V0IGFuIGlzc3VlIHdpdGggdGhlIGN1cnJlbnQgUFJQIGRyaXZlciB3aGVu
IHRyeWluZyB0bw0KPiBjb21tdW5pY2F0ZSB3aXRoIENpc2NvIElFIDIwMDAgaW5kdXN0cmlhbCBF
dGhlcm5ldCBzd2l0Y2hlcyBpbiBSZWRib3gNCj4gbW9kZS4gVGhlIENpc2NvIGFsd2F5cyByZXNl
dHMgdGhlIEhTUi9QUlAgc2VxdWVuY2UgY291bnRlciB0byAiMSIgYXQgbG93DQo+IHRyYWZmaWMg
KDw9IDEgZnJhbWUgaW4gNDAwIG1zKS4gSXQgY2FuIGJlIHJlcHJvZHVjZWQgYnkgYSBzaW1wbGUg
SUNNUCBlY2hvDQo+IHJlcXVlc3Qgd2l0aCAxIHMgaW50ZXJ2YWwgYmV0d2VlbiBhIExpbnV4IGJv
eCBydW5uaW5nIHdpdGggUFJQIGFuZCBhIFZEQU4NCj4gYmVoaW5kIHRoZSBDaXNjbyBSZWRib3gu
IFRoZSBMaW51eCBib3ggdGhlbiBhbHdheXMgcmVjZWl2ZXMgZnJhbWVzIHdpdGgNCj4gc2VxdWVu
Y2UgY291bnRlciAiMSIgYW5kIGRyb3BzIHRoZW0uIFRoZSBiZWhhdmlvciBpcyBub3QgY29uZmln
dXJhYmxlIGF0DQo+IHRoZSBDaXNjbyBSZWRib3guDQo+ID4NCj4gPiBJIGZpeGVkIGl0IGJ5IGln
bm9yaW5nIHNlcXVlbmNlIGNvdW50ZXJzIHdpdGggdmFsdWUgIjEiIGF0IHRoZSBzZXF1ZW5jZQ0K
PiBjb3VudGVyIGNoZWNrIGluIGhzcl9yZWdpc3Rlcl9mcmFtZV9vdXQgKCk6DQo+ID4NCj4gPiBk
aWZmIC0tZ2l0IGEvbmV0L2hzci9oc3JfZnJhbWVyZWcuYyBiL25ldC9oc3IvaHNyX2ZyYW1lcmVn
LmMgaW5kZXgNCj4gPiA1Yzk3ZGU0NTk5MDUuLjYzMGMyMzhlODFmMCAxMDA2NDQNCj4gPiAtLS0g
YS9uZXQvaHNyL2hzcl9mcmFtZXJlZy5jDQo+ID4gKysrIGIvbmV0L2hzci9oc3JfZnJhbWVyZWcu
Yw0KPiA+IEBAIC00MTEsNyArNDExLDcgQEAgdm9pZCBoc3JfcmVnaXN0ZXJfZnJhbWVfaW4oc3Ry
dWN0IGhzcl9ub2RlICpub2RlLA0KPiA+IHN0cnVjdCBoc3JfcG9ydCAqcG9ydCwgIGludCBoc3Jf
cmVnaXN0ZXJfZnJhbWVfb3V0KHN0cnVjdCBoc3JfcG9ydCAqcG9ydCwNCj4gc3RydWN0IGhzcl9u
b2RlICpub2RlLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHUxNiBzZXF1ZW5jZV9u
cikgIHsNCj4gPiAtICAgICAgIGlmIChzZXFfbnJfYmVmb3JlX29yX2VxKHNlcXVlbmNlX25yLCBu
b2RlLT5zZXFfb3V0W3BvcnQtPnR5cGVdKSkNCj4gPiArICAgICAgIGlmIChzZXFfbnJfYmVmb3Jl
X29yX2VxKHNlcXVlbmNlX25yLA0KPiA+ICsgbm9kZS0+c2VxX291dFtwb3J0LT50eXBlXSkgJiYg
KHNlcXVlbmNlX25yICE9IDEpKQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gMTsNCj4gPg0K
PiA+ICAgICAgICAgbm9kZS0+c2VxX291dFtwb3J0LT50eXBlXSA9IHNlcXVlbmNlX25yOw0KPiA+
DQo+ID4NCj4gPiBEbyB5b3UgdGhpbmsgdGhpcyBjb3VsZCBiZSBhIHNvbHV0aW9uPyBTaG91bGQg
dGhpcyBwYXRjaCBiZSBvZmZpY2lhbGx5IGFwcGxpZWQNCj4gaW4gb3JkZXIgdG8gYXZvaWQgb3Ro
ZXIgdXNlcnMgcnVubmluZyBpbnRvIHRoZXNlIGNvbW11bmljYXRpb24gaXNzdWVzPw0KPiANCj4g
VGhpcyBpc24ndCB0aGUgY29ycmVjdCB3YXkgdG8gc29sdmUgdGhlIHByb2JsZW0uIElFQyA2MjQz
OS0zIGRlZmluZXMNCj4gRW50cnlGb3JnZXRUaW1lIGFzICJUaW1lIGFmdGVyIHdoaWNoIGFuIGVu
dHJ5IGlzIHJlbW92ZWQgZnJvbSB0aGUgZHVwbGljYXRlDQo+IHRhYmxlIiB3aXRoIGEgdmFsdWUg
b2YgNDAwbXMgYW5kIHN0YXRlcyBkZXZpY2VzIHNob3VsZCB1c3VhbGx5IGJlIGNvbmZpZ3VyZWQN
Cj4gdG8ga2VlcCBlbnRyaWVzIGluIHRoZSB0YWJsZSBmb3IgYSBtdWNoIHNob3J0ZXIgdGltZS4g
aHNyX2ZyYW1lcmVnLmMgbmVlZHMgdG8NCj4gYmUgcmV3b3JrZWQgdG8gaGFuZGxlIHRoaXMgYWNj
b3JkaW5nIHRvIHRoZSBzcGVjaWZpY2F0aW9uLg0KDQpTb3JyeSBmb3IgdGhlIGRlbGF5IGJ1dCBJ
IGRpZCBub3QgaGF2ZSB0aGUgdGltZSB0byB0YWtlIGEgY2xvc2VyIGxvb2sgYXQgdGhlIHByb2Js
ZW0gdW50aWwgbm93LiANCg0KTXkgc3VnZ2VzdGlvbiBmb3IgdGhlIEVudHJ5Rm9yZ2V0VGltZSBm
ZWF0dXJlIHdvdWxkIGJlIHRoZSBmb2xsb3dpbmc6IEEgdGltZV9vdXQgZWxlbWVudCB3aWxsIGJl
IGFkZGVkIHRvIHRoZSBoc3Jfbm9kZSBzdHJ1Y3R1cmUsIHdoaWNoIGFsd2F5cyBzdG9yZXMgdGhl
IGN1cnJlbnQgdGltZSB3aGVuIGVudGVyaW5nIGhzcl9yZWdpc3Rlcl9mcmFtZV9vdXQoKS4gSWYg
dGhlIGxhc3Qgc3RvcmVkIHRpbWUgaXMgb2xkZXIgdGhhbiBFbnRyeUZvcmdldFRpbWUgKDQwMCBt
cykgdGhlIHNlcXVlbmNlIG51bWJlciBjaGVjayB3aWxsIGJlIGlnbm9yZWQuDQoNCmRpZmYgLS1n
aXQgYS9uZXQvaHNyL2hzcl9mcmFtZXJlZy5jIGIvbmV0L2hzci9oc3JfZnJhbWVyZWcuYw0KaW5k
ZXggNWM5N2RlNDU5OTA1Li5hOTdiZmZiZDI1ODEgMTAwNjQ0DQotLS0gYS9uZXQvaHNyL2hzcl9m
cmFtZXJlZy5jDQorKysgYi9uZXQvaHNyL2hzcl9mcmFtZXJlZy5jDQpAQCAtMTY0LDggKzE2NCwx
MCBAQCBzdGF0aWMgc3RydWN0IGhzcl9ub2RlICpoc3JfYWRkX25vZGUoc3RydWN0IGhzcl9wcml2
ICpoc3IsDQogCSAqIGFzIGluaXRpYWxpemF0aW9uLiAoMCBjb3VsZCB0cmlnZ2VyIGFuIHNwdXJp
b3VzIHJpbmcgZXJyb3Igd2FybmluZykuDQogCSAqLw0KIAlub3cgPSBqaWZmaWVzOw0KLQlmb3Ig
KGkgPSAwOyBpIDwgSFNSX1BUX1BPUlRTOyBpKyspDQorCWZvciAoaSA9IDA7IGkgPCBIU1JfUFRf
UE9SVFM7IGkrKykgew0KIAkJbmV3X25vZGUtPnRpbWVfaW5baV0gPSBub3c7DQorCQluZXdfbm9k
ZS0+dGltZV9vdXRbaV0gPSBub3c7DQorCX0NCiAJZm9yIChpID0gMDsgaSA8IEhTUl9QVF9QT1JU
UzsgaSsrKQ0KIAkJbmV3X25vZGUtPnNlcV9vdXRbaV0gPSBzZXFfb3V0Ow0KIA0KQEAgLTQxMSw5
ICs0MTMsMTIgQEAgdm9pZCBoc3JfcmVnaXN0ZXJfZnJhbWVfaW4oc3RydWN0IGhzcl9ub2RlICpu
b2RlLCBzdHJ1Y3QgaHNyX3BvcnQgKnBvcnQsDQogaW50IGhzcl9yZWdpc3Rlcl9mcmFtZV9vdXQo
c3RydWN0IGhzcl9wb3J0ICpwb3J0LCBzdHJ1Y3QgaHNyX25vZGUgKm5vZGUsDQogCQkJICAgdTE2
IHNlcXVlbmNlX25yKQ0KIHsNCi0JaWYgKHNlcV9ucl9iZWZvcmVfb3JfZXEoc2VxdWVuY2VfbnIs
IG5vZGUtPnNlcV9vdXRbcG9ydC0+dHlwZV0pKQ0KKwlpZiAoc2VxX25yX2JlZm9yZV9vcl9lcShz
ZXF1ZW5jZV9uciwgbm9kZS0+c2VxX291dFtwb3J0LT50eXBlXSkgJiYNCisJCSB0aW1lX2lzX2Fm
dGVyX2ppZmZpZXMobm9kZS0+dGltZV9vdXRbcG9ydC0+dHlwZV0gKyBtc2Vjc190b19qaWZmaWVz
KEhTUl9FTlRSWV9GT1JHRVRfVElNRSkpKSB7DQogCQlyZXR1cm4gMTsNCisJfQ0KIA0KKwlub2Rl
LT50aW1lX291dFtwb3J0LT50eXBlXSA9IGppZmZpZXM7DQogCW5vZGUtPnNlcV9vdXRbcG9ydC0+
dHlwZV0gPSBzZXF1ZW5jZV9ucjsNCiAJcmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL25ldC9o
c3IvaHNyX2ZyYW1lcmVnLmggYi9uZXQvaHNyL2hzcl9mcmFtZXJlZy5oDQppbmRleCA4NmI0M2Y1
MzlmMmMuLmQ5NjI4ZTdhNWYwNSAxMDA2NDQNCi0tLSBhL25ldC9oc3IvaHNyX2ZyYW1lcmVnLmgN
CisrKyBiL25ldC9oc3IvaHNyX2ZyYW1lcmVnLmgNCkBAIC03NSw2ICs3NSw3IEBAIHN0cnVjdCBo
c3Jfbm9kZSB7DQogCWVudW0gaHNyX3BvcnRfdHlwZQlhZGRyX0JfcG9ydDsNCiAJdW5zaWduZWQg
bG9uZwkJdGltZV9pbltIU1JfUFRfUE9SVFNdOw0KIAlib29sCQkJdGltZV9pbl9zdGFsZVtIU1Jf
UFRfUE9SVFNdOw0KKwl1bnNpZ25lZCBsb25nCQl0aW1lX291dFtIU1JfUFRfUE9SVFNdOw0KIAkv
KiBpZiB0aGUgbm9kZSBpcyBhIFNBTiAqLw0KIAlib29sCQkJc2FuX2E7DQogCWJvb2wJCQlzYW5f
YjsNCmRpZmYgLS1naXQgYS9uZXQvaHNyL2hzcl9tYWluLmggYi9uZXQvaHNyL2hzcl9tYWluLmgN
CmluZGV4IDdkYzkyY2U1YTEzNC4uZjc5Y2E1NWQ2OTg2IDEwMDY0NA0KLS0tIGEvbmV0L2hzci9o
c3JfbWFpbi5oDQorKysgYi9uZXQvaHNyL2hzcl9tYWluLmgNCkBAIC0yMSw2ICsyMSw3IEBADQog
I2RlZmluZSBIU1JfTElGRV9DSEVDS19JTlRFUlZBTAkJIDIwMDAgLyogbXMgKi8NCiAjZGVmaW5l
IEhTUl9OT0RFX0ZPUkdFVF9USU1FCQk2MDAwMCAvKiBtcyAqLw0KICNkZWZpbmUgSFNSX0FOTk9V
TkNFX0lOVEVSVkFMCQkgIDEwMCAvKiBtcyAqLw0KKyNkZWZpbmUgSFNSX0VOVFJZX0ZPUkdFVF9U
SU1FCQkgIDQwMCAvKiBtcyAqLw0KIA0KIC8qIEJ5IGhvdyBtdWNoIG1heSBzbGF2ZTEgYW5kIHNs
YXZlMiB0aW1lc3RhbXBzIG9mIGxhdGVzdCByZWNlaXZlZCBmcmFtZSBmcm9tDQogICogZWFjaCBu
b2RlIGRpZmZlciBiZWZvcmUgd2Ugbm90aWZ5IG9mIGNvbW11bmljYXRpb24gcHJvYmxlbT8NCg0K
DQpUaGlzIGFwcHJvYWNoIHdvcmtzIGZpbmUgd2l0aCB0aGUgQ2lzY28gSUUgMjAwMCBhbmQgSSB0
aGluayBpdCBpbXBsZW1lbnRzIHRoZSBjb3JyZWN0IHdheSB0byBoYW5kbGUgc2VxdWVuY2UgbnVt
YmVycyBhcyBkZWZpbmVkIGluIElFQyA2MjQzOS0zLg0KDQpSZWdhcmRzLA0KTWFyY28gV2VuemVs
DQoNCj4gPg0KPiA+IFRoYW5rcw0KPiA+IE1hcmNvIFdlbnplbA0KPiANCj4gUmVnYXJkcywNCj4g
R2VvcmdlIE1jQ29sbGlzdGVyDQo=
