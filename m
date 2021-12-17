Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3032F4782F8
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 03:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhLQCGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 21:06:07 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:49286 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231334AbhLQCGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 21:06:07 -0500
X-UUID: bfd9d48296cc4064aa069d17e1140ff2-20211217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=oKLXoDnvb+4kT3LFl2tU05cJqVSai2RXcpGwEw0iC4E=;
        b=ELpxMOegMLNzSaITGX1OAu2PibuUls4egKInPifVqYzhfRGPKCOWfdaCc4YLTdeeho8vykxt8KD12j7uaSWzDnXs2MQHRay5lh6MraoZdqazNYZv35/0/hAinInn5Q/f2Mtmm6ACUL4Ik8LdyQ2lKZkV94DrEF+b+5qVbNFS3Go=;
X-UUID: bfd9d48296cc4064aa069d17e1140ff2-20211217
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1188725979; Fri, 17 Dec 2021 10:06:02 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 17 Dec 2021 10:06:01 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Dec 2021 10:05:58 +0800
Message-ID: <be023f9d2fb2a8f947bd0075e8732ba07cfd7b89.camel@mediatek.com>
Subject: Re: [PATCH net-next v10 6/6] net: dt-bindings: dwmac: add support
 for mt8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     <srv_heupstream@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <angelogioacchino.delregno@collabora.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, <netdev@vger.kernel.org>,
        <dkirjanov@suse.de>, <linux-kernel@vger.kernel.org>,
        <macpaul.lin@mediatek.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Date:   Fri, 17 Dec 2021 10:05:58 +0800
In-Reply-To: <1639662782.987227.4004875.nullmailer@robh.at.kernel.org>
References: <20211216055328.15953-1-biao.huang@mediatek.com>
         <20211216055328.15953-7-biao.huang@mediatek.com>
         <1639662782.987227.4004875.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQogIFRoYW5rcyBmb3IgeW91ciBjb21tZW50c34NCg0KICBGb3IgbXQ4MTk1LCB0
