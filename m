Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488801181F2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfLJIO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:14:57 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45567 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726932AbfLJIO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:14:56 -0500
X-UUID: f5656f2ff80846ebb40e3da87d60fb90-20191210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=THbuVAlbiUyMgTyO0rwrKX/mskzsxNwDv9gxXp2O2c8=;
        b=pTp2PPKiPwR8QPOOf5yohf9lFERpEDlo/g/t2ChREfzFb9c+wylx++/div4hAB337+Ja2KIzbSu4URgdj5XHXUly8yuxrD8OBvV+ox0jlNLiRIN2dkCgL4fyzPr7ZPSk9lObJW05Yx2LY6Jy6eJZZXSShLlqLd0lDKwy6FT+hSI=;
X-UUID: f5656f2ff80846ebb40e3da87d60fb90-20191210
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 565263134; Tue, 10 Dec 2019 16:14:47 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 10 Dec 2019 16:14:38 +0800
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
Subject: [PATCH net-next 1/6] net: dsa: mt7530: Refine message in Kconfig
Date:   Tue, 10 Dec 2019 16:14:37 +0800
Message-ID: <6ecf6cbf38223f35854bc361c2eefa1d85c724d2.1575914275.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1575914275.git.landen.chao@mediatek.com>
References: <cover.1575914275.git.landen.chao@mediatek.com>
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
aW5kZXggYzc2Njc2NDVmMDRhLi40NjdmODAxNTdhY2YgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC9kc2EvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9uZXQvZHNhL0tjb25maWcNCkBAIC0zMywxMiAr
MzMsMTIgQEAgY29uZmlnIE5FVF9EU0FfTEFOVElRX0dTV0lQDQogCSAgdGhlIHhyeDIwMCAvIFZS
OSBTb0MuDQogDQogY29uZmlnIE5FVF9EU0FfTVQ3NTMwDQotCXRyaXN0YXRlICJNZWRpYXRlayBN
VDc1MzAgRXRoZXJuZXQgc3dpdGNoIHN1cHBvcnQiDQorCXRyaXN0YXRlICJNZWRpYVRlayBNVDc1
MzAgYW5kIE1UNzYyMSBFdGhlcm5ldCBzd2l0Y2ggc3VwcG9ydCINCiAJZGVwZW5kcyBvbiBORVRf
RFNBDQogCXNlbGVjdCBORVRfRFNBX1RBR19NVEsNCiAJLS0taGVscC0tLQ0KLQkgIFRoaXMgZW5h
YmxlcyBzdXBwb3J0IGZvciB0aGUgTWVkaWF0ZWsgTVQ3NTMwIEV0aGVybmV0IHN3aXRjaA0KLQkg
IGNoaXAuDQorCSAgVGhpcyBlbmFibGVzIHN1cHBvcnQgZm9yIHRoZSBNZWRpYVRlayBNVDc1MzAg
YW5kIE1UNzYyMSBFdGhlcm5ldA0KKwkgIHN3aXRjaCBjaGlwLg0KIA0KIGNvbmZpZyBORVRfRFNB
X01WODhFNjA2MA0KIAl0cmlzdGF0ZSAiTWFydmVsbCA4OEU2MDYwIGV0aGVybmV0IHN3aXRjaCBj
aGlwIHN1cHBvcnQiDQotLSANCjIuMTcuMQ0K

