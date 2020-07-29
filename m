Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C904231A98
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 09:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgG2Htf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 03:49:35 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:53050 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726476AbgG2Htf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 03:49:35 -0400
X-UUID: 6cf5602f4ff843c69a12ea981c21e0bc-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=PLS803tvjxppBUkg87cILtTBEuzNXhpjoLU3sd43MOw=;
        b=KBQhBILBY4thJZnHoetRGaauIVadATRUvBfrACdmCdC7nljM3qKcKQLFYABxlMiTb29rNn4Qh2wAQxJC2XE1ogKlmqDG/eV/csmqZLulrl/kVbNwKJGVFqTXz9V43sXypbjugqEQorK3i4Av73MgOoUs3NiQ4oZB4g8dg5hGWSc=;
X-UUID: 6cf5602f4ff843c69a12ea981c21e0bc-20200729
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 794015785; Wed, 29 Jul 2020 15:49:31 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 15:49:29 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 15:49:31 +0800
Message-ID: <1596008970.20318.19.camel@mtksdccf07>
Subject: Re: [PATCH v3] net: ethernet: mtk_eth_soc: fix mtu warning
From:   Landen Chao <landen.chao@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Frank Wunderlich <frank-w@public-files.de>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        Mark-MC Lee =?UTF-8?Q?=28=E6=9D=8E=E6=98=8E=E6=98=8C=29?= 
        <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Date:   Wed, 29 Jul 2020 15:49:30 +0800
In-Reply-To: <20200728085355.7de7c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200728122743.78489-1-frank-w@public-files.de>
         <20200728085355.7de7c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRnJhbmssDQoNCklmIHlvdSBzZW5kIG5leHQgdmVyc2lvbiBvZiBwYXRjaCwgeW91IGNhbiBo
ZWxwIHRvIGFkZCB0aGUgU2lnbmVkLW9mZg0KbGluZS4gVGhhbmtzLg0KU2lnbmVkLW9mZi1ieTog
TGFuZGVuIENoYW8gPGxhbmRlbi5jaGFvQG1lZGlhdGVrLmNvbT4NCg0KT24gVHVlLCAyMDIwLTA3
LTI4IGF0IDIzOjUzICswODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVHVlLCAyOCBK
dWwgMjAyMCAxNDoyNzo0MyArMDIwMCBGcmFuayBXdW5kZXJsaWNoIHdyb3RlOg0KPiA+IEZyb206
IExhbmRlbiBDaGFvIDxsYW5kZW4uY2hhb0BtZWRpYXRlay5jb20+DQo+IA0KPiBIaSBnZW50cywN
Cj4gDQo+IGlmIHRoZSBwYXRjaCBpcyBmcm9tIExhbmRlbiB3ZSBuZWVkIGhpcyBzaWduLW9mZiBv
biBpdC4NCj4gDQo+ID4gaW4gcmVjZW50IEtlcm5lbC1WZXJzaW9ucyB0aGVyZSBhcmUgd2Fybmlu
Z3MgYWJvdXQgaW5jb3JyZWN0IE1UVS1TaXplDQo+ID4gbGlrZSB0aGVzZToNCj4gPiANCj4gPiBl
dGgwOiBtdHUgZ3JlYXRlciB0aGFuIGRldmljZSBtYXhpbXVtDQo+ID4gbXRrX3NvY19ldGggMWIx
MDAwMDAuZXRoZXJuZXQgZXRoMDogZXJyb3IgLTIyIHNldHRpbmcgTVRVIHRvIGluY2x1ZGUgRFNB
IG92ZXJoZWFkDQo+ID4gDQo+ID4gRml4ZXM6IGJmY2I4MTMyMDNlNiAoIm5ldDogZHNhOiBjb25m
aWd1cmUgdGhlIE1UVSBmb3Igc3dpdGNoIHBvcnRzIikNCj4gPiBGaXhlczogNzI1NzllMTRhMWQz
ICgibmV0OiBkc2E6IGRvbid0IGZhaWwgdG8gcHJvYmUgaWYgd2UgY291bGRuJ3Qgc2V0IHRoZSBN
VFUiKQ0KPiA+IEZpeGVzOiA3YTRjNTNiZWUzMzIgKCJuZXQ6IHJlcG9ydCBpbnZhbGlkIG10dSB2
YWx1ZSB2aWEgbmV0bGluayBleHRhY2siKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFJlbsOpIHZhbiBE
b3JzdCA8b3BlbnNvdXJjZUB2ZG9yc3QuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEZyYW5rIFd1
bmRlcmxpY2ggPGZyYW5rLXdAcHVibGljLWZpbGVzLmRlPg0KPiANCg0K

