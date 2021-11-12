Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD5844E027
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhKLCOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:14:45 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45960 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229908AbhKLCOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 21:14:44 -0500
X-UUID: 21e06842463d43bc821990a8da6df3f8-20211112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ufO+ZBf8QD7tWoExaa5T5GTQHOADopwfBVamDw5rnT8=;
        b=WGNR5C6X6mNe9hpA9vwRUcTU0RpZ+MmlZaY7jez4e3CnJzapr5V2kQlzKqbAQQu+rUFQeu3QuTgN1Hp3VFE/gvn3ZDWUSeTGURKnQJ3Z/LO5fo3t1EkV66nFGaNjz5G2QanusQTSifCyApWAqNlOPOtzRpdaUJygJaIEco4qF3Y=;
X-UUID: 21e06842463d43bc821990a8da6df3f8-20211112
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1869951413; Fri, 12 Nov 2021 10:11:52 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 12 Nov 2021 10:11:51 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Nov 2021 10:11:50 +0800
Message-ID: <5500319817253c3f0c01064c363089d6b0c95d48.camel@mediatek.com>
Subject: Re: [PATCH v2 4/5] dt-bindings: net: dwmac: Convert mediatek-dwmac
 to DT schema
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Jose Abreu <joabreu@synopsys.com>,
        <srv_heupstream@mediatek.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <macpaul.lin@mediatek.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Date:   Fri, 12 Nov 2021 10:11:50 +0800
In-Reply-To: <1636642646.918741.3774088.nullmailer@robh.at.kernel.org>
References: <20211111071214.21027-1-biao.huang@mediatek.com>
         <20211111071214.21027-5-biao.huang@mediatek.com>
         <1636642646.918741.3774088.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KDQpPbiBUaHUsIDIwMjEtMTEt
MTEgYXQgMDg6NTcgLTA2MDAsIFJvYiBIZXJyaW5nIHdyb3RlOg0KPiBPbiBUaHUsIDExIE5vdiAy
MDIxIDE1OjEyOjEzICswODAwLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiA+IENvbnZlcnQgbWVkaWF0
ZWstZHdtYWMgdG8gRFQgc2NoZW1hLCBhbmQgZGVsZXRlIG9sZCBtZWRpYXRlay0NCj4gPiBkd21h
Yy50eHQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQmlhbyBIdWFuZyA8Ymlhby5odWFuZ0Bt
ZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdt
YWMudHh0ICAgICAgICAgICB8ICA5MSAtLS0tLS0tLQ0KPiA+ICAuLi4vYmluZGluZ3MvbmV0L21l
ZGlhdGVrLWR3bWFjLnlhbWwgICAgICAgICAgfCAyMTENCj4gPiArKysrKysrKysrKysrKysrKysN
Cj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyMTEgaW5zZXJ0aW9ucygrKSwgOTEgZGVsZXRpb25zKC0p
DQo+ID4gIGRlbGV0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L21lZGlhdGVrLQ0KPiA+IGR3bWFjLnR4dA0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQg
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay0NCj4gPiBkd21h
Yy55YW1sDQo+ID4gDQo+IA0KPiBSdW5uaW5nICdtYWtlIGR0YnNfY2hlY2snIHdpdGggdGhlIHNj
aGVtYSBpbiB0aGlzIHBhdGNoIGdpdmVzIHRoZQ0KPiBmb2xsb3dpbmcgd2FybmluZ3MuIENvbnNp
ZGVyIGlmIHRoZXkgYXJlIGV4cGVjdGVkIG9yIHRoZSBzY2hlbWEgaXMNCj4gaW5jb3JyZWN0LiBU
aGVzZSBtYXkgbm90IGJlIG5ldyB3YXJuaW5ncy4NCj4gDQo+IE5vdGUgdGhhdCBpdCBpcyBub3Qg
eWV0IGEgcmVxdWlyZW1lbnQgdG8gaGF2ZSAwIHdhcm5pbmdzIGZvcg0KPiBkdGJzX2NoZWNrLg0K
PiBUaGlzIHdpbGwgY2hhbmdlIGluIHRoZSBmdXR1cmUuDQo+IA0KPiBGdWxsIGxvZyBpcyBhdmFp
bGFibGUgaGVyZTogDQo+IGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvMTU1Mzgw
Mw0KPiANCj4gDQo+IGV0aGVybmV0QDExMDFjMDAwOiBjbG9jay1uYW1lczogWydheGknLCAnYXBi
JywgJ21hY19tYWluJywgJ3B0cF9yZWYnXQ0KPiBpcyB0b28gc2hvcnQNCj4gCWFyY2gvYXJtNjQv
Ym9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyLWV2Yi5kdC55YW1sDQo+IA0KPiBldGhlcm5ldEAxMTAx
YzAwMDogY2xvY2tzOiBbWzI3LCAzNF0sIFsyNywgMzddLCBbNiwgMTU0XSwgWzYsIDE1NV1dDQo+
IGlzIHRvbyBzaG9ydA0KPiAJYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDI3MTItZXZi
LmR0LnlhbWwNCj4gDQo+IGV0aGVybmV0QDExMDFjMDAwOiBjb21wYXRpYmxlOiBbJ21lZGlhdGVr
LG10MjcxMi1nbWFjJ10gZG9lcyBub3QNCj4gY29udGFpbiBpdGVtcyBtYXRjaGluZyB0aGUgZ2l2
ZW4gc2NoZW1hDQo+IAlhcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210MjcxMi1ldmIuZHQu
eWFtbA0KPiANCj4gZXRoZXJuZXRAMTEwMWMwMDA6IGNvbXBhdGlibGU6ICdvbmVPZicgY29uZGl0
aW9uYWwgZmFpbGVkLCBvbmUgbXVzdA0KPiBiZSBmaXhlZDoNCj4gCWFyY2gvYXJtNjQvYm9vdC9k
dHMvbWVkaWF0ZWsvbXQyNzEyLWV2Yi5kdC55YW1sDQo+IA0KWWVzLCBJIHNob3VsZCBhZGQgYSBk
dHMgcmVsYXRlZCBwYXRjaCB0byBmaXggdGhpcyBpc3N1ZSBpbiBuZXh0IHNlbmQuDQo=

