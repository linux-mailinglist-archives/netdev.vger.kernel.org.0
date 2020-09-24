Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903ED2770B3
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 14:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgIXMNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 08:13:48 -0400
Received: from mailgw01.mediatek.com ([216.200.240.184]:38286 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgIXMNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 08:13:43 -0400
X-UUID: e7bdb2f486e34841ac4f9509690828b5-20200924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=oEQqIT87UU1+x8zERr/VFYRlzuHTWeays79SiUEYuMQ=;
        b=RsjZ75svAwDKdF3bN2RFz2hobMgKpNPaKJ6TJ1LX+qyEObEQM1bUBWVN0y8i/TUhD1fkB/ox4IujBpaANw9dek+Z0I5rM6nGs0cGcl8Yu2aVPZJgjIXaBXWLxsvr0ulzGNe091ytqTti+N9fRyCKn3JW1/JjqOBbEjY2eikdV4k=;
X-UUID: e7bdb2f486e34841ac4f9509690828b5-20200924
Received: from mtkcas67.mediatek.inc [(172.29.193.45)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1365213064; Thu, 24 Sep 2020 04:13:39 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Sep 2020 05:13:36 -0700
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Sep 2020 20:13:23 +0800
Message-ID: <1600949604.11746.27.camel@mtksdccf07>
Subject: Re: [PATCH v2] net: dsa: mt7530: Add some return-value checks
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
Date:   Thu, 24 Sep 2020 20:13:24 +0800
In-Reply-To: <20200919192809.29120-1-alex.dewar90@gmail.com>
References: <1600327978.11746.22.camel@mtksdccf07>
         <20200919192809.29120-1-alex.dewar90@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxleCwNCg0KVGhhbmtzIGZvciB5b3VyIHBhdGNoLiBCeSBsaW51eC9zY3JpcHRzL2NoZWNr
cGF0Y2gucGwNCg0KT24gU3VuLCAyMDIwLTA5LTIwIGF0IDAzOjI4ICswODAwLCBBbGV4IERld2Fy
IHdyb3RlOg0KWy4uXQ0KPiBAQCAtMTYzMSw5ICsxNjM1LDExIEBAIG10NzUzMF9zZXR1cChzdHJ1
Y3QgZHNhX3N3aXRjaCAqZHMpDQo+ICAJCW10NzUzMF9ybXcocHJpdiwgTVQ3NTMwX1BDUl9QKGkp
LCBQQ1JfTUFUUklYX01BU0ssDQo+ICAJCQkgICBQQ1JfTUFUUklYX0NMUik7DQo+ICANCj4gLQkJ
aWYgKGRzYV9pc19jcHVfcG9ydChkcywgaSkpDQo+IC0JCQltdDc1M3hfY3B1X3BvcnRfZW5hYmxl
KGRzLCBpKTsNCj4gLQkJZWxzZQ0KPiArCQlpZiAoZHNhX2lzX2NwdV9wb3J0KGRzLCBpKSkgew0K
PiArCQkJcmV0ID0gbXQ3NTN4X2NwdV9wb3J0X2VuYWJsZShkcywgaSk7DQo+ICsJCQlpZiAocmV0
KQ0KPiArCQkJCXJldHVybiByZXQ7DQo+ICsJCX0gZWxzZQ0KPiAgCQkJbXQ3NTMwX3BvcnRfZGlz
YWJsZShkcywgaSk7DQpDSEVDSzogYnJhY2VzIHt9IHNob3VsZCBiZSB1c2VkIG9uIGFsbCBhcm1z
IG9mIHRoaXMgc3RhdGVtZW50DQpDSEVDSzogVW5iYWxhbmNlZCBicmFjZXMgYXJvdW5kIGVsc2Ug
c3RhdGVtZW50DQo+ICANCj4gIAkJLyogRW5hYmxlIGNvbnNpc3RlbnQgZWdyZXNzIHRhZyAqLw0K
PiBAQCAtMTc4NSw5ICsxNzkxLDExIEBAIG10NzUzMV9zZXR1cChzdHJ1Y3QgZHNhX3N3aXRjaCAq
ZHMpDQo+ICANCj4gIAkJbXQ3NTMwX3NldChwcml2LCBNVDc1MzFfREJHX0NOVChpKSwgTVQ3NTMx
X0RJU19DTFIpOw0KPiAgDQo+IC0JCWlmIChkc2FfaXNfY3B1X3BvcnQoZHMsIGkpKQ0KPiAtCQkJ
bXQ3NTN4X2NwdV9wb3J0X2VuYWJsZShkcywgaSk7DQo+IC0JCWVsc2UNCj4gKwkJaWYgKGRzYV9p
c19jcHVfcG9ydChkcywgaSkpIHsNCj4gKwkJCXJldCA9IG10NzUzeF9jcHVfcG9ydF9lbmFibGUo
ZHMsIGkpOw0KPiArCQkJaWYgKHJldCkNCj4gKwkJCQlyZXR1cm4gcmV0Ow0KPiArCQl9IGVsc2UN
Cj4gIAkJCW10NzUzMF9wb3J0X2Rpc2FibGUoZHMsIGkpOw0KQ0hFQ0s6IGJyYWNlcyB7fSBzaG91
bGQgYmUgdXNlZCBvbiBhbGwgYXJtcyBvZiB0aGlzIHN0YXRlbWVudA0KQ0hFQ0s6IFVuYmFsYW5j
ZWQgYnJhY2VzIGFyb3VuZCBlbHNlIHN0YXRlbWVudA0KDQpbLi5dDQpyZWdhcmRzIGxhbmRlbg0K

