Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB90289F9C
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 11:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgJJJif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 05:38:35 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:25204 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726340AbgJJIxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 04:53:20 -0400
X-UUID: 13cbfbf5df4f4785b50295cfc0dabea8-20201010
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=RlwrqT0bs3PS18yXEe3g2df8bGwD+XRsEbZm4K541oY=;
        b=neeFqIrOwQlo2fZHbn2wDfcpz4qJ2iS0pgy3lA00WzSWT7wJm1YxU1246flM9b56tvEnIo5UUXzMsfXYngJAwfEoCunRmUHkT10XoS15hM9hegRlirwwtTjycP8YNLzAmXrdskecvwoXzhGZU61IJ6ir136tsyBoR2IpeMw/ypU=;
X-UUID: 13cbfbf5df4f4785b50295cfc0dabea8-20201010
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1791958533; Sat, 10 Oct 2020 16:43:17 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS31N2.mediatek.inc (172.27.4.87) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 10 Oct 2020 16:43:15 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 10 Oct 2020 16:43:15 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH v2 3/4] dt-bindings: net: btusb: change reference file name
Date:   Sat, 10 Oct 2020 16:43:13 +0800
Message-ID: <8b7dcc3e524dbf93a8c3cda5fdcc15362f3d1e26.1602318869.git.chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 5A2428CBF1E4D8350554801BDB74F1CB58F8D7B7EF0764F4C82C613BCAE61E892000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RHVlIHRvIHVzYi1kZXZpY2UudHh0IGlzIGNvbnZlcnRlZCBpbnRvIHVzYi1kZXZpY2UueWFtbCwN
CnNvIG1vZGlmeSByZWZlcmVuY2UgZmlsZSBuYW1lcyBhdCB0aGUgc2FtZSB0aW1lLg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBDaHVuZmVuZyBZdW4gPGNodW5mZW5nLnl1bkBtZWRpYXRlay5jb20+DQotLS0N
CnYyOiBuZXcgcGF0Y2gNCi0tLQ0KIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9u
ZXQvYnR1c2IudHh0IHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC9idHVzYi50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L2J0dXNiLnR4dA0KaW5kZXggYjFhZDZlZTY4ZTkwLi5hOWMzZjQyNzdmNjkgMTAwNjQ0DQotLS0g
YS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2J0dXNiLnR4dA0KKysrIGIv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9idHVzYi50eHQNCkBAIC00LDcg
KzQsNyBAQCBHZW5lcmljIEJsdWV0b290aCBjb250cm9sbGVyIG92ZXIgVVNCIChidHVzYiBkcml2
ZXIpDQogUmVxdWlyZWQgcHJvcGVydGllczoNCiANCiAgIC0gY29tcGF0aWJsZSA6IHNob3VsZCBj
b21wbHkgd2l0aCB0aGUgZm9ybWF0ICJ1c2JWSUQsUElEIiBzcGVjaWZpZWQgaW4NCi0JCSBEb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdXNiL3VzYi1kZXZpY2UudHh0DQorCQkgRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3VzYi91c2ItZGV2aWNlLnlhbWwNCiAJCSBB
dCB0aGUgdGltZSBvZiB3cml0aW5nLCB0aGUgb25seSBPRiBzdXBwb3J0ZWQgZGV2aWNlcw0KIAkJ
IChtb3JlIG1heSBiZSBhZGRlZCBsYXRlcikgYXJlOg0KIA0KLS0gDQoyLjE4LjANCg==

