Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F88722813B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgGUNo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:44:27 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:41796 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGUNoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:44:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595339065; x=1626875065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=seeV6K6/kqbwm2ivshr+i1jXCjzdI2CHZ24hxWYQzb8=;
  b=gLOojyApYgFWAb+c3uxfVk9lN9mzN+ohtB8PIAPhUYf/zUJ4R+PkFbWO
   /l7gHyVqjmxAEtYOuAT6Hrxc84un62tNO9DFViy6kFA1T2d82/MmVBBVT
   SAEnUmRpj7G4/VuQHTTmvsBmgme0YsYJtGWr1ac68i5lot6RAeytGhxKK
   doYlbFWRoBTzPdeT5nlzftx55KcadC7ANi/W5U2ZpGa+4dnkvYVWL0V/K
   gy8kykC3qx8V+0TGXz+IGW3M8lkLBdEn42HTNRlrCZ65BdGTFXHfCAWB7
   m94cOlvxh6JrpzmOuUCuxSJQwDN8Syofg79jMYLt1boIJPmZFpD+otX8V
   g==;
IronPort-SDR: NfpgHurgAZSQegy3zOu9zHhhtpMN7cq0Ranu7nYo7wk1kMrcG7lmHsIKQvEV3ipo/JhIm0SLBk
 DH5nPsLZsGGXikMQweFjbXAKrW7PiuPmzj0mwD3ia4h+avmged36rW8FKQ+z6tzADxM1leqMyu
 mIz19cMmUCrxAC/nmu88SSvi2533Hg+auRH0/BO/XQ+qJjfBhqPOJy/h2Ye7vgJfppg/zcwhcS
 rCiGfg5xlQdIDqZhcQiscd3s2ILyIk3FO5nM5DPdtnETMNGjdoZveL3+DM+sM3b5UPBOLx++KN
 2bo=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84771993"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 06:44:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 06:43:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 21 Jul 2020 06:43:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQAsdd1TxeqQKXxXVra6Z6ef9qO3t6EZEW92bwAiV+E83PcYpaYcL38v163D7jmsxFnOtqa2va97fZGIiYORRnqpLEWr24x5qAGsIiLVeExZcKFqblH75QrUUAlWqgkiGaFdgvi5805jf2b33HGjbChSfLuJE1fUTAWPi/Pv26Ajmt5W5PxqpbxHYe/K6W0tDH+6fc4u8FkQsN9Ej3zgWD8BX1eK3tPffIGCmD1dA/ngk8G7Zr757wmVC7kaJUSoKdbQsr1SMFDTeYxNpMQe0TtZK6ZQl4eHLgfMPOhZidVSJFuxp+s572NbhByywUH8OLLHVmHzkZHGjxk4/SY1lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seeV6K6/kqbwm2ivshr+i1jXCjzdI2CHZ24hxWYQzb8=;
 b=FxHPPJ/BAx4eI8ptSX8yCvtyqi/u2iQXOvK4nN12sCTriVYZX0K8dnL/i6QGMR2dKg2eDYZPIeeyPfwS9qv5JKiH8Bl9Ks8tr3v4E/aQ5fRLS+prPqsTy3oR7DpyOpIYd8DCtonJq9LVk02O0nrxANQLeUeiepI8YHO/vhXT47L4MTVMTFgEACvGIG8P6CWe620gl94bVB2LrFiujtncvTT078BRwB63eRNm+67FlONWCwJL6ku9jidMh3WGjJLlKoqUYfzVXj80I0VD6/04YPhDBx4jC3GroPR7uvoLorWz5LwUkhuAhhtf3ELxgSLarOFAHCX5E5WyrK68tDz3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seeV6K6/kqbwm2ivshr+i1jXCjzdI2CHZ24hxWYQzb8=;
 b=u3hwDm6RuAm1EWHnJZe2S8nnCqxLiZDeJYi73rKewNGBBL8nZTX6Ib9c1aaq8K0504SJRE0RHAzYG4sbdwCDFK8eZfL9FSBNGotoNTg6iEcua+bzzg2gKgZtKB6E+V2TCgR3jdrieGzJtG81iKG2Bm90UvaAvAt1AjqJgKBGk60=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 13:44:23 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 13:44:23 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <alexandre.belloni@bootlin.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <robh+dt@kernel.org>, <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next 2/7] macb: bindings doc: use an MDIO node as a
 container for PHY nodes
Thread-Topic: [PATCH net-next 2/7] macb: bindings doc: use an MDIO node as a
 container for PHY nodes
Thread-Index: AQHWX0ZmBteUr2oDpEy77eQSYGBKPKkSB2cAgAAEHgA=
Date:   Tue, 21 Jul 2020 13:44:23 +0000
Message-ID: <c59b54d9-f2b1-97a5-9350-baeb6eabcea9@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
 <20200721100234.1302910-3-codrin.ciubotariu@microchip.com>
 <20200721132936.GQ3428@piout.net>
