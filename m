Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2CD1E5A9E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgE1IUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:20:15 -0400
Received: from mail-vi1eur05on2110.outbound.protection.outlook.com ([40.107.21.110]:5440
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgE1IUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 04:20:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSB/3+KDBFejUPvkhGc1vtYOjkpaIjK6GxZmCKynp1mJt+ErJA7Auem0UFmt7e1J40G6+fFrkJ/3YBA96s/xtghue4Px8CznNX/9cZQBJLtHp/oOFSzr0JoRXt2fTiHd7YRAqjkyB6XSemK/mGMzAFl1xxGWQqE3Bk6enRAnZKtAyTfJ+b6WmXqbv449ke0kJ+YhaIOBP6wB4hxmyLbDRubhpr9t/4zd65Om0WoC4p3qTKLWUeAle7dPFNxH5Wg4flasMoz8wZh+wjGHy1/ORVlpmlKfTNOsWrtACUNF7WX0iv9+QyScYD3n1uIJUkIQTyfMhwb9qmSlpTI4EuplZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLdz4gy7ZTNvhgmEWXp0OFQzkaeFRHciRVElCEe1Rew=;
 b=So7ccdeBIP490n+Pi/c4kpdpw86HC57Bt2I0wucRk+xtquuspQhq0Knm6tTLoYhQ2rP3xwG4sSPZ8BNGUQsQKwnOpDR9HXpIp5pzsVQrlDe0GoCUdUs/OTwbZ6cI4mndaDA0kpXdxAK4A518VwBBFkkI1Q39s4aka9QvI3tm8BIo2+GvV0db7ZsSwPlJ6q9lBWqgrfLa0pBJ+Y70wsgmulOdi/EurK32sRicYnFHxu9OlflvgPR/cFq00Ol3O8n0HZOQPVKKx8gWcABrwYHUrSHFW7V0F0+0tsbk7v+tng8qP/82QaR2I71LjqQna6me2QFMR7K1CJd32o+e5+l0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLdz4gy7ZTNvhgmEWXp0OFQzkaeFRHciRVElCEe1Rew=;
 b=FgIROp+XEv0cc0y8oXDXwuPvflY4luSTmIN/PyJ7Z0uPwDdxmL/oSslEmGXh9Rpqy/69++9+lMYAeVfYX+LXcwbnkDU5r7r850paSOCZd2b62tvdFGHlxjbi29Vdot0nR368LSutHRrvTmBQ7gdibBtmLZLHDn+MY/Ly8M+kass=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (2603:10a6:20b:a8::25)
 by AM6PR05MB5062.eurprd05.prod.outlook.com (2603:10a6:20b:b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Thu, 28 May
 2020 08:20:08 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289%6]) with mapi id 15.20.3021.030; Thu, 28 May 2020
 08:20:08 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kazuya.mizuguchi.ks@renesas.com" <kazuya.mizuguchi.ks@renesas.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Topic: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Index: AQHWGHaxUA6NfMbeRU2VdAoOfe//rKiOsmkAgAAFQQCAAAgNgIABFHSAgAALXgCALKTAgIAA3GGA
Date:   Thu, 28 May 2020 08:20:08 +0000
Message-ID: <3a6f6ecc5ea4de7600716a23739c13dc5b02771e.camel@toradex.com>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
         <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
         <20200428154718.GA24923@lunn.ch>
         <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
         <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
         <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
         <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
