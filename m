Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F472FA23F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 14:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392467AbhARNv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 08:51:27 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:33360 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392293AbhARNeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 08:34:09 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2021 08:34:02 EST
X-UUID: 729963f60f174358aa98c03c537ad45b-20210118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=blFPHC6W+BicL23dO3JcRIFtSRuQABtT0CWXjQpm7+s=;
        b=jDwFmxgZ+ImMh3X+1xykj38+/SjWhMF7n4wRmzrunthPfwRjxMm1qwSh4Hh8MaDAfmHWZkAYHd26KIb2oDPFd0qcFTzTGN4niMZzih6RjV3mSS7CV+a0CbOLdR9gBYu1z9MeBW/Fxe27XX8/oh3NBjDtjA6rm4WCUn1KJ4dw9Ck=;
X-UUID: 729963f60f174358aa98c03c537ad45b-20210118
Received: from mtkcas67.mediatek.inc [(172.29.193.45)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1934958909; Mon, 18 Jan 2021 05:28:00 -0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 18 Jan 2021 05:27:59 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 18 Jan 2021 21:27:57 +0800
Message-ID: <1610976477.24617.22.camel@mtksdccf07>
Subject: Re: Registering IRQ for MT7530 internal PHYs
From:   Landen Chao <landen.chao@mediatek.com>
To:     DENG Qingfang <dqfext@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <Sean.Wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Weijie Gao =?UTF-8?Q?=28=E9=AB=98=E6=83=9F=E6=9D=B0=29?= 
        <Weijie.Gao@mediatek.com>, Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Date:   Mon, 18 Jan 2021 21:27:57 +0800
In-Reply-To: <CALW65ja33=+7TGQMYdr=Wztwy_simszSwO6saMvvSeqX3qWGxA@mail.gmail.com>
References: <20201230042208.8997-1-dqfext@gmail.com>
         <441a77e8c30927ce5bc24708e1ceed79@kernel.org> <X+ybeg4dvR5Vq8LY@lunn.ch>
         <CALW65ja33=+7TGQMYdr=Wztwy_simszSwO6saMvvSeqX3qWGxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUWluZ2ZhbmcsDQpPbiBXZWQsIDIwMjEtMDEtMDYgYXQgMTY6NTQgKzA4MDAsIERFTkcgUWlu
Z2Zhbmcgd3JvdGU6DQo+IEhpIEFuZHJldywNCj4gDQo+IE9uIFdlZCwgRGVjIDMwLCAyMDIwIGF0
IDExOjIzIFBNIEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4gd3JvdGU6DQo+ID4NCj4gPiBP
biBXZWQsIERlYyAzMCwgMjAyMCBhdCAwOTo0MjowOUFNICswMDAwLCBNYXJjIFp5bmdpZXIgd3Jv
dGU6DQo+ID4gPiA+ICtzdGF0aWMgaXJxcmV0dXJuX3QNCj4gPiA+ID4gK210NzUzMF9pcnEoaW50
IGlycSwgdm9pZCAqZGF0YSkNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKyAgIHN0cnVjdCBtdDc1MzBf
cHJpdiAqcHJpdiA9IGRhdGE7DQo+ID4gPiA+ICsgICBib29sIGhhbmRsZWQgPSBmYWxzZTsNCj4g
PiA+ID4gKyAgIGludCBwaHk7DQo+ID4gPiA+ICsgICB1MzIgdmFsOw0KPiA+ID4gPiArDQo+ID4g
PiA+ICsgICB2YWwgPSBtdDc1MzBfcmVhZChwcml2LCBNVDc1MzBfU1lTX0lOVF9TVFMpOw0KPiA+
ID4gPiArICAgbXQ3NTMwX3dyaXRlKHByaXYsIE1UNzUzMF9TWVNfSU5UX1NUUywgdmFsKTsNCj4g
PiA+DQo+ID4gPiBJZiB0aGF0IGlzIGFuIGFjayBvcGVyYXRpb24sIGl0IHNob3VsZCBiZSBkZWFs
dCB3aXRoIGFzIHN1Y2ggaW4NCj4gPiA+IGFuIGlycWNoaXAgY2FsbGJhY2sgaW5zdGVhZCBvZiBi
ZWluZyBvcGVuLWNvZGVkIGhlcmUuDQo+ID4NCj4gPiBIaSBRaW5nZmFuZw0KPiA+DQo+ID4gRG9l
cyB0aGUgUEhZIGl0c2VsZiBoYXZlIGludGVycnVwdCBjb250cm9sIGFuZCBzdGF0dXMgcmVnaXN0
ZXJzPw0KPiANCj4gTVQ3NTMxJ3MgaW50ZXJuYWwgUEhZIGhhcyBhbiBpbnRlcnJ1cHQgc3RhdHVz
IHJlZ2lzdGVyLCBidXQgSSBkb24ndA0KPiBrbm93IGlmIHRoZSBzYW1lIGFwcGxpZXMgdG8gTVQ3
NTMwLg0KSW50ZXJydXB0IHN0YXR1cy9tYXNrIHJlZ2lzdGVycyBvZiBNVDc1MzAgaW50ZXJuYWwg
UEhZIGlzIHRoZSBzYW1lIGFzDQpNVDc1MzEuIFRoZSBzd2l0Y2ggaW50ZXJydXB0IHN0YXR1cyBy
ZWdpc3RlciBNVDc1MzBfU1lTX0lOVF9TVFNbMTQ6OF0NCnJlZmxlY3RzIGludGVybmFsIFBIWSBp
bnRlcnJ1cHQgc3RhdHVzLiBNVDc1MzBfU1lTX0lOVF9TVFNbNjowXSB3ZSB1c2VkDQpiZWZvcmUg
ZG9lcyBub3QgcmVsYXRlZCB0byBpbnRlcm5hbCBQSFkgImludGVycnVwdCIuDQoNCkhvd2V2ZXIs
IGJhc2Ugb24gTVQ3NTN4IGhhcmR3YXJlIGJlaGF2aW9yLCBhZnRlciByZWFkLWNsZWFyIGludGVy
cnVwdA0Kc3RhdHVzIG9mIGludGVybmFsIHBoeSwgd2Ugc3RpbGwgbmVlZCB0byB3cml0ZS1jbGVh
cg0KTVQ3NTMwX1NZU19JTlRfU1RTWzE0OjhdIHRvIGNsZWFyIHN3aXRjaCBpbnRlcnJ1cHQuDQoN
CkxhbmRlbg0KPiANCj4gPg0KPiA+IE15IGV4cGVyaWVuY2Ugd2l0aCB0aGUgTWFydmVsbCBTd2l0
Y2ggYW5kIGl0cyBlbWJlZGRlZCBQSFlzIGlzIHRoYXQNCj4gPiB0aGUgUEhZcyBhcmUganVzdCB0
aGUgc2FtZSBhcyB0aGUgZGlzY3JldGUgUEhZcy4gVGhlcmUgYXJlIGJpdHMgdG8NCj4gPiBlbmFi
bGUgZGlmZmVyZW50IGludGVycnVwdHMsIGFuZCB0aGVyZSBhcmUgc3RhdHVzIGJpdHMgaW5kaWNh
dGluZyB3aGF0DQo+ID4gZXZlbnQgY2F1c2VkIHRoZSBpbnRlcnJ1cHQuIENsZWFyaW5nIHRoZSBp
bnRlcnJ1cHQgaW4gdGhlIFBIWSBjbGVhcnMNCj4gPiB0aGUgaW50ZXJydXB0IGluIHRoZSBzd2l0
Y2ggaW50ZXJydXB0IGNvbnRyb2xsZXIuIFNvIGluIHRoZSBtdjg4ZTZ4eHgNCj4gPiBpbnRlcnJ1
cHQgY29kZSwgeW91IHNlZSBpIGRvIGEgcmVhZCBvZiB0aGUgc3dpdGNoIGludGVycnVwdCBjb250
cm9sbGVyDQo+ID4gc3RhdHVzIHJlZ2lzdGVyLCBidXQgaSBkb24ndCB3cml0ZSB0byBpdCBhcyB5
b3UgaGF2ZSBkb25lLg0KPiA+DQo+ID4gICAgICAgIEFuZHJldw0KDQo=

