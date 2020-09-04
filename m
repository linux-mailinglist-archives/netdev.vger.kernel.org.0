Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043EA25DB65
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgIDOW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:22:29 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:49690 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730779AbgIDOWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:22:18 -0400
X-UUID: 10827524f6cc4c1c9b5947d8369d3741-20200904
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=PLr5RiI3DMgYUSfvxUvOpCy9aKBipk9GFFlQ+87SFTg=;
        b=fx7LnJy24w34JQMJ9sReIKVTlcUBt8cNfV/X4eS12YKTdw16/8ig6bOHfXk70GkBsmf/8Sy/CahycsXHoJYBtzu9+UVTDkSoqB/LoYFYcB+bP/nt92ByfbuWacATn62ueimpd1B4PqxzFMUX+f9v82AXfWRbUtX22EvbeKQIbSk=;
X-UUID: 10827524f6cc4c1c9b5947d8369d3741-20200904
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 860483780; Fri, 04 Sep 2020 22:22:05 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Sep 2020 22:22:02 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Sep 2020 22:22:02 +0800
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
Subject: [PATCH net-next v3 0/6] net-next: dsa: mt7530: add support for MT7531
Date:   Fri, 4 Sep 2020 22:21:55 +0800
Message-ID: <cover.1599228079.git.landen.chao@mediatek.com>
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
ZWQgZnVsbC1kdXBsZXggYW5kIGZpeGVkIHBhdXNlLg0KDQp2MiAtPiB2Mw0KLSBLZWVwIHRoZSBz
YW1lIHNldHVwIGxvZ2ljIG9mIG10NzUzMC9tdDc2MjEgYmVjYXVzZSB0aGVzZSBzZXJpZXMgb2YN
CiAgcGF0Y2hlcyBpcyBmb3IgYWRkaW5nIG10NzUzMSBoYXJkd2FyZS4NCi0gRG8gbm90IGFkanVz
dCByZ21paSBkZWxheSB3aGVuIHZlbmRvciBwaHkgZHJpdmVyIHByZXNlbnRzIGluIG9yZGVyIHRv
DQogIHByZXZlbnQgZG91YmxlIGFkanVzdG1lbnQgYnkgc3VnZ2VzdGlvbiBvZiBBbmRyZXcgTHVu
bi4NCi0gUmVtb3ZlIHJlZHVuZGFudCAnRXhhbXBsZSA0JyBmcm9tIGR0LWJpbmRpbmdzIGJ5IHN1
Z2dlc3Rpb24gb2YNCiAgUm9iIEhlcnJpbmcuDQotIEZpeCB0eXBvLg0KDQp2MSAtPiB2Mg0KLSBj
aGFuZ2UgcGh5bGlua192YWxpZGF0ZSBjYWxsYmFjayBmdW5jdGlvbiB0byBzdXBwb3J0IGZ1bGwt
ZHVwbGV4DQogIGdpZ2FiaXQgb25seSB0byBtYXRjaCBoYXJkd2FyZSBjYXBhYmlsaXR5Lg0KLSBh
ZGQgZGVzY3JpcHRpb24gb2YgU0dNSUkgaW50ZXJmYWNlLg0KLSBjb25maWd1cmUgbXQ3NTMxIGNw
dSBwb3J0IGluIGZhc3Rlc3Qgc3BlZWQgYnkgZGVmYXVsdC4NCi0gcGFyc2UgU0dNSUkgY29udHJv
bCB3b3JkIGZvciBpbi1iYW5kIG5lZ290aWF0aW9uIG1vZGUuDQotIGNvbmZpZ3VyZSBSR01JSSBk
ZWxheSBiYXNlZCBvbiBwaHkucnN0Lg0KLSBSZW5hbWUgdGhlIGRlZmluaXRpb24gaW4gdGhlIGhl
YWRlciBmaWxlIHRvIGF2b2lkIHBvdGVudGlhbCBjb25mbGljdHMuDQotIEFkZCB3cmFwcGVyIGZ1
bmN0aW9uIGZvciBtZGlvIHJlYWQvd3JpdGUgdG8gc3VwcG9ydCBib3RoIEMyMiBhbmQgQzQ1Lg0K
LSBjb3JyZWN0IGZpeGVkLWxpbmsgc3BlZWQgb2YgMjUwMGJhc2UteCBpbiBkdHMuDQotIGFkZCBN
VDc1MzEgcG9ydCBtaXJyb3Igc2V0dGluZy4NCg0KTGFuZGVuIENoYW8gKDYpOg0KICBuZXQ6IGRz
YTogbXQ3NTMwOiBSZWZpbmUgbWVzc2FnZSBpbiBLY29uZmlnDQogIG5ldDogZHNhOiBtdDc1MzA6
IEV4dGVuZCBkZXZpY2UgZGF0YSByZWFkeSBmb3IgYWRkaW5nIGEgbmV3IGhhcmR3YXJlDQogIGR0
LWJpbmRpbmdzOiBuZXQ6IGRzYTogYWRkIG5ldyBNVDc1MzEgYmluZGluZyB0byBzdXBwb3J0IE1U
NzUzMQ0KICBuZXQ6IGRzYTogbXQ3NTMwOiBBZGQgdGhlIHN1cHBvcnQgb2YgTVQ3NTMxIHN3aXRj
aA0KICBhcm02NDogZHRzOiBtdDc2MjI6IGFkZCBtdDc1MzEgZHNhIHRvIG10NzYyMi1yZmIxIGJv
YXJkDQogIGFybTY0OiBkdHM6IG10NzYyMjogYWRkIG10NzUzMSBkc2EgdG8gYmFuYW5hcGktYnBp
LXI2NCBib2FyZA0KDQogLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1MzAudHh0
ICAgIHwgICAxMCArLQ0KIC4uLi9kdHMvbWVkaWF0ZWsvbXQ3NjIyLWJhbmFuYXBpLWJwaS1yNjQu
ZHRzICB8ICAgNDQgKw0KIGFyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLXJmYjEu
ZHRzICB8ICAgNTcgKy0NCiBkcml2ZXJzL25ldC9kc2EvS2NvbmZpZyAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICA2ICstDQogZHJpdmVycy9uZXQvZHNhL210NzUzMC5jICAgICAgICAgICAgICAg
ICAgICAgIHwgMTE5NCArKysrKysrKysrKysrKystLQ0KIGRyaXZlcnMvbmV0L2RzYS9tdDc1MzAu
aCAgICAgICAgICAgICAgICAgICAgICB8ICAyNTkgKysrLQ0KIDYgZmlsZXMgY2hhbmdlZCwgMTQ2
MyBpbnNlcnRpb25zKCspLCAxMDcgZGVsZXRpb25zKC0pDQoNCi0tIA0KMi4xNy4xDQo=