In-Reply-To: <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=toradex.com;
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe75acbe-39f8-4296-f47d-08d802dfeefc
x-ms-traffictypediagnostic: AM6PR05MB5062:
x-microsoft-antispam-prvs: <AM6PR05MB5062E51AB4D9A9A656C23B6CF48E0@AM6PR05MB5062.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WZaRoX600jRx92apxT26wt/BCzfuY5iKm5/UUOp/NuFDXL/a7cROccwoOegZLZAhRz0GKouMbPX6IwBtkiYgWeBqj2CYjG7/l8M0UHtewzWTMK1REzlbAvYXtt3+laiLwvuiMODLpnIHXuXGUrn+Y4pLX2vtZbFeuLScVlIF0P4ryraAaqcQ8Bqqzbh85wo9BzkPwJYiOlY0s9U5nOAIykB4+J/BCTlvieZEGOppJMTELzo6K/T0Ws1/zGV8pFRPtMo0gXsMSUh/I9d4JZivlJFDN4Gn/uSpsJcFusVSuZJkx4FawAF6alTGK8SzGFINSK94Ox7Kf0mwLK/mNm95jA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6120.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(6506007)(6486002)(66556008)(66446008)(53546011)(64756008)(66476007)(26005)(83380400001)(2906002)(186003)(7416002)(8676002)(66946007)(54906003)(316002)(8936002)(5660300002)(110136005)(76116006)(478600001)(86362001)(91956017)(71200400001)(36756003)(6512007)(44832011)(4326008)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: W9+wrOGTzKtNZENzkFAHNOGBpulpQegy2myR7w+LbXS5LH67lN+m6Ggn8rtxMfN91Uk50aH9PD8NupEqq0yQ9e2oT2ysterI/gcuYKSx/8Ga3IJhSC4yYx8D1SkfgbCb9hOwfRPCzvOYzlAIAtpe+8yoE2QDI+dFRzId6zDHq/IxHs4xZDxWj7OXp25gViSvPWrKkNezPoMmEdp1S+5CnwlPPyi5nU0zFpO42oYJJC7l5ADpSlkzTwvhOp7ut5qA1MdLT2Fl2Qw/muZHGRcqO3KiFxdyF4Xv6I5pfSJGiQfCcEjfwlXwlxBDxIrBgdWp4jw1m71eLTd++TR88du0q4k23G5hoWLn6ypUQOEKyW7GE3VGrm7PeKUI2r8gC5WJKjjKBTjaDDtfa4cN2Q5ahNjKCYOVOPQUH4MsnPk6TiJvBisLUy0PacsYqLdcY8f0375sC7cAzILTH0n7QXMNIEEfnB7NHxrWVw4temS5TP4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E15C01C3830D0B4480552E6A0BEA0033@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe75acbe-39f8-4296-f47d-08d802dfeefc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 08:20:08.2753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vh3szAzHsh0StPwkGzEBTZcKDnO3BKgoyzxOUH81orND13a7CszwgpkcOeaxx7Pk6eZb//jqxRCWQ2/1TfrOhWGcKninRqdATG1OvMtYD1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTI3IGF0IDIxOjExICswMjAwLCBHZWVydCBVeXR0ZXJob2V2ZW4gd3Jv
dGU6DQo+IEhpIE9sZWtzaWosDQo+IA0KPiBPbiBXZWQsIEFwciAyOSwgMjAyMCBhdCAxMToyNiBB
TSBPbGVrc2lqIFJlbXBlbCA8DQo+IG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPiB3cm90ZToNCj4g
PiBPbiBXZWQsIEFwciAyOSwgMjAyMCBhdCAxMDo0NTozNUFNICswMjAwLCBHZWVydCBVeXR0ZXJo
b2V2ZW4gd3JvdGU6DQo+ID4gPiBPbiBUdWUsIEFwciAyOCwgMjAyMCBhdCA2OjE2IFBNIFBoaWxp
cHBlIFNjaGVua2VyDQo+ID4gPiA8cGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+IHdyb3Rl
Og0KPiA+ID4gPiBPbiBUdWUsIDIwMjAtMDQtMjggYXQgMTc6NDcgKzAyMDAsIEFuZHJldyBMdW5u
IHdyb3RlOg0KPiA+ID4gPiA+IE9uIFR1ZSwgQXByIDI4LCAyMDIwIGF0IDA1OjI4OjMwUE0gKzAy
MDAsIEdlZXJ0IFV5dHRlcmhvZXZlbg0KPiA+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+ID4gVGhp
cyB0cmlnZ2VycyBvbiBSZW5lc2FzIFNhbHZhdG9yLVgoUyk6DQo+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+ICAgICBNaWNyZWwgS1NaOTAzMSBHaWdhYml0IFBIWSBlNjgwMDAwMC5ldGhlcm5ldC0N
Cj4gPiA+ID4gPiA+IGZmZmZmZmZmOjAwOg0KPiA+ID4gPiA+ID4gKi1za2V3LXBzIHZhbHVlcyBz
aG91bGQgYmUgdXNlZCBvbmx5IHdpdGggcGh5LW1vZGUgPSAicmdtaWkiDQo+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+IHdoaWNoIHVzZXM6DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ICAgICAg
ICAgcGh5LW1vZGUgPSAicmdtaWktdHhpZCI7DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IGFu
ZDoNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gICAgICAgICByeGMtc2tldy1wcyA9IDwxNTAw
PjsNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gSWYgSSB1bmRlcnN0YW5kDQo+ID4gPiA+ID4g
PiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2V0aGVybmV0LQ0KPiA+ID4g
PiA+ID4gY29udHJvbGxlci55YW1sDQo+ID4gPiA+ID4gPiBjb3JyZWN0bHk6DQo+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gQ2hlY2tpbmcgZm9yIHNrZXdzIHdoaWNoIG1pZ2h0IGNvbnRyYWRpY3QgdGhl
IFBIWS1tb2RlIGlzIG5ldy4NCj4gPiA+ID4gPiBJIHRoaW5rDQo+ID4gPiA+ID4gdGhpcyBpcyB0
aGUgZmlyc3QgUEhZIGRyaXZlciB0byBkbyBpdC4gU28gaSdtIG5vdCB0b28NCj4gPiA+ID4gPiBz
dXJwcmlzZWQgaXQgaGFzDQo+ID4gPiA+ID4gdHJpZ2dlcmVkIGEgd2FybmluZywgb3IgdGhlcmUg
aXMgY29udHJhZGljdG9yeSBkb2N1bWVudGF0aW9uLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFlv
dXIgdXNlIGNhc2VzIGlzIHJlYXNvbmFibGUuIEhhdmUgdGhlIG5vcm1hbCB0cmFuc21pdCBkZWxh
eSwNCj4gPiA+ID4gPiBhbmQgYQ0KPiA+ID4gPiA+IGJpdCBzaG9ydGVkIHJlY2VpdmUgZGVsYXku
IFNvIHdlIHNob3VsZCBhbGxvdyBpdC4gSXQganVzdA0KPiA+ID4gPiA+IG1ha2VzIHRoZQ0KPiA+
ID4gPiA+IHZhbGlkYXRpb24gY29kZSBtb3JlIGNvbXBsZXggOi0oDQo+ID4gPiA+IA0KPiA+ID4g
PiBJIHJldmlld2VkIE9sZWtzaWoncyBwYXRjaCB0aGF0IGludHJvZHVjZWQgdGhpcyB3YXJuaW5n
LiBJIGp1c3QNCj4gPiA+ID4gd2FudCB0bw0KPiA+ID4gPiBleHBsYWluIG91ciB0aGlua2luZyB3
aHkgdGhpcyBpcyBhIGdvb2QgdGhpbmcsIGJ1dCB5ZXMgbWF5YmUgd2UNCj4gPiA+ID4gY2hhbmdl
DQo+ID4gPiA+IHRoYXQgd2FybmluZyBhIGxpdHRsZSBiaXQgdW50aWwgaXQgbGFuZHMgaW4gbWFp
bmxpbmUuDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGUgS1NaOTAzMSBkcml2ZXIgZGlkbid0IHN1cHBv
cnQgZm9yIHByb3BlciBwaHktbW9kZXMgdW50aWwgbm93DQo+ID4gPiA+IGFzIGl0DQo+ID4gPiA+
IGRvbid0IGhhdmUgZGVkaWNhdGVkIHJlZ2lzdGVycyB0byBjb250cm9sIHR4IGFuZCByeCBkZWxh
eXMuIFdpdGgNCj4gPiA+ID4gT2xla3NpaidzIHBhdGNoIHRoaXMgZGVsYXkgaXMgbm93IGRvbmUg
YWNjb3JkaW5nbHkgaW4gc2tldw0KPiA+ID4gPiByZWdpc3RlcnMgYXMNCj4gPiA+ID4gYmVzdCBh
cyBwb3NzaWJsZS4gSWYgeW91IG5vdyBhbHNvIHNldCB0aGUgcnhjLXNrZXctcHMgcmVnaXN0ZXJz
DQo+ID4gPiA+IHRob3NlDQo+ID4gPiA+IHZhbHVlcyB5b3UgcHJldmlvdXNseSBzZXQgd2l0aCBy
Z21paS10eGlkIG9yIHJ4aWQgZ2V0DQo+ID4gPiA+IG92ZXJ3cml0dGVuLg0KPiANCj4gV2hpbGUg
SSBkb24ndCBjbGFpbSB0aGF0IHRoZSBuZXcgaW1wbGVtZW50YXRpb24gaXMgaW5jb3JyZWN0LCBt
eQ0KPiBiaWdnZXN0DQo+IGdyaXBlIGlzIHRoYXQgdGhpcyBjaGFuZ2UgYnJlYWtzIGV4aXN0aW5n
IHNldHVwcyAoY2ZyLiBHcnlnb3JpaSdzDQo+IHJlcG9ydCwNCj4gcGx1cyBzZWUgYmVsb3cpLiAg
UGVvcGxlIGZpbmUtdHVuZWQgdGhlIHBhcmFtZXRlcnMgaW4gdGhlaXIgRFRTIGZpbGVzDQo+IGFj
Y29yZGluZyB0byB0aGUgb2xkIGRyaXZlciBiZWhhdmlvciwgYW5kIG5vdyBoYXZlIHRvIHVwZGF0
ZSB0aGVpcg0KPiBEVEJzLA0KPiB3aGljaCB2aW9sYXRlcyBEVEIgYmFja3dhcmRzLWNvbXBhdGli
aWxpdHkgcnVsZXMuDQo+IEkga25vdyBpdCdzIHVnbHksIGJ1dCBJJ20gYWZyYWlkIHRoZSBvbmx5
IGJhY2t3YXJkcy1jb21wYXRpYmxlDQo+IHNvbHV0aW9uDQo+IGlzIHRvIGFkZCBhIG5ldyBEVCBw
cm9wZXJ0eSB0byBpbmRpY2F0ZSBpZiB0aGUgbmV3IHJ1bGVzIGFwcGx5Lg0KPiANCj4gPiA+ID4g
V2UgY2hvc2UgdGhlIHdhcm5pbmcgdG8gb2NjdXIgb24gcGh5LW1vZGVzICdyZ21paS1pZCcsICdy
Z21paS0NCj4gPiA+ID4gcnhpZCcgYW5kDQo+ID4gPiA+ICdyZ21paS10eGlkJyBhcyBvbiB0aG9z
ZSwgd2l0aCB0aGUgJ3J4Yy1za2V3LXBzJyB2YWx1ZSBwcmVzZW50LA0KPiA+ID4gPiBvdmVyd3Jp
dGluZyBza2V3IHZhbHVlcyBjb3VsZCBvY2N1ciBhbmQgeW91IGVuZCB1cCB3aXRoIHZhbHVlcw0K
PiA+ID4gPiB5b3UgZG8NCj4gPiA+ID4gbm90IHdhbnRlZC4gV2UgdGhvdWdodCwgdGhhdCBtb3N0
IG9mIHRoZSBib2FyZHMgaGF2ZSBqdXN0DQo+ID4gPiA+ICdyZ21paScgc2V0IGluDQo+ID4gPiA+
IHBoeS1tb2RlIHdpdGggc3BlY2lmaWMgc2tldy12YWx1ZXMgcHJlc2VudC4NCj4gPiA+ID4gDQo+
ID4gPiA+IEBHZWVydCBpZiB5b3UgYWN0dWFsbHkgd2FudCB0aGUgUEhZIHRvIGFwcGx5IFJYQyBh
bmQgVFhDIGRlbGF5cw0KPiA+ID4gPiBqdXN0DQo+ID4gPiA+IGluc2VydCAncmdtaWktaWQnIGlu
IHlvdXIgRFQgYW5kIHJlbW92ZSB0aG9zZSAqLXNrZXctcHMgdmFsdWVzLg0KPiA+ID4gPiBJZiB5
b3UNCj4gPiA+IA0KPiA+ID4gVGhhdCBzZWVtcyB0byB3b3JrIGZvciBtZSwgYnV0IG9mIGNvdXJz
ZSBkb2Vzbid0IHRha2UgaW50byBhY2NvdW50DQo+ID4gPiBQQ0INCj4gPiA+IHJvdXRpbmcuDQo+
IA0KPiBPZiBjb3Vyc2UgSSB0YWxrZWQgdG9vIHNvb24uICBCb3RoIHdpdGggdGhlIGV4aXN0aW5n
IERUUyB0aGF0IHRyaWdnZXJzDQo+IHRoZSB3YXJuaW5nLCBhbmQgYWZ0ZXIgY2hhbmdpbmcgdGhl
IG1vZGUgdG8gInJnbWlpLWlkIiwgYW5kIGRyb3BwaW5nDQo+IHRoZQ0KPiAqLXNrZXctcHMgdmFs
dWVzLCBFdGhlcm5ldCBiZWNhbWUgZmxha3kgb24gUi1DYXIgTTMtVyBFUzEuMC4gIFdoaWxlDQo+
IHRoZQ0KPiBzeXN0ZW0gc3RpbGwgYm9vdHMsIGl0IGJvb3RzIHZlcnkgc2xvdy4NCj4gVXNpbmcg
bnV0dGNwLCBJIGRpc2NvdmVyZWQgVFggcGVyZm9ybWFuY2UgZHJvcHBlZCBmcm9tIGNhLiA0MDAg
TWJwcyB0bw0KPiAwLjEtMC4zIE1icHMsIHdoaWxlIFJYIHBlcmZvcm1hbmNlIGxvb2tzIHVuYWZm
ZWN0ZWQuDQo+IA0KPiBTbyBJIGRpZCBzb21lIG1vcmUgdGVzdGluZzoNCj4gICAxLiBQbGFpbiAi
cmdtaWktdHhpZCIgYW5kICJyZ21paSIgYnJlYWsgdGhlIG5ldHdvcmsgY29tcGxldGVseSwgb24N
Cj4gYWxsDQo+ICAgICAgUi1DYXIgR2VuMyBwbGF0Zm9ybXMsDQo+ICAgMi4gInJnbWlpLWlkIiBh
bmQgInJnbWlpLXJ4aWQiIHdvcmssIGJ1dCBjYXVzZSBzbG93bmVzcyBvbiBSLUNhciBNMy0NCj4g
VywNCj4gICAzLiAicmdtaWkiIHdpdGggKi1za2V3LXBzIHZhbHVlcyB0aGF0IG1hdGNoIHRoZSBv
bGQgdmFsdWVzIChkZWZhdWx0DQo+ICAgICAgNDIwIGZvciBldmVyeXRoaW5nLCBidXQgZGVmYXVs
dCA5MDAgZm9yIHR4Yy1za2V3LXBzLCBhbmQgdGhlIDE1MDANCj4gICAgICBvdmVycmlkZSBmb3Ig
cnhjLXNrZXctcHMpLCBiZWhhdmVzIGV4YWN0bHkgdGhlIHNhbWUgYXMgInJnbWlpLQ0KPiBpZCIs
DQo+ICAgNC4gInJnbWlpLXR4aWQiIHdpdGggKi1za2V3LXBzIHZhbHVlcyB0aGF0IG1hdGNoIHRo
ZSBvbGQgdmFsdWVzIGRvZXMNCj4gd29yaywgaS5lLg0KPiAgICAgIGFkZGluZyB0byBhcmNoL2Fy
bTY0L2Jvb3QvZHRzL3JlbmVzYXMvc2FsdmF0b3ItY29tbW9uLmR0c2k6DQo+ICAgICAgKyAgICAg
ICAgICAgICAgIHJ4ZDAtc2tldy1wcyA9IDw0MjA+Ow0KPiAgICAgICsgICAgICAgICAgICAgICBy
eGQxLXNrZXctcHMgPSA8NDIwPjsNCj4gICAgICArICAgICAgICAgICAgICAgcnhkMi1za2V3LXBz
ID0gPDQyMD47DQo+ICAgICAgKyAgICAgICAgICAgICAgIHJ4ZDMtc2tldy1wcyA9IDw0MjA+Ow0K
PiAgICAgICsgICAgICAgICAgICAgICByeGR2LXNrZXctcHMgPSA8NDIwPjsNCj4gICAgICArICAg
ICAgICAgICAgICAgdHhjLXNrZXctcHMgPSA8OTAwPjsNCj4gICAgICArICAgICAgICAgICAgICAg
dHhkMC1za2V3LXBzID0gPDQyMD47DQo+ICAgICAgKyAgICAgICAgICAgICAgIHR4ZDEtc2tldy1w
cyA9IDw0MjA+Ow0KPiAgICAgICsgICAgICAgICAgICAgICB0eGQyLXNrZXctcHMgPSA8NDIwPjsN
Cj4gICAgICArICAgICAgICAgICAgICAgdHhkMy1za2V3LXBzID0gPDQyMD47DQo+ICAgICAgKyAg
ICAgICAgICAgICAgIHR4ZW4tc2tldy1wcyA9IDw0MjA+Ow0KPiANCj4gWW91IG1heSB3b25kZXIg
d2hhdCdzIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gMyBhbmQgND8gSXQncyBub3QganVzdA0KPiB0
aGUNCj4gUEhZIGRyaXZlciB0aGF0IGxvb2tzIGF0IHBoeS1tb2RlIQ0KPiBkcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jOnJhdmJfc2V0X2RlbGF5X21vZGUoKSBhbHNvDQo+
IGRvZXMsIGFuZCBjb25maWd1cmVzIGFuIGFkZGl0aW9uYWwgVFggY2xvY2sgZGVsYXkgb2YgMS44
IG5zIGlmIFRYSUQgaXMNCj4gZW5hYmxlZC4gIERvaW5nIHNvIGZpeGVzIFItQ2FyIE0zLVcsIGJ1
dCBkb2Vzbid0IHNlZW0gdG8gYmUgbmVlZGVkLA0KPiBvciBoYXJtLCBvbiBSLUNhciBIMyBFUzIu
MCBhbmQgUi1DYXIgTTMtTi4NCg0KSGkgR2VlcnQsDQoNClNvcnJ5IGZvciBjaGltaW5nIGluIG9u
IHRoaXMgdG9waWMgYnV0IEkgYWxzbyBkaWQgbWFrZSBteSB0aG91Z2h0cyBhYm91dA0KdGhpcyBp
bXBsZW1lbnRhdGlvbi4NCg0KVGhlIGRvY3VtZW50YXRpb24gaW4gRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9ldGhlcm5ldC0NCmNvbnRyb2xsZXIueWFtbCBjbGVhcmx5IHN0
YXRlcywgdGhhdCByZ21paS1pZCBpcyBtZWFuaW5nIHRoZSBkZWxheSBpcw0KcHJvdmlkZWQgYnkg
dGhlIFBIWSBhbmQgTUFDIHNob3VsZCBub3QgYWRkIGFueXRoaW5nIGluIHRoaXMgY2FzZS4NCg0K
QmVzdCBSZWdhcmRzLA0KUGhpbGlwcGUNCg0KPiANCj4gPiA+IFVzaW5nICJyZ21paSIgd2l0aG91
dCBhbnkgc2tldyB2YWx1ZXMgbWFrZXMgREhDUCBmYWlsIG9uIFItQ2FyIEgzDQo+ID4gPiBFUzIu
MCwNCj4gPiA+IE0zLVcgKEVTMS4wKSwgYW5kIE0zLU4gKEVTMS4wKS4gSW50ZXJlc3RpbmdseSwg
REhDUCBzdGlsbCB3b3JrcyBvbg0KPiA+ID4gUi1DYXINCj4gPiA+IEgzIEVTMS4wLg0KPiANCj4g
RlRSLCB0aGUgcmVhc29uIFItQ2FyIEgzIEVTMS4wIGlzIG5vdCBhZmZlY3RlZCBpcyB0aGF0IHRo
ZSBkcml2ZXINCj4gbGltaXRzDQo+IGl0cyBtYXhpbXVtIHNwZWVkIHRvIDEwMCBNYnBzLCBkdWUg
dG8gYSBoYXJkd2FyZSBlcnJhdHVtLg0KPiANCj4gU28sIGhvdyB0byBwcm9jZWVkPw0KPiBUaGFu
a3MhDQo+IA0KPiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgIEdlZXJ0DQo+IA0K
