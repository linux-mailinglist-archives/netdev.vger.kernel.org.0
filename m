Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB0C46C9D9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 02:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhLHBYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 20:24:21 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:42978 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231966AbhLHBYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 20:24:20 -0500
X-UUID: 7fbad56d52224e3d8cb0af2aa1b7785d-20211208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=8MEfUWmmn3GyKsBzKhZSTZEmNpkk6avA7qVgY8BtriE=;
        b=bufZfLL/YW1OXhgCj+OVYknySZMrucfJ73JZdVMLJuvr6GbYOsYUVD2bzTLq9ypD4jcBb7QeISOFvLzW0Bpc+5mmfh2Jxu9+SlyxaOJAOkfY+OeQFGv4azNGjfs6ej4QwmdioYCQmiWUsLGAqO1zijOm1Fd5APfQWPlEP9EaaEg=;
X-UUID: 7fbad56d52224e3d8cb0af2aa1b7785d-20211208
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 465109991; Wed, 08 Dec 2021 09:20:45 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 8 Dec 2021 09:20:44 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Dec 2021 09:20:43 +0800
Message-ID: <25e2a50392beeb3e7c7428f53fac617a5a5b30f9.camel@mediatek.com>
Subject: Re: [PATCH v5 0/7] MediaTek Ethernet Patches on MT8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Date:   Wed, 8 Dec 2021 09:20:38 +0800
In-Reply-To: <20211207064627.5623f3bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207015505.16746-1-biao.huang@mediatek.com>
         <20211207064345.2c6427a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20211207064627.5623f3bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBKYWt1YiwNCglUaGFua3MgZm9yIHlvdXIgY29tbWVudHN+DQpPbiBUdWUsIDIwMjEtMTIt
MDcgYXQgMDY6NDYgLTA4MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBUdWUsIDcgRGVj
IDIwMjEgMDY6NDM6NDUgLTA4MDAgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24gVHVlLCA3
IERlYyAyMDIxIDA5OjU0OjU4ICswODAwIEJpYW8gSHVhbmcgd3JvdGU6DQo+ID4gPiBDaGFuZ2Vz
IGluIHY1Og0KPiA+ID4gMS4gcmVtb3ZlIHVzZWxlc3MgaW5jbHVzaW9uIGluIGR3bWFjLW1lZGlh
dGVrLmMgYXMgQW5nZWxvJ3MNCj4gPiA+IGNvbW1lbnRzLg0KPiA+ID4gMi4gYWRkIGFja2VkLWJ5
IGluICJuZXQtbmV4dDogc3RtbWFjOiBkd21hYy1tZWRpYXRlazogYWRkIHN1cHBvcnQNCj4gPiA+
IGZvcg0KPiA+ID4gICAgbXQ4MTk1IiBwYXRjaCAgDQo+ID4gDQo+ID4gV2hpY2ggdHJlZSBpcyB0
aGlzIHNlcmllcyBiYXNlZCBvbj8gSXQgZG9lc24ndCBzZWVtIHRvIGFwcGx5IHRvDQo+ID4gbmV0
LW5leHQuIEFsc28gdGhlIG5ldC1uZXh0IGluIHRoZSBzdWJqZWN0cyBpcyBtaXNwbGFjZWQuIElm
IHRoZQ0KPiA+IHNlcmllcw0KPiA+IGlzIHN1cHBvc2VkIHRvIGJlIG1lcmdlZCB0byBuZXQtbmV4
dCB0aGUgc3ViamVjdCBzaG91bGQgYmUgbGlrZToNCj4gPiANCj4gPiBbUEFUQ0ggbmV0LW5leHQg
djUgMS83XSBzdG1tYWM6IGR3bWFjLW1lZGlhdGVrOiBhZGQgcGxhdGZvcm0gbGV2ZWwNCj4gPiBj
bG9ja3MgbWFuYWdlbWVudA0KPiA+IA0KPiA+IFlvdSBjYW4gdXNlIC0tc3ViamVjdC1wcmVmaXg9
IlBBVENIIG5ldC1uZXh0IHY2IiBpbiBnaXQtZm9ybWF0LQ0KPiA+IHBhdGNoIHRvDQo+ID4gYWRk
IHRoZSBwcmVmaXguDQo+IA0KPiBGV0lXIHBhdGNoIDYgaXMgdGhlIG9uZSB3aXRoIHRoZSBjb25m
bGljdDogImFybTY0OiBkdHM6IG10ODE5NTogYWRkDQo+IGV0aGVybmV0IGRldmljZSBub2RlIg0K
SSdsbCByZWJhc2UgdG8gdGhlIGxhdGVzdCBuZXQtbmV4dCB0cmVlLCBhbmQgZml4IHRoZXNlIGlz
c3VlcyBpbiBuZXh0DQpzZW5kDQo=

