Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17DF375430
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhEFMzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:55:36 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:63888 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhEFMzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:55:35 -0400
X-UUID: cacd1a97faf7419790fc48608d9431f0-20210506
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=u++h3xqD22QpblRd36WXArhv2zfQ3l9s+WBc2UfSt7g=;
        b=MV3NvYP2frJPRbpqE5J/Gqln5O/ylDZd6JEvYCY0/4C/gevK1puJ37yWeFxAT4xBy4dGg0VKkiyZlHyIKfG0LDeamzGEiNpmHiI/QFiHz/xeTgGxGfTtQyt+Km8kRRpThMcq5b3wHGpzoN+A5WqWQUwKWLyVq8wBeKsnWEnMH4k=;
X-UUID: cacd1a97faf7419790fc48608d9431f0-20210506
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1159418325; Thu, 06 May 2021 05:54:36 -0700
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62DR.mediatek.inc (172.29.94.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 6 May 2021 05:54:01 -0700
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 6 May 2021 20:53:59 +0800
Message-ID: <f3f5167f60b7897b952f5fff7bcaef976c3c6531.camel@mediatek.com>
Subject: Re: Re: Re: Re: [PATCH net-next 0/4] MT7530 interrupt support
From:   Landen Chao <landen.chao@mediatek.com>
To:     DENG Qingfang <dqfext@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        David Miller <davem@davemloft.net>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        <linux-staging@lists.linux.dev>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Date:   Thu, 6 May 2021 20:54:00 +0800
In-Reply-To: <CALW65ja5mRPoNM2EZsONMh8Kda5OgQg79R=Xp71CaQcp4cprnQ@mail.gmail.com>
References: <20210429062130.29403-1-dqfext@gmail.com>
         <20210429.170815.956010543291313915.davem@davemloft.net>
         <20210430023839.246447-1-dqfext@gmail.com> <YIv28APpOP9tnuO+@lunn.ch>
         <trinity-843c99ce-952a-434e-95e4-4ece3ba6b9bd-1619786236765@3c-app-gmx-bap03>
         <YIv7w8Wy81fmU5A+@lunn.ch>
         <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
         <YIwCliT5NZT713WD@lunn.ch>
         <trinity-c45bbeec-5b7c-43a2-8e86-7cb22ad61558-1619794787680@3c-app-gmx-bap03>
         <YIwxpYD1jnFMPQz+@lunn.ch>
         <fc962daf8b7babc22b043b2b0878a206780b55f3.camel@mediatek.com>
         <CALW65ja5mRPoNM2EZsONMh8Kda5OgQg79R=Xp71CaQcp4cprnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA1LTA1IGF0IDE3OjQzICswODAwLCBERU5HIFFpbmdmYW5nIHdyb3RlOg0K
PiBPbiBXZWQsIE1heSA1LCAyMDIxIGF0IDU6MzEgUE0gTGFuZGVuIENoYW8gPGxhbmRlbi5jaGFv
QG1lZGlhdGVrLmNvbT4NCj4gd3JvdGU6DQo+ID4gSG93IGFib3V0IHVzaW5nIG1lZGlhdGVrLWdl
LmtvLiAnZ2UnIGlzIHRoZSBhYmJyZXZpYXRpb24gb2YgZ2lnYWJpdA0KPiA+IEV0aGVybmV0LiBN
b3N0IG1lZGlhdGVrIHByb2R1Y3RzIHVzZSB0aGUgc2FtZSBnaWdhYml0IEV0aGVybmV0IHBoeS4N
Cj4gDQo+IFdlbGwsIE1UNzYyMCdzIFBIWSBpcyBGRS4uDQpNVDc2MjAncyBGRSBQSFkgSFcgaXMg
ZGlmZmVyZW50IGZyb20gTVQ3NTN4J3MgR0UgUEhZLiBWZW5kb3IgcmVnaXN0ZXJzDQpvZiB0aGVz
ZSB0d28gUEhZIGFyZSB0b3RhbGx5IGRpZmZlcmVudC4NCkhvd2V2ZXIsIE1UNzYyMCBpbnRlcm5h
bCBzd2l0Y2ggTUFDIGlzIHF1aXRlIHRoZSBzYW1lIGFzIE1UNzUzeCdzIE1BQw0KZXhjZXB0IGZv
ciBWTEFOIHRhYmxlIGFuZCBvdGhlciBtaW5vciBjaGFuZ2VzLiBUaGUgTUFDIHBhcnQgY2FuIGJl
DQpyZXVzZWQuIA0KDQo+IA0KPiA+IA0KPiA+IExhbmRlbg0K

