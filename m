Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E8D44D1DB
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 07:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhKKGSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 01:18:50 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56104 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229674AbhKKGSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 01:18:50 -0500
X-UUID: b19ff7f055f84f59846da09edcc5d20f-20211111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=tHZR4ShgONrY1xlUrKSMoIV7qdy+WnxCRT5rQr7aNKg=;
        b=AXypkWyzZ8T+5Xhbxi3j/hp1XjY94qr1XZyfZ6FI6buZRJY/nBAWGrytEpmzcR7H7w8Op8tWD2eRS37nUO8JtFNGQ5OQ51zcKR8IOKQ+m0hQNnEqR5phz2VHzEorka/4HK1ULoVzlb9AasCtv13+S6RVkeHXI3lLXcPPeNZk/B8=;
X-UUID: b19ff7f055f84f59846da09edcc5d20f-20211111
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 806377556; Thu, 11 Nov 2021 14:15:57 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 11 Nov 2021 14:15:56 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkmbs10n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 11 Nov 2021 14:15:55 +0800
Message-ID: <426d15179d7d79c3f3bd4774e23d4f5e384c7956.camel@mediatek.com>
Subject: Re: [PATCH 4/5] dt-bindings: net: dwmac: Convert mediatek-dwmac to
 DT schema
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <macpaul.lin@mediatek.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>
Date:   Thu, 11 Nov 2021 14:15:55 +0800
In-Reply-To: <1636573460.872424.1783735.nullmailer@robh.at.kernel.org>
References: <20211110083948.6082-1-biao.huang@mediatek.com>
         <20211110083948.6082-5-biao.huang@mediatek.com>
         <1636573460.872424.1783735.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KCUknbGwgY2hlY2sgYWdhaW4g
