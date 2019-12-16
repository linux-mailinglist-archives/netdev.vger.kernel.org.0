Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB06C11FE23
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 06:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfLPFkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 00:40:20 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34010 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726446AbfLPFkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 00:40:18 -0500
X-UUID: b83c995ee2664b2ab22617f9491e5ee6-20191216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ZFK5ya63Cy6wgpbjF8WuGV2/7oL5ZesSkDZ/6F6akns=;
        b=URuXVQ6rEfU70mCz7AhPi2espcq0sh73aLPTTTNiFNhvgqbo3R+//uGoo20HDq62wvq4EZnmIgZI9LreEAz1u3NfJOLD9cKVfvzcItZyn102ixKKiLu4obWhzPEQHRs8FdrSGXPtUfmuxQvI/S39hrN83egTm8WRlM9Ne9e/m5s=;
X-UUID: b83c995ee2664b2ab22617f9491e5ee6-20191216
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1769448215; Mon, 16 Dec 2019 13:40:09 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Dec 2019 13:40:30 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Dec 2019 13:39:22 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
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
Subject: [v2, PATCH 2/2] net-next: dt-binding: dwmac-mediatek: add more description for RMII
Date:   Mon, 16 Dec 2019 13:39:58 +0800
Message-ID: <20191216053958.26130-3-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191216053958.26130-1-biao.huang@mediatek.com>
References: <20191216053958.26130-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TVQyNzEyIFNvQyBjYW4gcHJvdmlkZSBSTUlJIHJlZmVyZW5jZSBjbG9jaywNCnNvIGFkZCBjb3Jy
ZXNwb25kaW5nIGRlc2NyaXB0aW9uIGluIGR0LWJpbmRpbmcuDQoNClNpZ25lZC1vZmYtYnk6IEJp
YW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29tPg0KLS0tDQogLi4uL2JpbmRpbmdzL25l
dC9tZWRpYXRlay1kd21hYy50eHQgICAgICAgICAgIHwgMzMgKysrKysrKysrKysrKy0tLS0tLQ0K
IDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWst
ZHdtYWMudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRl
ay1kd21hYy50eHQNCmluZGV4IDhhMDg2MjFhNWI1NC4uYWZiY2FlYmYwNjJlIDEwMDY0NA0KLS0t
IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy50
eHQNCisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWst
ZHdtYWMudHh0DQpAQCAtMTQsNyArMTQsNyBAQCBSZXF1aXJlZCBwcm9wZXJ0aWVzOg0KIAlTaG91
bGQgYmUgIm1hY2lycSIgZm9yIHRoZSBtYWluIE1BQyBJUlENCiAtIGNsb2NrczogTXVzdCBjb250
YWluIGEgcGhhbmRsZSBmb3IgZWFjaCBlbnRyeSBpbiBjbG9jay1uYW1lcy4NCiAtIGNsb2NrLW5h
bWVzOiBUaGUgbmFtZSBvZiB0aGUgY2xvY2sgbGlzdGVkIGluIHRoZSBjbG9ja3MgcHJvcGVydHku
IFRoZXNlIGFyZQ0KLQkiYXhpIiwgImFwYiIsICJtYWNfbWFpbiIsICJwdHBfcmVmIiBmb3IgTVQy
NzEyIFNvQw0KKwkiYXhpIiwgImFwYiIsICJtYWNfbWFpbiIsICJwdHBfcmVmIiwgInJtaWlfaW50
ZXJuYWwiIGZvciBNVDI3MTIgU29DLg0KIC0gbWFjLWFkZHJlc3M6IFNlZSBldGhlcm5ldC50eHQg
aW4gdGhlIHNhbWUgZGlyZWN0b3J5DQogLSBwaHktbW9kZTogU2VlIGV0aGVybmV0LnR4dCBpbiB0
aGUgc2FtZSBkaXJlY3RvcnkNCiAtIG1lZGlhdGVrLHBlcmljZmc6IEEgcGhhbmRsZSB0byB0aGUg
c3lzY29uIG5vZGUgdGhhdCBjb250cm9sIGV0aGVybmV0DQpAQCAtMjMsOCArMjMsMTAgQEAgUmVx
dWlyZWQgcHJvcGVydGllczoNCiBPcHRpb25hbCBwcm9wZXJ0aWVzOg0KIC0gbWVkaWF0ZWssdHgt
ZGVsYXktcHM6IFRYIGNsb2NrIGRlbGF5IG1hY3JvIHZhbHVlLiBEZWZhdWx0IGlzIDAuDQogCUl0
IHNob3VsZCBiZSBkZWZpbmVkIGZvciBSR01JSS9NSUkgaW50ZXJmYWNlLg0KKwlJdCBzaG91bGQg
YmUgZGVmaW5lZCBmb3IgUk1JSSBpbnRlcmZhY2Ugd2hlbiB0aGUgcmVmZXJlbmNlIGNsb2NrIGlz
IGZyb20gTVQyNzEyIFNvQy4NCiAtIG1lZGlhdGVrLHJ4LWRlbGF5LXBzOiBSWCBjbG9jayBkZWxh
eSBtYWNybyB2YWx1ZS4gRGVmYXVsdCBpcyAwLg0KLQlJdCBzaG91bGQgYmUgZGVmaW5lZCBmb3Ig
UkdNSUkvTUlJL1JNSUkgaW50ZXJmYWNlLg0KKwlJdCBzaG91bGQgYmUgZGVmaW5lZCBmb3IgUkdN
SUkvTUlJIGludGVyZmFjZS4NCisJSXQgc2hvdWxkIGJlIGRlZmluZWQgZm9yIFJNSUkgaW50ZXJm
YWNlLg0KIEJvdGggZGVsYXkgcHJvcGVydGllcyBuZWVkIHRvIGJlIGEgbXVsdGlwbGUgb2YgMTcw
IGZvciBSR01JSSBpbnRlcmZhY2UsDQogb3Igd2lsbCByb3VuZCBkb3duLiBSYW5nZSAwfjMxKjE3
MC4NCiBCb3RoIGRlbGF5IHByb3BlcnRpZXMgbmVlZCB0byBiZSBhIG11bHRpcGxlIG9mIDU1MCBm
b3IgTUlJL1JNSUkgaW50ZXJmYWNlLA0KQEAgLTM0LDEzICszNiwyMCBAQCBvciB3aWxsIHJvdW5k
IGRvd24uIFJhbmdlIDB+MzEqNTUwLg0KIAlyZWZlcmVuY2UgY2xvY2ssIHdoaWNoIGlzIGZyb20g
ZXh0ZXJuYWwgUEhZcywgaXMgY29ubmVjdGVkIHRvIFJYQyBwaW4NCiAJb24gTVQyNzEyIFNvQy4N
CiAJT3RoZXJ3aXNlLCBpcyBjb25uZWN0ZWQgdG8gVFhDIHBpbi4NCistIG1lZGlhdGVrLHJtaWkt
Y2xrLWZyb20tbWFjOiBib29sZWFuIHByb3BlcnR5LCBpZiBwcmVzZW50IGluZGljYXRlcyB0aGF0
DQorCU1UMjcxMiBTb0MgcHJvdmlkZXMgdGhlIFJNSUkgcmVmZXJlbmNlIGNsb2NrLCB3aGljaCBv
dXRwdXRzIHRvIFRYQyBwaW4gb25seS4NCiAtIG1lZGlhdGVrLHR4Yy1pbnZlcnNlOiBib29sZWFu
IHByb3BlcnR5LCBpZiBwcmVzZW50IGluZGljYXRlcyB0aGF0DQogCTEuIHR4IGNsb2NrIHdpbGwg
YmUgaW52ZXJzZWQgaW4gTUlJL1JHTUlJIGNhc2UsDQogCTIuIHR4IGNsb2NrIGluc2lkZSBNQUMg
d2lsbCBiZSBpbnZlcnNlZCByZWxhdGl2ZSB0byByZWZlcmVuY2UgY2xvY2sNCiAJICAgd2hpY2gg
aXMgZnJvbSBleHRlcm5hbCBQSFlzIGluIFJNSUkgY2FzZSwgYW5kIGl0IHJhcmVseSBoYXBwZW4u
DQorCTMuIHRoZSByZWZlcmVuY2UgY2xvY2ssIHdoaWNoIG91dHB1dHMgdG8gVFhDIHBpbiB3aWxs
IGJlIGludmVyc2VkIGluIFJNSUkgY2FzZQ0KKwkgICB3aGVuIHRoZSByZWZlcmVuY2UgY2xvY2sg
aXMgZnJvbSBNVDI3MTIgU29DLg0KIC0gbWVkaWF0ZWsscnhjLWludmVyc2U6IGJvb2xlYW4gcHJv
cGVydHksIGlmIHByZXNlbnQgaW5kaWNhdGVzIHRoYXQNCiAJMS4gcnggY2xvY2sgd2lsbCBiZSBp
bnZlcnNlZCBpbiBNSUkvUkdNSUkgY2FzZS4NCi0JMi4gcmVmZXJlbmNlIGNsb2NrIHdpbGwgYmUg
aW52ZXJzZWQgd2hlbiBhcnJpdmVkIGF0IE1BQyBpbiBSTUlJIGNhc2UuDQorCTIuIHJlZmVyZW5j
ZSBjbG9jayB3aWxsIGJlIGludmVyc2VkIHdoZW4gYXJyaXZlZCBhdCBNQUMgaW4gUk1JSSBjYXNl
LCB3aGVuDQorCSAgIHRoZSByZWZlcmVuY2UgY2xvY2sgaXMgZnJvbSBleHRlcm5hbCBQSFlzLg0K
KwkzLiB0aGUgaW5zaWRlIGNsb2NrLCB3aGljaCBiZSBzZW50IHRvIE1BQywgd2lsbCBiZSBpbnZl
cnNlZCBpbiBSTUlJIGNhc2Ugd2hlbg0KKwkgICB0aGUgcmVmZXJlbmNlIGNsb2NrIGlzIGZyb20g
TVQyNzEyIFNvQy4NCiAtIGFzc2lnbmVkLWNsb2NrczogbWFjX21haW4gYW5kIHB0cF9yZWYgY2xv
Y2tzDQogLSBhc3NpZ25lZC1jbG9jay1wYXJlbnRzOiBwYXJlbnQgY2xvY2tzIG9mIHRoZSBhc3Np
Z25lZCBjbG9ja3MNCiANCkBAIC01MCwyOSArNTksMzMgQEAgRXhhbXBsZToNCiAJCXJlZyA9IDww
IDB4MTEwMWMwMDAgMCAweDEzMDA+Ow0KIAkJaW50ZXJydXB0cyA9IDxHSUNfU1BJIDIzNyBJUlFf
VFlQRV9MRVZFTF9MT1c+Ow0KIAkJaW50ZXJydXB0LW5hbWVzID0gIm1hY2lycSI7DQotCQlwaHkt
bW9kZSA9InJnbWlpIjsNCisJCXBoeS1tb2RlID0icmdtaWktcnhpZCI7DQogCQltYWMtYWRkcmVz
cyA9IFswMCA1NSA3YiBiNSA3ZCBmN107DQogCQljbG9jay1uYW1lcyA9ICJheGkiLA0KIAkJCSAg
ICAgICJhcGIiLA0KIAkJCSAgICAgICJtYWNfbWFpbiIsDQogCQkJICAgICAgInB0cF9yZWYiLA0K
LQkJCSAgICAgICJwdHBfdG9wIjsNCisJCQkgICAgICAicm1paV9pbnRlcm5hbCI7DQogCQljbG9j
a3MgPSA8JnBlcmljZmcgQ0xLX1BFUklfR01BQz4sDQogCQkJIDwmcGVyaWNmZyBDTEtfUEVSSV9H
TUFDX1BDTEs+LA0KIAkJCSA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJfMTI1TV9TRUw+LA0KLQkJ
CSA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJfNTBNX1NFTD47DQorCQkJIDwmdG9wY2tnZW4gQ0xL
X1RPUF9FVEhFUl81ME1fU0VMPiwNCisJCQkgPCZ0b3Bja2dlbiBDTEtfVE9QX0VUSEVSXzUwTV9S
TUlJX1NFTD47DQogCQlhc3NpZ25lZC1jbG9ja3MgPSA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJf
MTI1TV9TRUw+LA0KLQkJCQkgIDwmdG9wY2tnZW4gQ0xLX1RPUF9FVEhFUl81ME1fU0VMPjsNCisJ
CQkJICA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJfNTBNX1NFTD4sDQorCQkJCSAgPCZ0b3Bja2dl
biBDTEtfVE9QX0VUSEVSXzUwTV9STUlJX1NFTD47DQogCQlhc3NpZ25lZC1jbG9jay1wYXJlbnRz
ID0gPCZ0b3Bja2dlbiBDTEtfVE9QX0VUSEVSUExMXzEyNU0+LA0KLQkJCQkJIDwmdG9wY2tnZW4g
Q0xLX1RPUF9BUExMMV9EMz47DQorCQkJCQkgPCZ0b3Bja2dlbiBDTEtfVE9QX0FQTEwxX0QzPiwN
CisJCQkJCSA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJQTExfNTBNPjsNCisJCXBvd2VyLWRvbWFp
bnMgPSA8JnNjcHN5cyBNVDI3MTJfUE9XRVJfRE9NQUlOX0FVRElPPjsNCiAJCW1lZGlhdGVrLHBl
cmljZmcgPSA8JnBlcmljZmc+Ow0KIAkJbWVkaWF0ZWssdHgtZGVsYXktcHMgPSA8MTUzMD47DQog
CQltZWRpYXRlayxyeC1kZWxheS1wcyA9IDwxNTMwPjsNCiAJCW1lZGlhdGVrLHJtaWktcnhjOw0K
IAkJbWVkaWF0ZWssdHhjLWludmVyc2U7DQogCQltZWRpYXRlayxyeGMtaW52ZXJzZTsNCi0JCXNu
cHMsdHhwYmwgPSA8MzI+Ow0KLQkJc25wcyxyeHBibCA9IDwzMj47DQorCQlzbnBzLHR4cGJsID0g
PDE+Ow0KKwkJc25wcyxyeHBibCA9IDwxPjsNCiAJCXNucHMscmVzZXQtZ3BpbyA9IDwmcGlvIDg3
IEdQSU9fQUNUSVZFX0xPVz47DQogCQlzbnBzLHJlc2V0LWFjdGl2ZS1sb3c7DQogCX07DQotLSAN
CjIuMTguMA0K

