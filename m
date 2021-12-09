Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58546E082
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbhLIB6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:58:33 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47452 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233346AbhLIB6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:58:32 -0500
X-UUID: 976cb222604948b6b6e4e47fc25af019-20211209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=WIV75YWZapc7GJoPTfjsaqgrja4fRL9eKNuW62oS71w=;
        b=ZZ8ZvMmlCr8vWKjA5sifCtDeR/aJWGNcK5jWlU6ckU3/NGwlMmbeHzY9eT47F4NFiTmU361PmD19Fqv2qw7OgI37PfyXrLAlVyuCs1gK+udEnCHS7k3ZcWcaRrw5Vk0ziU9xwDYiowBbNW8d7JUScFJb98dYtFyNp7dCnKZvOI8=;
X-UUID: 976cb222604948b6b6e4e47fc25af019-20211209
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1238356704; Thu, 09 Dec 2021 09:54:56 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 9 Dec 2021 09:54:54 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 9 Dec 2021 09:54:53 +0800
Message-ID: <6deeba8396a72d3d0bb3cb6630bc0c36f652de80.camel@mediatek.com>
Subject: Re: [PATCH net-next v7 5/6] stmmac: dwmac-mediatek: add support for
 mt8195
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
Date:   Thu, 9 Dec 2021 09:54:53 +0800
In-Reply-To: <20211208175142.1b63afea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211208054716.603-1-biao.huang@mediatek.com>
         <20211208054716.603-6-biao.huang@mediatek.com>
         <20211208063820.264df62d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <39aa23e1a48bc36a631b3074af2abfd5d1e2256d.camel@mediatek.com>
         <20211208175142.1b63afea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTA4IGF0IDE3OjUxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA5IERlYyAyMDIxIDA5OjQ4OjI1ICswODAwIEJpYW8gSHVhbmcgd3JvdGU6DQo+
ID4gU29ycnkgZm9yIHNvbWUgdHlwbyBpbiBwcmV2aW91cyByZXBseSwgZml4IGl0IGhlcmUuDQo+
ID4gDQo+ID4gQWxsIHRoZXNlIHdhcm5pbmcgbGluZXMgc2hhcmUgYSBzaW1pbGFyIHNlbWFudGlj
czoNCj4gPiBkZWxheV92YWwgfD0gRklFTERfUFJFUCh4eHgsICEhdmFsKTsNCj4gPiANCj4gPiBh
bmQsIHNob3VsZCBjb21lIGZyb20gdGhlIGV4cGFuc2lvbiBvZiBGSUVMRF9QUkVQIGluDQo+ID4g
aW5jbHVkZS9saW51eC9iaXRmaWxlZC5oOg0KPiA+IA0KPiA+ICAgRklFTEQgX1BSRVAgLS0+IF9f
QkZfRklMRURfQ0hFQ0sgLS0+ICJ+KChfbWFzaykgPj4NCj4gPiBfX2JmX3NoZihfbWFzaykpICYN
Cj4gPiAoX3ZhbCkgOiAwLCINCj4gPiANCj4gPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiBfX0JGX0ZJTEVEX0NIRUNL
IHsNCj4gPiAuLi4NCj4gPiAgIEJVSUxEX0JVR19PTl9NU0coX19idWlsdGluX2NvbnN0YW50X3Ao
X3ZhbCkgPyAgICAgICAgICAgXA0KPiA+ICAgICAgICAgICAgICAgICAgICB+KChfbWFzaykgPj4g
X19iZl9zaGYoX21hc2spKSAmIChfdmFsKSA6IDAsIFwNCj4gPiAgICAgICAgICAgICAgICAgICAg
X3BmeCAidmFsdWUgdG9vIGxhcmdlIGZvciB0aGUgZmllbGQiKTsgXCAuLi4NCj4gPiA9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0N
Cj4gPiANCj4gPiBTaG91bGQgSSBmaXggaXQgYnkgY29udmVydGluZw0KPiA+ICAgZGVsYXlfdmFs
IHw9IEZJRUxEX1BSRVAoRVRIX0RMWV9UWENfRU5BQkxFLCAhIW1hY19kZWxheS0NCj4gPiA+dHhf
ZGVsYXkpOw0KPiA+IHRvDQo+ID4gICBlbl92YWwgPSAhIW1hY19kZWxheS0+dHhfZGVsYXk7DQo+
ID4gICBkZWxheV92YWwgfD0gRklFTERfUFJFUChFVEhfRExZX1RYQ19FTkFCTEUsIGVuX3ZhbCk7
DQo+ID4gDQo+ID4gb3Igb3RoZXIgc3VnZ2VzdGlvbnMgZm9yIHRoZXNlIHdhcm5pbmdzPw0KPiAN
Cj4gSSBzZWUsIHRoYW5rcyBmb3IgZXhwbGFpbmluZy4gVGhlIGNvZGUgaXMgZmluZSwgd2UgY2Fu
IHNpbXBseSBpZ25vcmUNCj4gdGhpcyB3YXJuaW5nIElNSE8uDQpPSywgdGhhbmtzIGZvciB5b3Vy
IGNvbW1lbnRzfg0K

