Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA928AB64
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgJLB0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:26:10 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:52733 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725917AbgJLB0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 21:26:10 -0400
X-UUID: e35f3a41522b44ab82b04b3a3d4f211d-20201012
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=R1q9dfekP6mSdsS/ET+QXDzN+e6bl0PwJAWHtliaE3M=;
        b=egZlOpHpLj25rSinPIGxOKpqyurq2TpQOT20FwDiNgAfNvECWFMWSyCr+SAHzfaxkwKNJEvCdR67oSDNGVQnZETgTvtNHj/FBlSwUVqUerWH0iqvdt+opb+5SmYvCmIUN09yEgsy+GHV9R0DnlahxdRMVJwPMYupm/L6nEVu7NM=;
X-UUID: e35f3a41522b44ab82b04b3a3d4f211d-20201012
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 562371480; Mon, 12 Oct 2020 09:25:58 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31N1.mediatek.inc
 (172.27.4.69) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 09:25:56 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Oct 2020 09:25:55 +0800
Message-ID: <1602465955.29336.57.camel@mhfsdcap03>
Subject: Re: [PATCH v2 4/4] dt-bindings: usb: use preferred license tag
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date:   Mon, 12 Oct 2020 09:25:55 +0800
In-Reply-To: <20201010095052.GA989257@kroah.com>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
         <d76ca8b2d64c7c017e3ddaca8497eb38ee514204.1602318869.git.chunfeng.yun@mediatek.com>
         <20201010095052.GA989257@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 29B9D6F8DD7D8A01EEF75DC90A0B763AD3F7D6CA7860AF3A06EB30669984C0B72000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTEwLTEwIGF0IDExOjUwICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IE9uIFNhdCwgT2N0IDEwLCAyMDIwIGF0IDA0OjQzOjE0UE0gKzA4MDAsIENodW5mZW5n
IFl1biB3cm90ZToNCj4gPiBUaGlzIGlzIHVzZWQgdG8gZml4IHRoZSBjaGVja3BhY2gucGwgV0FS
TklORzpTUERYX0xJQ0VOU0VfVEFHDQo+ID4gDQo+ID4gU2VlIGJpbmRpbmdzL3N1Ym1pdHRpbmct
cGF0Y2hlcy5yc3Q6DQo+ID4gIkRUIGJpbmRpbmcgZmlsZXMgc2hvdWxkIGJlIGR1YWwgbGljZW5z
ZWQuIFRoZSBwcmVmZXJyZWQgbGljZW5zZSB0YWcgaXMNCj4gPiAgKEdQTC0yLjAtb25seSBPUiBC
U0QtMi1DbGF1c2UpLiINCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBDaHVuZmVuZyBZdW4gPGNo
dW5mZW5nLnl1bkBtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gdjI6IG5ldyBwYXRjaA0KPiA+
IC0tLQ0KPiA+ICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdXNiL3VzYi1oY2Qu
eWFtbCB8IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy91c2IvdXNiLWhjZC55YW1sIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL3VzYi91c2ItaGNkLnlhbWwNCj4gPiBpbmRleCA0MmIyOTVhZmRmMzIuLjExYjliOWVlMmI1
NCAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdXNi
L3VzYi1oY2QueWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy91c2IvdXNiLWhjZC55YW1sDQo+ID4gQEAgLTEsNCArMSw0IEBADQo+ID4gLSMgU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gPiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
KEdQTC0yLjAtb25seSBPUiBCU0QtMi1DbGF1c2UpDQo+IA0KPiBBcmUgeW91IHN1cmUgeW91IGFy
ZSBhbGxvd2VkIHRvIGNoYW5nZSB0aGUgbGljZW5zZSBvZiB0aGlzIGZpbGU/ICBMYXN0IEkNCj4g
Y2hlY2tlZCwgeW91IGRpZCBub3Qgd3JpdGUgdGhpcyBmaWxlLCBhbmQgc28sIHlvdSBjYW4ndCBj
aGFuZ2UgdGhlDQo+IGxpY2Vuc2Ugb2YgaXQuICBZb3UgbmVlZCB0byBnZXQgdGhlIG93bmVycyBv
ZiB0aGUgZmlsZSB0byBkbyBzby4NCkdvdCBpdCwgd2lsbCBhYmFuZG9uIGl0IGluIG5leHQgdmVy
c2lvbg0KDQpUaGFua3MNCg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCg0K

