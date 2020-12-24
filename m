Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A662E2537
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 08:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLXH1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 02:27:31 -0500
Received: from mailgw02.mediatek.com ([1.203.163.81]:11586 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726258AbgLXH1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 02:27:31 -0500
X-UUID: dda500f35131466e85b4d15b9edbda0e-20201224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=sTA9GxzeiTWZ8Bb1AzVPoBBRf2w9jvzoOgYWkMxjLWk=;
        b=V2m93C+mJ/lNd3Kma1Ao953qg0XQpgYHzo7sEzco8QIUdo4XBSjRucU+4Q6UKU1T2CXaedQlkUs7LjMxZun8AMXOhfnHclupAxOKzuEeegkiYz+9YfmCnib3bR2fWKdOlQCHft5o2499PfbTT/WdYuCjZv8C0WiC3NEK8r2gzdI=;
X-UUID: dda500f35131466e85b4d15b9edbda0e-20201224
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 268527532; Thu, 24 Dec 2020 15:26:42 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31DR.mediatek.inc
 (172.27.6.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 24 Dec
 2020 15:26:39 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Dec 2020 15:26:38 +0800
Message-ID: <1608794799.7499.2.camel@mhfsdcap03>
Subject: Re: [PATCH v4 01/11] dt-bindings: usb: convert usb-device.txt to
 YAML schema
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date:   Thu, 24 Dec 2020 15:26:39 +0800
In-Reply-To: <20201221190937.GA369845@robh.at.kernel.org>
References: <20201216093012.24406-1-chunfeng.yun@mediatek.com>
         <20201221190937.GA369845@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 74766EA34054B7FEA51C94AAD0ECCBCC07057C7F26AB70431A5FC6B4C07CE5A72000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEyLTIxIGF0IDEyOjA5IC0wNzAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4g
T24gV2VkLCBEZWMgMTYsIDIwMjAgYXQgMDU6MzA6MDJQTSArMDgwMCwgQ2h1bmZlbmcgWXVuIHdy
b3RlOg0KPiA+IENvbnZlcnQgdXNiLWRldmljZS50eHQgdG8gWUFNTCBzY2hlbWEgdXNiLWRldmlj
ZS55YW1sDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQ2h1bmZlbmcgWXVuIDxjaHVuZmVuZy55
dW5AbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+IHY0OiBubyBjaGFuZ2VzLCB1cGRhdGUgZGVw
ZW5kZW50IHNlcmllczoNCj4gPiAgICAgaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9q
ZWN0L2xpbnV4LXVzYi9saXN0Lz9zZXJpZXM9Mzk5NTYxDQo+ID4gICAgIFt2NiwwMC8xOV0gZHQt
YmluZGluZ3M6IHVzYjogQWRkIGdlbmVyaWMgVVNCIEhDRCwgeEhDSSwgRFdDIFVTQjMgRFQgc2No
ZW1hDQpbLi4uXQ0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvdXNiL3VzYi1kZXZpY2UueWFtbCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy91c2IvdXNiLWRldmljZS55YW1sDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBp
bmRleCAwMDAwMDAwMDAwMDAuLmYzMWQ4YTg1ZDNlNg0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiAr
KysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdXNiL3VzYi1kZXZpY2UueWFt
bA0KPiA+IEBAIC0wLDAgKzEsMTI1IEBADQo+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IChHUEwtMi4wLW9ubHkgT1IgQlNELTItQ2xhdXNlKQ0KPiA+ICslWUFNTCAxLjINCj4gPiArLS0t
DQo+ID4gKyRpZDogaHR0cDovL2RldmljZXRyZWUub3JnL3NjaGVtYXMvdXNiL3VzYi1kZXZpY2Uu
eWFtbCMNCj4gPiArJHNjaGVtYTogaHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9j
b3JlLnlhbWwjDQo+ID4gKw0KPiA+ICt0aXRsZTogVGhlIGRldmljZSB0cmVlIGJpbmRpbmdzIGZv
ciB0aGUgR2VuZXJpYyBVU0IgRGV2aWNlDQo+ID4gKw0KPiA+ICttYWludGFpbmVyczoNCj4gPiAr
ICAtIEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+ID4g
Kw0KPiA+ICtkZXNjcmlwdGlvbjogfA0KPiA+ICsgIFVzdWFsbHksIHdlIG9ubHkgdXNlIGRldmlj
ZSB0cmVlIGZvciBoYXJkIHdpcmVkIFVTQiBkZXZpY2UuDQo+ID4gKyAgVGhlIHJlZmVyZW5jZSBi
aW5kaW5nIGRvYyBpcyBmcm9tOg0KPiA+ICsgIGh0dHA6Ly93d3cuZGV2aWNldHJlZS5vcmcvb3Bl
bi1maXJtd2FyZS9iaW5kaW5ncy91c2IvdXNiLTFfMC5wcw0KPiA+ICsNCj4gPiArICBGb3VyIHR5
cGVzIG9mIGRldmljZS10cmVlIG5vZGVzIGFyZSBkZWZpbmVkOiAiaG9zdC1jb250cm9sbGVyIG5v
ZGVzIg0KPiA+ICsgIHJlcHJlc2VudGluZyBVU0IgaG9zdCBjb250cm9sbGVycywgImRldmljZSBu
b2RlcyIgcmVwcmVzZW50aW5nIFVTQiBkZXZpY2VzLA0KPiA+ICsgICJpbnRlcmZhY2Ugbm9kZXMi
IHJlcHJlc2VudGluZyBVU0IgaW50ZXJmYWNlcyBhbmQgImNvbWJpbmVkIG5vZGVzIg0KPiA+ICsg
IHJlcHJlc2VudGluZyBzaW1wbGUgVVNCIGRldmljZXMuDQo+ID4gKw0KPiA+ICsgIEEgY29tYmlu
ZWQgbm9kZSBzaGFsbCBiZSB1c2VkIGluc3RlYWQgb2YgYSBkZXZpY2Ugbm9kZSBhbmQgYW4gaW50
ZXJmYWNlIG5vZGUNCj4gPiArICBmb3IgZGV2aWNlcyBvZiBjbGFzcyAwIG9yIDkgKGh1Yikgd2l0
aCBhIHNpbmdsZSBjb25maWd1cmF0aW9uIGFuZCBhIHNpbmdsZQ0KPiA+ICsgIGludGVyZmFjZS4N
Cj4gPiArDQo+ID4gKyAgQSAiaHViIG5vZGUiIGlzIGEgY29tYmluZWQgbm9kZSBvciBhbiBpbnRl
cmZhY2Ugbm9kZSB0aGF0IHJlcHJlc2VudHMgYSBVU0INCj4gPiArICBodWIuDQo+ID4gKw0KPiA+
ICtwcm9wZXJ0aWVzOg0KPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gKyAgICBwYXR0ZXJuOiAiXnVz
YlswLTlhLWZdKyxbMC05YS1mXSskIg0KPiANCj4gWW91IGNhbiByZWZpbmUgdGhlIGxlbmd0aCBh
bGxvd2VkIGEgYml0OiBbMC05YS1mXXsxLDR9DQo+IA0KPiBTYW1lIGFwcGxpZXMgZWxzZXdoZXJl
Lg0KT2sNCj4gDQo+ID4gKyAgICBkZXNjcmlwdGlvbjogRGV2aWNlIG5vZGVzIG9yIGNvbWJpbmVk
IG5vZGVzLg0KPiA+ICsgICAgICAidXNiVklELFBJRCIsIHdoZXJlIFZJRCBpcyB0aGUgdmVuZG9y
IGlkIGFuZCBQSUQgdGhlIHByb2R1Y3QgaWQuDQo+ID4gKyAgICAgIFRoZSB0ZXh0dWFsIHJlcHJl
c2VudGF0aW9uIG9mIFZJRCBhbmQgUElEIHNoYWxsIGJlIGluIGxvd2VyIGNhc2UNCj4gPiArICAg
ICAgaGV4YWRlY2ltYWwgd2l0aCBsZWFkaW5nIHplcm9lcyBzdXBwcmVzc2VkLiBUaGUgb3RoZXIg
Y29tcGF0aWJsZQ0KPiA+ICsgICAgICBzdHJpbmdzIGZyb20gdGhlIGFib3ZlIHN0YW5kYXJkIGJp
bmRpbmcgY291bGQgYWxzbyBiZSB1c2VkLA0KPiA+ICsgICAgICBidXQgYSBkZXZpY2UgYWRoZXJp
bmcgdG8gdGhpcyBiaW5kaW5nIG1heSBsZWF2ZSBvdXQgYWxsIGV4Y2VwdA0KPiA+ICsgICAgICBm
b3IgInVzYlZJRCxQSUQiLg0KPiA+ICsNClsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91c2IvdXNiLWhjZC55YW1sIGIvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL3VzYi91c2ItaGNkLnlhbWwNCj4gPiBpbmRleCA5ODgxYWMx
MDM4MGQuLjVkMGM2YjU1MDBkNiAxMDA3NTUNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvdXNiL3VzYi1oY2QueWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy91c2IvdXNiLWhjZC55YW1sDQo+ID4gQEAgLTIzLDYgKzIzLDMy
IEBAIHByb3BlcnRpZXM6DQo+ID4gICAgICAgIHRhcmdldGVkIGhvc3RzIChub24tUEMgaG9zdHMp
Lg0KPiA+ICAgICAgdHlwZTogYm9vbGVhbg0KPiA+ICANCj4gPiArICAiI2FkZHJlc3MtY2VsbHMi
Og0KPiA+ICsgICAgY29uc3Q6IDENCj4gPiArDQo+ID4gKyAgIiNzaXplLWNlbGxzIjoNCj4gPiAr
ICAgIGNvbnN0OiAwDQo+ID4gKw0KPiA+ICtwYXR0ZXJuUHJvcGVydGllczoNCj4gPiArICAiQFsw
LTlhLWZdKyQiOg0KPiA+ICsgICAgdHlwZTogb2JqZWN0DQo+ID4gKyAgICBkZXNjcmlwdGlvbjog
VGhlIGhhcmQgd2lyZWQgVVNCIGRldmljZXMNCj4gPiArDQo+ID4gKyAgICBwcm9wZXJ0aWVzOg0K
PiA+ICsgICAgICBjb21wYXRpYmxlOg0KPiA+ICsgICAgICAgIHBhdHRlcm46ICJedXNiWzAtOWEt
Zl0rLFswLTlhLWZdKyQiDQo+ID4gKyAgICAgICAgJHJlZjogL3VzYi91c2ItZGV2aWNlLnlhbWwN
Cj4gDQo+IFRoaXMgaXMgd3JvbmcuIEl0IHNob3VsZCBiZSB1cCBhIGxldmVsLg0KT2sNCj4gIEFu
ZCBubyBuZWVkIHRvIGRlZmluZSANCj4gJ2NvbXBhdGlibGUnIG9yICdyZWcnIGhlcmUgYmVjYXVz
ZSB0aG9zZSBhcmUgZGVmaW5lZCB3aXRoaW4gDQo+IHVzYi1kZXZpY2UueWFtbC4NCndpbGwgZHJv
cCBpdA0KPiANCj4gPiArICAgICAgICBkZXNjcmlwdGlvbjogdGhlIHN0cmluZyBpcyAndXNiVklE
LFBJRCcsIHdoZXJlIFZJRCBpcyB0aGUgdmVuZG9yIGlkDQo+ID4gKyAgICAgICAgICBhbmQgUElE
IGlzIHRoZSBwcm9kdWN0IGlkDQo+ID4gKw0KPiA+ICsgICAgICByZWc6DQo+ID4gKyAgICAgICAg
JHJlZjogL3VzYi91c2ItZGV2aWNlLnlhbWwNCj4gPiArICAgICAgICBtYXhJdGVtczogMQ0KPiA+
ICsNCj4gPiArICAgIHJlcXVpcmVkOg0KPiA+ICsgICAgICAtIGNvbXBhdGlibGUNCj4gPiArICAg
ICAgLSByZWcNCj4gPiArDQo+ID4gIGFkZGl0aW9uYWxQcm9wZXJ0aWVzOiB0cnVlDQo+ID4gIA0K
PiA+ICBleGFtcGxlczoNCj4gPiBAQCAtMzAsNCArNTYsMTEgQEAgZXhhbXBsZXM6DQo+ID4gICAg
ICB1c2Igew0KPiA+ICAgICAgICAgIHBoeXMgPSA8JnVzYjJfcGh5MT4sIDwmdXNiM19waHkxPjsN
Cj4gPiAgICAgICAgICBwaHktbmFtZXMgPSAidXNiIjsNCj4gPiArICAgICAgICAjYWRkcmVzcy1j
ZWxscyA9IDwxPjsNCj4gPiArICAgICAgICAjc2l6ZS1jZWxscyA9IDwwPjsNCj4gPiArDQo+ID4g
KyAgICAgICAgaHViQDEgew0KPiA+ICsgICAgICAgICAgICBjb21wYXRpYmxlID0gInVzYjVlMyw2
MTAiOw0KPiA+ICsgICAgICAgICAgICByZWcgPSA8MT47DQo+ID4gKyAgICAgICAgfTsNCj4gPiAg
ICAgIH07DQo+ID4gLS0gDQo+ID4gMi4xOC4wDQo+ID4gDQoNCg==

