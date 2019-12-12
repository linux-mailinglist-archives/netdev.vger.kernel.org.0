Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07B911D092
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 16:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfLLPKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 10:10:11 -0500
Received: from mailgw01.mediatek.com ([216.200.240.184]:45626 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbfLLPKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 10:10:10 -0500
X-UUID: d5b1c1139af847fab4a6947ae83326a9-20191212
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=84wpsP18Q2abVq3hW8fuZwnD/ApWQ30/AxRn97/G118=;
        b=UkPiQGkS1kcFAqhGZxjzEALbMv4gp538c3RtIPLGNFC4DE5xWKS3uuKHLtV7RxD26mPPD5w4rHadQoqMqeoNSzBtEktr9awH5AzEYoEosmXRjTlVGtauooi48+BTvcwr8NL1C7l3QPAkpamTqdF+kLOELr4QVCVCcMnuCoV+iBk=;
X-UUID: d5b1c1139af847fab4a6947ae83326a9-20191212
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 263070001; Thu, 12 Dec 2019 07:09:59 -0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Dec 2019 07:06:26 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 23:05:20 +0800
Message-ID: <1576163122.18168.2.camel@mtksdccf07>
Subject: Re: [PATCH net-next 2/6] net: dsa: mt7530: Extend device data ready
 for adding a new hardware
From:   Landen Chao <landen.chao@mediatek.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@savoirfairelinux.com" 
        <vivien.didelot@savoirfairelinux.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "opensource@vdorst.com" <opensource@vdorst.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Date:   Thu, 12 Dec 2019 23:05:22 +0800
In-Reply-To: <d77e3109-e022-3581-2ca8-02889c5ddbf4@gmail.com>
References: <cover.1575914275.git.landen.chao@mediatek.com>
         <2d546d6bb15ff8b4b75af2220e20db4e634f4145.1575914275.git.landen.chao@mediatek.com>
         <d77e3109-e022-3581-2ca8-02889c5ddbf4@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTEyLTEyIGF0IDExOjQ1ICswODAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiANCj4gT24gMTIvMTAvMjAxOSAxMjoxNCBBTSwgTGFuZGVuIENoYW8gd3JvdGU6DQo+ID4g
QWRkIGEgc3RydWN0dXJlIGhvbGRpbmcgcmVxdWlyZWQgb3BlcmF0aW9ucyBmb3IgZWFjaCBkZXZp
Y2Ugc3VjaCBhcyBkZXZpY2UNCj4gPiBpbml0aWFsaXphdGlvbiwgUEhZIHBvcnQgcmVhZCBvciB3
cml0ZSwgYSBjaGVja2VyIHdoZXRoZXIgUEhZIGludGVyZmFjZSBpcw0KPiA+IHN1cHBvcnRlZCBv
biBhIGNlcnRhaW4gcG9ydCwgTUFDIHBvcnQgc2V0dXAgZm9yIGVpdGhlciBidXMgcGFkIG9yIGEN
Cj4gPiBzcGVjaWZpYyBQSFkgaW50ZXJmYWNlLg0KPiA+IA0KPiA+IFRoZSBwYXRjaCBpcyBkb25l
IGZvciByZWFkeSBhZGRpbmcgYSBuZXcgaGFyZHdhcmUgTVQ3NTMxLg0KPiA+IA0KPiA+IFNpZ25l
ZC1vZmYtYnk6IExhbmRlbiBDaGFvIDxsYW5kZW4uY2hhb0BtZWRpYXRlay5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogU2VhbiBXYW5nIDxzZWFuLndhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0K
PiBbc25pcF0NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYyBi
L2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYw0KPiA+IGluZGV4IGVkMWVjMTBlYzYyYi4uOWE2NDhk
MWY1ZDA5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2RzYS9tdDc1MzAuYw0KPiA+IEBAIC00MjUsNyArNDI1LDcgQEAgbXQ3
NTMwX2ZkYl93cml0ZShzdHJ1Y3QgbXQ3NTMwX3ByaXYgKnByaXYsIHUxNiB2aWQsDQo+ID4gIH0N
Cj4gPiAgDQo+ID4gIHN0YXRpYyBpbnQNCj4gPiAtbXQ3NTMwX3BhZF9jbGtfc2V0dXAoc3RydWN0
IGRzYV9zd2l0Y2ggKmRzLCBpbnQgbW9kZSkNCj4gPiArbXQ3NTMwX3BhZF9jbGtfc2V0dXAoc3Ry
dWN0IGRzYV9zd2l0Y2ggKmRzLCBwaHlfaW50ZXJmYWNlX3QgbW9kZSkNCj4gDQo+IEhlcmUgeW91
IHBhc3MgYSBwaHlfaW50ZXJmYWNlX3QgYXJndW1lbnQgYnV0IG5vdCBpbiBtdDc2MzJfcGFkX2Ns
a19zZXR1cCgpLg0KPiANCj4gPiArc3RhdGljIGludA0KPiA+ICttdDc1MzBfcGFkX3NldHVwKHN0
cnVjdCBkc2Ffc3dpdGNoICpkcywgY29uc3Qgc3RydWN0IHBoeWxpbmtfbGlua19zdGF0ZSAqc3Rh
dGUpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBtdDc1MzBfcHJpdiAqcHJpdiA9IGRzLT5wcml2Ow0K
PiA+ICsNCj4gPiArCS8qIFNldHVwIFRYIGNpcmN1aXQgaW5jbHVpbmcgcmVsZXZhbnQgUEFEIGFu
ZCBkcml2aW5nICovDQo+ID4gKwltdDc1MzBfcGFkX2Nsa19zZXR1cChkcywgc3RhdGUtPmludGVy
ZmFjZSk7DQo+ID4gKw0KPiA+ICsJaWYgKHByaXYtPmlkID09IElEX01UNzUzMCkgew0KPiA+ICsJ
CS8qIFNldHVwIFJYIGNpcmN1aXQsIHJlbGV2YW50IFBBRCBhbmQgZHJpdmluZyBvbiB0aGUNCj4g
PiArCQkgKiBob3N0IHdoaWNoIG11c3QgYmUgcGxhY2VkIGFmdGVyIHRoZSBzZXR1cCBvbiB0aGUN
Cj4gPiArCQkgKiBkZXZpY2Ugc2lkZSBpcyBhbGwgZmluaXNoZWQuDQo+ID4gKwkJICovDQo+ID4g
KwkJbXQ3NjIzX3BhZF9jbGtfc2V0dXAoZHMpOw0KPiANCj4gV291bGQgbm90IGl0IG1ha2Ugc2Vu
c2UgdG8gcGFzcyBpdCBkb3duIGhlcmUgYXMgd2VsbCBmb3IgY29uc2lzdGVuY3k/DQptdDc2MjNf
cGFkX2NsaygpIGNvbnRhaW5zIHRoZSBzZXR0aW5nIGZvciBQSFlfSU5URVJGQUNFX01PREVfVFJH
TUlJLiBJdA0KaXMgcmVhbGx5IGJldHRlciB0byBwYXNzIHBoeV9pbnRlcmZhY2VfdCBmb3IgZXJy
b3IgaGFuZGxpbmcuDQo+IA0KPiBbc25pcF0NCj4gDQo+ID4gQEAgLTE2NjAsOCArMTc2OCwxOSBA
QCBtdDc1MzBfcHJvYmUoc3RydWN0IG1kaW9fZGV2aWNlICptZGlvZGV2KQ0KPiA+ICAJLyogR2V0
IHRoZSBoYXJkd2FyZSBpZGVudGlmaWVyIGZyb20gdGhlIGRldmljZXRyZWUgbm9kZS4NCj4gPiAg
CSAqIFdlIHdpbGwgbmVlZCBpdCBmb3Igc29tZSBvZiB0aGUgY2xvY2sgYW5kIHJlZ3VsYXRvciBz
ZXR1cC4NCj4gPiAgCSAqLw0KPiA+IC0JcHJpdi0+aWQgPSAodW5zaWduZWQgaW50KSh1bnNpZ25l
ZCBsb25nKQ0KPiA+IC0JCW9mX2RldmljZV9nZXRfbWF0Y2hfZGF0YSgmbWRpb2Rldi0+ZGV2KTsN
Cj4gPiArCXByaXYtPmluZm8gPSBvZl9kZXZpY2VfZ2V0X21hdGNoX2RhdGEoJm1kaW9kZXYtPmRl
dik7DQo+ID4gKwlpZiAoIXByaXYtPmluZm8pDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4g
Kw0KPiA+ICsJLyogU2FuaXR5IGNoZWNrIGlmIHRoZXNlIHJlcXVpcmVkIGRldmljZSBvcGVyc3Rh
aW9ucyBhcmUgZmlsbGVkDQo+ID4gKwkgKiBwcm9wZXJseS4NCj4gDQo+IFR5cG86IG9wZXJhdGlv
bnMuDQpPb3BzLCBzb3JyeS4gSSdsbCBjb3JyZWN0IGl0Lg0KDQpMYW5kZW4NCj4gDQo+IE90aGVy
IHRoYW4gdGhhdCwgdGhpcyBsb29rcyBva2F5IHRvIG1lLg0KDQoNCg==

