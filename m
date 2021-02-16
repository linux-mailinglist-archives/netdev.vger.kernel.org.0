Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7879931C57C
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 03:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBPCXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 21:23:17 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:39144 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhBPCXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 21:23:14 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 11G2KaEL013987; Tue, 16 Feb 2021 11:20:36 +0900
X-Iguazu-Qid: 34tMK0YvjNyL0XPqRj
X-Iguazu-QSIG: v=2; s=0; t=1613442035; q=34tMK0YvjNyL0XPqRj; m=y3Xh8kZ4fDBfkpRo6r1eMc381bPF4JCGGtCCaYiTyIo=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id 11G2KXeN039126;
        Tue, 16 Feb 2021 11:20:33 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11G2KWgj001771;
        Tue, 16 Feb 2021 11:20:32 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11G2KWHU025366;
        Tue, 16 Feb 2021 11:20:32 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cg10BushYPxLfT6Y9TZk2FQUkhRpNCr7cSk6cwRCdNegDDtVwloOi0U/vgoajzExqnO6V7vi7OGN9egMR89OJuxoCx2CcPqGHoltaxQjaUfGlJBSETri1yqmNiVLo+2jUwfSKLjGfH95MzEW88Y8wSUQhRq6ZI9i/k9WFd6omTL7eav/dyDU1q//0O3qul5BoYft7igU20xZl9NhFgP8CzBPEaK5MY/TLSJ/VGusy7VjiAsH8VYXswNdly1yVlE2N1Q48iED38Pb1nHMlthcmZ/9PiHJSCPSEHmHQCsEwYwHYYrp7C4DA+yEbqvSflullHiWZ7dPvzi1snQ9JHLkZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJBrMTvk6nSxSbFqpp/ci70ko3pLhHFmxsEsVwmblh8=;
 b=RQhJfltAmkjtzBzZSMvlOpoCQTdOfZpFpnOg8mDmjCcVerMTftIexRtC5jlv1f8PPio9X3+kPpA5rwSwq6UmaUK5s7hSCamYJK4JtDUD0j8KaH03Cy4xVqo5KaLFJyUw9F4odUs7/XOw22eRO5rq6pGESk5Kz0bbruZeOXNh2VAnntwgdV0fyhctZpJFLvPVejHxTynHvun87Op82n7u6hgbbeEqypXf/vWkhsJmbmgrBWmCSCBDAqRcW/Rp3xg9A3rc0ejeVyoYi0z6TqGpJudq1W0kUIzQ5Xwzw+WVU7Np0GMkg+xdXwhqmlNmaC6DChGNexEdVR5OQqOOsVmYDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <sfr@canb.auug.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <olof@lixom.net>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <bgolaszewski@baylibre.com>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: RE: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Topic: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Index: AQHXBAg4vV8NxMrm20q1gNg3jtvtOKpaCnzA
