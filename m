Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA12E7F2E
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 11:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgLaKCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 05:02:11 -0500
Received: from smtp.h3c.com ([60.191.123.50]:12010 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgLaKCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 05:02:10 -0500
Received: from DAG2EX07-IDC.srv.huawei-3com.com ([10.8.0.70])
        by h3cspam02-ex.h3c.com with ESMTP id 0BVA0ASa034262;
        Thu, 31 Dec 2020 18:00:10 +0800 (GMT-8)
        (envelope-from gao.yanB@h3c.com)
Received: from DAG2EX08-IDC.srv.huawei-3com.com (10.8.0.71) by
 DAG2EX07-IDC.srv.huawei-3com.com (10.8.0.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 31 Dec 2020 18:00:13 +0800
Received: from DAG2EX08-IDC.srv.huawei-3com.com ([fe80::81d1:43f5:5563:4c58])
 by DAG2EX08-IDC.srv.huawei-3com.com ([fe80::81d1:43f5:5563:4c58%10]) with
 mapi id 15.01.2106.002; Thu, 31 Dec 2020 18:00:13 +0800
From:   Gaoyan <gao.yanB@h3c.com>
To:     "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldDogcmVtb3ZlIGRpc2NfZGF0YV9sb2NrIGlu?=
 =?utf-8?Q?_ppp_line_discipline?=
Thread-Topic: [PATCH] net: remove disc_data_lock in ppp line discipline
Thread-Index: AQHW3OrDdljHfTEdukqMzUeudaTjxKoQ+gbQ
Date:   Thu, 31 Dec 2020 10:00:12 +0000
Message-ID: <cfc4caad55554bf68bfae8a23c32950c@h3c.com>
References: <20201228071550.15745-1-gao.yanB@h3c.com>
In-Reply-To: <20201228071550.15745-1-gao.yanB@h3c.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.161.27]
x-sender-location: DAG2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com 0BVA0ASa034262
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBhbGzvvJoNCg0KQ291bGQgSSBnZXQgeW91ciBjb21tZW50cyBmb3IgdGhlIHVwZGF0ZXM/
ICBJZiBJIGNhbiBnZXQgYSByZXBseSwgaXQgd2lsbCBoZWxwIG1lIGEgbG90IC4gVGhhbmtzDQoN
Cmh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIwLzEyLzI4LzE5DQoNCg0KDQoqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqDQoNCg0KLS0tLU9yaWdpbmFsIG1haWwgLS0tLS0NCuWPkeS7tuS6
ujogZ2FveWFuIChSRCkgDQrlj5HpgIHml7bpl7Q6IDIwMjDlubQxMuaciDI45pelIDE1OjE2DQrm
lLbku7bkuro6IHBhdWx1c0BzYW1iYS5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2Vy
bmVsLm9yZw0K5oqE6YCBOiBsaW51eC1wcHBAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBnYW95YW4gKFJEKSA8Z2Fv
LnlhbkJAaDNjLmNvbT4NCuS4u+mimDogW1BBVENIXSBuZXQ6IHJlbW92ZSBkaXNjX2RhdGFfbG9j
ayBpbiBwcHAgbGluZSBkaXNjaXBsaW5lDQoNCkluIHR0eSBsYXllciwgaXQgdXNlIHR0eS0+bGRp
c2Nfc2VtIHRvIHByb2VjdCB0dHlfbGRpc2Nfb3BzLg0KU28gSSB0aGluayB0dHktPmxkaXNjX3Nl
bSBjYW4gYWxzbyBwcm90ZWN0IHR0eS0+ZGlzY19kYXRhOyBGb3IgZXhhbWxwZSwgV2hlbiBjcHUg
QSBpcyBydW5uaW5nIHBwcF9zeW5jdHR5X2lvY3RsIHRoYXQgaG9sZCB0aGUgdHR5LT5sZGlzY19z
ZW0sIGF0IHRoZSBzYW1lIHRpbWUgIGlmIGNwdSBCIGNhbGxzIHBwcF9zeW5jdHR5X2Nsb3NlLCBp
dCB3aWxsIHdhaXQgdW50aWwgY3B1IEEgcmVsZWFzZSB0dHktPmxkaXNjX3NlbS4gU28gSSB0aGlu
ayBpdCBpcyB1bm5lY2Vzc2FyeSB0byBoYXZlIHRoZSBkaXNjX2RhdGFfbG9jazsNCg0KY3B1IEEg
ICAgICAgICAgICAgICAgICAgICAgICAgICBjcHUgQg0KdHR5X2lvY3RsICAgICAgICAgICAgICAg
ICAgICAgICB0dHlfcmVvcGVuDQogLT5ob2xkIHR0eS0+bGRpc2Nfc2VtICAgICAgICAgICAgLT5o
b2xkIHR0eS0+bGRpc2Nfc2VtKHdyaXRlKSwgZmFpbGVkDQogLT5sZC0+b3BzLT5pb2N0bCAgICAg
ICAgICAgICAgICAgLT53YWl0Li4uDQogLT5yZWxlYXNlIHR0eS0+bGRpc2Nfc2VtICAgICAgICAg
LT53YWl0Li4uT0ssaG9sZCB0dHktPmxkaXNjX3NlbQ0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgLT50dHlfbGRpc2NfcmVpbml0DQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIC0+dHR5X2xkaXNjX2Nsb3NlDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgLT5sZC0+b3BzLT5jbG9zZQ0KDQpTaWduZWQtb2ZmLWJ5OiBHYW8gWWFu
IDxnYW8ueWFuQkBoM2MuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvcHBwL3BwcF9hc3luYy5jICAg
fCAxMSArKy0tLS0tLS0tLQ0KIGRyaXZlcnMvbmV0L3BwcC9wcHBfc3luY3R0eS5jIHwgMTIgKyst
LS0tLS0tLS0tDQogMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDE5IGRlbGV0aW9u
cygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcHBwL3BwcF9hc3luYy5jIGIvZHJpdmVy
cy9uZXQvcHBwL3BwcF9hc3luYy5jIGluZGV4IDI5YTA5MTdhOC4uMjBiNTBmYWNkIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvcHBwL3BwcF9hc3luYy5jDQorKysgYi9kcml2ZXJzL25ldC9wcHAv
cHBwX2FzeW5jLmMNCkBAIC0xMjcsMTcgKzEyNywxMyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHBw
cF9jaGFubmVsX29wcyBhc3luY19vcHMgPSB7DQogICogRklYTUU6IHRoaXMgaXMgbm8gbG9uZ2Vy
IHRydWUuIFRoZSBfY2xvc2UgcGF0aCBmb3IgdGhlIGxkaXNjIGlzDQogICogbm93IGd1YXJhbnRl
ZWQgdG8gYmUgc2FuZS4NCiAgKi8NCi1zdGF0aWMgREVGSU5FX1JXTE9DSyhkaXNjX2RhdGFfbG9j
ayk7DQogDQogc3RhdGljIHN0cnVjdCBhc3luY3BwcCAqYXBfZ2V0KHN0cnVjdCB0dHlfc3RydWN0
ICp0dHkpICB7DQotCXN0cnVjdCBhc3luY3BwcCAqYXA7DQorCXN0cnVjdCBhc3luY3BwcCAqYXAg
PSB0dHktPmRpc2NfZGF0YTsNCiANCi0JcmVhZF9sb2NrKCZkaXNjX2RhdGFfbG9jayk7DQotCWFw
ID0gdHR5LT5kaXNjX2RhdGE7DQogCWlmIChhcCAhPSBOVUxMKQ0KIAkJcmVmY291bnRfaW5jKCZh
cC0+cmVmY250KTsNCi0JcmVhZF91bmxvY2soJmRpc2NfZGF0YV9sb2NrKTsNCiAJcmV0dXJuIGFw
Ow0KIH0NCiANCkBAIC0yMTQsMTIgKzIxMCw5IEBAIHBwcF9hc3luY3R0eV9vcGVuKHN0cnVjdCB0
dHlfc3RydWN0ICp0dHkpICBzdGF0aWMgdm9pZCAgcHBwX2FzeW5jdHR5X2Nsb3NlKHN0cnVjdCB0
dHlfc3RydWN0ICp0dHkpICB7DQotCXN0cnVjdCBhc3luY3BwcCAqYXA7DQorCXN0cnVjdCBhc3lu
Y3BwcCAqYXAgPSB0dHktPmRpc2NfZGF0YTsNCiANCi0Jd3JpdGVfbG9ja19pcnEoJmRpc2NfZGF0
YV9sb2NrKTsNCi0JYXAgPSB0dHktPmRpc2NfZGF0YTsNCiAJdHR5LT5kaXNjX2RhdGEgPSBOVUxM
Ow0KLQl3cml0ZV91bmxvY2tfaXJxKCZkaXNjX2RhdGFfbG9jayk7DQogCWlmICghYXApDQogCQly
ZXR1cm47DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcHBwL3BwcF9zeW5jdHR5LmMgYi9k
cml2ZXJzL25ldC9wcHAvcHBwX3N5bmN0dHkuYyBpbmRleCAwZjMzODc1MmMuLjUzZmI2OGUyOSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3BwcC9wcHBfc3luY3R0eS5jDQorKysgYi9kcml2ZXJz
L25ldC9wcHAvcHBwX3N5bmN0dHkuYw0KQEAgLTEyOSwxNyArMTI5LDEyIEBAIHBwcF9wcmludF9i
dWZmZXIgKGNvbnN0IGNoYXIgKm5hbWUsIGNvbnN0IF9fdTggKmJ1ZiwgaW50IGNvdW50KQ0KICAq
DQogICogRklYTUU6IEZpeGVkIGluIHR0eV9pbyBub3dhZGF5cy4NCiAgKi8NCi1zdGF0aWMgREVG
SU5FX1JXTE9DSyhkaXNjX2RhdGFfbG9jayk7DQotDQogc3RhdGljIHN0cnVjdCBzeW5jcHBwICpz
cF9nZXQoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSkgIHsNCi0Jc3RydWN0IHN5bmNwcHAgKmFwOw0K
KwlzdHJ1Y3Qgc3luY3BwcCAqYXAgPSB0dHktPmRpc2NfZGF0YTsNCiANCi0JcmVhZF9sb2NrKCZk
aXNjX2RhdGFfbG9jayk7DQotCWFwID0gdHR5LT5kaXNjX2RhdGE7DQogCWlmIChhcCAhPSBOVUxM
KQ0KIAkJcmVmY291bnRfaW5jKCZhcC0+cmVmY250KTsNCi0JcmVhZF91bmxvY2soJmRpc2NfZGF0
YV9sb2NrKTsNCiAJcmV0dXJuIGFwOw0KIH0NCiANCkBAIC0yMTMsMTIgKzIwOCw5IEBAIHBwcF9z
eW5jX29wZW4oc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSkgIHN0YXRpYyB2b2lkICBwcHBfc3luY19j
bG9zZShzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5KSAgew0KLQlzdHJ1Y3Qgc3luY3BwcCAqYXA7DQor
CXN0cnVjdCBzeW5jcHBwICphcCA9IHR0eS0+ZGlzY19kYXRhOw0KIA0KLQl3cml0ZV9sb2NrX2ly
cSgmZGlzY19kYXRhX2xvY2spOw0KLQlhcCA9IHR0eS0+ZGlzY19kYXRhOw0KIAl0dHktPmRpc2Nf
ZGF0YSA9IE5VTEw7DQotCXdyaXRlX3VubG9ja19pcnEoJmRpc2NfZGF0YV9sb2NrKTsNCiAJaWYg
KCFhcCkNCiAJCXJldHVybjsNCiANCi0tDQoyLjE3LjENCg0K
