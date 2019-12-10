Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E031181DA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLJIOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:14:51 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:39119 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726062AbfLJIOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:14:51 -0500
X-UUID: 8f0ba1f4840f4936b2c6ccbfb04d7663-20191210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=uC8RbIA/Bmt5jx7r3LAgXAyyrUdbG45GJY60y9w1Jj0=;
        b=kzQG1PijyQIvz17fz+F/cb/IZaPnQR2v6XDMsEcwMk2B9pdtwxmPkQGVHpN0kIcp7nWg5Vb+Iy8ENI8FvTnEhHvpQHqRSmzQOjjExTkESI+bY1r7gw8RShydh0SYdOwlZK2oSdRNeIb2XqgZW4wREq+uRqGAJCo6kE0X5DZz4m0=;
X-UUID: 8f0ba1f4840f4936b2c6ccbfb04d7663-20191210
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 754408917; Tue, 10 Dec 2019 16:14:46 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 10 Dec 2019 16:14:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 10 Dec 2019 16:14:26 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@savoirfairelinux.com>, <matthias.bgg@gmail.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <davem@davemloft.net>,
        <sean.wang@mediatek.com>, <opensource@vdorst.com>,
        <frank-w@public-files.de>, Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next 0/6] net-next: dsa: mt7530: add support for MT7531
Date:   Tue, 10 Dec 2019 16:14:36 +0800
Message-ID: <cover.1575914275.git.landen.chao@mediatek.com>
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
YXRlaw0Kcm91dGVyIHBsYXRmb3JtcyBzdWNoIGFzIE1UNzYyMiBvciBNVDc2MjkuIA0KDQpJdCBp
cyBhbHNvIGEgNy1wb3J0cyBzd2l0Y2ggd2l0aCA1IGdpZ2EgZW1iZWRkZWQgcGh5cywgMiBjcHUg
cG9ydHMsIGFuZA0KdGhlIHNhbWUgTUFDIGxvZ2ljIG9mIE1UNzUzMC4gQ3B1IHBvcnQgNiBvbmx5
IHN1cHBvcnRzIEhTR01JSSBpbnRlcmZhY2UuDQpDcHUgcG9ydCA1IHN1cHBvcnRzIGVpdGhlciBS
R01JSSBvciBIU0dNSUkgaW4gZGlmZmVyZW50IEhXIFNLVS4gRHVlIHRvDQpzdXBwb3J0IGZvciBI
U0dNSUkgaW50ZXJmYWNlLCBwbGwsIGFuZCBwYWQgc2V0dGluZyBhcmUgZGlmZmVyZW50IGZyb20N
Ck1UNzUzMC4NCg0KTGFuZGVuIENoYW8gKDYpOg0KICBuZXQ6IGRzYTogbXQ3NTMwOiBSZWZpbmUg
bWVzc2FnZSBpbiBLY29uZmlnDQogIG5ldDogZHNhOiBtdDc1MzA6IEV4dGVuZCBkZXZpY2UgZGF0
YSByZWFkeSBmb3IgYWRkaW5nIGEgbmV3IGhhcmR3YXJlDQogIGR0LWJpbmRpbmdzOiBuZXQ6IGRz
YTogYWRkIG5ldyBNVDc1MzEgYmluZGluZyB0byBzdXBwb3J0IE1UNzUzMQ0KICBuZXQ6IGRzYTog
bXQ3NTMwOiBBZGQgdGhlIHN1cHBvcnQgb2YgTVQ3NTMxIHN3aXRjaA0KICBhcm02NDogZHRzOiBt
dDc2MjI6IGFkZCBtdDc1MzEgZHNhIHRvIG10NzYyMi1yZmIxIGJvYXJkDQogIGFybTY0OiBkdHM6
IG10NzYyMjogYWRkIG10NzUzMSBkc2EgdG8gYmFuYW5hcGktYnBpLXI2NCBib2FyZA0KDQogLi4u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1MzAudHh0ICAgIHwgIDc3ICstDQogLi4u
L2R0cy9tZWRpYXRlay9tdDc2MjItYmFuYW5hcGktYnBpLXI2NC5kdHMgIHwgIDUwICsNCiBhcmNo
L2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi1yZmIxLmR0cyAgfCAgNjMgKy0NCiBkcml2
ZXJzL25ldC9kc2EvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgfCAgIDYgKy0NCiBkcml2
ZXJzL25ldC9kc2EvbXQ3NTMwLmMgICAgICAgICAgICAgICAgICAgICAgfCA4NzQgKysrKysrKysr
KysrKysrKy0tDQogZHJpdmVycy9uZXQvZHNhL210NzUzMC5oICAgICAgICAgICAgICAgICAgICAg
IHwgMTczICsrKy0NCiA2IGZpbGVzIGNoYW5nZWQsIDExNjggaW5zZXJ0aW9ucygrKSwgNzUgZGVs
ZXRpb25zKC0pDQoNCi0tIA0KMi4xNy4xDQo=

