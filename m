Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3011C369
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 03:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfLLCmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 21:42:16 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:34495 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727756AbfLLCmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 21:42:14 -0500
X-UUID: dbebac3d474c4adf8342a6dc070e59d7-20191212
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=VDJkFfjQ2A7EK11jJQUQ+/nDT660s5v+Di1gVGNcQ80=;
        b=XM2eXN50fH9j2JUNXqxJH0wn5y6GFhzQqRoDcacXkOkr0RimKdKu+gXqxGf/rnWfO3xEY50jcJjcNx57n+CAyzOcxYvViPuYy9dwsnVnV/e4C4ojKPtiXgwn3DowQBUQAeq9kOTv5ODIYxnJQl+c3ZFtA6ygftPYMpAK5h37kTg=;
X-UUID: dbebac3d474c4adf8342a6dc070e59d7-20191212
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 460475510; Thu, 12 Dec 2019 10:42:11 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Dec 2019 10:42:40 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 10:42:05 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>
Subject: [PATCH 2/2] net-next: dt-binding: dwmac-mediatek: add more description for RMII
Date:   Thu, 12 Dec 2019 10:41:45 +0800
Message-ID: <20191212024145.21752-3-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191212024145.21752-1-biao.huang@mediatek.com>
References: <20191212024145.21752-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TVQyNzEyIFNvQyBjYW4gcHJvdmlkZXMgUk1JSSByZWZlcmVuY2UgY2xvY2ssDQpzbyBhZGQgY29y
cmVzcG9uZGluZyBkZXNjcmlwdGlvbiBpbiBkdC1iaW5kaW5nLg0KDQpTaWduZWQtb2ZmLWJ5OiBC
aWFvIEh1YW5nIDxiaWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIC4uLi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy50eHQgIHwgMTcgKysrKysrKysrKysrKystLS0N
CiAxIGZpbGUgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWst
ZHdtYWMudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRl
ay1kd21hYy50eHQNCmluZGV4IDhhMDg2MjFhNWI1NC4uMzRmNjkyZWEwNDA2IDEwMDY0NA0KLS0t
IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy50
eHQNCisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWst
ZHdtYWMudHh0DQpAQCAtMTQsNyArMTQsOSBAQCBSZXF1aXJlZCBwcm9wZXJ0aWVzOg0KIAlTaG91
bGQgYmUgIm1hY2lycSIgZm9yIHRoZSBtYWluIE1BQyBJUlENCiAtIGNsb2NrczogTXVzdCBjb250
YWluIGEgcGhhbmRsZSBmb3IgZWFjaCBlbnRyeSBpbiBjbG9jay1uYW1lcy4NCiAtIGNsb2NrLW5h
bWVzOiBUaGUgbmFtZSBvZiB0aGUgY2xvY2sgbGlzdGVkIGluIHRoZSBjbG9ja3MgcHJvcGVydHku
IFRoZXNlIGFyZQ0KLQkiYXhpIiwgImFwYiIsICJtYWNfbWFpbiIsICJwdHBfcmVmIiBmb3IgTVQy
NzEyIFNvQw0KKwkiYXhpIiwgImFwYiIsICJtYWNfbWFpbiIsICJwdHBfcmVmIiBmb3IgTVQyNzEy
IFNvQy4NCisJInJtaWlfaW50ZXJuYWwiIGlzIG9wdGlvbmFsLCBvbmx5IGZvciBSTUlJIHdoZW4g
dGhlIHJlZmVyZW5jZSBjbG9jayBpcw0KKwlmcm9tIE1UMjcxMiBTb0MuDQogLSBtYWMtYWRkcmVz
czogU2VlIGV0aGVybmV0LnR4dCBpbiB0aGUgc2FtZSBkaXJlY3RvcnkNCiAtIHBoeS1tb2RlOiBT
ZWUgZXRoZXJuZXQudHh0IGluIHRoZSBzYW1lIGRpcmVjdG9yeQ0KIC0gbWVkaWF0ZWsscGVyaWNm
ZzogQSBwaGFuZGxlIHRvIHRoZSBzeXNjb24gbm9kZSB0aGF0IGNvbnRyb2wgZXRoZXJuZXQNCkBA
IC0yMyw4ICsyNSwxMCBAQCBSZXF1aXJlZCBwcm9wZXJ0aWVzOg0KIE9wdGlvbmFsIHByb3BlcnRp
ZXM6DQogLSBtZWRpYXRlayx0eC1kZWxheS1wczogVFggY2xvY2sgZGVsYXkgbWFjcm8gdmFsdWUu
IERlZmF1bHQgaXMgMC4NCiAJSXQgc2hvdWxkIGJlIGRlZmluZWQgZm9yIFJHTUlJL01JSSBpbnRl
cmZhY2UuDQorCUl0IHNob3VsZCBiZSBkZWZpbmVkIGZvciBSTUlJIGludGVyZmFjZSB3aGVuIHRo
ZSByZWZlcmVuY2UgY2xvY2sgaXMgZnJvbSBNVDI3MTIgU29DLg0KIC0gbWVkaWF0ZWsscngtZGVs
YXktcHM6IFJYIGNsb2NrIGRlbGF5IG1hY3JvIHZhbHVlLiBEZWZhdWx0IGlzIDAuDQotCUl0IHNo
b3VsZCBiZSBkZWZpbmVkIGZvciBSR01JSS9NSUkvUk1JSSBpbnRlcmZhY2UuDQorCUl0IHNob3Vs
ZCBiZSBkZWZpbmVkIGZvciBSR01JSS9NSUkgaW50ZXJmYWNlLg0KKwlJdCBzaG91bGQgYmUgZGVm
aW5lZCBmb3IgUk1JSSBpbnRlcmZhY2UuDQogQm90aCBkZWxheSBwcm9wZXJ0aWVzIG5lZWQgdG8g
YmUgYSBtdWx0aXBsZSBvZiAxNzAgZm9yIFJHTUlJIGludGVyZmFjZSwNCiBvciB3aWxsIHJvdW5k
IGRvd24uIFJhbmdlIDB+MzEqMTcwLg0KIEJvdGggZGVsYXkgcHJvcGVydGllcyBuZWVkIHRvIGJl
IGEgbXVsdGlwbGUgb2YgNTUwIGZvciBNSUkvUk1JSSBpbnRlcmZhY2UsDQpAQCAtMzQsMTMgKzM4
LDIwIEBAIG9yIHdpbGwgcm91bmQgZG93bi4gUmFuZ2UgMH4zMSo1NTAuDQogCXJlZmVyZW5jZSBj
bG9jaywgd2hpY2ggaXMgZnJvbSBleHRlcm5hbCBQSFlzLCBpcyBjb25uZWN0ZWQgdG8gUlhDIHBp
bg0KIAlvbiBNVDI3MTIgU29DLg0KIAlPdGhlcndpc2UsIGlzIGNvbm5lY3RlZCB0byBUWEMgcGlu
Lg0KKy0gbWVkaWF0ZWsscm1paS1jbGstZnJvbS1tYWM6IGJvb2xlYW4gcHJvcGVydHksIGlmIHBy
ZXNlbnQgaW5kaWNhdGVzIHRoYXQNCisJTVQyNzEyIFNvQyBwcm92aWRlcyB0aGUgUk1JSSByZWZl
cmVuY2UgY2xvY2ssIHdoaWNoIG91dHB1dHMgdG8gVFhDIHBpbiBvbmx5Lg0KIC0gbWVkaWF0ZWss
dHhjLWludmVyc2U6IGJvb2xlYW4gcHJvcGVydHksIGlmIHByZXNlbnQgaW5kaWNhdGVzIHRoYXQN
CiAJMS4gdHggY2xvY2sgd2lsbCBiZSBpbnZlcnNlZCBpbiBNSUkvUkdNSUkgY2FzZSwNCiAJMi4g
dHggY2xvY2sgaW5zaWRlIE1BQyB3aWxsIGJlIGludmVyc2VkIHJlbGF0aXZlIHRvIHJlZmVyZW5j
ZSBjbG9jaw0KIAkgICB3aGljaCBpcyBmcm9tIGV4dGVybmFsIFBIWXMgaW4gUk1JSSBjYXNlLCBh
bmQgaXQgcmFyZWx5IGhhcHBlbi4NCisJMy4gdGhlIHJlZmVyZW5jZSBjbG9jaywgd2hpY2ggb3V0
cHV0cyB0byBUWEMgcGluIHdpbGwgYmUgaW52ZXJzZWQgaW4gUk1JSSBjYXNlDQorCSAgIHdoZW4g
dGhlIHJlZmVyZW5jZSBjbG9jayBpcyBmcm9tIE1UMjcxMiBTb0MuDQogLSBtZWRpYXRlayxyeGMt
aW52ZXJzZTogYm9vbGVhbiBwcm9wZXJ0eSwgaWYgcHJlc2VudCBpbmRpY2F0ZXMgdGhhdA0KIAkx
LiByeCBjbG9jayB3aWxsIGJlIGludmVyc2VkIGluIE1JSS9SR01JSSBjYXNlLg0KLQkyLiByZWZl
cmVuY2UgY2xvY2sgd2lsbCBiZSBpbnZlcnNlZCB3aGVuIGFycml2ZWQgYXQgTUFDIGluIFJNSUkg
Y2FzZS4NCisJMi4gcmVmZXJlbmNlIGNsb2NrIHdpbGwgYmUgaW52ZXJzZWQgd2hlbiBhcnJpdmVk
IGF0IE1BQyBpbiBSTUlJIGNhc2UsIHdoZW4NCisJICAgdGhlIHJlZmVyZW5jZSBjbG9jayBpcyBm
cm9tIGV4dGVybmFsIFBIWXMuDQorCTMuIHRoZSBpbnNpZGUgY2xvY2ssIHdoaWNoIGJlIHNlbnQg
dG8gTUFDLCB3aWxsIGJlIGludmVyc2VkIGluIFJNSUkgY2FzZSB3aGVuDQorCSAgIHRoZSByZWZl
cmVuY2UgY2xvY2sgaXMgZnJvbSBNVDI3MTIgU29DLg0KIC0gYXNzaWduZWQtY2xvY2tzOiBtYWNf
bWFpbiBhbmQgcHRwX3JlZiBjbG9ja3MNCiAtIGFzc2lnbmVkLWNsb2NrLXBhcmVudHM6IHBhcmVu
dCBjbG9ja3Mgb2YgdGhlIGFzc2lnbmVkIGNsb2Nrcw0KIA0KLS0gDQoyLjE4LjANCg==

