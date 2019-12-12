Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D847D11D0A6
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 16:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfLLPOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 10:14:39 -0500
Received: from mailgw02.mediatek.com ([216.200.240.185]:33650 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbfLLPOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 10:14:39 -0500
X-UUID: 570f561f5b0b4658a53dd63d9d56ad04-20191212
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=rc1N+2mn11vQnuHKJzeaj4YyfZJLE0LcAj+lNO1fVFk=;
        b=pLg+4cv2VvvAIXJsMEcXb85SuEhZhUu0t0/ywWL7GP+8QjX+TVcjrX+V1YNcITaWjq3tL4HEArB6rS7yoU4s5ZWqqOoGzttOuyKW1WieABsuoVR1JyP4Sz+rYLtJomr06PZsAcDrjAf3XBDDudKKF8G6w1+Cu2gt8V1iHURkLY0=;
X-UUID: 570f561f5b0b4658a53dd63d9d56ad04-20191212
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 607824229; Thu, 12 Dec 2019 07:14:35 -0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Dec 2019 07:05:41 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Dec 2019 23:04:30 +0800
Message-ID: <1576163072.18168.0.camel@mtksdccf07>
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
Date:   Thu, 12 Dec 2019 23:04:32 +0800
In-Reply-To: <20191211192703.GC30053@lunn.ch>
References: <cover.1575914275.git.landen.chao@mediatek.com>
         <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
         <20191210164438.GD27714@lunn.ch> <1576088280.23763.73.camel@mtksdccf07>
         <20191211192703.GC30053@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTEyLTEyIGF0IDAzOjI3ICswODAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiBEbyB5b3UgYWxzbyBoaW50IGF0IHVzaW5nIHRoZSBzYW1lIG51bWJlciBvZiBwYXJhbWV0ZXJz
IGZvcg0KPiA+IG10NzUzMV9pbmRfYzIyX3BoeV9yZWFkKCkgYW5kIG10NzUzMV9pbmRfYzQ1X3Bo
eV9yZWFkKCk/DQo+IA0KPiBUaGF0IGlzIHVwIHRvIHlvdS4gSXQganVzdCBzZWVtcyBsaWtlIHlv
dXIgTURJTyBidXMgY2FuIGRvIGJvdGggQzIyDQo+IGFuZCBDNDUuIEFuZCBzb21lYm9keSBtaWdo
dCBjb25uZWN0IGFuIGV4dGVybmFsIEM0NSBQSFksIHNvIHlvdSBtaWdodA0KPiBhcyB3ZWxsIHN1
cHBvcnQgaXQuDQpZZXMsIGl0IGlzIGJldHRlciB0byBzdXBwb3J0IGV4dGVybmFsIEM0NSBQSFku
IFRoYW5rcyBmb3IgeW91ciBhZHZpY2UuDQoNCkxhbmRlbg0KPiANCj4gICAgQW5kcmV3DQo=

