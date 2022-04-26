Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D6C50FD0F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346978AbiDZMfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346613AbiDZMfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:35:32 -0400
X-Greylist: delayed 77161 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 05:32:21 PDT
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 400ABBB089
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:32:20 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2113.outbound.protection.outlook.com [104.47.22.113]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-26-5-Hhi9j7PnCokkgu-KEZuw-1; Tue, 26 Apr 2022 14:32:17 +0200
X-MC-Unique: 5-Hhi9j7PnCokkgu-KEZuw-1
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3b::9) by
 GV0P278MB0113.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:1e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.13; Tue, 26 Apr 2022 12:32:16 +0000
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::dd15:e6d7:a4d0:7207]) by ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::dd15:e6d7:a4d0:7207%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 12:32:16 +0000
From:   Marcel Ziswiler <marcel.ziswiler@toradex.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: net: stmmac: dwmac-imx: half duplex crash
Thread-Topic: net: stmmac: dwmac-imx: half duplex crash
Thread-Index: AQHYV2WZ5uT4Cdlm/Umu1AAuySf2Oqz/ns2AgAEebICAAA7vAIABWF6A
Date:   Tue, 26 Apr 2022 12:32:16 +0000
Message-ID: <8f8cdcf584c13faf8bcdc2abfdb62b09950ea652.camel@toradex.com>
References: <36ba455aad3e57c0c1f75cce4ee0f3da69e139a1.camel@toradex.com>
         <YmXIo6q8vVkL6zLp@lunn.ch>
         <5e51e11bbbf6ecd0ee23b4fd2edec98e6e7fbaa8.camel@toradex.com>
         <YmbFblFCrGFND+h/@lunn.ch>
