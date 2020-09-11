Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D46266485
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgIKQk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:40:27 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:41905 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726295AbgIKPLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:11:33 -0400
X-UUID: 367ed8fe597b4281bbaebc8ef530fe36-20200911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=MkU2LaCnOssekgPwIVl1I9pETqJ6+L8geigHE05ACLc=;
        b=N55bqLu/1TsTmbMTWL77Hg/vTkHJllWvm74QB/BzWYjuf4pQmoTnNqyk5wfD0L6vySN8nN5m5MM52XhxrEqwI5wvE6hRHgIzLBI+WJscmof48qxS5ojtl1HK+jsVpjDajCJKNP+PrW+6jPtAv2ULfXdnIbOdPqg9YID50so8R74=;
X-UUID: 367ed8fe597b4281bbaebc8ef530fe36-20200911
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 655240207; Fri, 11 Sep 2020 21:49:13 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 11 Sep 2020 21:49:09 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 21:49:09 +0800
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
Subject: [PATCH net-next v5 0/6] net-next: dsa: mt7530: add support for MT7531
Date:   Fri, 11 Sep 2020 21:48:50 +0800
Message-ID: <cover.1599829696.git.landen.chao@mediatek.com>
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
ZWQgZnVsbC1kdXBsZXggYW5kIGZpeGVkIHBhdXNlLg0KDQp2NCAtPiB2NQ0KLSBBZGQgZml4ZWQt
bGluayBub2RlIHRvIGRzYSBjcHUgcG9ydCBpbiBkdHMgZmlsZSBieSBzdWdnZXN0aW9uIG9mDQog
IFZsYWRpbWlyIE9sdGVhbi4NCg0KdjMgLT4gdjQNCi0gQWRqdXN0IHRoZSBjb2Rpbmcgc3R5bGUg
Ynkgc3VnZ2VzdGlvbiBvZiBKYWt1YiBLaWNpbnNraS4NCiAgUmVtb3ZlIHVubmVjZXNzYXJ5IGp1
bXBpbmcgbGFiZWwsIG1lcmdlIGNvbnRpbnVvdXMgbnVtZXJpYyAnc3dpdGNoDQogIGNhc2VzJyBp
bnRvIG9uZSBsaW5lLCBhbmQga2VlcCB0aGUgdmFyaWFibGVzIGxvbmdlc3QgdG8gc2hvcnRlc3QN
CiAgKHJldmVyc2UgeG1hcyB0cmVlKS4NCg0KdjIgLT4gdjMNCi0gS2VlcCB0aGUgc2FtZSBzZXR1
cCBsb2dpYyBvZiBtdDc1MzAvbXQ3NjIxIGJlY2F1c2UgdGhlc2Ugc2VyaWVzIG9mDQogIHBhdGNo
ZXMgaXMgZm9yIGFkZGluZyBtdDc1MzEgaGFyZHdhcmUuDQotIERvIG5vdCBhZGp1c3QgcmdtaWkg
ZGVsYXkgd2hlbiB2ZW5kb3IgcGh5IGRyaXZlciBwcmVzZW50cyBpbiBvcmRlciB0bw0KICBwcmV2
ZW50IGRvdWJsZSBhZGp1c3RtZW50IGJ5IHN1Z2dlc3Rpb24gb2YgQW5kcmV3IEx1bm4uDQotIFJl
bW92ZSByZWR1bmRhbnQgJ0V4YW1wbGUgNCcgZnJvbSBkdC1iaW5kaW5ncyBieSBzdWdnZXN0aW9u
IG9mDQogIFJvYiBIZXJyaW5nLg0KLSBGaXggdHlwby4NCg0KdjEgLT4gdjINCi0gY2hhbmdlIHBo
eWxpbmtfdmFsaWRhdGUgY2FsbGJhY2sgZnVuY3Rpb24gdG8gc3VwcG9ydCBmdWxsLWR1cGxleA0K
ICBnaWdhYml0IG9ubHkgdG8gbWF0Y2ggaGFyZHdhcmUgY2FwYWJpbGl0eS4NCi0gYWRkIGRlc2Ny
aXB0aW9uIG9mIFNHTUlJIGludGVyZmFjZS4NCi0gY29uZmlndXJlIG10NzUzMSBjcHUgcG9ydCBp
biBmYXN0ZXN0IHNwZWVkIGJ5IGRlZmF1bHQuDQotIHBhcnNlIFNHTUlJIGNvbnRyb2wgd29yZCBm
b3IgaW4tYmFuZCBuZWdvdGlhdGlvbiBtb2RlLg0KLSBjb25maWd1cmUgUkdNSUkgZGVsYXkgYmFz
ZWQgb24gcGh5LnJzdC4NCi0gUmVuYW1lIHRoZSBkZWZpbml0aW9uIGluIHRoZSBoZWFkZXIgZmls
ZSB0byBhdm9pZCBwb3RlbnRpYWwgY29uZmxpY3RzLg0KLSBBZGQgd3JhcHBlciBmdW5jdGlvbiBm
b3IgbWRpbyByZWFkL3dyaXRlIHRvIHN1cHBvcnQgYm90aCBDMjIgYW5kIEM0NS4NCi0gY29ycmVj
dCBmaXhlZC1saW5rIHNwZWVkIG9mIDI1MDBiYXNlLXggaW4gZHRzLg0KLSBhZGQgTVQ3NTMxIHBv
cnQgbWlycm9yIHNldHRpbmcuDQoNCkxhbmRlbiBDaGFvICg2KToNCiAgbmV0OiBkc2E6IG10NzUz
MDogUmVmaW5lIG1lc3NhZ2UgaW4gS2NvbmZpZw0KICBuZXQ6IGRzYTogbXQ3NTMwOiBFeHRlbmQg
ZGV2aWNlIGRhdGEgcmVhZHkgZm9yIGFkZGluZyBhIG5ldyBoYXJkd2FyZQ0KICBkdC1iaW5kaW5n
czogbmV0OiBkc2E6IGFkZCBuZXcgTVQ3NTMxIGJpbmRpbmcgdG8gc3VwcG9ydCBNVDc1MzENCiAg
bmV0OiBkc2E6IG10NzUzMDogQWRkIHRoZSBzdXBwb3J0IG9mIE1UNzUzMSBzd2l0Y2gNCiAgYXJt
NjQ6IGR0czogbXQ3NjIyOiBhZGQgbXQ3NTMxIGRzYSB0byBtdDc2MjItcmZiMSBib2FyZA0KICBh
cm02NDogZHRzOiBtdDc2MjI6IGFkZCBtdDc1MzEgZHNhIHRvIGJhbmFuYXBpLWJwaS1yNjQgYm9h
cmQNCg0KIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbXQ3NTMwLnR4dCAgICB8ICAg
MTMgKy0NCiAuLi4vZHRzL21lZGlhdGVrL210NzYyMi1iYW5hbmFwaS1icGktcjY0LmR0cyAgfCAg
IDUwICsNCiBhcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi1yZmIxLmR0cyAgfCAg
IDYzICstDQogZHJpdmVycy9uZXQvZHNhL0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAgNiArLQ0KIGRyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYyAgICAgICAgICAgICAgICAgICAgICB8
IDExOTIgKysrKysrKysrKysrKysrLS0NCiBkcml2ZXJzL25ldC9kc2EvbXQ3NTMwLmggICAgICAg
ICAgICAgICAgICAgICAgfCAgMjU5ICsrKy0NCiA2IGZpbGVzIGNoYW5nZWQsIDE0NjcgaW5zZXJ0
aW9ucygrKSwgMTE2IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTcuMQ0K