Date:   Tue, 16 Feb 2021 02:20:29 +0000
X-TSB-HOP: ON
Message-ID: <OSBPR01MB2983FDFEF1D1E24E7C2DF0F692879@OSBPR01MB2983.jpnprd01.prod.outlook.com>
References: <20210216130449.3d1f0338@canb.auug.org.au>
In-Reply-To: <20210216130449.3d1f0338@canb.auug.org.au>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=toshiba.co.jp;
x-originating-ip: [103.91.184.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0db2f97-52e7-40cf-c0df-08d8d2216e55
x-ms-traffictypediagnostic: OS3PR01MB6392:
x-microsoft-antispam-prvs: <OS3PR01MB63928BFCBD7BE05EDA297D0292879@OS3PR01MB6392.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlZNBilmDTcFEyIKA1XnNtHIKFfJN2r0t7lU35e5kzH7GyWo3qR02YP5n85ooekq3cVxwKfY10ACCjsvnuaomrH+QoCYseVVKcBzXOIniF+5qS3Pu+TAK0l9fsX6xiNsWRp72RrxX2WTxA1s6IfQzAqrgAwGkiqmum9HhFfl2vPXqZErrFZ3A5L8CEIotfbMKXZh0xvASGduHSq7qc3uCcNGepPRD2DzjNOvTF6y5XhPnH2/1hLCaHbe5IJzmDiKyhqV/sg1ngtm67rysv0UJMwiPfZyj5ccie0Izt7L0xbUcFCW+jh1ipP+/WYBOi7X8zD3vCo8yfzvxkiNWp7RloElbtk1DpDA8ovFg5agrCWSQikoetpXk5dTHIUobDvpm824vv3kaiKIiwpXFD1+AgKGuCmpI6L73mZNdU9Me3BMD5CLJHNulyKdeBGAfB6LfEeAySpmDrXgHc+4qCOoo3wpwkjVi6tD87zOYqfpTcnciHsIY2eLVofcwzpbju4at3lqmHt8bV2geSHXnUFlmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2983.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(86362001)(66446008)(478600001)(66556008)(66946007)(64756008)(2906002)(52536014)(76116006)(5660300002)(33656002)(66476007)(186003)(110136005)(6506007)(53546011)(26005)(83380400001)(8676002)(7696005)(71200400001)(9686003)(4326008)(55016002)(8936002)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NXA5MUl4Y0ZEVG1wN2RIWjErU1lmaFBlMWV3UHpyckdWRkFtNTNtcGlVZFJl?=
 =?utf-8?B?UnJ0WitsT0M5WDBaR3ZhQTRTbDN4aTg3TldRZ2xKMWxrQ0J2akZIb2JkMGFY?=
 =?utf-8?B?RS9mT0Fjb3psRXp0NDZyUE9wbFphZUQrQkZSTVlxRmdSVVlGazQ1d0Izajdz?=
 =?utf-8?B?NExsNlBaOGJsYXhnMTVsdTdrTjhMR3FGWnBHTm9IRE9kZ0hTbjZaT1hBVUIz?=
 =?utf-8?B?SitITDZrNlZtT1ZRMWM2em1IOW1aVnZQZkdHak5Lb2lkc0JaUzBwRk5ORk83?=
 =?utf-8?B?NVNDTEdNVllMa1p4RGQ5TXk4WHZQWitlcGk0SGFBZHE4ZjVveUxGTXVGN041?=
 =?utf-8?B?d09jUFo1VE1yMUxjODJiOVV2dENxK1NkSktCMW5VMmtmYzNwcStueDFSRm1U?=
 =?utf-8?B?VzY1TExyTFMxbTlnYVJxMmtjK0ZrOWRaRzdnVVVrSmNsUHUrbGs0RDIzTDZS?=
 =?utf-8?B?WWpZVFNyK2NaM0ZGKy9QaW9tYVBvbWpXVldoMVltelF6YzZXT0xaeUZyZjJH?=
 =?utf-8?B?NG1PSmFyNGNNU1JCeVJ2Rm43cy9mOHJrMWEzTStYVzFVR1JrdHMrUnVkWGp5?=
 =?utf-8?B?b2ZybmZIbkttSVQveDcyN2hMeWw4RzdBd2ZOaEdYWWdxeDZqZVlwb1VHOUtO?=
 =?utf-8?B?NXNINlBFMUU5T1B3aDdzRENLSnFPbzVNbU80RE1HRTBJem11TFZwT2dwenlN?=
 =?utf-8?B?bFkzTjEweExWRk1kN2ZYempMRUVRZ3hyMFJUcWJMb1AzZWMxekFpK3FoWFMy?=
 =?utf-8?B?UTNWNk9Lc3hMTXhCN0lLUHc2NEFZYXVsQm4zYjlCQUMvS0Vkd3JyWjVXSWRo?=
 =?utf-8?B?V3NwTSt0aEhWT0dEb0hiS09pc2hJYWVsamlJRFgvM3FFbWRmZXlNdjNZT0xo?=
 =?utf-8?B?M3BEMC9WaWhZZTZjbGg4aUQ3TWwwd0s3dUdLVFFwMndEOEpUR0crNVAzV1Mw?=
 =?utf-8?B?UmhsTnd4bXFOd1ltdm4wMG11R2owVjZsd2FrdVVObTRINTRvQWEveHlYRjkv?=
 =?utf-8?B?S0dseFNvbVhLVlhvaWVhWExhNU1yMTlBeGdLUkRueWxHdjRQcm9MYk9oOU9r?=
 =?utf-8?B?MUVVMmlsZGdyWW8rY0JLNDVBR25iUzFwWXJ5SlFXQ1ZYWHRPbVQzU2tMQ2VY?=
 =?utf-8?B?djdoQWdvZnNuTTQzYmhkRVZDSjc4cHJ4SVRzc212K0w1Wk1SaWdRaytCWkVU?=
 =?utf-8?B?L2FtV1RwRXdlLyt5RVQyN05HRXdIWmEvdDJhTW9oMmZwUFFnd1hpWURzejht?=
 =?utf-8?B?aXlnQi9nejNnS0hxNHhrZnp0YU14L2dTTHNiK0hCNDc0UXRZNkxjeW9rajZZ?=
 =?utf-8?B?SlB3akxRWmR5RFVUNWtqbXNFVkJsTVN6WUZqM21DeVg3SlpLK3BlSHJwUDBU?=
 =?utf-8?B?K3JGOWZHRndCQXJLRSttb0FNRFp5RFY3aTJ4L1RKSlpWaUJERGJraEhaTzd6?=
 =?utf-8?B?UUJZc2RvbVlNTTRGTTFHbklDaGpvWThmY2puQlRHczlzeGtHM0FzRFBoekhh?=
 =?utf-8?B?MDRRb0p5Y0J3ZGsycEt0ZXVBZ25ESGl2N21wU3NPZWpIMzBhWnRjUVZDV1Bv?=
 =?utf-8?B?d0NrV2RtR3BqUEFRK1RVV3lDL0lFWU1ZcXVGQmQycnhIZW5IUU4xckNKb2h6?=
 =?utf-8?B?TXhsWGRrY25ZeTZUOHdvRjB6SnpiR05CdkxlamlnRExZb3h4N2pZU2ZpNzlp?=
 =?utf-8?B?Y0xGYVN6a1RyTU5VdlJVejJ3YURLdHh0bEdDa1dGSUlvaUxzd1FYK041UkJH?=
 =?utf-8?Q?hqxf8sbBT6Q6lsIjk4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2983.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0db2f97-52e7-40cf-c0df-08d8d2216e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 02:20:29.8393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tZP8vhwtXGNlcgevOSUjiMlydVzffnicWjBChUIyzZO4Te6iCxOgfAJ/GB9EuMh/dt/3J+IvuBmQkiwiUR45iOdrdgRavOcZ9Jp6kn+5B/hoWfdAxwilgQHzs0m7WUkV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6392
MSSCP.TransferMailToMossAgent: 103
X-OriginatorOrg: toshiba.co.jp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3RlcGhlbiBSb3Ro
d2VsbCBbbWFpbHRvOnNmckBjYW5iLmF1dWcub3JnLmF1XQ0KPiBTZW50OiBUdWVzZGF5LCBGZWJy
dWFyeSAxNiwgMjAyMSAxMTowNSBBTQ0KPiBUbzogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxv
ZnQubmV0PjsgTmV0d29ya2luZyA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IE9sb2YgSm9oYW5z
c29uIDxvbG9mQGxpeG9tLm5ldD47IEFybmQNCj4gQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+OyBB
Uk0gPGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZz4NCj4gQ2M6IEJhcnRvc3og
R29sYXN6ZXdza2kgPGJnb2xhc3pld3NraUBiYXlsaWJyZS5jb20+OyBMaW51eCBLZXJuZWwgTWFp
bGluZyBMaXN0IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgTGludXgNCj4gTmV4dCBN
YWlsaW5nIExpc3QgPGxpbnV4LW5leHRAdmdlci5rZXJuZWwub3JnPjsgaXdhbWF0c3Ugbm9idWhp
cm8o5bKp5p2+IOS/oea0iyDilqHvvLPvvLfvvKPil6/vvKHvvKPvvLQpDQo+IDxub2J1aGlybzEu
aXdhbWF0c3VAdG9zaGliYS5jby5qcD4NCj4gU3ViamVjdDogbGludXgtbmV4dDogbWFudWFsIG1l
cmdlIG9mIHRoZSBuZXQtbmV4dCB0cmVlIHdpdGggdGhlIGFybS1zb2MgdHJlZQ0KPiANCj4gSGkg
YWxsLA0KPiANCj4gVG9kYXkncyBsaW51eC1uZXh0IG1lcmdlIG9mIHRoZSBuZXQtbmV4dCB0cmVl
IGdvdCBjb25mbGljdHMgaW46DQo+IA0KPiAgIGFyY2gvYXJtNjQvYm9vdC9kdHMvdG9zaGliYS90
bXB2NzcwOC1ybS1tYnJjLmR0cw0KPiAgIGFyY2gvYXJtNjQvYm9vdC9kdHMvdG9zaGliYS90bXB2
NzcwOC5kdHNpDQo+IA0KPiBiZXR3ZWVuIGNvbW1pdHM6DQo+IA0KPiAgIDRmZDE4ZmMzODc1NyAo
ImFybTY0OiBkdHM6IHZpc2NvbnRpOiBBZGQgd2F0Y2hkb2cgc3VwcG9ydCBmb3IgVE1QVjc3MDgg
U29DIikNCj4gICAwMTA5YTE3NTY0ZmMgKCJhcm06IGR0czogdmlzY29udGk6IEFkZCBEVCBzdXBw
b3J0IGZvciBUb3NoaWJhIFZpc2NvbnRpNSBHUElPIGRyaXZlciIpDQo+IA0KPiBmcm9tIHRoZSBh
cm0tc29jIHRyZWUgYW5kIGNvbW1pdDoNCj4gDQo+ICAgZWM4YTQyZTczNDMyICgiYXJtOiBkdHM6
IHZpc2NvbnRpOiBBZGQgRFQgc3VwcG9ydCBmb3IgVG9zaGliYSBWaXNjb250aTUgZXRoZXJuZXQg
Y29udHJvbGxlciIpDQo+IA0KPiBmcm9tIHRoZSBuZXQtbmV4dCB0cmVlLg0KPiANCj4gSSBmaXhl
ZCBpdCB1cCAoc2VlIGJlbG93KSBhbmQgY2FuIGNhcnJ5IHRoZSBmaXggYXMgbmVjZXNzYXJ5LiBU
aGlzDQo+IGlzIG5vdyBmaXhlZCBhcyBmYXIgYXMgbGludXgtbmV4dCBpcyBjb25jZXJuZWQsIGJ1
dCBhbnkgbm9uIHRyaXZpYWwNCj4gY29uZmxpY3RzIHNob3VsZCBiZSBtZW50aW9uZWQgdG8geW91
ciB1cHN0cmVhbSBtYWludGFpbmVyIHdoZW4geW91ciB0cmVlDQo+IGlzIHN1Ym1pdHRlZCBmb3Ig
bWVyZ2luZy4gIFlvdSBtYXkgYWxzbyB3YW50IHRvIGNvbnNpZGVyIGNvb3BlcmF0aW5nDQo+IHdp
dGggdGhlIG1haW50YWluZXIgb2YgdGhlIGNvbmZsaWN0aW5nIHRyZWUgdG8gbWluaW1pc2UgYW55
IHBhcnRpY3VsYXJseQ0KPiBjb21wbGV4IGNvbmZsaWN0cy4NCj4gDQoNClRoaXMgaXMgYmVjYXVz
ZSB0aGUgRFRTIGNoYW5nZXMgYXJlIGluY2x1ZGVkIGluIG5ldC1uZXh0LiBUaGlzIHBhdGNoIHNo
b3VsZCBiZSBtZXJnZWQgdmlhIHRoZSBzb2MgdHJlZS4NCkkgaGFkIHRoZSBzYW1lIHByb2JsZW0g
YmVmb3JlLiBIb3cgaXMgaXQgY29ycmVjdCB0byBzZW5kIGEgRFRTIHBhdGNoPw0KU2hvdWxkIEkg
c2VwYXJhdGUgaW50byBkaWZmZXJlbnQgc2VyaWVzPw0KDQpCZXN0IHJlZ2FyZHMsDQogIE5vYnVo
aXJvDQo=
