Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AD25A789C
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiHaINA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiHaIMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:12:54 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.109.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994BAC59E0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 01:12:47 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2045.outbound.protection.outlook.com [104.47.22.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-ZMdf7M68PA-ruUWMQqX1tQ-2; Wed, 31 Aug 2022 10:12:44 +0200
X-MC-Unique: ZMdf7M68PA-ruUWMQqX1tQ-2
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3b::9) by
 ZRAP278MB0287.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Wed, 31 Aug 2022 08:12:42 +0000
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::cd78:5df6:612c:455f]) by ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::cd78:5df6:612c:455f%2]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 08:12:42 +0000
From:   Marcel Ziswiler <marcel.ziswiler@toradex.com>
To:     Philippe Schenker <philippe.schenker@toradex.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "embed3d@gmail.com" <embed3d@gmail.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>
CC:     "philipp.rossak@formulastudent.de" <philipp.rossak@formulastudent.de>,
        "guoniu.zhou@nxp.com" <guoniu.zhou@nxp.com>,
        "aisheng.dong@nxp.com" <aisheng.dong@nxp.com>,
        "abel.vesa@nxp.com" <abel.vesa@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>
Subject: Re: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) - kernel
 5.19
Thread-Topic: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) -
 kernel 5.19
Thread-Index: AQHYrI/+0vnMKpTjW0iEfU3dAn0M562oeBSAgADhsQCAH2/8gA==
Date:   Wed, 31 Aug 2022 08:12:41 +0000
Message-ID: <fe0d235ff45dea2cd808b0d86b5601b333915fd4.camel@toradex.com>
References: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
         <7d541e1dfa1e93abf901f96c60be54b01c78371c.camel@toradex.com>
         <47c884e9-e5ea-16a2-38e5-7b7f61e77e80@gmail.com>
         <e17a49d75fa8fe36af30ff1c2b1c981375c94541.camel@toradex.com>
