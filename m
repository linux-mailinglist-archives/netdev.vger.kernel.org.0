Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896A531CB69
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 14:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhBPNuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 08:50:25 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:32820 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhBPNuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 08:50:22 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 11GDlYLu016877; Tue, 16 Feb 2021 22:47:34 +0900
X-Iguazu-Qid: 2wGr679RaPzzBbRgxs
X-Iguazu-QSIG: v=2; s=0; t=1613483254; q=2wGr679RaPzzBbRgxs; m=tb65jn7FIuNFo2VnfA85gKn0GTVb2lZQdz90Y5O7yuo=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1110) id 11GDlU85039532;
        Tue, 16 Feb 2021 22:47:31 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11GDlU6g004234;
        Tue, 16 Feb 2021 22:47:30 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11GDlT2N031327;
        Tue, 16 Feb 2021 22:47:29 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPzRYqvII/5dVup35a4cPgAA6ozQzV9XDaRQJ4o5MZNgpJt3U0ykE516ixHFRxDVQ14qXiriBtVjopypKoFmeLfUqbV/7iEQ2JTT5HZH/ovu5qwFxuffrXeJOzBZjrse8vFfAFG/R5sm67UTQYE1zOTLRjGI0RLhvjxBwGvRD3nGHhfeK0Cxd46SF/JJcHCK4StSOOKnn4FCSDUTgGpaBkrr1c57Xlnfwb67mxT0pnilKpDxU+qxtXUiGFBWfATjRepUbrBIMooIek4+9MI7i2G8J/9HSdEfVeepqMc71kvTHylQhxcUGWKv8foqyLuCfdrsyw9au4TAUfjeEMOZ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lM5PiJhBKkca8BTrb+vSydLwKcsUGY8hgi8YN4jCpTU=;
 b=HWtpB9BnYYlLaf4zJ7xwo7L9orIxs2TK1Ymf+sCuFNZnhR/VR0edHYxk7vx9B/wYb9NizuLDv/UYPjUF3lf+5WUNOa+RJxEo8ERImM67Bszw7ChxngfYuchHnn8HcFz2Hk6QsrOIgySMHrENVgTjiUUFf1GeHMVHV8gqQicxDbHc5cMSpMQitEbfbLRDrEnlLKbGTszUjJWTiLKe4DXCPcicfe+eSvtRNPYsdF2dZKuFRKmnj+G58KPq9J/rTIRlH4F/0Ime+nh3cNVRwOx9Ho1oW1XECLow2I4VkHTGo5SzI2Ae43Q0HgJntjyJX/z4MVCBDzAAwumK/571cq1qPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <naresh.kamboju@linaro.org>, <yoshihiro.shimoda.uh@renesas.com>,
        <sfr@canb.auug.org.au>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <olof@lixom.net>,
        <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <bgolaszewski@baylibre.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lkft-triage@lists.linaro.org>
Subject: RE: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Topic: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Index: AQHXBAg4vV8NxMrm20q1gNg3jtvtOKparL4AgAAJsgCAABTF8A==
Date:   Tue, 16 Feb 2021 13:47:27 +0000
X-TSB-HOP: ON
Message-ID: <TYAPR01MB29904A0E8BE08D4BDFDA517C92879@TYAPR01MB2990.jpnprd01.prod.outlook.com>
References: <20210216130449.3d1f0338@canb.auug.org.au>
 <TY2PR01MB3692F75AF6192AB0B082B493D8879@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <CA+G9fYs=hDh7mYb0E=9hC14f5dSNocH=dANLrvMfxk+hSjS5bg@mail.gmail.com>