In-Reply-To: <20200721132936.GQ3428@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ca4e545-9e93-49d2-495d-08d82d7c2d68
x-ms-traffictypediagnostic: SN6PR11MB3504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3504E9FAA8FBAC94F3EA88B8E7780@SN6PR11MB3504.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T7fMPFiimPFW9OXVWsafYRCHN068nUIFiAf6uNY4h6BIfA5xkiromRwcSz751XYi2XCrAi/Z661FJwjUodwv4yH+ZqCTLprnh5DxZU/4VAoQVTytyuZu6rLFnYEvh8ux2Yjx8msRwBQSVy2KswGKPX2Zd3wu20ZzOlXRlBRutKkdzA2RgH0UjISFHRUQCQrIzBojJXgQymjlvMoWWK46Gp2YzfQBYjGZTSqqa0lQjJRg8Us3ZaLwHMouFKQwBj1SI/prPQXhHIlK4w/9vTIgYjKtx3rjVlkRnSzv2enJGflxvYSKeJ+EwAHIlNFDWS2/7Iz3w9ZJkuAgp/yd1WYE331wWBVZq+Gj7DTVUa28BgEdggRg02XDLbTDprsaZFY8OTIH5bqBucc0oH9BRr1QeojrCJPxuIPiZyEVE833gcUiIc+SEufvMTgBIwyAdERMTXQq4yNl3+9FGa6N6L5KxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(4326008)(6512007)(86362001)(54906003)(2906002)(498600001)(186003)(7416002)(8676002)(6916009)(76116006)(64756008)(91956017)(66556008)(66476007)(66946007)(8936002)(66446008)(966005)(71200400001)(6506007)(107886003)(83380400001)(26005)(6486002)(36756003)(5660300002)(31686004)(31696002)(2616005)(53546011)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RV+B+Sgy+e//fTslynbHN6fWyJE4L3G6LEvS1MI3Dxkrx9BV0tDFCehKI8FbCL02Tfbw7wdtpEwvlxqO/a4qS5AwFi25mxMrOo3/T5w6j/daoHmMbIhTUPlQVOpDuiWtRm5Ma18dckWCgt7TlFOIH0S7CLFDa36ye7oWYlbPMmHPg8/eX35goxCSVLnTMkaWfCUhS09/pH7c/irogU5ocVpMy60EMwQz8kHU9gLZU8N32Y/+72SIZ+aP7WBULt2+teJxuiWy30H3JV/i4WUxDBZZ2ap0GpO4HRX58G5LCmZE+o4in7guHIiJsvfyw4hbL8enxjyh7okis67HGBy8Mr8OxFCr1MBo+jEhNXbLhe6WGCb9njsBSMlBzbDgaNugibHPl1hy1M6N3v+kgbF2aruqo65dwMoea2JYuLUPZ//m6g1iSQYuw2ZKKc1xojF0Ckw0iQdaI+GALxhCS74IQ1Z6K4LcR/R7eUuVdnwfJQvPRhFUKTIdQwPVKPY0zB9m
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF9E7A9A54DA0B4F95F088AE8F05DDDA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca4e545-9e93-49d2-495d-08d82d7c2d68
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 13:44:23.1840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L21y4cisuFX63MXKyQhr0omX+LAXSE9f47HwrShXQfNQEgfNFZ/Zgeyrn6D69MhHMZ2PqiJJFcNfZqdzTDIFiV55S6lZXpdJisQfXhFl6tY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEuMDcuMjAyMCAxNjoyOSwgQWxleGFuZHJlIEJlbGxvbmkgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGksDQo+IA0KPiBUaGUgcHJvcGVyIHN1
YmplY3QgcHJlZml4IGlzIGR0LWJpbmRpbmdzOiBuZXQ6IG1hY2I6DQoNCldpbGwgZml4IGluIHYy
LiBUaGFua3MhDQoNCj4gDQo+IE9uIDIxLzA3LzIwMjAgMTM6MDI6MjkrMDMwMCwgQ29kcmluIENp
dWJvdGFyaXUgd3JvdGU6DQo+PiBUaGUgTUFDQiBkcml2ZXIgZW1iZWRzIGFuIE1ESU8gYnVzIGNv
bnRyb2xsZXIgYW5kIGZvciB0aGlzIHJlYXNvbiB0aGVyZQ0KPj4gd2FzIG5vIG5lZWQgZm9yIGFu
IE1ESU8gc3ViLW5vZGUgcHJlc2VudCB0byBjb250YWluIHRoZSBQSFkgbm9kZXMuIEFkZGluZw0K
Pj4gTURJTyBkZXZpZXMgZGlyZWN0bHkgdW5kZXIgYW4gRXRoZXJuZXQgbm9kZSBpcyBkZXByZWNh
dGVkLCBzbyBhbiBNRElPIG5vZGUNCj4+IGlzIGluY2x1ZGVkIHRvIGNvbnRhaW4gb2YgdGhlIFBI
WSBub2RlcyAoYW5kIG90aGVyIE1ESU8gZGV2aWNlcycgbm9kZXMpLg0KPj4NCj4+IFNpZ25lZC1v
ZmYtYnk6IENvZHJpbiBDaXVib3Rhcml1IDxjb2RyaW4uY2l1Ym90YXJpdUBtaWNyb2NoaXAuY29t
Pg0KPj4gLS0tDQo+PiAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFj
Yi50eHQgfCAxNSArKysrKysrKysrKystLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFjYi50eHQgYi9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L21hY2IudHh0DQo+PiBpbmRleCAwYjYxYTkwZjE1OTIuLjg4ZDUx
OTljMjI3OSAxMDA2NDQNCj4+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvbWFjYi50eHQNCj4+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvbWFjYi50eHQNCj4+IEBAIC0zMiw2ICszMiwxMSBAQCBSZXF1aXJlZCBwcm9wZXJ0aWVz
Og0KPj4gICBUaGUgTUFDIGFkZHJlc3Mgd2lsbCBiZSBkZXRlcm1pbmVkIHVzaW5nIHRoZSBvcHRp
b25hbCBwcm9wZXJ0aWVzDQo+PiAgIGRlZmluZWQgaW4gZXRoZXJuZXQudHh0Lg0KPj4NCj4+ICtP
cHRpb25hbCBzdWJub2RlczoNCj4+ICstIG1kaW8gOiBzcGVjaWZpZXMgdGhlIE1ESU8gYnVzIGlu
IHRoZSBNQUNCLCB1c2VkIGFzIGEgY29udGFpbmVyIGZvciBQSFkgbm9kZXMgb3Igb3RoZXINCj4+
ICsgIG5vZGVzIG9mIGRldmljZXMgcHJlc2VudCBvbiB0aGUgTURJTyBidXMuIFBsZWFzZSBzZWUg
ZXRoZXJuZXQtcGh5LnlhbWwgaW4gdGhlIHNhbWUNCj4+ICsgIGRpcmVjdG9yeSBmb3IgbW9yZSBk
ZXRhaWxzLg0KPj4gKw0KPj4gICBPcHRpb25hbCBwcm9wZXJ0aWVzIGZvciBQSFkgY2hpbGQgbm9k
ZToNCj4+ICAgLSByZXNldC1ncGlvcyA6IFNob3VsZCBzcGVjaWZ5IHRoZSBncGlvIGZvciBwaHkg
cmVzZXQNCj4+ICAgLSBtYWdpYy1wYWNrZXQgOiBJZiBwcmVzZW50LCBpbmRpY2F0ZXMgdGhhdCB0
aGUgaGFyZHdhcmUgc3VwcG9ydHMgd2FraW5nDQo+PiBAQCAtNDgsOCArNTMsMTIgQEAgRXhhbXBs
ZXM6DQo+PiAgICAgICAgICAgICAgICBsb2NhbC1tYWMtYWRkcmVzcyA9IFszYSAwZSAwMyAwNCAw
NSAwNl07DQo+PiAgICAgICAgICAgICAgICBjbG9jay1uYW1lcyA9ICJwY2xrIiwgImhjbGsiLCAi
dHhfY2xrIjsNCj4+ICAgICAgICAgICAgICAgIGNsb2NrcyA9IDwmY2xrYyAzMD4sIDwmY2xrYyAz
MD4sIDwmY2xrYyAxMz47DQo+PiAtICAgICAgICAgICAgIGV0aGVybmV0LXBoeUAxIHsNCj4+IC0g
ICAgICAgICAgICAgICAgICAgICByZWcgPSA8MHgxPjsNCj4+IC0gICAgICAgICAgICAgICAgICAg
ICByZXNldC1ncGlvcyA9IDwmcGlvRSA2IDE+Ow0KPj4gKyAgICAgICAgICAgICBtZGlvIHsNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4+ICsgICAgICAg
ICAgICAgICAgICAgICAjc2l6ZS1jZWxscyA9IDwwPjsNCj4+ICsgICAgICAgICAgICAgICAgICAg
ICBldGhlcm5ldC1waHlAMSB7DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZWcg
PSA8MHgxPjsNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJlc2V0LWdwaW9zID0g
PCZwaW9FIDYgMT47DQo+PiArICAgICAgICAgICAgICAgICAgICAgfTsNCj4+ICAgICAgICAgICAg
ICAgIH07DQo+PiAgICAgICAgfTsNCj4+IC0tDQo+PiAyLjI1LjENCj4+DQo+IA0KPiAtLQ0KPiBB
bGV4YW5kcmUgQmVsbG9uaSwgQm9vdGxpbg0KPiBFbWJlZGRlZCBMaW51eCBhbmQgS2VybmVsIGVu
Z2luZWVyaW5nDQo+IGh0dHBzOi8vYm9vdGxpbi5jb20NCj4gDQoNCg==
