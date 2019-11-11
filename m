Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A58F6EB5
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKGvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:51:41 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:14087 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726768AbfKKGvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 01:51:41 -0500
X-UUID: fbb8478e55e84bd8bc395048e53ab68d-20191111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=YVTLncncE/8QbF39XxCJ9mXM/sirh7PaGKSXHI0dujI=;
        b=Lt82WdY2Tp9g/Hd0hy746SyGafzz22p+HiBVI135IIjdwIbt+M0ZBBP180qudfOD9NNvfmNKSMBnYqltKVGGvM2bLtGE5FnljW361qAV6u+TVQJ9fsS8aoopFCghb7GUK7TPYTmjIeG3VGS02biBpcHJvukNhIBujgabDnIA2nE=;
X-UUID: fbb8478e55e84bd8bc395048e53ab68d-20191111
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1137527795; Mon, 11 Nov 2019 14:51:31 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 11 Nov 2019 14:51:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 11 Nov 2019 14:51:28 +0800
From:   MarkLee <Mark-MC.Lee@mediatek.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net,v2 3/3] net: ethernet: mediatek: Enable GDM GDMA_DROP_ALL mode
Date:   Mon, 11 Nov 2019 14:51:29 +0800
Message-ID: <20191111065129.30078-4-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191111065129.30078-1-Mark-MC.Lee@mediatek.com>
References: <20191111065129.30078-1-Mark-MC.Lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RW5hYmxlIEdETSBHRE1BX0RST1BfQUxMIG1vZGUgdG8gZHJvcCBhbGwgcGFja2V0IGR1cmluZyB0
aGUgDQpzdG9wIG9wZXJhdGlvbi4gVGhpcyBpcyByZWNvbW1lbmRlZCBieSB0aGUgbXQ3NjJ4IEhX
IGRlc2lnbiANCnRvIGRyb3AgYWxsIHBhY2tldCBmcm9tIEdNQUMgYmVmb3JlIHN0b3BwaW5nIFBE
TUEuDQoNClNpZ25lZC1vZmYtYnk6IE1hcmtMZWUgPE1hcmstTUMuTGVlQG1lZGlhdGVrLmNvbT4N
Ci0tDQp2MS0+djI6DQoqIG5vIGNoYW5nZQ0KDQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWRpYXRlay9tdGtfZXRoX3NvYy5jIHwgMiArKw0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlh
dGVrL210a19ldGhfc29jLmggfCAxICsNCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9z
b2MuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmMNCmluZGV4
IGIxNDdhYjBlNDRjZS4uNWZlMWFiMGMxNmNjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVkaWF0ZWsvbXRrX2V0aF9zb2MuYw0KQEAgLTIyNzksNiArMjI3OSw4IEBAIHN0YXRpYyBpbnQg
bXRrX3N0b3Aoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJaWYgKCFyZWZjb3VudF9kZWNfYW5k
X3Rlc3QoJmV0aC0+ZG1hX3JlZmNudCkpDQogCQlyZXR1cm4gMDsNCiANCisJbXRrX2dkbV9jb25m
aWcoZXRoLCBNVEtfR0RNQV9EUk9QX0FMTCk7DQorDQogCW10a190eF9pcnFfZGlzYWJsZShldGgs
IE1US19UWF9ET05FX0lOVCk7DQogCW10a19yeF9pcnFfZGlzYWJsZShldGgsIE1US19SWF9ET05F
X0lOVCk7DQogCW5hcGlfZGlzYWJsZSgmZXRoLT50eF9uYXBpKTsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5oIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuaA0KaW5kZXggYjE2ZDhkOWIxOTZhLi44NTgzMGZl
MTRhMWIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRo
X3NvYy5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5o
DQpAQCAtODUsNiArODUsNyBAQA0KICNkZWZpbmUgTVRLX0dETUFfVENTX0VOCQlCSVQoMjEpDQog
I2RlZmluZSBNVEtfR0RNQV9VQ1NfRU4JCUJJVCgyMCkNCiAjZGVmaW5lIE1US19HRE1BX1RPX1BE
TUEJMHgwDQorI2RlZmluZSBNVEtfR0RNQV9EUk9QX0FMTCAgICAgICAweDc3NzcNCiANCiAvKiBV
bmljYXN0IEZpbHRlciBNQUMgQWRkcmVzcyBSZWdpc3RlciAtIExvdyAqLw0KICNkZWZpbmUgTVRL
X0dETUFfTUFDX0FEUkwoeCkJKDB4NTA4ICsgKHggKiAweDEwMDApKQ0KLS0gDQoyLjE3LjENCg==

