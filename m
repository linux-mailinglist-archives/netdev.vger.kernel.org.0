Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BCA266698
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgIKRaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:30:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:5086 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726035AbgIKM5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 08:57:31 -0400
X-UUID: 1445cd8382324fd9b417b9a8bc326fb9-20200911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=9IxbvCYdqQwTMonJZE4jQEeGH8Ha8YJTXuQqIHNBJ30=;
        b=ZLIWB/+IhKpyNz53CsBLLnBg3ie3euRxAztpyNVKm3sxihJACWZ9muOV+vs2FSZpjZ6koIPEcmH6nxuSgDn7Bi0DvIyuhUlp27kWh2IiS7MuxByoDKhiDF4SjRPYppWMolA2it4eVVVTLbfCsIszZZctiB99fe36GDkp7ETOUds=;
X-UUID: 1445cd8382324fd9b417b9a8bc326fb9-20200911
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1764434070; Fri, 11 Sep 2020 20:57:18 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 11 Sep 2020 20:57:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 20:57:08 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <frank-w@public-files.de>,
        <opensource@vdorst.com>, <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next v4 0/6] net-next: dsa: mt7530: add support for MT7531 
Date:   Fri, 11 Sep 2020 20:56:22 +0800
Message-ID: <cover.1599825966.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBNVDc1MzEuDQoNCk1UNzUzMSBpcyB0
aGUgbmV4dCBnZW5lcmF0aW9uIG9mIE1UNzUzMCB3aGljaCBjb3VsZCBiZSBmb3VuZCBvbiBNZWRp
YXRlaw0Kcm91dGVyIHBsYXRmb3JtcyBzdWNoIGFzIE1UNzYyMiBvciBNVDc2MjkuDQoNCkl0IGlz
IGFsc28gYSA3LXBvcnRzIHN3aXRjaCB3aXRoIDUgZ2lnYSBlbWJlZGRlZCBwaHlzLCAyIGNwdSBw
b3J0cywgYW5kDQp0aGUgc2FtZSBNQUMgbG9naWMgb2YgTVQ3NTMwLiBDcHUgcG9ydCA2IG9ubHkg
c3VwcG9ydHMgU0dNSUkgaW50ZXJmYWNlLg0KQ3B1IHBvcnQgNSBzdXBwb3J0cyBlaXRoZXIgUkdN
SUkgb3IgU0dNSUkgaW4gZGlmZmVyZW50IEhXIFNLVSwgYnV0IGNhbm5vdA0KYmUgbXV4ZWQgdG8g
UEhZIG9mIHBvcnQgMC80IGxpa2UgbXQ3NTMwLiBEdWUgdG8gc3VwcG9ydCBmb3IgU0dNSUkNCmlu
dGVyZmFjZSwgcGxsLCBhbmQgcGFkIHNldHRpbmcgYXJlIGRpZmZlcmVudCBmcm9tIE1UNzUzMC4N
Cg0KTVQ3NTMxIFNHTUlJIGludGVyZmFjZSBjYW4gYmUgY29uZmlndXJlZCBpbiBmb2xsb3dpbmcg
bW9kZToNCi0gJ1NHTUlJIEFOIG1vZGUnIHdpdGggaW4tYmFuZCBuZWdvdGlhdGlvbiBjYXBhYmls
aXR5DQogICAgd2hpY2ggaXMgY29tcGF0aWJsZSB3aXRoIFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01J
SS4NCi0gJ1NHTUlJIGZvcmNlIG1vZGUnIHdpdGhvdXQgaW4tYmFuZCBuZWdvdGlhdGlvbg0KICAg
IHdoaWNoIGlzIGNvbXBhdGlibGUgd2l0aCAxMEIvOEIgZW5jb2Rpbmcgb2YNCiAgICBQSFlfSU5U
RVJGQUNFX01PREVfMTAwMEJBU0VYIHdpdGggZml4ZWQgZnVsbC1kdXBsZXggYW5kIGZpeGVkIHBh
dXNlLg0KLSAyLjUgdGltZXMgZmFzdGVyIGNsb2NrZWQgJ1NHTUlJIGZvcmNlIG1vZGUnIHdpdGhv
dXQgaW4tYmFuZCBuZWdvdGlhdGlvbg0KICAgIHdoaWNoIGlzIGNvbXBhdGlibGUgd2l0aCAxMEIv
OEIgZW5jb2Rpbmcgb2YNCiAgICBQSFlfSU5URVJGQUNFX01PREVfMjUwMEJBU0VYIHdpdGggZml4
ZWQgZnVsbC1kdXBsZXggYW5kIGZpeGVkIHBhdXNlLg0KDQp2MyAtPiB2NA0KLSBBZGp1c3QgdGhl
IGNvZGluZyBzdHlsZSBieSBzdWdnZXN0aW9uIG9mIEpha3ViIEtpY2luc2tpLg0KICBSZW1vdmUg
dW5uZWNlc3NhcnkganVtcGluZyBsYWJlbCwgbWVyZ2UgY29udGludW91cyBudW1lcmljICdzd2l0
Y2gNCiAgY2FzZXMnIGludG8gb25lIGxpbmUsIGFuZCBrZWVwIHRoZSB2YXJpYWJsZXMgbG9uZ2Vz
dCB0byBzaG9ydGVzdA0KICAocmV2ZXJzZSB4bWFzIHRyZWUpLg0KDQp2MiAtPiB2Mw0KLSBLZWVw
IHRoZSBzYW1lIHNldHVwIGxvZ2ljIG9mIG10NzUzMC9tdDc2MjEgYmVjYXVzZSB0aGVzZSBzZXJp
ZXMgb2YNCiAgcGF0Y2hlcyBpcyBmb3IgYWRkaW5nIG10NzUzMSBoYXJkd2FyZS4NCi0gRG8gbm90
IGFkanVzdCByZ21paSBkZWxheSB3aGVuIHZlbmRvciBwaHkgZHJpdmVyIHByZXNlbnRzIGluIG9y
ZGVyIHRvDQogIHByZXZlbnQgZG91YmxlIGFkanVzdG1lbnQgYnkgc3VnZ2VzdGlvbiBvZiBBbmRy
ZXcgTHVubi4NCi0gUmVtb3ZlIHJlZHVuZGFudCAnRXhhbXBsZSA0JyBmcm9tIGR0LWJpbmRpbmdz
IGJ5IHN1Z2dlc3Rpb24gb2YNCiAgUm9iIEhlcnJpbmcuDQotIEZpeCB0eXBvLg0KDQp2MSAtPiB2
Mg0KLSBjaGFuZ2UgcGh5bGlua192YWxpZGF0ZSBjYWxsYmFjayBmdW5jdGlvbiB0byBzdXBwb3J0
IGZ1bGwtZHVwbGV4DQogIGdpZ2FiaXQgb25seSB0byBtYXRjaCBoYXJkd2FyZSBjYXBhYmlsaXR5
Lg0KLSBhZGQgZGVzY3JpcHRpb24gb2YgU0dNSUkgaW50ZXJmYWNlLg0KLSBjb25maWd1cmUgbXQ3
NTMxIGNwdSBwb3J0IGluIGZhc3Rlc3Qgc3BlZWQgYnkgZGVmYXVsdC4NCi0gcGFyc2UgU0dNSUkg
Y29udHJvbCB3b3JkIGZvciBpbi1iYW5kIG5lZ290aWF0aW9uIG1vZGUuDQotIGNvbmZpZ3VyZSBS
R01JSSBkZWxheSBiYXNlZCBvbiBwaHkucnN0Lg0KLSBSZW5hbWUgdGhlIGRlZmluaXRpb24gaW4g
dGhlIGhlYWRlciBmaWxlIHRvIGF2b2lkIHBvdGVudGlhbCBjb25mbGljdHMuDQotIEFkZCB3cmFw
cGVyIGZ1bmN0aW9uIGZvciBtZGlvIHJlYWQvd3JpdGUgdG8gc3VwcG9ydCBib3RoIEMyMiBhbmQg
QzQ1Lg0KLSBjb3JyZWN0IGZpeGVkLWxpbmsgc3BlZWQgb2YgMjUwMGJhc2UteCBpbiBkdHMuDQot
IGFkZCBNVDc1MzEgcG9ydCBtaXJyb3Igc2V0dGluZy4NCg0KTGFuZGVuIENoYW8gKDYpOg0KICBu
ZXQ6IGRzYTogbXQ3NTMwOiBSZWZpbmUgbWVzc2FnZSBpbiBLY29uZmlnDQogIG5ldDogZHNhOiBt
dDc1MzA6IEV4dGVuZCBkZXZpY2UgZGF0YSByZWFkeSBmb3IgYWRkaW5nIGEgbmV3IGhhcmR3YXJl
DQogIGR0LWJpbmRpbmdzOiBuZXQ6IGRzYTogYWRkIG5ldyBNVDc1MzEgYmluZGluZyB0byBzdXBw
b3J0IE1UNzUzMQ0KICBuZXQ6IGRzYTogbXQ3NTMwOiBBZGQgdGhlIHN1cHBvcnQgb2YgTVQ3NTMx
IHN3aXRjaA0KICBhcm02NDogZHRzOiBtdDc2MjI6IGFkZCBtdDc1MzEgZHNhIHRvIG10NzYyMi1y
ZmIxIGJvYXJkDQogIGFybTY0OiBkdHM6IG10NzYyMjogYWRkIG10NzUzMSBkc2EgdG8gYmFuYW5h
cGktYnBpLXI2NCBib2FyZA0KDQogLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1
MzAudHh0ICAgIHwgICAxMyArLQ0KIC4uLi9kdHMvbWVkaWF0ZWsvbXQ3NjIyLWJhbmFuYXBpLWJw
aS1yNjQuZHRzICB8ICAgNDQgKw0KIGFyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIy
LXJmYjEuZHRzICB8ICAgNTcgKy0NCiBkcml2ZXJzL25ldC9kc2EvS2NvbmZpZyAgICAgICAgICAg
ICAgICAgICAgICAgfCAgICA2ICstDQogZHJpdmVycy9uZXQvZHNhL210NzUzMC5jICAgICAgICAg
ICAgICAgICAgICAgIHwgMTE5MiArKysrKysrKysrKysrKystLQ0KIGRyaXZlcnMvbmV0L2RzYS9t
dDc1MzAuaCAgICAgICAgICAgICAgICAgICAgICB8ICAyNTkgKysrLQ0KIDYgZmlsZXMgY2hhbmdl
ZCwgMTQ1NSBpbnNlcnRpb25zKCspLCAxMTYgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xNy4xDQo=

