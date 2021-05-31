Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25F73957D9
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhEaJIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:08:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:51018 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230206AbhEaJI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 05:08:26 -0400
X-UUID: f55c5c59fb404821854a59d59c51b813-20210531
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bS+/yrXs2fjTD4HJUy9q0nG4d3SEQmTaKJc1kPQr/lY=;
        b=P2Y6uW/39UPevtRmui2W//ilgxzx3tSjua7XqutfffxKluzJ8b5putOPTmJMowkFsFsD6HLu6vhE/vAKQUYNr9uV+nF4idwvO1oxMA19KiJO9aFR2ZFvZ1VHOYkhHyZLjqS5WPsy3IYFZKhTSNGVVh/ntOMgU3loB3m0P1nrfbY=;
X-UUID: f55c5c59fb404821854a59d59c51b813-20210531
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1479349101; Mon, 31 May 2021 17:06:42 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 31 May 2021 17:06:40 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 17:06:40 +0800
Message-ID: <1903cbd39afb96a9f6ab72ac45d830918e3b5982.camel@mediatek.com>
Subject: Re: [PATCH net] net: Update MAINTAINERS for MediaTek switch driver
From:   Landen Chao <landen.chao@mediatek.com>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "dqfext@gmail.com" <dqfext@gmail.com>,
        Sean Wang <Sean.Wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "frank-w@public-files.de" <frank-w@public-files.de>,
        Steven Liu =?UTF-8?Q?=28=E5=8A=89=E4=BA=BA=E8=B1=AA=29?= 
        <steven.liu@mediatek.com>
Date:   Mon, 31 May 2021 17:06:40 +0800
In-Reply-To: <20210531162342.339635bb@xhacker.debian>
References: <49e67daeadace13a9fa3f4553f1ec14c6a93bdc8.1622445132.git.landen.chao@mediatek.com>
         <20210531162342.339635bb@xhacker.debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA1LTMxIGF0IDE2OjIzICswODAwLCBKaXNoZW5nIFpoYW5nIHdyb3RlOg0K
PiBPbiBNb24sIDMxIE1heSAyMDIxIDE1OjU5OjM5ICswODAwDQo+IExhbmRlbiBDaGFvIDxsYW5k
ZW4uY2hhb0BtZWRpYXRlay5jb20+IHdyb3RlOg0KPiANCj4gDQo+ID4gDQo+ID4gDQo+ID4gVXBk
YXRlIG1haW50YWluZXJzIGZvciBNZWRpYVRlayBzd2l0Y2ggZHJpdmVyIHdpdGggRGVuZyBRaW5n
ZmFuZw0KPiA+IHdobw0KPiA+IGNvbnRyaWJ1dGVzIG1hbnkgdXNlZnVsIHBhdGNoZXMgKGludGVy
cnVwdCwgVkxBTiwgR1BJTywgYW5kIGV0Yy4pDQo+ID4gdG8NCj4gPiBlbmhhbmNlIE1lZGlhVGVr
IHN3aXRjaCBkcml2ZXIgYW5kIHdpbGwgaGVscCBtYWludGVuYW5jZS4NCj4gPiANCj4gPiBDaGFu
Z2UtSWQ6IElmMzcyYzFhMGRmNmUzYmE5ZjkzYjE2OTlkYmRhODFmMWZkNTAxYTdjDQo+IA0KPiBk
byB3ZSBuZWVkIHRvIHJlbW92ZSB0aGlzIENoYW5nZS1JZCB0YWc/DQpTb3JyeSwgSSB3aWxsIHJl
bW92ZSBDaGFuZ2UtSWQgaW4gdjIuDQoNCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogTGFuZGVuIENo
YW8gPGxhbmRlbi5jaGFvQG1lZGlhdGVrLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBERU5HIFFp
bmdmYW5nIDxkcWZleHRAZ21haWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBNQUlOVEFJTkVSUyB8IDEg
Kw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gPiANCj4gPiBkaWZmIC0t
Z2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUw0KPiA+IGluZGV4IGJkN2FmZjBjMTIwZi4u
MzMxNTYyN2ViYjZiIDEwMDY0NA0KPiA+IC0tLSBhL01BSU5UQUlORVJTDQo+ID4gKysrIGIvTUFJ
TlRBSU5FUlMNCj4gPiBAQCAtMTE1ODgsNiArMTE1ODgsNyBAQCBGOiAgICAgIGRyaXZlcnMvY2hh
ci9od19yYW5kb20vbXRrLXJuZy5jDQo+ID4gIE1FRElBVEVLIFNXSVRDSCBEUklWRVINCj4gPiAg
TTogICAgIFNlYW4gV2FuZyA8c2Vhbi53YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiAgTTogICAgIExh
bmRlbiBDaGFvIDxsYW5kZW4uY2hhb0BtZWRpYXRlay5jb20+DQo+ID4gK006ICAgICBERU5HIFFp
bmdmYW5nIDxkcWZleHRAZ21haWwuY29tPg0KPiA+ICBMOiAgICAgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPiA+ICBTOiAgICAgTWFpbnRhaW5lZA0KPiA+ICBGOiAgICAgZHJpdmVycy9uZXQvZHNh
L210NzUzMC4qDQo+ID4gLS0NCj4gPiAyLjI5LjINCg==