In-Reply-To: <e17a49d75fa8fe36af30ff1c2b1c981375c94541.camel@toradex.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa225fa2-c6d7-43e0-f3ca-08da8b2893c9
x-ms-traffictypediagnostic: ZRAP278MB0287:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ld8hvqZciOYIFxL/Ti2GMLaA2CaqwgUNP7sAI+ygzP5+OoqylLDUddEm4SfD2g2uBvh21DJ2n9jOSgrE3ACLmlsXWYGbbkmDajM8DS1GzdVjXRNDN3niPteKTeUQ8yqEvaNpQfgw1WhIkcDE/K/x2XRvCKy+9bWMRwCFM91Kd2xXV5T/xHMav9PX6299w+Gc2E20TCoJYWL+Wte/zsS5Qy2EanCr0+mhmSs/slOjbr6DzJwnWYHlRUlPcMZMl9+SFWTliIGKBrEqFOwWy/2PNScH2BjrpwSUl3VMQ58easNG61Q8SPc3E1xgOYts3At7Rogd5EoIIGZzLJPtdV6pZU6rbphCodQuCjjlDhXowQWDhm77aoQWgmxzv0HSf6z0+aWlOixSISrI0uQNeqDxuySyL2nOzDq9/tBqT07EDwrWKvueriEAxlBfQinsg4YEtZdR9oLqXlq00fFGL78UMARS5bN+f1hiAwGfl3uELuFAbsZVbacty1PBge4mh6SGwPrcMxPJ/9Hq0gwGf28lfkfjngZrwoCBQFdG7t0E/csNqiYcZjbiDgoHHA/+yGGY6fJXKGNscT75xuXdnyun3dSDMTQRIuXcDdd+SeEJnAERTEyposXPGOba7dirMqNLUelr3PcjiXe95z+ez7Ym4nF6xtI3mqOl2bZrjZJkAHIHZ+q75rzySOgsXxRRmlMl6jwiXmgYI7eQmbStkKRMvrBA5U4Nv2/y8MnqGCmxPKgJoUvY5OZMDWz+kufImLd48ndeS+1lkUwMH0Z7OX0knksJl1pdirCU+V26RuNJn9NE7i94oCukZ9SFWMhtK9gV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39850400004)(396003)(346002)(366004)(54906003)(110136005)(966005)(8676002)(86362001)(4326008)(66946007)(66476007)(76116006)(6486002)(66556008)(66446008)(71200400001)(64756008)(36756003)(5660300002)(41300700001)(38070700005)(8936002)(316002)(478600001)(7416002)(122000001)(44832011)(2616005)(38100700002)(6506007)(2906002)(53546011)(83380400001)(26005)(186003)(6512007)(32563001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M01JcmlJSmxrM1ZRdklpaUZPOGVTcHJBMnNDSngyeG1ZbyttQXh3ckpCbTZx?=
 =?utf-8?B?cUlrZlYxa3RFVlRwcGZWeTJNbTZQa2NkM2JYc3N5SVdhK3hxRmdUbi9KQzZx?=
 =?utf-8?B?QmZpZlMvbjY2OHB6NmVJTG4zTFhHQlpxcE9vWjdQaGc1WlZvWWk3a0VJeW1n?=
 =?utf-8?B?Q2hodGFDSGhHRHFDcklZSG00aWJMTEZZS0FDNmZCbUpTVTN1R1pucTRFeUJq?=
 =?utf-8?B?K0tnNWdQaTJVdXN3VHhFaVREN2lIOG9zQ3ZsUDg1NHI4aFczKzlTWHp0eTJa?=
 =?utf-8?B?N2V6cmVzb1llNnFTMUNGU1hQN1pZQWZEOUlJUkZGOXFYV3VwbFl0elJoSUpO?=
 =?utf-8?B?UnJqd3pHbllsclVQSGZCditMOURMZjNGRkZhT3lPOXFuU0JwejNsYUx1UzNz?=
 =?utf-8?B?YXNZdFRUMVBHQ09zTHgzbXo3Z25LMlMxakFQTjRJY1ZNQWxoUEdiRUIzcFp2?=
 =?utf-8?B?dXo0QVZJaWtpLzVtcno0eGpHb1lwdDZEZjFwM0ZQcUlFVU4veUlOSUpiN0R2?=
 =?utf-8?B?WVYzK0VZQVBRTHRUVExHL3JsTG9JMkdtMU1rSmd0T0krYnRtdG1aWDYyV3Js?=
 =?utf-8?B?Tzl6ZVdHQ292d2JMcUJBaWU3eU1WVlhyTmg0NkxRdGxNUU9xZ2ZZTHlzUHRt?=
 =?utf-8?B?NVJoajF6NVl1bzltcDJBQ2VlbFBHaHlMS29TQVl4VEpMdnQ3OUVuakExbkVv?=
 =?utf-8?B?N1RSaWxlRFNGS1RuVUZ6RHJoZkRGcHJTVlBiVXg1YTRLWGEyeTlpQXMwSzVP?=
 =?utf-8?B?eDBSakYvOUhjcGhmZllaVXFSOUdVNU9NQ1REOU9LU2tCdjF2ZTIzSGZXTHhF?=
 =?utf-8?B?RFFWKzdoV21YbTF5Tmt4RldlclN3ZHJ2WUdyWVFhUDk3Y1hXbUh6NUpWY2g4?=
 =?utf-8?B?SHRTVnU3cTI5emNVblFyZ0xJWHI0VjRyZmNaNUNYRzFJdldLZ1J4N3VJMUlH?=
 =?utf-8?B?OWcyN2pveVFRSmhGRnphTGN3dlZXNzdaWlZlQ2dQZkZjbUFkQVMzZ2xRSkU4?=
 =?utf-8?B?c0ZubXl0bWJzTE93MUFBa0JUVlR5TVlIbTFxOWRwd2pqR3kwTlFvby9aakRD?=
 =?utf-8?B?U3g0NkJOYXRtRE96V1JCU0E5T2tnMHNCOW0yMFlOek5kNVNld3VnSmFZL1pV?=
 =?utf-8?B?VlhUMElFUGNRMDVVaE9yODI0TkpuOUZXbXlKcDY2ckJMMFhiMkdBa1FNQ1Y2?=
 =?utf-8?B?UmtzRFlCdUtrekpKUHpGYVNQVHl6eTNzck9hakREWmZSWHREQzZqc0MzOER5?=
 =?utf-8?B?cHdOZFdQL2VGSWRkVUVWdzFndXlXMklNQ0FPc3B6dGdDOUJnRUtSWHVtM1hY?=
 =?utf-8?B?ektzU3ltVE1HVXcrdXZNNlhGUlVDSGVmbGFFWktNRFYyb3dUek9DNjlvYmNp?=
 =?utf-8?B?NnNRSUt3NndxME1CZGVPZUpDK1BHejB6ZVBWMGJqU3N3azZpd2t2a2hmZzc1?=
 =?utf-8?B?OWJubGhzZ3ZaVm5jTTRWNTRyNHRjUVV2d2FPVDNqN3JpK3JMeGs0RlFiYS9Y?=
 =?utf-8?B?VlJxVFFrWXU2QlFldWIybWloZXNMcGlBUTExRndVdnhvZDhkQUVqRjBTU0R2?=
 =?utf-8?B?VlJudTNHN3FnOXFnV0Q3eG5pcWVzYk0xbUUxSE5aRjRrNGlndVQxbXFUWlF3?=
 =?utf-8?B?ZkFmWlEyL1FCdHVTUERJRXZGNXVIOGY2TmFkVTdrbjZtdjRtdzlqOWxlZndv?=
 =?utf-8?B?bjVhZ1ZqMVN6V3daRkM2SCtKWkYvcXZXZzRxYUl2aVYxY0pZRDNrNHBOd1F4?=
 =?utf-8?B?dEZYVnVCVkE0MzVON0ViaGtQWnpubWk0RGo5WTh3QVE1S3VFT1EvSkorbkEv?=
 =?utf-8?B?aGFiUjl0SzNDaDA1Snh6d1Q1NEQzL1RSN1VLdGdtYU95N0xXWEJyTE55TkFh?=
 =?utf-8?B?UmNlYTd5U05UQ2t2c0k3ZXh6bVBmNjlGVEhhajVId0hYSzY4Zm0vdjVMbHFU?=
 =?utf-8?B?eFIrVHQzVXZuQjhBbkE1SzBuY0ZWNFhLNmVsdlh1NEVIYzd2azRpK3JKNGwr?=
 =?utf-8?B?LzNHeXVzUlpKMDhneDdnTXFtaGVDNGN6UURWWXlkN3FicEtuT0tFbnZKWnE3?=
 =?utf-8?B?cWhlTlE3VHgzR3pSelRKWGxSMG80WFJXUytFbkZjU0RqMTlOdTdRaTdHd0VO?=
 =?utf-8?B?bTlITTVYNFMrck5xVU03bUZNQzNabnRENktBRTBVcDJWUVNEcERoSll4Mzk2?=
 =?utf-8?Q?KkYGJPd8mqsgWtlO2osbj3A=3D?=
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fa225fa2-c6d7-43e0-f3ca-08da8b2893c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 08:12:42.0472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hnEMxrJ2MaqbXmqRetGNCs+xi/6qnTNgTvsbVgiU9W2x9ZVyF1OsaajcDMwY6ATYqvnNaIzdWiIFMzL76gbeoLc7O3kYNN/uKCusgRN8Mrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0287
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <C52AB53A1A650341AE27AF4AF89B5768@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA4LTExIGF0IDA4OjA3ICswMDAwLCBQaGlsaXBwZSBTY2hlbmtlciB3cm90
ZToNCj4gT24gV2VkLCAyMDIyLTA4LTEwIGF0IDIwOjQwICswMjAwLCBQaGlsaXBwIFJvc3NhayB3
cm90ZToNCj4gPiA+IEhpIE1hcmNlbCwNCj4gPiA+IA0KPiA+ID4gdGhhbmtzIQ0KPiA+ID4gDQo+
ID4gPiBXaXRoIHRoZSByZW1vdmVkIGxpbmUgaXQgaXMgd29ya2luZyBub3chDQo+ID4gPiANCj4g
PiA+IEkgaG9wZSB0aGVyZSB3aWxsIGJlIGEgbWFpbmxpbmVkIHNvbHV0aW9uIHNvb24uDQoNClll
cywgSSBhbSBzdGlsbCBob3BpbmcgZm9yIG1vcmUgaW5mb3JtYXRpb24gZnJvbSBOWFAgb24gdGhh
dCBtYXR0ZXIuDQoNCkBOWFA6IEFueWJvZHk/DQoNCj4gVGhpcyBpcyBhbiBpbnRlcmVzdGluZyBx
dWVzdGlvbi4gU2luY2UgaXQncyBhIFNDRlcgaXNzdWUgYW5kIGEgZ2VuZXJhbA0KPiBxdWVzdGlv
biBhYm91dCB0aGVzZSBTb0NzLCBJJ2xsIHRha2UgdGhlIGxpYmVydHkgb2YgaGlqYWNraW5nIHRo
aXMNCj4gdGhyZWFkIGZvciBzb21lIHF1ZXN0aW9ucyAoc2luY2UgTlhQIGlzIGFsc28gaW4gdGhl
IGxvb3Agbm93KS4NCj4gDQo+IEBOWFAgcGVvcGxlOiB3aGljaCBTQ0ZXIHZlcnNpb24gc2hvdWxk
IGJlIHVzZWQgaW4gZ2VuZXJhbCB3aXRoIG1haW5saW5lDQo+IGxpbnV4LWtlcm5lbCA/DQo+IEFu
ZCBob3cgaXMgaXQgcGxhbm5lZCB0byBwcm9jZWVkIHdpdGggU0MtZmlybXdhcmUgZW5hYmxlZCBT
b0NzIG9uDQo+IG1haW5saW5lIGxpbnV4Pw0KPiBJcyB0aGUgU0NGVyBBUEkgYmFja3dhcmQgY29t
cGF0aWJsZT8NCj4gSWYgc28sIGZyb20gd2hpY2ggdmVyc2lvbiBvbj8NCj4gDQo+IFRoYW5rcyBp
biBhZHZhbmNlIGZvciBlbmxpZ2h0ZW5pbmcgdXMgYWxsIG9uIHRoaXMgU0NGVyBpc3N1ZS4NCj4g
DQo+IFBoaWxpcHBlDQo+IA0KPiA+ID4gQ2hlZXJzDQo+ID4gPiBQaGlsaXBwDQo+ID4gPiANCj4g
PiA+IE9uIDEwLjA4LjIyIDEwOjA1LCBNYXJjZWwgWmlzd2lsZXIgd3JvdGU6DQo+ID4gPiA+ID4g
U2FsaSBQaGlsaXBwDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gT24gV2VkLCAyMDIyLTA4LTEwIGF0
IDAwOjU1ICswMjAwLCBQaGlsaXBwIFJvc3NhayB3cm90ZToNCj4gPiA+ID4gPiA+ID4gSGksDQo+
ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBJIGN1cnJlbnRseSBoYXZlIGEgcHJvamVjdCB3
aXRoIGEgVG9yYWRleCBDb2xpYnJpIElNWDhYIFNPTQ0KPiA+ID4gPiA+ID4gPiBib2FyZD4gPj4g
d2hpdGgNCj4gPiA+ID4gPiA+ID4gYW4gb25ib2FyZCBNaWNyZWwgS1NaODA0MU5MIEV0aGVybmV0
IFBIWS4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IFRoZSBoYXJkd2FyZSBpcyBkZXNj
cmliZWQgaW4gdGhlIGRldmljdHJlZSBwcm9wZXJseSBzbyBJDQo+ID4gPiA+ID4gPiA+IGV4cGVj
dGVkPiA+PiB0aGF0DQo+ID4gPiA+ID4gPiA+IHRoZSBvbmJvYXJkIEV0aGVybmV0IHdpdGggdGhl
IHBoeSBpcyB3b3JraW5nLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gQ3VycmVudGx5
IEknbSBub3QgYWJsZSB0byBnZXQgdGhlIGxpbmsgdXAuDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4g
PiA+ID4gPiBJIGFscmVhZHkgY29tcGFyZWQgaXQgdG8gdGhlIEJTUCBrZXJuZWwsIGJ1dCBJIGRp
ZG4ndCBmb3VuZD4NCj4gPiA+ID4gPiA+ID4gPiA+IGFueXRoaW5nDQo+ID4gPiA+ID4gPiA+IGhl
bHBmdWwuIFRoZSBCU1Aga2VybmVsIGlzIHdvcmtpbmcuDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4g
PiA+ID4gPiBEbyB5b3Uga25vdyBpZiB0aGVyZSBpcyBzb21ldGhpbmcgaW4gdGhlIGtlcm5lbCBt
aXNzaW5nIGFuZA0KPiA+ID4gPiA+ID4gPiBnb3QgaXQ+ID4+IHJ1bm5pbmc/DQo+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gWWVzLCB5b3UgbWF5IGp1c3QgcmV2ZXJ0IHRoZSBmb2xsb3dpbmcgY29tbWl0
IGJhYmZhYTk1NTZkNw0KPiA+ID4gPiA+ICgiY2xrOj4gPmlteDogc2N1OiBhZGQgbW9yZSBzY3Ug
Y2xvY2tzIikNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBBbHRlcm5hdGl2ZWx5LCBqdXN0IGNvbW1l
bnRpbmcgb3V0IHRoZSBmb2xsb3dpbmcgc2luZ2xlIGxpbmUNCj4gPiA+ID4gPiBhbHNvPiA+aGVs
cHM6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvZHJpdmVycy9jbGsvaW14
L2Nsay1pbXg4cXhwLmM/aD12NS4xOSNuMTcyDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSBqdXN0
IGZvdW5kIHRoaXMgb3V0IGFib3V0IHR3byB3ZWVrcyBhZ28gYmVmb3JlIEkgd2VudCB0bw0KPiA+
ID4gPiA+IHZhY2F0aW9uPiA+YW5kIHNpbmNlIGhhdmUgdG8gZmluZCBvdXQgd2l0aCBOWFAgd2hh
dA0KPiA+ID4gPiA+IGV4YWN0bHkgdGhlIGlkZWEgb2YgdGhpcyBjbG9ja2luZy9TQ0ZXIHN0dWZm
IGlzIHJlbGF0ZWQgdG8gb3VyPg0KPiA+ID4gPiA+ID4gaGFyZHdhcmUuDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gQE5YUDogSWYgYW55IG9mIHlvdSBndXlzIGNvdWxkIHNoZWQgc29tZSBsaWdodCB0
aGF0IHdvdWxkIGJlDQo+ID4gPiA+ID4gbXVjaD4gPmFwcHJlY2lhdGVkLiBUaGFua3MhDQo+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gPiA+IFRoYW5rcywNCj4gPiA+ID4gPiA+ID4gUGhpbGlwcA0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+IENoZWVycw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE1hcmNlbA0K