In-Reply-To: <CA+G9fYs=hDh7mYb0E=9hC14f5dSNocH=dANLrvMfxk+hSjS5bg@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=toshiba.co.jp;
x-originating-ip: [103.91.184.0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efef16c9-3c32-4530-b9ba-08d8d28165da
x-ms-traffictypediagnostic: TYAPR01MB2704:
x-microsoft-antispam-prvs: <TYAPR01MB27041487D7652101341BBCF592879@TYAPR01MB2704.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U7/ZIhqPL3/9dBvN7yEi73Klw4AJ+QuCDyLOnel+BDKntO/zcZuMZbwxcN6CPHsB9yZV700nKbGVfQylYxfZxuxOOmUhLygG7Ynla5yQMyABH0IdUby7ngoOMTDSySy4UvGKTZQibjJ0usqp0ESUvsxweq+CaaHyPymKYAd0gANkX3xyIrKiNviwPZ/r322SJ4cnCJ7+DJ2/cOOURjLS/OxynlMQBEmTnBAfLQaMnkUM9giyeK8UFMxgPKpitHbJQYVDWrWdMZgdx8iBquathy7H7xwdKSArvJS/Co7h/Og9F32DXBSzs1c/JWGoronVOsaOdJbc1vjMj5K+2KIO8SUP79UNOUF1VZyIrfKQOh+Fc//YB2AJqMV6i6BZqXR1C7l3nppGsGzjVC07fFP0ftAZdQrXX/diwhh4CU9gbrHMQJr9gQ27JZ6M2BI7f3808ccrevEwpIUpL+zR6rgL1OZEWb4BvGhsq2dF3nMePk5jlFR6NjAJg6F1sM3e4Sa61gf4Xb2govA7ytp77UAJxuYJMUvMCkjZrlil9o6I9fYJo35BpitaLrtJoe4I6UrqzxdAVSTzzGT65/SVgaK0y7BTsAAIDJS7hB4btXGNU9I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB2990.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(66556008)(66476007)(110136005)(33656002)(64756008)(66446008)(66946007)(9686003)(55016002)(83380400001)(54906003)(26005)(6506007)(76116006)(316002)(186003)(2906002)(966005)(478600001)(71200400001)(7696005)(4326008)(8936002)(7416002)(8676002)(86362001)(52536014)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZjcyN1R3Y040SHdSTkNpMG95QXBqdTQwZVRtdzE0VkkycVl6QWowVjFlblVj?=
 =?utf-8?B?RHN3a1RhdW9ieFJ6M2FSSGp1NmNSMjZLNVNJcTdGRDlQWFJGMDgvNkN0U25P?=
 =?utf-8?B?MGQrZUlTRVpqWWJud0ttSjBqMkMvNkxZNHZqUFRxWEswNllNV2NZYmZNaE5z?=
 =?utf-8?B?aXNJL21FQWpYTnNjdXA1ZFg0OTliVE9vaXVETmNRZE1kNXZLOTh4Tkd4TW5R?=
 =?utf-8?B?aGloZDlUSmljSzVmTE96Si9ITGswVXl4dnhVOFI3VXJDZ0FKSFpZMDAxMDlr?=
 =?utf-8?B?WE1pNEh5V1E0MzBlSUoxcDh1ajhlRHRVL1JFOXhKaXZGamtpMEZ5eUlHeWJu?=
 =?utf-8?B?bERtUWExSmNOc2Vjd2F1Qk9oSmxBQlhNckg3RUxiZ0MwRVJLb3ovWXpMdEFL?=
 =?utf-8?B?WFJiOXQvMTE3Wi9BcEN4aEZoRzdxb0xHQkN1N3hVWjhhbkhPNS91MXpkMzRQ?=
 =?utf-8?B?ZU1kTkE4UWJ5b0FMVHVSU2h4aHJGOVRiTmZlQ0FxbkRZMGloVE4wRzBUY0Nk?=
 =?utf-8?B?Q3lTVkZtVW8wMWJ4OVJiNm9jK3B6T1hDMXlQL0ZCM0RqVEI2d09tQml6blBy?=
 =?utf-8?B?cm9Zd2ljSE5YS3BWMFF0YU1nSUVSOU1sS2d4d1BZdVlmQXhtYWVSZWFwQk44?=
 =?utf-8?B?aWs5enpQSEFyVTFRR01DWkNoRG4zY29IUGRiNmFlMlVubkwrTzBRRE1Ic1h3?=
 =?utf-8?B?Mmg0NjgxYkdRM0xZVllURUNGOFc1UFg4b1crUzNoek5CSDY3ZU5DVXd2Vy9E?=
 =?utf-8?B?bEtrZndOZmhxWXhiS2xzS2g3VU4zejA0Y3UvV3R1L2tnckFoUGcvWlRJYVBI?=
 =?utf-8?B?VGs5OTl3UnlDM3ZsZXlnSEJiODF2UzhjZER4VTFyN1FOYWYxbmJPZlhUenl5?=
 =?utf-8?B?VVpIZVBtcnV0WUlXQzVRNnVmV3RreDlOL1NJb2tIaHZ4Q1k2U3JJemFXK3A5?=
 =?utf-8?B?MkJKcEp5ZEM0eVZmL3I5Nm1nYWxXNG9SdmtsN2h3U0FKa3lEL3grMnIrb1Y5?=
 =?utf-8?B?WThxaFJMZXdnV0dUKzM2U3VzWXg0SWU0R1dsYWFTVmcxRW1XWTB1N2lVZFds?=
 =?utf-8?B?dnpLOCtZSUJGTThZTTlWaEZJdUpCYWVNM2xBYVVmQXkzbmw4eG5vSHVLanVp?=
 =?utf-8?B?enVNNXpiWmtlcmlueEhjTzlDVzYvWkFsSkE1RXpXbHFmekE4MnNoMGhqZUJC?=
 =?utf-8?B?cmF4RHpWMGNqOUNLT09tUExBVDNaNkp3N0gzVGJvYzkxekN3MHFqZm81T3M1?=
 =?utf-8?B?VlBDc04vTGZvRGxCb2JPVnhIakFabU9uc3JERXgyd2ZXSE81WnA3UFRYUjFk?=
 =?utf-8?B?alhUSU8vOU5ncVNPbm9ZQmxyZzVEYmN5RDY0N1hWeHI5MWlOOFY1RGcrV0V2?=
 =?utf-8?B?R1gyWDdrbm5HajljNVVoVTdBQlVQM2twYUcxdEx4dmpCTnRQUVMzMERjLzdR?=
 =?utf-8?B?M1ovN3pHY0Y1VGJ3Um9JdnM2TjB0ek14SmhBK2dRai9LV1JnOGJhdTVmVTBy?=
 =?utf-8?B?MExTQUJpTlhaZUEyOTNzSDl1Wnp6ZjlvMUV2K1plSzNwR1ljaWVVZ3JNQis5?=
 =?utf-8?B?RkRZKy82eEdkUlVMRm5oSU13SGhLeFp4alBYM1ZEM2FWM0dtV0Q1ZWU0OHlv?=
 =?utf-8?B?UGU3VkFrbTM2MHFpZlFiWklsck4vbGxZaXBlVlZUUDQvTUg3SUIrYzAxSk9P?=
 =?utf-8?B?eFpqem1pRTVIN2ZpVTdmZmJqVHpxL2poVjNqZWlwdDhWajdJajNRSUgzUnY3?=
 =?utf-8?Q?sJtItY8ieV3YESj6Yw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYAPR01MB2990.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efef16c9-3c32-4530-b9ba-08d8d28165da
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 13:47:27.3343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: umJWgPYtcO/U+gqwk+aVugh43Ij+w8Pn09iaPpn96p3IOmSO9dq9T0qPaSZaq3J9v5j5kKtOE/WbvNbbMGDaMMJRa7xOgszGfdCcGrXwuo7YissGASqR9gIN9s4Nvr8n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2704
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClRobmFrcyBmb3IgeW91ciByZXBvcnQuDQoNCj4gTEtGVCBidWlsZGVycyBhbHNvIGZv
dW5kIHRoaXMgcHJvYmxlbSB3aGlsZSBidWlsZGluZyBhcm02NCBkdGIuDQo+IA0KPiA+IFRoaXMg
YCBjYXVzZXMgdGhlIGZvbGxvd2luZyBidWlsZCBlcnJvciBvbiB0aGUgbmV4dC0yMDIxMDIxNi4N
Cj4gPg0KPiA+ICAgRFRDICAgICBhcmNoL2FybTY0L2Jvb3QvZHRzL3Rvc2hpYmEvdG1wdjc3MDgt
cm0tbWJyYy5kdGINCj4gPiBFcnJvcjogYXJjaC9hcm02NC9ib290L2R0cy90b3NoaWJhL3RtcHY3
NzA4LXJtLW1icmMuZHRzOjUyLjMtNCBzeW50YXggZXJyb3INCj4gPiBGQVRBTCBFUlJPUjogVW5h
YmxlIHRvIHBhcnNlIGlucHV0IHRyZWUNCj4gPiBzY3JpcHRzL01ha2VmaWxlLmxpYjozMzY6IHJl
Y2lwZSBmb3IgdGFyZ2V0ICdhcmNoL2FybTY0L2Jvb3QvZHRzL3Rvc2hpYmEvdG1wdjc3MDgtcm0t
bWJyYy5kdGInIGZhaWxlZA0KPiA+IG1ha2VbMl06ICoqKiBbYXJjaC9hcm02NC9ib290L2R0cy90
b3NoaWJhL3RtcHY3NzA4LXJtLW1icmMuZHRiXSBFcnJvciAxDQo+ID4gc2NyaXB0cy9NYWtlZmls
ZS5idWlsZDo1MzA6IHJlY2lwZSBmb3IgdGFyZ2V0ICdhcmNoL2FybTY0L2Jvb3QvZHRzL3Rvc2hp
YmEnIGZhaWxlZA0KPiANCj4gcmVmOg0KPiBodHRwczovL2dpdGxhYi5jb20vTGluYXJvL2xrZnQv
bWlycm9ycy9uZXh0L2xpbnV4LW5leHQvLS9qb2JzLzEwMzMwNzI1MDkjTDM4Mg0KPiANCg0KVGhp
cyBzZWVtcyB0byBiZSBhIHByb2JsZW0gZml4aW5nIHRoZSBjb25mbGljdC4NCg0KaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV4dC9saW51eC1uZXh0Lmdp
dC9jb21taXQvP2lkPWM1ZTE4OGVhMDgyOTBkOWI2NjI1YjRiZWYzMjIwMTJjMGIxOTAyZDcNCg0K
YGBgDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy90b3NoaWJhL3RtcHY3NzA4LXJt
LW1icmMuZHRzIGIvYXJjaC9hcm02NC9ib290L2R0cy90b3NoaWJhL3RtcHY3NzA4LXJtLW1icmMu
ZHRzDQppbmRleCAyNDA3YjJkODljMWU5Li4zNzYwZGY5M2E4OWI1IDEwMDY0NA0KLS0tIGEvYXJj
aC9hcm02NC9ib290L2R0cy90b3NoaWJhL3RtcHY3NzA4LXJtLW1icmMuZHRzDQorKysgYi9hcmNo
L2FybTY0L2Jvb3QvZHRzL3Rvc2hpYmEvdG1wdjc3MDgtcm0tbWJyYy5kdHMNCkBAIC00OSw0ICs0
OSwyMiBAQA0KIA0KICZncGlvIHsNCiAJc3RhdHVzID0gIm9rYXkiOw0KK307YA0KKw0KKyZwaWV0
aGVyIHsNCisJc3RhdHVzID0gIm9rYXkiOw0KKwlwaHktaGFuZGxlID0gPCZwaHkwPjsNCisJcGh5
LW1vZGUgPSAicmdtaWktaWQiOw0KKwljbG9ja3MgPSA8JmNsazMwMG1oej4sIDwmY2xrMTI1bWh6
PjsNCisJY2xvY2stbmFtZXMgPSAic3RtbWFjZXRoIiwgInBoeV9yZWZfY2xrIjsNCisNCisJbWRp
bzAgew0KKwkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQorCQkjc2l6ZS1jZWxscyA9IDwwPjsNCisJ
CWNvbXBhdGlibGUgPSAic25wcyxkd21hYy1tZGlvIjsNCisJCXBoeTA6IGV0aGVybmV0LXBoeUAx
IHsNCisJCQlkZXZpY2VfdHlwZSA9ICJldGhlcm5ldC1waHkiOw0KKwkJCXJlZyA9IDwweDE+Ow0K
KwkJfTsNCisJfTsNCiB9Ow0KYGBgDQoNClN0ZXBoZW4sIGNvdWxkIHlvdSBmaXggdGhpcz8NCg0K
QmVzdCByZWdhcmRzLA0KICBOb2J1aGlybw0K
