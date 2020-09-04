Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4F125DB67
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbgIDOWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:22:34 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:26582 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730786AbgIDOWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:22:24 -0400
X-UUID: 59a2a1d3f91243169abb6ca8014e754a-20200904
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=d6kOW52w5IkfV9rG1/hHcYEAa68TX5XY3lJUkDhh0sM=;
        b=YlWKbQnYppFVrqwFSjGBq/D7yof7wPF/LittSaBZx4a0qIvovNUwY69BplsPZlQQo94BFBFMJh3fB9ORHi17q9uXks5NQfqPY3SAQEUlrUD+/kfA+3U+G+oaSZXJJjPH6xfnUDzIAi0A7uL7AsCH9lKRFHYK5NtDzq7AkMatIvI=;
X-UUID: 59a2a1d3f91243169abb6ca8014e754a-20200904
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1470373698; Fri, 04 Sep 2020 22:22:17 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Sep 2020 22:22:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Sep 2020 22:22:14 +0800
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
Subject: [PATCH net-next v3 1/6] net: dsa: mt7530: Refine message in Kconfig
Date:   Fri, 4 Sep 2020 22:21:56 +0800
Message-ID: <38268b91c7dc7296764795aac3c710378d2d24a8.1599228079.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1599228079.git.landen.chao@mediatek.com>
References: <cover.1599228079.git.landen.chao@mediatek.com>
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
ZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdt
YWlsLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2RzYS9LY29uZmlnIHwgNiArKystLS0NCiAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZHNhL0tjb25maWcgYi9kcml2ZXJzL25ldC9kc2EvS2NvbmZpZw0KaW5k
ZXggNDY4YjNjNDI3M2M1Li4wNmQ2OGE4NDg3NzQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9k
c2EvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9uZXQvZHNhL0tjb25maWcNCkBAIC0zMywxMiArMzMs
MTIgQEAgY29uZmlnIE5FVF9EU0FfTEFOVElRX0dTV0lQDQogCSAgdGhlIHhyeDIwMCAvIFZSOSBT
b0MuDQogDQogY29uZmlnIE5FVF9EU0FfTVQ3NTMwDQotCXRyaXN0YXRlICJNZWRpYXRlayBNVDc1
MzAgRXRoZXJuZXQgc3dpdGNoIHN1cHBvcnQiDQorCXRyaXN0YXRlICJNZWRpYVRlayBNVDc1MzAg
YW5kIE1UNzYyMSBFdGhlcm5ldCBzd2l0Y2ggc3VwcG9ydCINCiAJZGVwZW5kcyBvbiBORVRfRFNB
DQogCXNlbGVjdCBORVRfRFNBX1RBR19NVEsNCiAJaGVscA0KLQkgIFRoaXMgZW5hYmxlcyBzdXBw
b3J0IGZvciB0aGUgTWVkaWF0ZWsgTVQ3NTMwIEV0aGVybmV0IHN3aXRjaA0KLQkgIGNoaXAuDQor
CSAgVGhpcyBlbmFibGVzIHN1cHBvcnQgZm9yIHRoZSBNZWRpYVRlayBNVDc1MzAgYW5kIE1UNzYy
MSBFdGhlcm5ldA0KKwkgIHN3aXRjaCBjaGlwLg0KIA0KIGNvbmZpZyBORVRfRFNBX01WODhFNjA2
MA0KIAl0cmlzdGF0ZSAiTWFydmVsbCA4OEU2MDYwIGV0aGVybmV0IHN3aXRjaCBjaGlwIHN1cHBv
cnQiDQotLSANCjIuMTcuMQ0K

