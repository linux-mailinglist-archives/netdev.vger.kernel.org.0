Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8032497A5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgHSHpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:45:51 -0400
Received: from mailgw01.mediatek.com ([216.200.240.184]:46722 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgHSHpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:45:50 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2020 03:45:50 EDT
X-UUID: f89b5b861c5f43ee874e5302307a12a6-20200818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=fA1ZbejQFXPVLQG+Xp5gLcjblRbOlo94pfMY0RDgam0=;
        b=Wq6KxU26E3Hy1RaGgPDFkuiC1wtJh3NWU9TaEzhThMlD9GaXmHENZhNPnsPC7HQnnjXE2BwAhxR3HTpvzjVFRgW27h3lhsGvukd7t/hGDk2y7Wzq9Um8IcuWMPZ8ccC2tLjz+4opqS8oZ16viCadWg7a9/nrJLEIyjPMCuQ/D5Y=;
X-UUID: f89b5b861c5f43ee874e5302307a12a6-20200818
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1275055599; Tue, 18 Aug 2020 23:40:44 -0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS62DR.mediatek.inc (172.29.94.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 19 Aug 2020 00:38:35 -0700
Received: from [172.21.84.99] (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Aug 2020 15:38:23 +0800
Message-ID: <1597822704.31846.27.camel@mtksdccf07>
Subject: Re: [PATCH net-next v2 0/7] net-next: dsa: mt7530: add support for
 MT7531
From:   Landen Chao <landen.chao@mediatek.com>
To:     DENG Qingfang <dqfext@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "vivien.didelot@savoirfairelinux.com" 
        <vivien.didelot@savoirfairelinux.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Sean Wang <Sean.Wang@mediatek.com>,
        =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Date:   Wed, 19 Aug 2020 15:38:24 +0800
In-Reply-To: <CALW65jZRWwW4DqpsCM9J=GRp6KnxqT-9MHUO7WSRJtp4E9vnFw@mail.gmail.com>
References: <cover.1597729692.git.landen.chao@mediatek.com>
         <CALW65jZRWwW4DqpsCM9J=GRp6KnxqT-9MHUO7WSRJtp4E9vnFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgREVORywNCg0KTVQ3NTMxIG1pcnJvciBwb3J0IGhhcyBiZWVuIGZpeGVkIGJ5IG5ldyBkZWZp
bml0aW9uIG9mIHJlZ2lzdGVyIGJhc2UgaW4gDQpoZWFkZXIgZmlsZS4gVGhlIGxvZ2ljIG9mIG1p
cnJvciBwb3J0IHNldHRpbmcgaW4gNzUzMC5jIGlzIHJldXNlZC4NCg0KQEAgLTQxLDYgKzQyLDMz
IEBAICBlbnVtIG10NzUzeF9pZCB7DQogI2RlZmluZSAgTUlSUk9SX1BPUlQoeCkJCQkoKHgpICYg
MHg3KQ0KICNkZWZpbmUgIE1JUlJPUl9NQVNLCQkJMHg3DQogDQorLyogUmVnaXN0ZXJzIGZvciBD
UFUgZm9yd2FyZCBjb250cm9sICovDQorI2RlZmluZSBNVDc1MzFfQ0ZDCQkJMHg0DQorI2RlZmlu
ZSAgTVQ3NTMxX01JUlJPUl9FTgkJQklUKDE5KQ0KKyNkZWZpbmUgIE1UNzUzMV9NSVJST1JfTUFT
SwkJKE1JUlJPUl9NQVNLIDw8IDE2KQ0KKyNkZWZpbmUgIE1UNzUzMV9NSVJST1JfUE9SVF9HRVQo
eCkJKCgoeCkgPj4gMTYpICYgTUlSUk9SX01BU0spDQorI2RlZmluZSAgTVQ3NTMxX01JUlJPUl9Q
T1JUX1NFVCh4KQkoKCh4KSAmIE1JUlJPUl9NQVNLKSA8PCAxNikNCisjZGVmaW5lICBNVDc1MzFf
Q1BVX1BNQVBfTUFTSwkJR0VOTUFTSyg3LCAwKQ0KKw0KKyNkZWZpbmUgTVQ3NTNYX01JUlJPUl9S
RUcoaWQpCQkoKChpZCkgPT0gSURfTVQ3NTMxKSA/IFwNCisJCQkJCSBNVDc1MzFfQ0ZDIDogTVQ3
NTMwX01GQykNCisjZGVmaW5lIE1UNzUzWF9NSVJST1JfRU4oaWQpCQkoKChpZCkgPT0gSURfTVQ3
NTMxKSA/IFwNCisJCQkJCSBNVDc1MzFfTUlSUk9SX0VOIDogTUlSUk9SX0VOKQ0KKyNkZWZpbmUg
TVQ3NTNYX01JUlJPUl9NQVNLKGlkKQkJKCgoaWQpID09IElEX01UNzUzMSkgPyBcDQorCQkJCQkg
TVQ3NTMxX01JUlJPUl9NQVNLIDogTUlSUk9SX01BU0spDQoNCg0KT24gV2VkLCAyMDIwLTA4LTE5
IGF0IDExOjQ5ICswODAwLCBERU5HIFFpbmdmYW5nIHdyb3RlOg0KPiBIaSwNCj4gDQo+IElzIHBv
cnQgbWlycm9yaW5nIHdvcmtpbmc/IFBvcnQgbWlycm9yaW5nIHJlZ2lzdGVycyBvbiBNVDc1MzEg
aGF2ZQ0KPiBtb3ZlZCwgYWNjb3JkaW5nIHRvIGJwaSdzIE1UNzUzMSByZWZlcmVuY2UgbWFudWFs
Lg0KPiBQbGVhc2UgZml4IHRoYXQgYXMgd2VsbC4NCg0K

