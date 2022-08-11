Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D803558F8D5
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiHKIH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiHKIH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:07:56 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.109.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB1989018D
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:07:54 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2043.outbound.protection.outlook.com [104.47.22.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-25-0-Zhh1E9Og-N--Fg-BZSOw-1; Thu, 11 Aug 2022 10:07:51 +0200
X-MC-Unique: 0-Zhh1E9Og-N--Fg-BZSOw-1
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZR0P278MB0186.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:36::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 11 Aug
 2022 08:07:50 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::b42a:f237:69bc:f27a]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::b42a:f237:69bc:f27a%5]) with mapi id 15.20.5504.023; Thu, 11 Aug 2022
 08:07:50 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "embed3d@gmail.com" <embed3d@gmail.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>
CC:     "philipp.rossak@formulastudent.de" <philipp.rossak@formulastudent.de>,
        "guoniu.zhou@nxp.com" <guoniu.zhou@nxp.com>,
        "aisheng.dong@nxp.com" <aisheng.dong@nxp.com>,
        "abel.vesa@nxp.com" <abel.vesa@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) - kernel
 5.19
Thread-Topic: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) -
 kernel 5.19
Thread-Index: AQHYrENL0Xt8IugAdkOjaFC01uNOlq2oeL+egADhoAA=
Date:   Thu, 11 Aug 2022 08:07:50 +0000
Message-ID: <e17a49d75fa8fe36af30ff1c2b1c981375c94541.camel@toradex.com>
References: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
         <7d541e1dfa1e93abf901f96c60be54b01c78371c.camel@toradex.com>
         <47c884e9-e5ea-16a2-38e5-7b7f61e77e80@gmail.com>
