Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6F511BACA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbfLKR6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:58:02 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:41887 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729228AbfLKR6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:58:02 -0500
X-UUID: 62157b23eeb545c7ab86c1fe8c47aeb5-20191211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=u7qv1t+UEdcZ3p9avQ8ygs4s73dg8OSg8iN56BmCOVg=;
        b=pfltpKZnVgfgvpFUQxqIxY0veuIleO4Ge2hVHVj5TRDVqWu0xtE0EUSqsQAYLqHYfPyZ2m2f5ZlZwE26Le74VT+Bu4WuBj2YyPmmlSF38TWsWMJXeC43255okcdazeonO0x8R15xhQJx4tla1DDHBdjSGnfKu5xNDkixsXm/r/s=;
X-UUID: 62157b23eeb545c7ab86c1fe8c47aeb5-20191211
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1466117543; Wed, 11 Dec 2019 09:58:00 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS62DR.mediatek.inc (172.29.94.18) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 11 Dec 2019 09:48:35 -0800
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 01:47:31 +0800
Message-ID: <1576086486.23763.61.camel@mtksdccf07>
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of
 MT7531 switch
From:   Landen Chao <landen.chao@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
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
Date:   Thu, 12 Dec 2019 01:48:06 +0800
In-Reply-To: <20191210164855.GE27714@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
         <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
         <20191210164855.GE27714@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDAwOjQ4ICswODAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiArc3RhdGljIGludCBtdDc1MzFfc2V0dXAoc3RydWN0IGRzYV9zd2l0Y2ggKmRzKQ0KPiA+ICt7
DQo+ID4gKwkvKiBFbmFibGUgUEhZIHBvd2VyLCBzaW5jZSBwaHlfZGV2aWNlIGhhcyBub3QgeWV0
IGJlZW4gY3JlYXRlZA0KPiA+ICsJICogcHJvdmlkZWQgZm9yIHBoeV9bcmVhZCx3cml0ZV1fbW1k
X2luZGlyZWN0IGlzIGNhbGxlZCwgd2UgcHJvdmlkZQ0KPiA+ICsJICogb3VyIG93biBtdDc1MzFf
aW5kX21tZF9waHlfW3JlYWQsd3JpdGVdIHRvIGNvbXBsZXRlIHRoaXMNCj4gPiArCSAqIGZ1bmN0
aW9uLg0KPiA+ICsJICovDQo+ID4gKwl2YWwgPSBtdDc1MzFfaW5kX21tZF9waHlfcmVhZChwcml2
LCAwLCBQSFlfREVWMUYsDQo+ID4gKwkJCQkgICAgICBNVDc1MzFfUEhZX0RFVjFGX1JFR180MDMp
Ow0KPiA+ICsJdmFsIHw9IE1UNzUzMV9QSFlfRU5fQllQQVNTX01PREU7DQo+ID4gKwl2YWwgJj0g
fk1UNzUzMV9QSFlfUE9XRVJfT0ZGOw0KPiA+ICsJbXQ3NTMxX2luZF9tbWRfcGh5X3dyaXRlKHBy
aXYsIDAsIFBIWV9ERVYxRiwNCj4gPiArCQkJCSBNVDc1MzFfUEhZX0RFVjFGX1JFR180MDMsIHZh
bCk7DQo+ID4gKw0KPiANCj4gSXMgdGhpcyBwb3dlciB0byBhbGwgdGhlIFBIWXM/IE9yIGp1c3Qg
b25lPw0KVGhpcyBpcyBhbiBpbnRlcm5hbCBjaXJjdWl0IHRoYXQgY29udHJvbHMgdGhlIHBvd2Vy
IHRvIGFsbCBQSFlzIGJlZm9yZQ0KR2VuZXJpYyBNSUkgcmVnaXN0ZXJzIGFyZSBhdmFpbGFibGUu
DQoNCkxhbmRlbg0KPiANCj4gICAgQW5kcmV3DQoNCg==

