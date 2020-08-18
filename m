Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55ADB247F37
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHRHOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:14:39 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:61559 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgHRHOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:14:38 -0400
X-UUID: 02a51d058313488b983ce8a9cddc5153-20200818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=KLL9icB0ENV0PXcL0pq4h8SClrUKR3FN7QtsR8jlUsA=;
        b=KBSy9fTHkQnJ7gnHZDaObV7ck2G763YUa9bdJA4/imBSHdjsh6MAGCYz06LEotqgVZqJoc/dZS9JjccjE8OSC9wjzFhxZ1gT8KIqVice4gnWGJqFrOdoVZq5oCxKI0mP/jqBvkv9Yska0Nw+2wsa8Qc1KoqbGX5zLhTtfI8424o=;
X-UUID: 02a51d058313488b983ce8a9cddc5153-20200818
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1347278885; Tue, 18 Aug 2020 15:14:35 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 18 Aug 2020 15:14:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 15:14:33 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@savoirfairelinux.com>, <matthias.bgg@gmail.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <davem@davemloft.net>,
        <sean.wang@mediatek.com>, <opensource@vdorst.com>,
        <frank-w@public-files.de>, <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next v2 1/7] net: dsa: mt7530: Refine message in Kconfig
Date:   Tue, 18 Aug 2020 15:14:06 +0800
Message-ID: <8fc65123d1fea9d8c77d7795b3d0482e766c76c6.1597729692.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1597729692.git.landen.chao@mediatek.com>
References: <cover.1597729692.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVmaW5lIG1lc3NhZ2UgaW4gS2NvbmZpZyB3aXRoIGZpeGluZyB0eXBvIGFuZCBhbiBleHBsaWNp
dCBNVDc2MjEgc3VwcG9ydC4NCg0KU2lnbmVkLW9mZi1ieTogTGFuZGVuIENoYW8gPGxhbmRlbi5j
aGFvQG1lZGlhdGVrLmNvbT4NClNpZ25lZC1vZmYtYnk6IFNlYW4gV2FuZyA8c2Vhbi53YW5nQG1l
ZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2RzYS9LY29uZmlnIHwgNiArKystLS0NCiAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZHNhL0tjb25maWcgYi9kcml2ZXJzL25ldC9kc2EvS2NvbmZpZw0K
aW5kZXggZDAwMjRjYjMwYTdiLi42Njc4NDQxMmI2ODMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC9kc2EvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9uZXQvZHNhL0tjb25maWcNCkBAIC0zMywxMiAr
MzMsMTIgQEAgY29uZmlnIE5FVF9EU0FfTEFOVElRX0dTV0lQDQogCSAgdGhlIHhyeDIwMCAvIFZS
OSBTb0MuDQogDQogY29uZmlnIE5FVF9EU0FfTVQ3NTMwDQotCXRyaXN0YXRlICJNZWRpYXRlayBN
VDc1MzAgRXRoZXJuZXQgc3dpdGNoIHN1cHBvcnQiDQorCXRyaXN0YXRlICJNZWRpYVRlayBNVDc1
MzAgYW5kIE1UNzYyMSBFdGhlcm5ldCBzd2l0Y2ggc3VwcG9ydCINCiAJZGVwZW5kcyBvbiBORVRf
RFNBDQogCXNlbGVjdCBORVRfRFNBX1RBR19NVEsNCiAJaGVscA0KLQkgIFRoaXMgZW5hYmxlcyBz
dXBwb3J0IGZvciB0aGUgTWVkaWF0ZWsgTVQ3NTMwIEV0aGVybmV0IHN3aXRjaA0KLQkgIGNoaXAu
DQorCSAgVGhpcyBlbmFibGVzIHN1cHBvcnQgZm9yIHRoZSBNZWRpYVRlayBNVDc1MzAgYW5kIE1U
NzYyMSBFdGhlcm5ldA0KKwkgIHN3aXRjaCBjaGlwLg0KIA0KIGNvbmZpZyBORVRfRFNBX01WODhF
NjA2MA0KIAl0cmlzdGF0ZSAiTWFydmVsbCA4OEU2MDYwIGV0aGVybmV0IHN3aXRjaCBjaGlwIHN1
cHBvcnQiDQotLSANCjIuMTcuMQ0K

