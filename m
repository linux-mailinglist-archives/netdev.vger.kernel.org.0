Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F1331CBCB
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhBPOX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:23:57 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:58656 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhBPOXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 09:23:50 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 11GEL9eA006563; Tue, 16 Feb 2021 23:21:10 +0900
X-Iguazu-Qid: 34tMK0YvjOp49yXNIn
X-Iguazu-QSIG: v=2; s=0; t=1613485269; q=34tMK0YvjOp49yXNIn; m=mU9/KXsCfUUynGn12IkiAO7rYCNEbrnOBscp2b+oV5A=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1513) id 11GEL6XT026383;
        Tue, 16 Feb 2021 23:21:07 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11GEL6nN013044;
        Tue, 16 Feb 2021 23:21:06 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11GEL5Lg019986;
        Tue, 16 Feb 2021 23:21:06 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clvIhSanAEGhYKNYLIJE/9ka7osTAbL0Da5UKGlBIfH6OFIieuXysvizkfPD3sdjwSQR7I+MHAsadvFJvIxwjf2twkJ8ujGy4bo2ER2MDkIG7+hcaxP/dLrvsTdlMqs4dwic8l+Le0d0afDWB5nXs4BT7AHOx1FKg7A1sFS5vO6LtfGd13kQLVZN09xbjSuvQJYJGPYgZbS32+9BoW3Vo5S0/QIqMsUQCQSH5YhR9W/kEYgi5EFqQTVb1gXIkqlDDzkxDdhissIo7QqXn3u9IpHYjTN0srIYbtFcUVvBGxFYr7oL1XU7DUVcG7G6ZdOP0HdqiDPhasPTTt8DFZ1nBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFcBs3JYkhb6fMhUd/pJHHDszbnPJxHa73gS/C2OX1E=;
 b=O/zSV13nFkVmX/w9/RPxuKQ/som0eL5PwxQuMFQJFFKxLGPBWwlr6G93dmL5aF06ym2dhNCnq+cHjFMN4z8In4LNMAEBIttfBiviuFYhr6Tt+hMuXwbhEIEtBvosc1tNPQiTLdw/ElZ9V343W//OxxxnkKkHP1K/1fNMiuMX0qLz1tCnHuzPlWWuwLUxH6QgW2nKiH8yPtFkw/IJAOvLcKsQeLKY5AAJIFTM1PiQ9fyvxyC2Fb/sFNaV/1k/Pf9SoSsUb5yBeRgm0nZ0CiOabOPpSW0knRBUj5URZFnQt7eB4C4MmO0heM3WiSzhcng/WB9GnkvCeEeH+FD6vmqLLw==
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
Thread-Index: AQHXBAg4vV8NxMrm20q1gNg3jtvtOKparL4AgAAJsgCAABTF8IAACUvw
Date:   Tue, 16 Feb 2021 14:21:04 +0000
X-TSB-HOP: ON
Message-ID: <TYAPR01MB2990FAA79F1C3F3A0441721892879@TYAPR01MB2990.jpnprd01.prod.outlook.com>
References: <20210216130449.3d1f0338@canb.auug.org.au>
 <TY2PR01MB3692F75AF6192AB0B082B493D8879@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <CA+G9fYs=hDh7mYb0E=9hC14f5dSNocH=dANLrvMfxk+hSjS5bg@mail.gmail.com>
 <TYAPR01MB29904A0E8BE08D4BDFDA517C92879@TYAPR01MB2990.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB29904A0E8BE08D4BDFDA517C92879@TYAPR01MB2990.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: yes
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=toshiba.co.jp;
x-originating-ip: [103.91.184.0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72464e4f-1d22-46fd-8b9e-08d8d28617f3
x-ms-traffictypediagnostic: TYCPR01MB6317:
x-microsoft-antispam-prvs: <TYCPR01MB6317A4E109E709A5837ED3DC92879@TYCPR01MB6317.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LNzBo8mBUjWCN+0wRTs0/DsP1+mMsuruUt1K/2Ce7RNmXDQD8kKD9Xx9vBWXsfqKqYcwT5mYEQo8lrTFA3ZTDuE7taw9Od79qDZnvaOwrat2gOIbLYhMr2yvFIyWqaLu0nVvQpHHTuz6NI759QVMTibSwYET8fLSG5C4Ac+JYJmy7OVB57Ds7jCTI7+yYk5XNAX94XRojOVY0dbC1/NqAwG2Vh6j2HVT+eSc8ADpyNboCWtjkZJxWsUdyavKKUO9YkJoOX08FgQCfD+6kOQDA9DU2wEfrIdJNRjBTyrq16rbiSlZL8Q+RuSplikRjGc4J98rk1fxnokQOI7rSNZzaGiXZDTsLlPW4+UbdWHKZpesKozPPJAeRt6v+H7gmnc6QqiQXaU9snIBB0PfD4LM3MTt1N3VqrNQ88HnCYsIwCJaUKWXo7Iotbcz1wgaIyVM0mbk7BdWIv55nHwgUat6SynR8D0cdZ6xHKT6ob6KZk6B15mKBtZtV2J+8obS1wdZ2yqzbDDSTjSCTGrqyQNMdxDFdEzMv3atc7wb88pUBV5wB0/T+lyj+ToWYQYpGdSigg16G9YcFZOvuQ/23j0kE7ymqiA0/ckeT+i5f9DY1J4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB2990.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(478600001)(6506007)(64756008)(53546011)(66476007)(66556008)(66616009)(7696005)(2906002)(66446008)(33656002)(99936003)(55016002)(9686003)(86362001)(52536014)(8676002)(2940100002)(71200400001)(8936002)(5660300002)(66946007)(54906003)(966005)(76116006)(7416002)(316002)(110136005)(4326008)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QVV3R1VCNTZMcXB2N2F6dTRBSDFJSXl6ZE5MK01tMUl6MFMrUDV2bE11aTMy?=
 =?utf-8?B?dmoxd2M0UC8wMTkreEh1Wk1Ub095OGFFNWxtM1hLTm1aaTFJTU1JTFlDVDFy?=
 =?utf-8?B?SmxJTUhZWGd6bVBNckxDbTgzRnpiTE95bDNtUkpJZTRUVVByY3puRmJLeTFr?=
 =?utf-8?B?TkR5NUs3M3ZlOFFFeGtHc00za0tzTkN3K1VuM2toZWNPZktZYmJMbEo2QkVC?=
 =?utf-8?B?N2tjTE14UktEeFNHeWNWaUI3TVY2TlE2d2xuRnhoOFVoaWw2ekMxRUhpRjdQ?=
 =?utf-8?B?c2RIVHJCTTVZRy9lZVFkSk1PMGdDQWtLek1tUFBhZHh1STBWcGw4WjF1c21G?=
 =?utf-8?B?UllzSG54aFl6UFN4ZDJYYmE5V2R3Rzk5MGdBdmh0OVdaVStUdUJVbDdHRTZI?=
 =?utf-8?B?eG5qbDJJbTFLeFJZemlka05OaHhBVXU4RkJwWm4xVjBsdUJPR2RvcVBkUFZ0?=
 =?utf-8?B?NXc3c1phalVOYlU1VFhPbVo3Wm0xZjlIQWI1WmZtdkdPdS9yWkEyU2V6SVJi?=
 =?utf-8?B?OHl1N3RUK01EUmFheU40MExJaUovVnI3Sjh0YndDV3BhZlc5ZTByL3RzZmhp?=
 =?utf-8?B?M1RQRG9vVTdMYzJEZmxWYXNjZXRTOUNGbUdObzRrOHN5TVlGREJjZmFxYkxF?=
 =?utf-8?B?cE9ZZEs0YXQ0WU85M0tCYUNPQnBVYmpoc0NQV2lrSjZRNGhXRWVhNndhQ2dK?=
 =?utf-8?B?NksxTHJ2enhtbGFpUlNQNWlHVXZ0Zko5c0IrNnZ3SUdqNHM2WnVDby9KbURH?=
 =?utf-8?B?bzB3Y1lLdWZQeUtDQy9FQnFtL0t1SjN3V2VHaDdpd3VaOWdMWTRHU3hBR0lY?=
 =?utf-8?B?SUpYNS9nRFptZmN3dmxHeW41UXpObUU5L3dwQUkzNHZlOUhPRjVhOFdrc0Zy?=
 =?utf-8?B?UkVIYmhzbjF3N00vTjFhZk5zTmFybFdxTTJJYmNmT3ZFeFlpQ0FqUjJDVWk3?=
 =?utf-8?B?WjF3d1dnWjdiT1dLMVRNS3JFcy85akZMRWVqVlczOXV6SEdEWllkdTZlRHhV?=
 =?utf-8?B?U2R5U1lTRHp1NHV1djVNSUVrVzVyVDlNWFBqNjJiMjR3ZzYzdkZvY1U0UFhD?=
 =?utf-8?B?WS82cy9KL0lNWUJSYTZFV0pUZUJoSG9TNjJoL1NkYy9LdnF5K1NPdWFqeG1p?=
 =?utf-8?B?UlVQRldhVmhacDN4a0MwSjQvUVRzNThQUHN5OWh2VS9sazBkS2hUVm10NnU4?=
 =?utf-8?B?RDJra0Z1U2p3VmxzcmlsVnUzTmVIZzRLQnE2TFlVVHFRS0d2TVZueFFsSjNO?=
 =?utf-8?B?d2hjM2xMQ1ZnUzVORkszdWltYjVxb1I0dkozMndsYTVtT3dvV0YxcUV6cGtN?=
 =?utf-8?B?RXRzV2EyQnc5S2VpS0xEUGY0UWNIV05neUxDQVp1UGd2SzN6bVpEVk1KdHVT?=
 =?utf-8?B?SU83SDRlZFhRN0dGNzhBUW41OTYrQVUvNVN2VDRSNHlTMXdEZ0EzNGsybERM?=
 =?utf-8?B?eGttZnFDcHFPRENhSzZ0UjY1c2preGg2eVFjZlF2Z1BvUnh2NGVONjdiUnZR?=
 =?utf-8?B?eHRwOTZRbUZyZHdhaDB4M1IrRWJORVowN2ZzUVlKOHFkQWgrZGJUZWpjVTN5?=
 =?utf-8?B?aWFMSG51WnZjL3k2WmN3bk9reVEzTHdCZEk3NWwzaHk0aXF6Rjl4bDlzQkxm?=
 =?utf-8?B?ZkJlMWJSc2VkanROZkJRWVJxOW5kdTFkN0FkZm0rd09KRkt4SVQ4UmdycCto?=
 =?utf-8?B?b0dJS1ZGdWVxc2c4eUNQZXNwT09qSzRKSHlhdjRBNkJwMG1uSDlpMktkNHhz?=
 =?utf-8?Q?Pbj7UmMhBxhI8MZiTA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_TYAPR01MB2990FAA79F1C3F3A0441721892879TYAPR01MB2990jpnp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYAPR01MB2990.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72464e4f-1d22-46fd-8b9e-08d8d28617f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 14:21:04.1773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5P/rXIwmdMMcMGCosd80yYUU4MQ6J8tbs5SmHpYKR5TsSwWXBfJPTopZjItMiB99bKB89v2lpZYF14/emQ1/Jncqwvyo3BaAaSYudWhoa/LzuswFcAf1+XjzYQoSPC8a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6317
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_TYAPR01MB2990FAA79F1C3F3A0441721892879TYAPR01MB2990jpnp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksDQoNCkkgYXR0YWNoZWQgYSBwYXRjaCB3aGljaCByZXZpc2UgdGhpcyBpc3N1ZS4NCklmIEkg
bmVlZCB0byBzZW5kIHdpdGggZ2l0IHNlbmQtZW1haWwsIHBsZWFzZSBsZXQgbWUga25vdy4NCg0K
QmVzdCByZWdhcmRzLA0KICBOb2J1aGlybw0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+IEZyb206IGl3YW1hdHN1IG5vYnVoaXJvKOWyqeadviDkv6HmtIsg4pah77yz77y377yj4pev
77yh77yj77y0KQ0KPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxNiwgMjAyMSAxMDo0NyBQTQ0K
PiBUbzogTmFyZXNoIEthbWJvanUgPG5hcmVzaC5rYW1ib2p1QGxpbmFyby5vcmc+OyBZb3NoaWhp
cm8gU2hpbW9kYSA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5jb20+OyBTdGVwaGVuDQo+
IFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9yZy5hdT4NCj4gQ2M6IERhdmlkIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47IE5ldHdvcmtpbmcgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBP
bG9mIEpvaGFuc3NvbiA8b2xvZkBsaXhvbS5uZXQ+OyBBcm5kDQo+IEJlcmdtYW5uIDxhcm5kQGFy
bmRiLmRlPjsgQVJNIDxsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc+OyBCYXJ0
b3N6IEdvbGFzemV3c2tpDQo+IDxiZ29sYXN6ZXdza2lAYmF5bGlicmUuY29tPjsgTGludXggTmV4
dCBNYWlsaW5nIExpc3QgPGxpbnV4LW5leHRAdmdlci5rZXJuZWwub3JnPjsgTGludXggS2VybmVs
IE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IGxrZnQtdHJp
YWdlQGxpc3RzLmxpbmFyby5vcmcNCj4gU3ViamVjdDogUkU6IGxpbnV4LW5leHQ6IG1hbnVhbCBt
ZXJnZSBvZiB0aGUgbmV0LW5leHQgdHJlZSB3aXRoIHRoZSBhcm0tc29jIHRyZWUNCj4gDQo+IEhp
LA0KPiANCj4gVGhuYWtzIGZvciB5b3VyIHJlcG9ydC4NCj4gDQo+ID4gTEtGVCBidWlsZGVycyBh
bHNvIGZvdW5kIHRoaXMgcHJvYmxlbSB3aGlsZSBidWlsZGluZyBhcm02NCBkdGIuDQo+ID4NCj4g
PiA+IFRoaXMgYCBjYXVzZXMgdGhlIGZvbGxvd2luZyBidWlsZCBlcnJvciBvbiB0aGUgbmV4dC0y
MDIxMDIxNi4NCj4gPiA+DQo+ID4gPiAgIERUQyAgICAgYXJjaC9hcm02NC9ib290L2R0cy90b3No
aWJhL3RtcHY3NzA4LXJtLW1icmMuZHRiDQo+ID4gPiBFcnJvcjogYXJjaC9hcm02NC9ib290L2R0
cy90b3NoaWJhL3RtcHY3NzA4LXJtLW1icmMuZHRzOjUyLjMtNCBzeW50YXggZXJyb3INCj4gPiA+
IEZBVEFMIEVSUk9SOiBVbmFibGUgdG8gcGFyc2UgaW5wdXQgdHJlZQ0KPiA+ID4gc2NyaXB0cy9N
YWtlZmlsZS5saWI6MzM2OiByZWNpcGUgZm9yIHRhcmdldCAnYXJjaC9hcm02NC9ib290L2R0cy90
b3NoaWJhL3RtcHY3NzA4LXJtLW1icmMuZHRiJyBmYWlsZWQNCj4gPiA+IG1ha2VbMl06ICoqKiBb
YXJjaC9hcm02NC9ib290L2R0cy90b3NoaWJhL3RtcHY3NzA4LXJtLW1icmMuZHRiXSBFcnJvciAx
DQo+ID4gPiBzY3JpcHRzL01ha2VmaWxlLmJ1aWxkOjUzMDogcmVjaXBlIGZvciB0YXJnZXQgJ2Fy
Y2gvYXJtNjQvYm9vdC9kdHMvdG9zaGliYScgZmFpbGVkDQo+ID4NCj4gPiByZWY6DQo+ID4gaHR0
cHM6Ly9naXRsYWIuY29tL0xpbmFyby9sa2Z0L21pcnJvcnMvbmV4dC9saW51eC1uZXh0Ly0vam9i
cy8xMDMzMDcyNTA5I0wzODINCj4gPg0KPiANCj4gVGhpcyBzZWVtcyB0byBiZSBhIHByb2JsZW0g
Zml4aW5nIHRoZSBjb25mbGljdC4NCj4gDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L25leHQvbGludXgtbmV4dC5naXQvY29tbWl0Lz9pZD1jNWUxODhl
YTA4MjkwZDliNjYyNWI0YmVmMzIyMDEyYzBiDQo+IDE5MDJkNw0KPiANCj4gYGBgDQo+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2Jvb3QvZHRzL3Rvc2hpYmEvdG1wdjc3MDgtcm0tbWJyYy5kdHMg
Yi9hcmNoL2FybTY0L2Jvb3QvZHRzL3Rvc2hpYmEvdG1wdjc3MDgtcm0tbWJyYy5kdHMNCj4gaW5k
ZXggMjQwN2IyZDg5YzFlOS4uMzc2MGRmOTNhODliNSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02
NC9ib290L2R0cy90b3NoaWJhL3RtcHY3NzA4LXJtLW1icmMuZHRzDQo+ICsrKyBiL2FyY2gvYXJt
NjQvYm9vdC9kdHMvdG9zaGliYS90bXB2NzcwOC1ybS1tYnJjLmR0cw0KPiBAQCAtNDksNCArNDks
MjIgQEANCj4gDQo+ICAmZ3BpbyB7DQo+ICAJc3RhdHVzID0gIm9rYXkiOw0KPiArfTtgDQo+ICsN
Cj4gKyZwaWV0aGVyIHsNCj4gKwlzdGF0dXMgPSAib2theSI7DQo+ICsJcGh5LWhhbmRsZSA9IDwm
cGh5MD47DQo+ICsJcGh5LW1vZGUgPSAicmdtaWktaWQiOw0KPiArCWNsb2NrcyA9IDwmY2xrMzAw
bWh6PiwgPCZjbGsxMjVtaHo+Ow0KPiArCWNsb2NrLW5hbWVzID0gInN0bW1hY2V0aCIsICJwaHlf
cmVmX2NsayI7DQo+ICsNCj4gKwltZGlvMCB7DQo+ICsJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0K
PiArCQkjc2l6ZS1jZWxscyA9IDwwPjsNCj4gKwkJY29tcGF0aWJsZSA9ICJzbnBzLGR3bWFjLW1k
aW8iOw0KPiArCQlwaHkwOiBldGhlcm5ldC1waHlAMSB7DQo+ICsJCQlkZXZpY2VfdHlwZSA9ICJl
dGhlcm5ldC1waHkiOw0KPiArCQkJcmVnID0gPDB4MT47DQo+ICsJCX07DQo+ICsJfTsNCj4gIH07
DQo+IGBgYA0KPiANCj4gU3RlcGhlbiwgY291bGQgeW91IGZpeCB0aGlzPw0KPiANCj4gQmVzdCBy
ZWdhcmRzLA0KPiAgIE5vYnVoaXJvDQo=

--_002_TYAPR01MB2990FAA79F1C3F3A0441721892879TYAPR01MB2990jpnp_
Content-Type: application/octet-stream;
	name="0001-arm64-dts-visconti-Fix-parse-error-for-TMPV7708-RM-m.patch"
Content-Description: 0001-arm64-dts-visconti-Fix-parse-error-for-TMPV7708-RM-m.patch
Content-Disposition: attachment;
	filename="0001-arm64-dts-visconti-Fix-parse-error-for-TMPV7708-RM-m.patch";
	size=1151; creation-date="Tue, 16 Feb 2021 14:19:33 GMT";
	modification-date="Tue, 16 Feb 2021 14:19:14 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3ZDg1MmU2MWRmMjA0ODdlZmQyYWUzNjI3Y2NlNDk4Yjg1ZDJlODg0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOb2J1aGlybyBJd2FtYXRzdSA8bm9idWhpcm8xLml3YW1hdHN1
QHRvc2hpYmEuY28uanA+CkRhdGU6IFR1ZSwgMTYgRmViIDIwMjEgMjM6MDU6MDkgKzA5MDAKU3Vi
amVjdDogW1BBVENIXSBhcm02NDogZHRzOiB2aXNjb250aTogRml4IHBhcnNlIGVycm9yIGZvciBU
TVBWNzcwOCBSTSBtYWluCiBib2FyZAoKVGhlIHBhdGNoIGZpeCBjb21taXQ6IGM1ZTE4OGVhMDgy
OTBkOSAoIk1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gKJ25ldC1uZXh0L21hc3RlciciKS4K
VGhpcyBtZXJnZSBjb21taXQgZml4ZXMgdG1wdjc3MDgtcm0tbWJyYy5kdHMncyBjb25mbGljdCwg
YnV0IHRoZSB0eXBvCmNhdXNlcyBhIHBhcnNlIGVycm9yLiBUaGlzIHJlbW92ZXMgdGhpcyB0eXBv
LgoKcmVmOiBodHRwczovL2dpdGxhYi5jb20vTGluYXJvL2xrZnQvbWlycm9ycy9uZXh0L2xpbnV4
LW5leHQvLS9qb2JzLzEwMzMwNzI1MDkjTDM4MgpSZXBvcnRlZC1ieTogTmFyZXNoIEthbWJvanUg
PG5hcmVzaC5rYW1ib2p1QGxpbmFyby5vcmc+ClNpZ25lZC1vZmYtYnk6IE5vYnVoaXJvIEl3YW1h
dHN1IDxub2J1aGlybzEuaXdhbWF0c3VAdG9zaGliYS5jby5qcD4KLS0tCiBhcmNoL2FybTY0L2Jv
b3QvZHRzL3Rvc2hpYmEvdG1wdjc3MDgtcm0tbWJyYy5kdHMgfCAyICstCiAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2Jvb3QvZHRzL3Rvc2hpYmEvdG1wdjc3MDgtcm0tbWJyYy5kdHMgYi9hcmNoL2FybTY0L2Jvb3Qv
ZHRzL3Rvc2hpYmEvdG1wdjc3MDgtcm0tbWJyYy5kdHMKaW5kZXggMzc2MGRmOTNhODliNTcuLjIz
MGY0ODdkZDZiMmUzIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2Jvb3QvZHRzL3Rvc2hpYmEvdG1w
djc3MDgtcm0tbWJyYy5kdHMKKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy90b3NoaWJhL3RtcHY3
NzA4LXJtLW1icmMuZHRzCkBAIC00OSw3ICs0OSw3IEBAICZ3ZHQgewogCiAmZ3BpbyB7CiAJc3Rh
dHVzID0gIm9rYXkiOwotfTtgCit9OwogCiAmcGlldGhlciB7CiAJc3RhdHVzID0gIm9rYXkiOwot
LSAKMi4zMC4wCgo=

--_002_TYAPR01MB2990FAA79F1C3F3A0441721892879TYAPR01MB2990jpnp_--