In-Reply-To: <47c884e9-e5ea-16a2-38e5-7b7f61e77e80@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 476d21c5-0856-4aab-087c-08da7b7095af
x-ms-traffictypediagnostic: ZR0P278MB0186:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /mnUV50DWB3ro3zm2xkr40rAhpr0NGpN1MWVGi+An5iy3fzcqB7VhYdcxxqFhBAEFbYSyD55WcfpsKTmQ4Xe7oJobs36lQ6Cy3p3VAmExYd7QQl3NpNm9jkvGypkIrVO/DKkFjgGOP5+Y/hYsE9n0E6sBuQSzzNL/Y8YbXo9Y88ZjC4qx2NK0+42cCSwSCUp/EoxcfXNmlf/3SORx2z9TO6BNvdZ7g98v79tQYAp3vAESZiagthfwVzrutE119/of4esxGuBpmq8zdmCO/fg8QRERfsvqZFlrE/h5jtC5iAbzivG3CE2pcD1LA6o6P9n7cS1CDBZhOYTwbpFEk6eJh0wgeetvEF66gsWP+tIOFjyaKRreVVca1ZPmsKotaP9AwCCUrzDQSe/mGwaEIcDwQpo5YvRtjl59aDKuY3g5dYcY/2Tz8VjO7H1jJnGtAbftYa/jcDLnzwOzpnNF2WsUyQj7a7hDt57WzMroNV/rQV0Td8Rq3TFjR6wjIbKHFJPRe5QfX1RXuf4NaTtrBOzFyflhyW5dgxVQcMvkLZg+8wF7u1D02TEs1kRhmmsHTiKyhQojjRqeUz7UKFdwPbXjBhbSOamUR+yjoabTqVETqbov7n0QSkMvOQSwOzdNq2YleqES7AXlcHT2+Xu6YGPwl7CAx2cAtVZ1XPs+SkXgDGsjjke++83U5KyHGHPqoAyGJSR1x6sLQpvVzZ7/LAdYhaPEBBgs2wH2h4+ja2HksZTgie22B3QZXpSFlv+NQvD57UXbtAB5thkqOod16/Y8QSsa/+HQMzvqgkmCA4j8vriLZU6NioNGnV3r0RzOh6F+chnkhx/obqjmYUkKVu9oLeP6tHH8azK6khd0HPrGmU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39840400004)(346002)(366004)(136003)(396003)(110136005)(66946007)(66556008)(76116006)(54906003)(8676002)(36756003)(71200400001)(4326008)(66476007)(66446008)(64756008)(5660300002)(966005)(6486002)(316002)(86362001)(8936002)(478600001)(44832011)(41300700001)(83380400001)(6506007)(53546011)(2906002)(38100700002)(122000001)(26005)(2616005)(38070700005)(6512007)(186003)(32563001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eE1Fd1FrbzNvZTFWOFE3SGNMbnlrTlBaRy9tY2tFa2pGM1I4ajNTcXdlblRH?=
 =?utf-8?B?emdHSFg1VTVIbVBQbVRLc3JYdG9pVnNaM3NueTBlY21JNElKZHpLa1lyakhU?=
 =?utf-8?B?c1N1YXJHQmtpSG1ocnhiZGFuSnVyRFprRkR6eXgrTE15c0hwTzBycjdJaXZG?=
 =?utf-8?B?SVpSK0dHT3pqU05OTktmMnZkdnBid25XZUJ1MDZNcDhPOWhWZ1p3SGFNUVFq?=
 =?utf-8?B?Q3pobGlWL2NkQW8rQ2dIZG9sTklnZHhpcE5sTXh2QjJmZXFDenZuQ2JVOVVD?=
 =?utf-8?B?MytuOXB4L2RvenkzTkN0eTVzNUhheTg0WFVtNFZ6TE04RUd2U2l4RUcwdkJR?=
 =?utf-8?B?a2pPY0VjVzJISFEyNlRjcTRwL2FVaHpPZVFzb3pWRTIwVDhrOEpYUEpkRXQz?=
 =?utf-8?B?aS9nVG1VUVBva2VobjBjMjA1V1YraUU1ZkdhMFB1R09DT01DUkxxSDBPZ3I2?=
 =?utf-8?B?K1FIa2h3YUxYK3F0R3UxYjY3RGZHSStWaDBxejRzaG53MVlUZi9CR2NSZkEv?=
 =?utf-8?B?U21NUlg2YnVBNWhjQ1M4RGgwRUxLM3NyNUI4bXk0RzJGZDIvWW9CaFJEWjVj?=
 =?utf-8?B?a2RYRFJaTkhCd1pXVEEyZ1FzUWI0QjNRUHZLVkJGc0Vmd3pYeGxuL1hLV050?=
 =?utf-8?B?TlNkdlNTaE9LYXRyWHNBbytaMUdWT2NmMlo4Rkk3eldPM3RVR0FaVk01NW1s?=
 =?utf-8?B?M2Z2UmRTd1VrL016aGJCeEFUeHhLWEJBaEUxOEM4ekJ2RkE5Y2Y0a3FGc1Jl?=
 =?utf-8?B?QzQwa1gzRjQ2S3BQMHIzTlJFY1kvMTNKeU9MbUV3QTFsaE5OYk9vQnZmUUh2?=
 =?utf-8?B?ZE9QeEM4ZjhRQ1BIMHRDbWdGcFNXSUlCcXk3TndvNldZWlJjY2NPNlpSNk1T?=
 =?utf-8?B?QjhtRmVkN2JzK25EbEhhTGFCQU55alIxWk1zK3hoYTdXTmhJNGN1TFoxTEFh?=
 =?utf-8?B?ajJGcFliVXJVMW9Jb3RXYnE4Qk1QNHlyZytEb3F4NnRIQ0pnY0t3UlRBUzY1?=
 =?utf-8?B?SVdEdG9uaURubFRoS0s1VUJzTkhaOHBVL3RydDRlK2JyRmR6VWE2MEd4VnZ2?=
 =?utf-8?B?SktqT0lzRzMvS2l0WGxJektwRVFSMHBJSElXNVVycEJVNXpMdFRocDZVK0xZ?=
 =?utf-8?B?Y2xoQjFROFBuRFYwQlY5RTZpZzVRUkxMTlhEZGZ3VnFCYmRLajdLc1UzZ3o4?=
 =?utf-8?B?Wi9PSkxRNGxTYVh0bXBBdE9aMmJHeE11bmhWNzN6OUtReVJYSXFiKzB1UUd0?=
 =?utf-8?B?MUJOUFBmblFmdmwwOXIxcDcwS3FJUU9TMmltd0RzWlBUL3VuM3lVT3pudTlY?=
 =?utf-8?B?M01RVm4xeTVya01ONVBSajNlL0Vub1VhR3FTNis1NmlLbFNPN0l1MW1qcTY1?=
 =?utf-8?B?UGhKTHUvY3NIRFNaUU14Qlc3b3ppcldaMDRTVGx4Kzh5cHU0YTVBME1FQmd5?=
 =?utf-8?B?UWljTmRGRkJIMTN4SWQ4OUZDcytYZVN4MEwxbjJlVVFmaVJadFZ4djk2MXZt?=
 =?utf-8?B?alFoZitWSlJHQ2kwSGZvOURtNzdvRVZlN0llR0krNUw0RkRrczJ0YWlFOXVP?=
 =?utf-8?B?MEpzV3NzcmhGNDE0SjlZaUtNZmpWUDdCc3hDVUlxZHoyUERHVkQ5OVErN2xB?=
 =?utf-8?B?aTEwKzZjZ1RrWnYxMEd2ei8vb2RIN0hZUUFoaXc4eEhnallhMStRZnNsS3d1?=
 =?utf-8?B?bzBPdlZKYWZhKzMyLzJtYndwYlBGbWFpY0cwSGh2V1RtRkhyMnk3VGxxSG1z?=
 =?utf-8?B?dDBaMzgwaEJqSFYrZXl2RjRIOWpKdDV1WTVXY2lZM2V5ZDkxNTh5bkZrMGxE?=
 =?utf-8?B?TnYvdHorMjdhSzhyUDRraXptZ0FOK3pieGhDQ0RzRlFVLzdxWDFEVDNtNlh4?=
 =?utf-8?B?T2NyV3d0U2JDMlk0NUxydTlqeTc3UXIrMml5RUJWYjJaWGNtWVo5Q2ozR01y?=
 =?utf-8?B?aTh0VkQ0VVBWeURZNXRQM3ZqcnNKVHBDUnpkOGJHbFROaU1VNERlbGJXOXA1?=
 =?utf-8?B?U0NPTmtsVHFJZWVEb1hGNmw0bUNvY0pDMEMxTlF3SGRWeTNvVjh6cElFOUZN?=
 =?utf-8?B?ckI5QU4vOUsxaU5MWm5UVzE5YlM4dFdFSW5mYVZyZzdFaXduVnhURVBGSmdQ?=
 =?utf-8?B?THdPV2E2MXRuZXFOVGRCVTM2Zy9BSmZkNTJib0g5eEtmZXlOWHV1Y0x0QlZD?=
 =?utf-8?Q?nWsq8At5inJxyg0ac2Wb9Lg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 476d21c5-0856-4aab-087c-08da7b7095af
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 08:07:50.3707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r8duMFmm9Bjklx1QJfVxhOvQOJTB6QmsKHm+4tteazo0fUbmV824aJZi1F8TlUqkZV/S5wICJ/2rLiXUElPqCIY9mrnUAwpCcxjK3gNbxKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0186
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <F337B52145133F499A7A9DE5DB1C5E74@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA4LTEwIGF0IDIwOjQwICswMjAwLCBQaGlsaXBwIFJvc3NhayB3cm90ZToN
Cj4gPiBIaSBNYXJjZWwsDQo+ID4gDQo+ID4gdGhhbmtzIQ0KPiA+IA0KPiA+IFdpdGggdGhlIHJl
bW92ZWQgbGluZSBpdCBpcyB3b3JraW5nIG5vdyENCj4gPiANCj4gPiBJIGhvcGUgdGhlcmUgd2ls
bCBiZSBhIG1haW5saW5lZCBzb2x1dGlvbiBzb29uLg0KDQpUaGlzIGlzIGFuIGludGVyZXN0aW5n
IHF1ZXN0aW9uLiBTaW5jZSBpdCdzIGEgU0NGVyBpc3N1ZSBhbmQgYSBnZW5lcmFsDQpxdWVzdGlv
biBhYm91dCB0aGVzZSBTb0NzLCBJJ2xsIHRha2UgdGhlIGxpYmVydHkgb2YgaGlqYWNraW5nIHRo
aXMNCnRocmVhZCBmb3Igc29tZSBxdWVzdGlvbnMgKHNpbmNlIE5YUCBpcyBhbHNvIGluIHRoZSBs
b29wIG5vdykuDQoNCkBOWFAgcGVvcGxlOiB3aGljaCBTQ0ZXIHZlcnNpb24gc2hvdWxkIGJlIHVz
ZWQgaW4gZ2VuZXJhbCB3aXRoIG1haW5saW5lDQpsaW51eC1rZXJuZWwgPw0KQW5kIGhvdyBpcyBp
dCBwbGFubmVkIHRvIHByb2NlZWQgd2l0aCBTQy1maXJtd2FyZSBlbmFibGVkIFNvQ3Mgb24NCm1h
aW5saW5lIGxpbnV4Pw0KSXMgdGhlIFNDRlcgQVBJIGJhY2t3YXJkIGNvbXBhdGlibGU/DQpJZiBz
bywgZnJvbSB3aGljaCB2ZXJzaW9uIG9uPw0KDQpUaGFua3MgaW4gYWR2YW5jZSBmb3IgZW5saWdo
dGVuaW5nIHVzIGFsbCBvbiB0aGlzIFNDRlcgaXNzdWUuDQoNClBoaWxpcHBlDQoNCj4gPiBDaGVl
cnMNCj4gPiBQaGlsaXBwDQo+ID4gDQo+ID4gT24gMTAuMDguMjIgMTA6MDUsIE1hcmNlbCBaaXN3
aWxlciB3cm90ZToNCj4gPiA+ID4gU2FsaSBQaGlsaXBwDQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBX
ZWQsIDIwMjItMDgtMTAgYXQgMDA6NTUgKzAyMDAsIFBoaWxpcHAgUm9zc2FrIHdyb3RlOg0KPiA+
ID4gPiA+ID4gSGksDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IEkgY3VycmVudGx5IGhhdmUg
YSBwcm9qZWN0IHdpdGggYSBUb3JhZGV4IENvbGlicmkgSU1YOFggU09NDQo+ID4gPiA+ID4gPiBi
b2FyZD4gPj4gd2hpdGgNCj4gPiA+ID4gPiA+IGFuIG9uYm9hcmQgTWljcmVsIEtTWjgwNDFOTCBF
dGhlcm5ldCBQSFkuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFRoZSBoYXJkd2FyZSBpcyBk
ZXNjcmliZWQgaW4gdGhlIGRldmljdHJlZSBwcm9wZXJseSBzbyBJDQo+ID4gPiA+ID4gPiBleHBl
Y3RlZD4gPj4gdGhhdA0KPiA+ID4gPiA+ID4gdGhlIG9uYm9hcmQgRXRoZXJuZXQgd2l0aCB0aGUg
cGh5IGlzIHdvcmtpbmcuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IEN1cnJlbnRseSBJJ20g
bm90IGFibGUgdG8gZ2V0IHRoZSBsaW5rIHVwLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJ
IGFscmVhZHkgY29tcGFyZWQgaXQgdG8gdGhlIEJTUCBrZXJuZWwsIGJ1dCBJIGRpZG4ndCBmb3Vu
ZD4NCj4gPiA+ID4gPiA+ID4+IGFueXRoaW5nDQo+ID4gPiA+ID4gPiBoZWxwZnVsLiBUaGUgQlNQ
IGtlcm5lbCBpcyB3b3JraW5nLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBEbyB5b3Uga25v
dyBpZiB0aGVyZSBpcyBzb21ldGhpbmcgaW4gdGhlIGtlcm5lbCBtaXNzaW5nIGFuZA0KPiA+ID4g
PiA+ID4gZ290IGl0PiA+PiBydW5uaW5nPw0KPiA+ID4gPiANCj4gPiA+ID4gWWVzLCB5b3UgbWF5
IGp1c3QgcmV2ZXJ0IHRoZSBmb2xsb3dpbmcgY29tbWl0IGJhYmZhYTk1NTZkNw0KPiA+ID4gPiAo
ImNsazo+ID5pbXg6IHNjdTogYWRkIG1vcmUgc2N1IGNsb2NrcyIpDQo+ID4gPiA+IA0KPiA+ID4g
PiBBbHRlcm5hdGl2ZWx5LCBqdXN0IGNvbW1lbnRpbmcgb3V0IHRoZSBmb2xsb3dpbmcgc2luZ2xl
IGxpbmUNCj4gPiA+ID4gYWxzbz4gPmhlbHBzOg0KPiA+ID4gPiANCj4gPiA+ID4gaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0
L3RyZWUvZHJpdmVycy9jbGsvaW14L2Nsay1pbXg4cXhwLmM/aD12NS4xOSNuMTcyDQo+ID4gPiA+
IA0KPiA+ID4gPiBJIGp1c3QgZm91bmQgdGhpcyBvdXQgYWJvdXQgdHdvIHdlZWtzIGFnbyBiZWZv
cmUgSSB3ZW50IHRvDQo+ID4gPiA+IHZhY2F0aW9uPiA+YW5kIHNpbmNlIGhhdmUgdG8gZmluZCBv
dXQgd2l0aCBOWFAgd2hhdA0KPiA+ID4gPiBleGFjdGx5IHRoZSBpZGVhIG9mIHRoaXMgY2xvY2tp
bmcvU0NGVyBzdHVmZiBpcyByZWxhdGVkIHRvIG91cj4NCj4gPiA+ID4gPmhhcmR3YXJlLg0KPiA+
ID4gPiANCj4gPiA+ID4gQE5YUDogSWYgYW55IG9mIHlvdSBndXlzIGNvdWxkIHNoZWQgc29tZSBs
aWdodCB0aGF0IHdvdWxkIGJlDQo+ID4gPiA+IG11Y2g+ID5hcHByZWNpYXRlZC4gVGhhbmtzIQ0K
PiA+ID4gPiANCj4gPiA+ID4gPiA+IFRoYW5rcywNCj4gPiA+ID4gPiA+IFBoaWxpcHANCj4gPiA+
ID4gDQo+ID4gPiA+IENoZWVycw0KPiA+ID4gPiANCj4gPiA+ID4gTWFyY2VsDQo+ID4gDQoNCg==

