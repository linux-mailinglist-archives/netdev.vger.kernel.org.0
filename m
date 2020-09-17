Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42E426D4D5
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 09:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgIQHi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 03:38:28 -0400
Received: from mailgw01.mediatek.com ([216.200.240.184]:22414 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIQHiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 03:38:17 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 03:38:16 EDT
X-UUID: 007f8bb6d6fe4cce89c2335e6e602d91-20200916
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=cSlCNcl11u7qHTtN7BxhpCgzqViFmJKikDj8COuqZE8=;
        b=OOGU1T9kbZHyfUTyYSEZ4xcpLiixKJpx9xdV16W1ThP3YNzvqyAdScINoP2cRaA3tasXqbxUK/92B+RC6PDnijMnrH/w1vWlKY9i12d1eCW3bDTP2inY/+9SJEs4iM2eUuU8iy1iYPpYHIBYP7NWG6NbyOtuPcqQ/uK7AoJrLGU=;
X-UUID: 007f8bb6d6fe4cce89c2335e6e602d91-20200916
Received: from mtkcas67.mediatek.inc [(172.29.193.45)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 74245434; Wed, 16 Sep 2020 23:33:01 -0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Sep 2020 00:32:58 -0700
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Sep 2020 15:32:58 +0800
Message-ID: <1600327978.11746.22.camel@mtksdccf07>
Subject: Re: [PATCH] net: dsa: mt7530: Add some return-value checks
From:   Landen Chao <landen.chao@mediatek.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
CC:     Sean Wang <Sean.Wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 17 Sep 2020 15:32:58 +0800
In-Reply-To: <20200916195017.34057-1-alex.dewar90@gmail.com>
References: <20200916195017.34057-1-alex.dewar90@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxleCwNCg0KVGhhbmtzIGZvciB5b3VyIHJldmlldyBhbmQgZml4aW5nLg0KT24gVGh1LCAy
MDIwLTA5LTE3IGF0IDAzOjUwICswODAwLCBBbGV4IERld2FyIHdyb3RlOg0KWy4uXQ0KPiANCj4g
SWYgaXQgaXMgbm90IGV4cGVjdGVkIHRoYXQgdGhlc2UgZnVuY3Rpb25zIHdpbGwgdGhyb3cgZXJy
b3JzIChpLmUuDQo+IGJlY2F1c2UgdGhlIHBhcmFtZXRlcnMgcGFzc2VkIHdpbGwgYWx3YXlzIGJl
IGNvcnJlY3QpLCB3ZSBjb3VsZCBkaXNwZW5zZQ0KPiB3aXRoIHRoZSB1c2Ugb2YgRUlOVkFMIGVy
cm9ycyBhbmQganVzdCB1c2UgQlVHKigpIG1hY3JvcyBpbnN0ZWFkLiBMZXQgbWUNCj4ga25vdyBp
ZiB5b3UnZCByYXRoZXIgSSBmaXggdGhpbmdzIHVwIGluIHRoYXQgd2F5Lg0KVGhlIGNwdSBwb3J0
IHNldHRpbmcgaXMgcGFzc2VkIGJ5IGR0cy4gVXNlIEVJTlZBTCB0byBjYXRjaCB1bmV4cGVjdGVk
DQpzZXR0aW5nIGlzIGZpbmUuDQo+IA0KPiBCZXN0LA0KPiBBbGV4DQo+IA0KPiAgZHJpdmVycy9u
ZXQvZHNhL210NzUzMC5jIHwgMTYgKysrKysrKysrKysrLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDEyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZHNhL210NzUzMC5jIGIvZHJpdmVycy9uZXQvZHNhL210NzUzMC5jDQo+IGluZGV4
IDYxMzg4OTQ1ZDMxNi4uMTU3ZDBhMDFmYWFlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9k
c2EvbXQ3NTMwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL210NzUzMC5jDQo+IEBAIC05NDUs
MTAgKzk0NSwxNCBAQCBzdGF0aWMgaW50DQo+ICBtdDc1M3hfY3B1X3BvcnRfZW5hYmxlKHN0cnVj
dCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQpDQo+ICB7DQo+ICAJc3RydWN0IG10NzUzMF9wcml2
ICpwcml2ID0gZHMtPnByaXY7DQo+ICsJaW50IHJldDsNCj4gIA0KPiAgCS8qIFNldHVwIG1heCBj
YXBhYmlsaXR5IG9mIENQVSBwb3J0IGF0IGZpcnN0ICovDQo+IC0JaWYgKHByaXYtPmluZm8tPmNw
dV9wb3J0X2NvbmZpZykNCj4gLQkJcHJpdi0+aW5mby0+Y3B1X3BvcnRfY29uZmlnKGRzLCBwb3J0
KTsNCj4gKwlpZiAocHJpdi0+aW5mby0+Y3B1X3BvcnRfY29uZmlnKSB7DQo+ICsJCXJldCA9IHBy
aXYtPmluZm8tPmNwdV9wb3J0X2NvbmZpZyhkcywgcG9ydCk7DQo+ICsJCWlmIChyZXQpDQo+ICsJ
CQlyZXR1cm4gcmV0Ow0KPiArCX0NCkhvdyBhYm91dCBjaGVjayByZXR1cm4gdmFsdWUgaW4gY2Fs
bGVyIGZ1bmN0aW9uLCBtdDc1MzBfc2V0dXAoKSBhbmQNCm10NzUzMV9zZXR1cCgpLCB0b28/DQog
ICAgICAgICAgICAgICAgaWYgKGRzYV9pc19jcHVfcG9ydChkcywgaSkpIHsNCiAgICAgICAgICAg
ICAgICAgICAgICAgIHJldCA9IG10NzUzeF9jcHVfcG9ydF9lbmFibGUoZHMsIGkpOw0KCQkJaWYg
KHJldCkNCgkJCQlyZXR1cm4gcmV0Ow0KCQl9IGVsc2Ugew0KWy4uXQ0KcmVnYXJkcywNCmxhbmRl
bg0KDQo=