aGUgZXRoIGRldmljZSBub2RlIHdpbGwgbG9vayBsaWtlOg0KICBldGg6IGV0aGVybmV0QDExMDIx
MDAwIHsNCiAgICBjb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODE5NS1nbWFjIiwgInNucHMsZHdt
YWMtNS4xMGEiOw0KICAgIC4uLg0KICAgIGNsb2NrLW5hbWVzID0gImF4aSIsDQogICAgICAgICAg
ICAgICAgICAiYXBiIiwNCiAgICAgICAgICAgICAgICAgICJtYWNfY2ciLA0KICAgICAgICAgICAg
ICAgICAgIm1hY19tYWluIiwNCiAgICAgICAgICAgICAgICAgICJwdHBfcmVmIiwNCiAgICAgICAg
ICAgICAgICAgICJybWlpX2ludGVybmFsIjsNCiAgICBjbG9ja3MgPSA8JnBlcmljZmdfYW8gQ0xL
X1BFUklfQU9fRVRIRVJORVQ+LA0KICAgICAgICAgICAgIDwmcGVyaWNmZ19hbyBDTEtfUEVSSV9B
T19FVEhFUk5FVF9CVVM+LA0KICAgICAgICAgICAgIDwmcGVyaWNmZ19hbyBDTEtfUEVSSV9BT19F
VEhFUk5FVF9NQUM+LA0KICAgICAgICAgICAgIDwmdG9wY2tnZW4gQ0xLX1RPUF9TTlBTX0VUSF8y
NTBNPiwNCiAgICAgICAgICAgICA8JnRvcGNrZ2VuIENMS19UT1BfU05QU19FVEhfNjJQNE1fUFRQ
PiwNCiAgICAgICAgICAgICA8JnRvcGNrZ2VuIENMS19UT1BfU05QU19FVEhfNTBNX1JNSUk+Ow0K
ICAgIC4uLg0KICB9DQoNCjEuICJybWlpX2ludGVybmFsIiBpcyBhIHNwZWNpYWwgY2xvY2sgb25s
eSByZXF1aXJlZCBmb3INCiAgIFJNSUkgcGh5IGludGVyZmFjZSwgZHdtYWMtbWVkaWF0ZWsuYyB3
aWxsIGVuYWJsZSBjbG9ja3MNCiAgIGludm9raW5nIGNsa19idWxrX3ByZXBhcmVfZW5hYmxlKHh4
LCA2KSBmb3IgUk1JSSwNCiAgIGFuZCBjbGtfYnVsa19wcmVwYXJlX2VuYWJsZSh4eCwgNSkgZm9y
IG90aGVyIHBoeSBpbnRlcmZhY2VzLg0KICAgc28sIG10MjcxMi9tdDgxOTUgYWxsIHB1dCAicm1p
aV9pbnRlcm5hbCIgY2xvY2sgdG8gdGhlDQogICBlbmQgb2YgY2xvY2sgbGlzdCB0byBzaW1wbGlm
eSBjbG9jayBoYW5kbGluZy4NCg0KICAgSWYgSSBwdXQgbWFjX2NnIGFzIGRlc2NyaWJlZCBhYm92
ZSwgYSBpZiBjb25kaXRpb24gaXMgcmVxdWlyZWQNCmZvciBjbG9ja3MgZGVzY3JpcHRpb24gaW4g
ZHQtYmluZGluZywganVzdCBsaWtlIHdoYXQgSSBkbyBpbiB2NyBzZW5kOg0KICAtIGlmOg0KICAg
ICAgcHJvcGVydGllczoNCiAgICAgICAgY29tcGF0aWJsZToNCiAgICAgICAgICBjb250YWluczoN
CiAgICAgICAgICAgIGVudW06DQogICAgICAgICAgICAgIC0gbWVkaWF0ZWssbXQyNzEyLWdtYWMN
Cg0KICAgIHRoZW46DQogICAgICBwcm9wZXJ0aWVzOg0KICAgICAgICBjbG9ja3M6DQogICAgICAg
ICAgbWluSXRlbXM6IDUNCiAgICAgICAgICBpdGVtczoNCiAgICAgICAgICAgIC0gZGVzY3JpcHRp
b246IEFYSSBjbG9jaw0KICAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogQVBCIGNsb2NrDQogICAg
ICAgICAgICAtIGRlc2NyaXB0aW9uOiBNQUMgTWFpbiBjbG9jaw0KICAgICAgICAgICAgLSBkZXNj
cmlwdGlvbjogUFRQIGNsb2NrDQogICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiBSTUlJIHJlZmVy
ZW5jZSBjbG9jayBwcm92aWRlZCBieSBNQUMNCg0KICAgICAgICBjbG9jay1uYW1lczoNCiAgICAg
ICAgICBtaW5JdGVtczogNQ0KICAgICAgICAgIGl0ZW1zOg0KICAgICAgICAgICAgLSBjb25zdDog
YXhpDQogICAgICAgICAgICAtIGNvbnN0OiBhcGINCiAgICAgICAgICAgIC0gY29uc3Q6IG1hY19t
YWluDQogICAgICAgICAgICAtIGNvbnN0OiBwdHBfcmVmDQogICAgICAgICAgICAtIGNvbnN0OiBy
bWlpX2ludGVybmFsDQoNCiAgLSBpZjoNCiAgICAgIHByb3BlcnRpZXM6DQogICAgICAgIGNvbXBh
dGlibGU6DQogICAgICAgICAgY29udGFpbnM6DQogICAgICAgICAgICBlbnVtOg0KICAgICAgICAg
ICAgICAtIG1lZGlhdGVrLG10ODE5NS1nbWFjDQoNCiAgICB0aGVuOg0KICAgICAgcHJvcGVydGll
czoNCiAgICAgICAgY2xvY2tzOg0KICAgICAgICAgIG1pbkl0ZW1zOiA2DQogICAgICAgICAgaXRl
bXM6DQogICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiBBWEkgY2xvY2sNCiAgICAgICAgICAgIC0g
ZGVzY3JpcHRpb246IEFQQiBjbG9jaw0KICAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogTUFDIGNs
b2NrIGdhdGUNCiAgICAgICAgICAgIC0gZGVzY3JpcHRpb246IE1BQyBNYWluIGNsb2NrDQogICAg
ICAgICAgICAtIGRlc2NyaXB0aW9uOiBQVFAgY2xvY2sNCiAgICAgICAgICAgIC0gZGVzY3JpcHRp
b246IFJNSUkgcmVmZXJlbmNlIGNsb2NrIHByb3ZpZGVkIGJ5IE1BQw0KDQogICBUaGlzIGludHJv
ZHVjZXMgc29tZSBkdXBsaWNhdGVkIGRlc2NyaXB0aW9uLg0KDQoyLiBJZiBJIHB1dCAibWFjX2Nn
IiB0byB0aGUgZW5kIG9mIGNsb2NrIGxpc3QsDQogICB0aGUgZHQtYmluZGluZyBmaWxlIGNhbiBi
ZSBzaW1wbGUganVzdCBsaWtlDQogICB3aGF0IHdlIGRvIGluIHRoaXMgdjEwIHBhdGNoKG5lZWQg
Zml4IHdhcm5pbmdzIHJlcG9ydGVkIGJ5ICJtYWtlDQpEVF9DSEVDS0VSX0ZMQUdTPS1tIGR0X2Jp
bmRpbmdfY2hlY2siKS4NCg0KICAgQnV0IGZvciBtdDgxOTU6DQogICAgIHRoZSBldGggbm9kZSBp
biBkdHMgc2hvdWxkIGJlIG1vZGlmaWVkLA0KICAgICBhbmQgZXRoIGRyaXZlciBjbG9jayBoYW5k
bGluZyB3aWxsIGJlIGNvbXBsZXg7DQoNCldlIHByZWZlciAxKGR1cGxpY2F0ZWQgZGVzY3JpcHRp
b24gb25lKS4NCkNhbiB3ZSBqdXN0IGRlc2NpcmJlIGNsb2Nrcy9jbG9ja3MtbmFtZXMgZm9yIG10
MjcxMi9tdDgxOTUgc2VwZXJhdGVseT8NClBsZWFzZSBraW5kbHkgY29tbWVudCBhYm91dCB0aGlz
IGlzc3VlLg0KVGhhbmtzIGluIGFkdmFuY2UuDQoNCk9uIFRodSwgMjAyMS0xMi0xNiBhdCAwNzo1
MyAtMDYwMCwgUm9iIEhlcnJpbmcgd3JvdGU6DQo+IE9uIFRodSwgMTYgRGVjIDIwMjEgMTM6NTM6
MjggKzA4MDAsIEJpYW8gSHVhbmcgd3JvdGU6DQo+ID4gQWRkIGJpbmRpbmcgZG9jdW1lbnQgZm9y
IHRoZSBldGhlcm5ldCBvbiBtdDgxOTUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQmlhbyBI
dWFuZyA8Ymlhby5odWFuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9iaW5kaW5n
cy9uZXQvbWVkaWF0ZWstZHdtYWMueWFtbCAgICAgICAgICB8IDI5DQo+ID4gKysrKysrKysrKysr
KysrKy0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkNCj4gPiANCj4gDQo+IE15IGJvdCBmb3VuZCBlcnJvcnMgcnVubmluZyAnbWFrZSBEVF9D
SEVDS0VSX0ZMQUdTPS1tDQo+IGR0X2JpbmRpbmdfY2hlY2snDQo+IG9uIHlvdXIgcGF0Y2ggKERU
X0NIRUNLRVJfRkxBR1MgaXMgbmV3IGluIHY1LjEzKToNCj4gDQo+IHlhbWxsaW50IHdhcm5pbmdz
L2Vycm9yczoNCj4gDQo+IGR0c2NoZW1hL2R0YyB3YXJuaW5ncy9lcnJvcnM6DQo+IC9idWlsZHMv
cm9iaGVycmluZy9saW51eC1kdC0NCj4gcmV2aWV3L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMueWFtbDoNCj4gcHJvcGVydGllczpjbG9jay1uYW1l
czogeydtaW5JdGVtcyc6IDUsICdtYXhJdGVtcyc6IDYsICdpdGVtcyc6DQo+IFt7J2NvbnN0Jzog
J2F4aSd9LCB7J2NvbnN0JzogJ2FwYid9LCB7J2NvbnN0JzogJ21hY19tYWluJ30sIHsnY29uc3Qn
Og0KPiAncHRwX3JlZid9LCB7J2NvbnN0JzogJ3JtaWlfaW50ZXJuYWwnfSwgeydjb25zdCc6ICdt
YWNfY2cnfV19IHNob3VsZA0KPiBub3QgYmUgdmFsaWQgdW5kZXIgeydyZXF1aXJlZCc6IFsnbWF4
SXRlbXMnXX0NCj4gCWhpbnQ6ICJtYXhJdGVtcyIgaXMgbm90IG5lZWRlZCB3aXRoIGFuICJpdGVt
cyIgbGlzdA0KPiAJZnJvbSBzY2hlbWEgJGlkOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1z
Y2hlbWFzL2l0ZW1zLnlhbWwjDQo+IC9idWlsZHMvcm9iaGVycmluZy9saW51eC1kdC0NCj4gcmV2
aWV3L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMu
eWFtbDoNCj4gaWdub3JpbmcsIGVycm9yIGluIHNjaGVtYTogcHJvcGVydGllczogY2xvY2stbmFt
ZXMNCj4gd2FybmluZzogbm8gc2NoZW1hIGZvdW5kIGluIGZpbGU6DQo+IC4vRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy55YW1sDQo+IERvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstDQo+IGR3bWFjLmV4YW1wbGUu
ZHQueWFtbDowOjA6IC9leGFtcGxlLTAvZXRoZXJuZXRAMTEwMWMwMDA6IGZhaWxlZCB0bw0KPiBt
YXRjaCBhbnkgc2NoZW1hIHdpdGggY29tcGF0aWJsZTogWydtZWRpYXRlayxtdDI3MTItZ21hYycs
DQo+ICdzbnBzLGR3bWFjLTQuMjBhJ10NCj4gDQo+IGRvYyByZWZlcmVuY2UgZXJyb3JzIChtYWtl
IHJlZmNoZWNrZG9jcyk6DQo+IA0KPiBTZWUgaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9w
YXRjaC8xNTY4OTAyDQo+IA0KPiBUaGlzIGNoZWNrIGNhbiBmYWlsIGlmIHRoZXJlIGFyZSBhbnkg
ZGVwZW5kZW5jaWVzLiBUaGUgYmFzZSBmb3IgYQ0KPiBwYXRjaA0KPiBzZXJpZXMgaXMgZ2VuZXJh
bGx5IHRoZSBtb3N0IHJlY2VudCByYzEuDQo+IA0KPiBJZiB5b3UgYWxyZWFkeSByYW4gJ21ha2Ug
ZHRfYmluZGluZ19jaGVjaycgYW5kIGRpZG4ndCBzZWUgdGhlIGFib3ZlDQo+IGVycm9yKHMpLCB0
aGVuIG1ha2Ugc3VyZSAneWFtbGxpbnQnIGlzIGluc3RhbGxlZCBhbmQgZHQtc2NoZW1hIGlzIHVw
DQo+IHRvDQo+IGRhdGU6DQo+IA0KPiBwaXAzIGluc3RhbGwgZHRzY2hlbWEgLS11cGdyYWRlDQo+
IA0KPiBQbGVhc2UgY2hlY2sgYW5kIHJlLXN1Ym1pdC4NCj4gDQo=

