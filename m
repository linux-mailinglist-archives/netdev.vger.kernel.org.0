Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ABD28C96F
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390299AbgJMHeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:34:44 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:57140 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390018AbgJMHeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:34:44 -0400
X-UUID: a19d8a28a2ce4e888bb090038b9755cb-20201013
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=NhVO6qrUz779jbsjX2Ikk7b4lJypQXusY9/S6kpeNkY=;
        b=DuMCEZmHGfFooF26geQ0Q1Jiilf0s67Ja/UqIKxCJsj1E6DRBU1/PZNjjDOE1EiEyWXFPWVfYbT7akUMwA0JUGiTW4KP6Cq/9/l6I9xN0NKDrVCnD/3If4AUrE5ZfVE4JUfBw9KZphUKR/wNPd4o1kK/rqiQ5pI1ISp0rMEAu3E=;
X-UUID: a19d8a28a2ce4e888bb090038b9755cb-20201013
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 731229190; Tue, 13 Oct 2020 15:34:30 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31N2.mediatek.inc
 (172.27.4.87) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Oct
 2020 15:34:28 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 13 Oct 2020 15:34:28 +0800
Message-ID: <1602574467.29336.64.camel@mhfsdcap03>
Subject: Re: [PATCH v2 2/4] dt-bindings: usb: add properties for hard wired
 devices
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date:   Tue, 13 Oct 2020 15:34:27 +0800
In-Reply-To: <20201012160038.GA1618651@bogus>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
         <bd71ed260efd162d25e0491988d61fcf1e589bc0.1602318869.git.chunfeng.yun@mediatek.com>
         <20201012160038.GA1618651@bogus>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 808F5C65F94737A36C1DDF462A60B7D27527B5E22BB6950CA26F91DCA51009302000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTEyIGF0IDExOjAwIC0wNTAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4g
T24gU2F0LCBPY3QgMTAsIDIwMjAgYXQgMDQ6NDM6MTJQTSArMDgwMCwgQ2h1bmZlbmcgWXVuIHdy
b3RlOg0KPiA+IEFkZCBzb21lIG9wdGlvbmFsIHByb3BlcnRpZXMgd2hpY2ggYXJlIG5lZWRlZCBm
b3IgaGFyZCB3aXJlZCBkZXZpY2VzDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQ2h1bmZlbmcg
WXVuIDxjaHVuZmVuZy55dW5AbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+IHYyIGNoYW5nZXMg
c3VnZ2VzdGVkIGJ5IFJvYjoNCj4gPiAgICAxLiBtb2RpZnkgcGF0dGVybiB0byBzdXBwb3J0IGFu
eSBVU0IgY2xhc3MNCj4gPiAgICAyLiByZWZlciB0byB1c2ItZGV2aWNlLnlhbWwgaW5zdGVhZCBv
ZiB1c2ItZGV2aWNlLnR4dA0KPiA+IC0tLQ0KPiA+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy91
c2IvdXNiLWhjZC55YW1sICAgICAgfCAxOSArKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmls
ZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspDQo+IA0KPiBZb3UgY2FuIGZvbGQgdGhpcyBpbnRv
IHRoZSBmaXJzdCBwYXRjaC4gV2hpbGUgbm90IGV4cGxpY2l0IGJlZm9yZSwgaXQgDQo+IHdhcyBp
bXBsaWVkLg0KT2sNCg0KPiANCj4gUm9iDQo+IA0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdXNiL3VzYi1oY2QueWFtbCBiL0RvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91c2IvdXNiLWhjZC55YW1sDQo+ID4gaW5kZXggNzI2
M2I3ZjJiNTEwLi40MmIyOTVhZmRmMzIgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL3VzYi91c2ItaGNkLnlhbWwNCj4gPiArKysgYi9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdXNiL3VzYi1oY2QueWFtbA0KPiA+IEBAIC0yMiw5ICsy
MiwyOCBAQCBwcm9wZXJ0aWVzOg0KPiA+ICAgICAgZGVzY3JpcHRpb246DQo+ID4gICAgICAgIE5h
bWUgc3BlY2lmaWVyIGZvciB0aGUgVVNCIFBIWQ0KPiA+ICANCj4gPiArICAiI2FkZHJlc3MtY2Vs
bHMiOg0KPiA+ICsgICAgY29uc3Q6IDENCj4gPiArDQo+ID4gKyAgIiNzaXplLWNlbGxzIjoNCj4g
PiArICAgIGNvbnN0OiAwDQo+ID4gKw0KPiA+ICtwYXR0ZXJuUHJvcGVydGllczoNCj4gPiArICAi
XlthLWZdK0BbMC05YS1mXSskIjoNCj4gDQo+IEp1c3QgZGVmaW5lIHRoZSB1bml0LWFkZHJlc3Mg
aGVyZTogIkBbMC05YS1mXSskIg0KV2hlbiBJIGRlZmluZSBpdCBhcyAiQFswLTlhLWZdKyQiLCB0
aGVyZSBpcyBlcnJvcjoNCiJ1c2ItaGNkLmV4YW1wbGUuZHQueWFtbDogdXNiOiBodWJAMTogJ2Nv
bXBhdGlsZScgaXMgYSByZXF1aXJlZA0KcHJvcGVydHkiDQoNCj4gPiArICAgIHR5cGU6IG9iamVj
dA0KPiA+ICsgICAgJHJlZjogL3VzYi91c2ItZGV2aWNlLnlhbWwNCj4gPiArICAgIGRlc2NyaXB0
aW9uOiBUaGUgaGFyZCB3aXJlZCBVU0IgZGV2aWNlcw0KPiANCj4gTmVlZCB0byBhbHNvIGRlZmlu
ZSAncmVnJyBhbmQgJ2NvbXBhdGlibGUnIGhlcmUuDQoncmVnJyBhbmQgJ2NvbXBhdGlibGUnIGFy
ZSBhbHJlYWR5IGRlZmluZWQgaW4gdXNiLWRldmljZS55YW1sDQoNCj4gDQo+ID4gKw0KPiA+ICBl
eGFtcGxlczoNCj4gPiAgICAtIHwNCj4gPiAgICAgIHVzYiB7DQo+ID4gICAgICAgICAgcGh5cyA9
IDwmdXNiMl9waHkxPiwgPCZ1c2IzX3BoeTE+Ow0KPiA+ICAgICAgICAgIHBoeS1uYW1lcyA9ICJ1
c2IiOw0KPiA+ICsgICAgICAgICNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPiA+ICsgICAgICAgICNz
aXplLWNlbGxzID0gPDA+Ow0KPiA+ICsNCj4gPiArICAgICAgICBodWJAMSB7DQo+ID4gKyAgICAg
ICAgICAgIGNvbXBhdGlibGUgPSAidXNiNWUzLDYxMCI7DQo+ID4gKyAgICAgICAgICAgIHJlZyA9
IDwxPjsNCj4gPiArICAgICAgICB9Ow0KPiA+ICAgICAgfTsNCj4gPiAtLSANCj4gPiAyLjE4LjAN
Cg0K