d2l0aCB1cGRhdGVkIGR0c2NoZW1hLCBhbmQgc2VuZCBpbiBuZXh0DQp2ZXJzaW9uLg0KCQ0KQmVz
dCBSZWdhcmRzIQ0KQmlhbw0KDQpPbiBXZWQsIDIwMjEtMTEtMTAgYXQgMTM6NDQgLTA2MDAsIFJv
YiBIZXJyaW5nIHdyb3RlOg0KPiBPbiBXZWQsIDEwIE5vdiAyMDIxIDE2OjM5OjQ3ICswODAwLCBC
aWFvIEh1YW5nIHdyb3RlOg0KPiA+IENvbnZlcnQgbWVkaWF0ZWstZHdtYWMgdG8gRFQgc2NoZW1h
LCBhbmQgZGVsZXRlIG9sZCBtZWRpYXRlay0NCj4gPiBkd21hYy50eHQuDQo+ID4gDQo+ID4gU2ln
bmVkLW9mZi1ieTogQmlhbyBIdWFuZyA8Ymlhby5odWFuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0t
DQo+ID4gIC4uLi9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMudHh0ICAgICAgICAgICB8ICA5
MSAtLS0tLS0tLS0NCj4gPiAgLi4uL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy55YW1sICAg
ICAgICAgIHwgMTc5DQo+ID4gKysrKysrKysrKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdl
ZCwgMTc5IGluc2VydGlvbnMoKyksIDkxIGRlbGV0aW9ucygtKQ0KPiA+ICBkZWxldGUgbW9kZSAx
MDA2NDQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay0NCj4g
PiBkd21hYy50eHQNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstDQo+ID4gZHdtYWMueWFtbA0KPiA+IA0KPiANCj4g
TXkgYm90IGZvdW5kIGVycm9ycyBydW5uaW5nICdtYWtlIERUX0NIRUNLRVJfRkxBR1M9LW0NCj4g
ZHRfYmluZGluZ19jaGVjaycNCj4gb24geW91ciBwYXRjaCAoRFRfQ0hFQ0tFUl9GTEFHUyBpcyBu
ZXcgaW4gdjUuMTMpOg0KPiANCj4geWFtbGxpbnQgd2FybmluZ3MvZXJyb3JzOg0KPiANCj4gZHRz
Y2hlbWEvZHRjIHdhcm5pbmdzL2Vycm9yczoNCj4gL2J1aWxkcy9yb2JoZXJyaW5nL2xpbnV4LWR0
LQ0KPiByZXZpZXcvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRl
ay1kd21hYy55YW1sOg0KPiBwcm9wZXJ0aWVzOm1lZGlhdGVrLHR4LWRlbGF5LXBzOiAnJHJlZicg
c2hvdWxkIG5vdCBiZSB2YWxpZCB1bmRlcg0KPiB7J2NvbnN0JzogJyRyZWYnfQ0KPiAJaGludDog
U3RhbmRhcmQgdW5pdCBzdWZmaXggcHJvcGVydGllcyBkb24ndCBuZWVkIGEgdHlwZSAkcmVmDQo+
IAlmcm9tIHNjaGVtYSAkaWQ6IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29y
ZS55YW1sIw0KPiAvYnVpbGRzL3JvYmhlcnJpbmcvbGludXgtZHQtDQo+IHJldmlldy9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFjLnlhbWw6DQo+IHBy
b3BlcnRpZXM6bWVkaWF0ZWsscngtZGVsYXktcHM6ICckcmVmJyBzaG91bGQgbm90IGJlIHZhbGlk
IHVuZGVyDQo+IHsnY29uc3QnOiAnJHJlZid9DQo+IAloaW50OiBTdGFuZGFyZCB1bml0IHN1ZmZp
eCBwcm9wZXJ0aWVzIGRvbid0IG5lZWQgYSB0eXBlICRyZWYNCj4gCWZyb20gc2NoZW1hICRpZDog
aHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwjDQo+IC9idWlsZHMv
cm9iaGVycmluZy9saW51eC1kdC0NCj4gcmV2aWV3L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMueWFtbDoNCj4gcHJvcGVydGllczpjbG9ja3M6IHsn
bWluSXRlbXMnOiA1LCAnbWF4SXRlbXMnOiA2LCAnaXRlbXMnOg0KPiBbeydkZXNjcmlwdGlvbic6
ICdBWEkgY2xvY2snfSwgeydkZXNjcmlwdGlvbic6ICdBUEIgY2xvY2snfSwNCj4geydkZXNjcmlw
dGlvbic6ICdNQUMgY2xvY2sgZ2F0ZSd9LCB7J2Rlc2NyaXB0aW9uJzogJ01BQyBNYWluIGNsb2Nr
J30sDQo+IHsnZGVzY3JpcHRpb24nOiAnUFRQIGNsb2NrJ30sIHsnZGVzY3JpcHRpb24nOiAnUk1J
SSByZWZlcmVuY2UgY2xvY2sNCj4gcHJvdmlkZWQgYnkgTUFDJ31dfSBzaG91bGQgbm90IGJlIHZh
bGlkIHVuZGVyIHsncmVxdWlyZWQnOg0KPiBbJ21heEl0ZW1zJ119DQo+IAloaW50OiAibWF4SXRl
bXMiIGlzIG5vdCBuZWVkZWQgd2l0aCBhbiAiaXRlbXMiIGxpc3QNCj4gCWZyb20gc2NoZW1hICRp
ZDogaHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9pdGVtcy55YW1sIw0KPiAvYnVp
bGRzL3JvYmhlcnJpbmcvbGludXgtZHQtDQo+IHJldmlldy9Eb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFjLnlhbWw6DQo+IGlnbm9yaW5nLCBlcnJvciBp
biBzY2hlbWE6IHByb3BlcnRpZXM6IG1lZGlhdGVrLHR4LWRlbGF5LXBzDQo+IHdhcm5pbmc6IG5v
IHNjaGVtYSBmb3VuZCBpbiBmaWxlOg0KPiAuL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMueWFtbA0KPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvbmV0L21lZGlhdGVrLQ0KPiBkd21hYy5leGFtcGxlLmR0LnlhbWw6MDowOiAvZXhh
bXBsZS0wL2V0aGVybmV0QDExMDFjMDAwOiBmYWlsZWQgdG8NCj4gbWF0Y2ggYW55IHNjaGVtYSB3
aXRoIGNvbXBhdGlibGU6IFsnbWVkaWF0ZWssbXQyNzEyLWdtYWMnLA0KPiAnc25wcyxkd21hYy00
LjIwYSddDQo+IA0KPiBkb2MgcmVmZXJlbmNlIGVycm9ycyAobWFrZSByZWZjaGVja2RvY3MpOg0K
PiANCj4gU2VlIGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvMTU1MzMwNA0KPiAN
Cj4gVGhpcyBjaGVjayBjYW4gZmFpbCBpZiB0aGVyZSBhcmUgYW55IGRlcGVuZGVuY2llcy4gVGhl
IGJhc2UgZm9yIGENCj4gcGF0Y2gNCj4gc2VyaWVzIGlzIGdlbmVyYWxseSB0aGUgbW9zdCByZWNl
bnQgcmMxLg0KPiANCj4gSWYgeW91IGFscmVhZHkgcmFuICdtYWtlIGR0X2JpbmRpbmdfY2hlY2sn
IGFuZCBkaWRuJ3Qgc2VlIHRoZSBhYm92ZQ0KPiBlcnJvcihzKSwgdGhlbiBtYWtlIHN1cmUgJ3lh
bWxsaW50JyBpcyBpbnN0YWxsZWQgYW5kIGR0LXNjaGVtYSBpcyB1cA0KPiB0bw0KPiBkYXRlOg0K
PiANCj4gcGlwMyBpbnN0YWxsIGR0c2NoZW1hIC0tdXBncmFkZQ0KPiANCj4gUGxlYXNlIGNoZWNr
IGFuZCByZS1zdWJtaXQuDQo+IA0K