In-Reply-To: <YmbFblFCrGFND+h/@lunn.ch>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfe1b8c5-efde-4c2d-4de0-08da2780cc77
x-ms-traffictypediagnostic: GV0P278MB0113:EE_
x-microsoft-antispam-prvs: <GV0P278MB011367FE130F4B15D103AA28FBFB9@GV0P278MB0113.CHEP278.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ibHIFjeOe2lOMyXpKrtRA9c/J880AJ1cqkQBjj3hEIeIwswb436Rc62Xt+2dNvfk0f2CkyVYRbZupjHCtCLcERht1EW3/EzaJsk190c0jwLKpRWWOMu23Sw7/1zpUWcbytCFYeqnx4Myvsq7yQfczZ1utMJOgDRFuQ2lzfaQ6D7ikpmlz4FNkg1tkb0RjTekvl/tGgZOAKyaW2dSPpmzb5Kit4cJWt6paseX8aCvqB++0/aZtXylPhdwfM3g1RqMuLHPwgft/EAHGCVSQmkW/J0fi+iNGyYiVmcvpnNo6XAgJf/XbmWWjmWILQjBAPvgImVOafXHpCDZv+68Wj6bcIK92kcOLWQ3RSvsevge3W/30KJAMAJ6pkj6WzrZfXR+pZk+PAkxSZpwizF59bRK8tf8MyyAP32ei44Y+6+wkTNBP3izwEe5z7XA10e/BHkKyWqodUZSlleZZB5uC6AMgiBoERg/v7a7QZXRh0E8YjKPoZ2vrzrL80qZgArIjWrR0oIH5DWw+yY4DFEX5jLjJRyRQiaZM8zdUUCuO4WA7euhSnyBgOLUnOpjBwhkKUGXx9scsLCO41njM3S6Z4iml6Lqjx30hPEE/nb70BwMkV63AETfHyza2WUX9V/l/SDsQK6emsOcJrlY6z0lkXBVVeyyF8fPRXF7++G7wM4Jk715/8UjxTLJCzDBs7345FB8e/j+cs6IMbA5R4XiCiZYbAR7TKF72r8uM1X+jnVcUS3lA0ttnN3eXynXb/9w00lqHIa9J/ddl+cNDw2JrabecICrqPcWDyC6J4ItdlerfIE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(39830400003)(366004)(376002)(396003)(346002)(66476007)(86362001)(76116006)(64756008)(66446008)(66556008)(71200400001)(5660300002)(66946007)(4326008)(186003)(83380400001)(38070700005)(38100700002)(8936002)(7416002)(316002)(36756003)(6486002)(966005)(2616005)(2906002)(508600001)(26005)(8676002)(54906003)(44832011)(6916009)(6512007)(122000001)(6506007);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3YzNGltWWJXSHRpanMwWTh0NWc0THhqME9YVGZDUlY1em1JSkREU3JLUTFt?=
 =?utf-8?B?RWtFU3labjIwRlZiVFY1VSt1S2I2bzFRck5IaEx4d08wOGJFWUxHU1J2OXJD?=
 =?utf-8?B?YjJQSVRySGZpenB4Tkd5TXlrcFRoSjBpb1czNlJPUWpNaU9Da3JGMG53bWQw?=
 =?utf-8?B?K0ZBTDdnZGE0Tmk0U01hb3BuWWsvejR5cHViV3p6a2VMMVBlZkQ4ekd4NTMr?=
 =?utf-8?B?TGo2OEw4U05JNnRJN25uNkkxU2w5ZENTc0ZQNERxeXYvMWZZMFpCcGg3VkU5?=
 =?utf-8?B?SEVDeWlteFVBWndKZmZjdDFvT3BYZCtKcTAwTXhNN0FnYTB6c2JtcE1NK0ta?=
 =?utf-8?B?bUtVd1RkNFdQZS9wamhVd08yYlViM0tNeWg5L0Z4S2lvcnFBQUpSRjU1b2k2?=
 =?utf-8?B?QjZydzNmelJSRUZqNkh4aXdUdDlwRXdMNjBzUVY4Y1pBWWwzK0VFK3I4eUtx?=
 =?utf-8?B?Rk9KSWxRY0NDQ01QRXM2aVBHOWU4eXlPVVlMSHI2UnhrODVMbmEwR3oyYU5L?=
 =?utf-8?B?aElhWVBiZzlCNy9Sc0xSdXllUVlHU3RXRS9jMlhDdFFYUHhxNHd3WDZVbUFJ?=
 =?utf-8?B?WFVDMUVROFgxMkZGTldKMFBKbEZYQmt4RHdiZGI4aVB0Q0UyMEx6QWduR2RW?=
 =?utf-8?B?a2V0RVdwYm5vVm5MaDRTRDZuNlhIZ3VuTDdrNDg4Q2lrMmQxVzNSb0JHdk9K?=
 =?utf-8?B?d2lCeEVrSzJKM2pqVGZOWXpEZUdwR0dBV09xVll3V3k5OEFMMUh3L0l0VDZT?=
 =?utf-8?B?YStTaUZlNmJoVDd3c1pDYWJRd3Q2UVZxWW1vZ2x5UTMwbTJZa21iSkliRm00?=
 =?utf-8?B?a1JhYXZua2NlNnFkZVlNRkV0R0VkQUFHS0VGaHNyOFVxdlBSajY0ODV1V1J5?=
 =?utf-8?B?UkkzaUV6UW1adDZwcitoQjRiU05reXF2bFBEdmN6ZUQxRnlwZG5OYTZTdXJG?=
 =?utf-8?B?WWZaSUdTZjVsRTlxNHgwWWZNUzU5VWFNKzFocGdNOWZHcFhNRUo1ZEl2Y0N0?=
 =?utf-8?B?SWMvWmNnMHJ5UDR3V2E1NExSLy9LSVlpNUVTdTZZZUlDRmQ1WC9qQlQ5Y081?=
 =?utf-8?B?SEEvRXc4RHZHdWxIZE9QOXNOSWsySi9aWEdsS1hlejMzeW0ySTJGQ28wamxs?=
 =?utf-8?B?YnIzQVFaRHpKUFBLUStaQ3ZncHloUVFrVHJNZmEzVi96WHh6ektzU3ZJYmZh?=
 =?utf-8?B?ZWs3NGJtSmtUcHdaN3FhcytkZTBaTXdrczdKRU85V1VEWHc1NnlhRGxRVEhp?=
 =?utf-8?B?UDNFdlFEWmNMRUZRdUgzNTQ2SHpvd0JPZFBLbFpXUDZzTTJIRGRCbnhySk13?=
 =?utf-8?B?elVlOEwvUEtYeG5naWc5UWF2OEhwSDhCajFvOGxyQ0xpNDhRbi9RV1BKRktp?=
 =?utf-8?B?Tk1EWWN4ZHpBZmMydm9nbzJvQ2VMNG8yVzdtbHFCUGFsZkRCbGxVWlBTRDly?=
 =?utf-8?B?UGVqRURxS0FpNTBwdnVMR0VzNGYyM3hxN1lxdEYxNEE0aVY5T0ducFR4Zko4?=
 =?utf-8?B?dHVOaGJ1QlhwUEYrS1RWT2pPYXZydWl0eHlGUXZaeXN3eWdDN25rZ3p1OHFN?=
 =?utf-8?B?dVJUOEk4SUZNWjRaUEVFVEhvVTVTZ2JacjZjVGowcC8wdm5TY2FSKzJkWHBv?=
 =?utf-8?B?RTM2akRyM0ZQTERsRUpPU1lna2trSnNqRWI0L0Y5bjNieTROM1ZzUVpvNEN1?=
 =?utf-8?B?R3dUbEFzTU9nYVlXOWpoc1dwQWlQQjd0Z2hGa0dkNXY1dWcydTdIRlFXbHBL?=
 =?utf-8?B?L09LMkJUYUJ3dHBrbjQ4Y0l5b0M0VjRWQjFHS0crTVlrbmpHSHMyUnQ4YlBv?=
 =?utf-8?B?Wk01M05HdEdwUUc0SXc3VGpmN0lTalM4OWJNVG9DRWQyZ1dWRTZYOWhMTXVX?=
 =?utf-8?B?UXA3bXR3YlhIdjJCQWNzNStEVXdvNHoxVkpOQ1J5NVZFckg0NWIxUTFCbm1q?=
 =?utf-8?B?alJXcDNHVlIzcDdjTitVSzEreDIzTTJqSmQ0RmJJdDQvbXhKU2tyU2R6YXRQ?=
 =?utf-8?B?cTFNSmpPMk1sTGRlaVRLS3hkTEQrdHkxYTVyNFZnZVY3N0ZOWXl5WVRLYmtW?=
 =?utf-8?B?cnVNazVZRkJaVUlNc1pySnQxaWxwTnNiUUQvMzN6bVV0TGlRQmlMcEk3RTU5?=
 =?utf-8?B?Lzg2SFVzYVg3akRKOWt0OWdjWGZPYXBEbHZPdCtrTmViR2dZeDlYNHduMDVW?=
 =?utf-8?B?Z1VzMHIzS2JQR3h0K1Q2R3RmdzZ2NkI2Qitkb3BRTk4xUy9HUGxDcG9MSnNF?=
 =?utf-8?B?eVN6N3BTbW91N0FuemhwODM3bkNWWnZ1WUxYVGQzcWtmWU9nSHRpc3VaVEV6?=
 =?utf-8?B?TjRiTEJHTFpYazh3U3FyNFY5SFR4NGxBZGViQ1VoNFJTYVhRU3VnMVdIdGhQ?=
 =?utf-8?Q?MdOiMseIs/pjgDQVXWuhvSM9wR/HN7lOI754O?=
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe1b8c5-efde-4c2d-4de0-08da2780cc77
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 12:32:16.5858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 58irGXk4FVRiobgsAQetlompNYDzFS2KBg4o1cDaYPsG5sMiOEm5EUpYUV/Cokp6kl/m09KVjdLT8MPROvY2OFhMaxgHBJFAYVMDe3tK0FQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0113
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=marcel.ziswiler@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <FBADD40D113CDF47A7DE0C7AD8A7C7EA@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA0LTI1IGF0IDE3OjU5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiBHb29kIHBvaW50LiBJIHdhcyBibGluZGVkIGJ5IE5YUCBkb3duc3RyZWFtIHdoaWNoLCB3aGls
ZSBsaXN0aW5nIGFsbCBpbmNsLiAxMGJhc2VUL0hhbGYgYW5kIDEwMGJhc2VUL0hhbGYNCj4gPiBh
cw0KPiA+IHN1cHBvcnRlZCBsaW5rIG1vZGVzLCBhbHNvIGRvZXMgbm90IHdvcmsuIEhvd2V2ZXIs
IHVwc3RyZWFtIGluZGVlZCBzaG93cyBvbmx5IGZ1bGwtZHVwbGV4IG1vZGVzIGFzDQo+ID4gc3Vw
cG9ydGVkOg0KPiA+IA0KPiA+IHJvb3RAdmVyZGluLWlteDhtcC0wNzEwNjkxNjp+IyBldGh0b29s
IGV0aDENCj4gPiBTZXR0aW5ncyBmb3IgZXRoMToNCj4gPiDCoMKgwqDCoMKgwqDCoCBTdXBwb3J0
ZWQgcG9ydHM6IFsgVFAgTUlJIF0NCj4gPiDCoMKgwqDCoMKgwqDCoCBTdXBwb3J0ZWQgbGluayBt
b2RlczrCoMKgIDEwYmFzZVQvRnVsbCANCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxMDBiYXNlVC9GdWxsIA0KPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIDEwMDBiYXNlVC9GdWxsIA0KPiANCj4gU28gbWF5YmUgd2UgYWN0dWFsbHkgd2FudCBldGh0
b29sIHRvIHJlcG9ydCAtRUlOVkFMIHdoZW4gYXNrZWQgdG8gZG8NCj4gc29tZXRoaW5nIHdoaWNo
IGlzIG5vdCBzdXBwb3J0ZWQhIEh1bW06DQo+IA0KPiBodHRwczovL2VsaXhpci5ib290bGluLmNv
bS9saW51eC9sYXRlc3Qvc291cmNlL2RyaXZlcnMvbmV0L3BoeS9waHkuYyNMNzgzDQo+IA0KPiAN
Cj4gwqDCoMKgwqDCoMKgwqDCoC8qIFdlIG1ha2Ugc3VyZSB0aGF0IHdlIGRvbid0IHBhc3MgdW5z
dXBwb3J0ZWQgdmFsdWVzIGluIHRvIHRoZSBQSFkgKi8NCj4gwqDCoMKgwqDCoMKgwqDCoGxpbmtt
b2RlX2FuZChhZHZlcnRpc2luZywgYWR2ZXJ0aXNpbmcsIHBoeWRldi0+c3VwcG9ydGVkKTsNCj4g
DQo+IFNvIG1heWJlIHRoZSB1bnN1cHBvcnRlZCBtb2RlIGdvdCByZW1vdmVkLCBhbmQgdGhlIFBI
WSB3YXMgYXNrZWQgdG8NCj4gYWR2ZXJ0aXNlIG5vdGhpbmchDQoNClllYWgsIHRoYXQncyBhbHNv
IHdoYXQgSSB3YXMgc3VzcGVjdGluZy4NCg0KQW5kIHJ1bm5pbmcgZXRodG9vbCBhZ2FpbiBhZnRl
ciB0aGUgY3Jhc2gga2luZGEgc3VwcG9ydHMgdGhpcyB0aGVvcnkuDQoNCnJvb3RAdmVyZGluLWlt
eDhtcC0wNzEwNjkxNjp+IyBldGh0b29sIC1zIGV0aDEgYWR2ZXJ0aXNlIDB4MDENCg0KPT4gY3Jh
c2gNCg0Kcm9vdEB2ZXJkaW4taW14OG1wLTA3MTA2OTE2On4jIGV0aHRvb2wgZXRoMQ0KU2V0dGlu
Z3MgZm9yIGV0aDE6DQogICAgICAgIFN1cHBvcnRlZCBwb3J0czogWyBUUCBNSUkgXQ0KICAgICAg
ICBTdXBwb3J0ZWQgbGluayBtb2RlczogICAxMGJhc2VUL0Z1bGwgDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIDEwMGJhc2VUL0Z1bGwgDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIDEwMDBiYXNlVC9GdWxsIA0KICAgICAgICBTdXBwb3J0ZWQgcGF1c2UgZnJhbWUgdXNl
OiBTeW1tZXRyaWMgUmVjZWl2ZS1vbmx5DQogICAgICAgIFN1cHBvcnRzIGF1dG8tbmVnb3RpYXRp
b246IFllcw0KICAgICAgICBTdXBwb3J0ZWQgRkVDIG1vZGVzOiBOb3QgcmVwb3J0ZWQNCiAgICAg
ICAgQWR2ZXJ0aXNlZCBsaW5rIG1vZGVzOiAgTm90IHJlcG9ydGVkDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIF5eXl5eXl5eXl5eXg0KICAgICAgICBBZHZlcnRpc2VkIHBhdXNlIGZy
YW1lIHVzZTogU3ltbWV0cmljIFJlY2VpdmUtb25seQ0KICAgICAgICBBZHZlcnRpc2VkIGF1dG8t
bmVnb3RpYXRpb246IFllcw0KICAgICAgICBBZHZlcnRpc2VkIEZFQyBtb2RlczogTm90IHJlcG9y
dGVkDQogICAgICAgIFNwZWVkOiBVbmtub3duIQ0KICAgICAgICBEdXBsZXg6IFVua25vd24hICgy
NTUpDQogICAgICAgIFBvcnQ6IFR3aXN0ZWQgUGFpcg0KICAgICAgICBQSFlBRDogNw0KICAgICAg
ICBUcmFuc2NlaXZlcjogaW50ZXJuYWwNCiAgICAgICAgQXV0by1uZWdvdGlhdGlvbjogb24NCiAg
ICAgICAgTURJLVg6IFVua25vd24NCiAgICAgICAgU3VwcG9ydHMgV2FrZS1vbjogdWcNCiAgICAg
ICAgV2FrZS1vbjogZA0KICAgICAgICBDdXJyZW50IG1lc3NhZ2UgbGV2ZWw6IDB4MDAwMDAwM2Yg
KDYzKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRydiBwcm9iZSBsaW5rIHRpbWVy
IGlmZG93biBpZnVwDQogICAgICAgIExpbmsgZGV0ZWN0ZWQ6IG5vDQoNCj4gQW55d2F5LCB0aGlz
IGlzIHJvdWdobHkgdGhlcmUgdGhlIGNoZWNrIHNob3VsZCBnby4NCg0KWW91IG1lYW4gaXQgd291
bGQgbmVlZCBhbiBhZGRpdGlvbmFsIGNoZWNrIGFnYWluc3QgYWR2ZXJ0aXNpbmcgbm90aGluZz8N
Cg0KPiA+IC4uLg0KPiA+IA0KPiA+IE9uY2UgSSByZW1vdmUgdGhlbSBxdWV1ZXMgYmVpbmcgc2V0
dXAgdmlhIGRldmljZSB0cmVlIGl0IHNob3dzIGFsbCBtb2RlcyBhcyBzdXBwb3J0ZWQgYWdhaW46
DQo+ID4gDQo+ID4gcm9vdEB2ZXJkaW4taW14OG1wLTA3MTA2OTE2On4jIGV0aHRvb2wgZXRoMQ0K
PiA+IFNldHRpbmdzIGZvciBldGgxOg0KPiA+IMKgwqDCoMKgwqDCoMKgIFN1cHBvcnRlZCBwb3J0
czogWyBUUCBNSUkgXQ0KPiA+IMKgwqDCoMKgwqDCoMKgIFN1cHBvcnRlZCBsaW5rIG1vZGVzOsKg
wqAgMTBiYXNlVC9IYWxmIDEwYmFzZVQvRnVsbCANCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxMDBiYXNlVC9IYWxmIDEw
MGJhc2VUL0Z1bGwgDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTAwMGJhc2VUL0Z1bGwgDQo+ID4gLi4uDQo+ID4gDQo+
ID4gSG93ZXZlciwgMTBiYXNlVC9IYWxmLCB3aGlsZSBubyBsb25nZXIganVzdCBjcmFzaGluZywg
c3RpbGwgZG9lcyBub3Qgc2VlbSB0byB3b3JrIHJpZ2h0LiBMb29raW5nIGF0DQo+ID4gd2lyZXNo
YXJrDQo+ID4gdHJhY2VzIGl0IGRvZXMgc2VuZCBwYWNrZXRzIGJ1dCBzZWVtcyBub3QgdG8gZXZl
ciBnZXQgbmVpdGhlciBBUlAgbm9yIERIQ1AgYW5zd2VycyAoYXMgd2VsbCBhcyBhbnkgb3RoZXIN
Cj4gPiBwYWNrZXQNCj4gPiBmb3IgdGhhdCBtYXR0ZXIpLg0KPiANCj4gU28gdGhlIGFuc3dlcnMg
YXJlIG9uIHRoZSB3aXJlLCBqdXN0IG5vdCByZWNlaXZlZD8NCg0KWWVzLCBqdWRnaW5nIGZyb20g
dGhlIHdpcmVzaGFyayB0cmFjZSB0aGF0IGlzIGV4YWN0bHkgaG93IGl0IGxvb2tzLg0KDQo+ID4g
TG9va3MgbGlrZSB0aGUgc2FtZSBhY3R1YWxseSBhcHBsaWVzIHRvIDEwYmFzZVQvRnVsbCBhcyB3
ZWxsLiBXaGlsZSAxMDBiYXNlVC9IYWxmIGFuZA0KPiA+IDEwMGJhc2VUL0Z1bGwgd29yayBmaW5l
IG5vdy4NCj4gPiANCj4gPiBBbnkgaWRlYSB3aGF0IGVsc2UgY291bGQgc3RpbGwgYmUgZ29pbmcg
d3Jvbmcgd2l0aCB0aGVtIDEwYmFzZVQgbW9kZXM/DQo+IA0KPiBJIHdvdWxkIHVzZSBtaWktdG9v
bCB0byBjaGVjayB0aGUgc3RhdHVzIG9mIHRoZSBQSFkuIE1ha2Ugc3VyZSBpdA0KPiByZWFsbHkg
aGFzIG5lZ290aWF0ZWQgMTAvSGFsZiBtb2RlLg0KDQpZZXMsIGl0IGxvb2tzIGxpa2UgaXQuDQoN
CnJvb3RAdmVyZGluLWlteDhtcC0wNzEwNjkxNjp+IyBtaWktdG9vbA0KZXRoMDogbmVnb3RpYXRl
ZCAxMGJhc2VULUhELCBsaW5rIG9rDQpldGgxOiBuZWdvdGlhdGVkIDEwYmFzZVQtSEQsIGxpbmsg
b2sNCg0KQXMgYSBtYXR0ZXIgb2YgZmFjdCwgdGhlIGV4YWN0IHNhbWUgS1NaOTEzMVJOWEkgUEhZ
IGFsYmVpdCBvbiBGRUMgTUFDIGV0aDAgd29ya3MganVzdCBmaW5lIHdpdGggMTBNYnBzIGhhbGYt
DQpkdXBsZXguDQoNCj4gQWZ0ZXIgdGhhdCwgaXQgaXMgdmVyeSBsaWtlbHkgdG8NCj4gYmUgYSBN
QUMgcHJvYmxlbSwgYW5kIGkgZG9uJ3QgdGhpbmsgaSBjYW4gaGVscCB5b3UuDQoNClN1cmUsIGFu
eXdheSwgdGhhbmtzIGFnYWluIGZvciBhbGwgeW91ciBzdWdnZXN0aW9ucyBzbyBmYXIuIEkgaG9w
ZSBzb21lYm9keSBtb3JlIGZhbWlsaWFyIHdpdGggdGhlIERXTUFDIHNpZGUNCm9mIHRoaW5ncyBt
aWdodCBjaGltZSBpbiBub3cuLi4NCg0KPiA+IE9uIGEgc2lkZSBub3RlLCBiZXNpZGVzIG1vZGlm
eWluZyB0aGUgZGV2aWNlIHRyZWUgZm9yIHN1Y2ggc2luZ2xlLXF1ZXVlIHNldHVwIGJlaW5nIGhh
bGYtZHVwbGV4IGNhcGFibGUsIGlzDQo+ID4gdGhlcmUgYW55IGVhc2llciB3YXk/IE11Y2ggbmlj
ZXIgd291bGQsIG9mIGNvdXJzZSwgYmUgaWYgaXQganVzdHdvcmtlZFRNIChlLmcuIGFkdmVydGlz
ZSBhbGwgbW9kZXMgYnV0IG9uY2UNCj4gPiBhDQo+ID4gaGFsZi1kdXBsZXggbW9kZSBpcyBjaG9z
ZW4gcmV2ZXJ0IHRvIHN1Y2ggc2luZ2xlLXF1ZXVlIG9wZXJhdGlvbikuIFRoZW4sIG9uIHRoZSBv
dGhlciBoYW5kLCB3aG8gc3RpbGwgdXNlcw0KPiA+IGhhbGYtZHVwbGV4IGNvbW11bmljYXRpb24g
aW4gdGhpcyBkYXkgYW5kIGFnZSAoOy1wKS4NCj4gDQo+IFlvdSBzZWVtIHRvIG5lZWQgaXQgZm9y
IHNvbWUgcmVhc29uIQ0KDQpXZWxsLCB3ZSBhcmUgZ2VhcmluZyB1cCBvbiBvdXIgYXV0b21hdGVk
IHRlc3RpbmcgaW5mcmFzdHJ1Y3R1cmUgYW5kIGFza2luZyBteSBodW1ibGUgb3BpbmlvbiBvbiB3
aGF0IGV4YWN0bHkgdG8NCnRlc3QgY29uY2VybmluZyB0aGUgRXRoZXJuZXQgc3Vic3lzdGVtIEkg
Z2F2ZSB0aGUgYnJpbGxpYW50IHN1Z2dlc3Rpb24gdG8gdHJ5IGVhY2ggYW5kIGV2ZXJ5IHN1cHBv
cnRlZCBsaW5rDQptb2RlICg7LXApLiBXaGljaCBhY3R1YWxseSB3b3JrcyBqdXN0IGZpbmUgb24g
ZXZlcnkgb3RoZXIgaGFyZHdhcmUgb2Ygb3VycyBqdXN0IG5vdCB0aGUgaS5NWCA4TSBQbHVzIHdp
dGggdGhlDQpEV01BQyBJUCAocmVtZW1iZXIsIGV2ZW4gRkVDIE1BQyB3b3JrcykuIFNvIGZvciBu
b3cgdGhpcyBpcyBub3Qgc29tZXRoaW5nIGEgY3VzdG9tZXIgb2Ygb3VycyBoYXMgcmVhbCB0cm91
YmxlDQp3aXRoIGJ1dCBpdCByYWlzZWQgc29tZSBxdWVzdGlvbnMgY29uY2VybmluZyB3aGV0aGVy
IG9yIG5vdCBhbmQgd2hhdCBleGFjdGx5IHdlIGRvIHN1cHBvcnQuLi4NCg0KPiBBbnl3YXksIGl0
IGlzIGp1c3QgY29kZS4gWW91IGhhdmUgYWxsIHRoZSBuZWVkZWQgaW5mb3JtYXRpb24gaW4gdGhl
DQo+IGFkanVzdF9saW5rIGNhbGxiYWNrLCBzbyB5b3UgY291bGQgaW1wbGVtZW50IGl0Lg0KDQpZ
ZWFoLCBJIGd1ZXNzIHRoYXQgbWlnaHQgYmUgYSBuZWF0IGxpdHRsZSBzaWRlIHByb2plY3QgdHJ5
aW5nIHRvIGdldCBtb3JlIGludG8gdGhlIHRvcGljLiBTbyBmYXIgbXVjaCBvZiB0aGUNCmludGVy
YWN0aW9uIHdpdGhpbiB0aGUgbmV0d29ya2luZyBzdWJzeXN0ZW0gaW4gTGludXggaXMgc3RpbGwg
cmF0aGVyIGEgbWlyYWNsZSB0byBtZS4uLg0KDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQW5k
cmV3DQoNCkNoZWVycw0KDQpNYXJjZWwNCg==

