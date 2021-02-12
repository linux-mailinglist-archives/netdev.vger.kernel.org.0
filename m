Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E6531A278
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhBLQRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:17:30 -0500
Received: from mail-eopbgr1410114.outbound.protection.outlook.com ([40.107.141.114]:42336
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229788AbhBLQRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 11:17:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVY9A6Aup/1QPGdjQ/1VVfEU6HBe8yAzfu0Bo5CO62NT6FlO78VnbbZgmeeugscUv8Lp5ZZN74oN0f3XZz5s55FXTbYAB5pN1Ev9tUf4FzUFigfBi3aMOexiW4cJQkXei4DtdpWt8MfdbT2e074GlrJm6mUWBEmHtqUVZeO8g6/DRvNChEk2lA7lYc0wEYE9ys1RW3ZxfzMO++OvWfQwuXLGyk6K+ES9IQxENrVI6f5S1NlXLyojo2oJwqyrGDUdgA99dKF7lCZFY1YfSCW9qyyvWwTBP7CbGXIraevdsPlWDdx5Q/eaWC0yQblOUTobrvIZZpqhC46QWUL/ml6xkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxAO6pF1liBfS/5eVHezFwchjClzJE3YnRInlpTgi6U=;
 b=ifvbJUaW+YpE12T9FeevVHi6jbJPwReSVDQRmez4YECn6mST+5fvvJohOex/q8gWlQzgoDtcFD35VFrPLE539t/8yyTDwuVgysv/jf9W8unhwtodVmC59rgctgnHpExCB/bFRKifzwJUxR9jyi9o3jHMImypgovD+DfJDW8RUNSSBkzgThqpsNh+xRXgBdibhCllTPRQiOy8v4rWUNzANLnopX9slk6hdZaZ8545GisUwrqqRecqzna5WNogIxnwCSJvrBzSycOPccZ4ZzrLOhhQ7CjyE4rtKABkGpD6WkuVBVn0YfX3VEUqUy/DofRmhCBSWWvo6hdOdnl5igqFFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxAO6pF1liBfS/5eVHezFwchjClzJE3YnRInlpTgi6U=;
 b=aYcw+mlvVai8AWwrrCEb04u31AK2EaaSYsCkMO/V6jSIVDgE6xfk+AILuZpa2uvEysZm4LSRX+sD4bHOfwdQLDggoSXoGyoOps1IhELrMWXkbskNWM5l2LNcoLLkETdjKbn2fhxJZayVRog0buNxewzZfmbnnF6ctnY9xndntv4=
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com (2603:1096:604:7a::23)
 by OSAPR01MB1970.jpnprd01.prod.outlook.com (2603:1096:603:17::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 16:16:31 +0000
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5]) by OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5%3]) with mapi id 15.20.3846.029; Fri, 12 Feb 2021
 16:16:31 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Topic: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Index: AQHXACKOoFb+ofRp20OhBYk2S05d7KpS86SAgADGlHCAAIcoAIAAassg
Date:   Fri, 12 Feb 2021 16:16:30 +0000
Message-ID: <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
In-Reply-To: <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e287ca2-cd05-46ae-c2c5-08d8cf718f25
x-ms-traffictypediagnostic: OSAPR01MB1970:
x-microsoft-antispam-prvs: <OSAPR01MB19701CA6897E3782AAA144BABA8B9@OSAPR01MB1970.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9i7D8SMBHLCtbF3ULAJskqSLyjRvsBWgC50XA+QYeJPqYQ5UMYgXEGM1542StB+rvcdMoNGhNBohHTMKMdP2/5TZUaR3y+thKyfxP83Ftk3X2uKTiyeNARQtifH3xjynynOprBj5IOdLND+zjezKfQQzhWcUhAptdkgj4g33UP1brIdp08jGTGI4iCY1qB5vcZTuwhYeDOA55mIz2raeNLxpluoZERrPpGZfAffnm+zCdGw0PduCtf7cEB0i9vUp+s3jGDhBjckprDr6wB6wFviidlIft7f9Kj76Y6aovIGKnJAkK4LIekJDLQmwSI4flYsXRj7T4+rECWFCnbKIMHgO9JMO6uZAI3jNRQ3u4aqcC4g1jAk9CijMPGQCjvHaLj7xIrexTZMI3+toonJrE6k6Qfor76P3EUzWoTme8e275P0U1+veDaUjy6dObgfIFqbuAfZl7dP491Q4c+WJvGySLsgLsjbS06/OneXkUgg5uAnJtOpo4/Wf9ngB04ClDp0ldY3fFNFMEoPGm07fog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4773.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(136003)(396003)(376002)(6916009)(26005)(6506007)(186003)(478600001)(33656002)(52536014)(5660300002)(71200400001)(64756008)(66446008)(66946007)(66476007)(66556008)(4326008)(76116006)(54906003)(86362001)(55016002)(8936002)(8676002)(2906002)(9686003)(83380400001)(7696005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aTUzSm1PTmFwNDFLQm8rVE1tUElMeXNtblFLS0pZVFNCcUdTWGhSbWNEVDd3?=
 =?utf-8?B?TzBNMkJ3YlpLclVjUG9jQWNJc3RJUmQraVdJc0lnOURGbUpwb0FOMkJ2a3FK?=
 =?utf-8?B?b3Z5ME5tc2ZORWZwdjAyWGMvMk5KbmliR3hXUEZqL2ZqbTdJOFBCMlJOWW0r?=
 =?utf-8?B?bzJFakp0ZmVURmZrRTV1aWhKVnFid0p0cnRwdW9kRXRTZm5mZzQvM0tZL09a?=
 =?utf-8?B?R2VjVWdPdjU0ZVpSOHJMOW5CYjdocnhwTXRoZEZyZlc5SlBCNlpBT2o4cEN5?=
 =?utf-8?B?aXFML1hkMnB6Z29lejIxcVpEdTRBSU9HZW5xbjJ0aUt3dklyQjRPM3k4dUtm?=
 =?utf-8?B?R2U2bGZ4b1N3MDV1M2wyKzRJbGZacTBaZEZYL2txQVBlTHVMSkhhVEE3a0E5?=
 =?utf-8?B?Yk5Bb1NaR2psSEgwK0hmV0RpR2Y2RTZKQjhCOXNTdkxFZlpTS2lCdGR3Q3FP?=
 =?utf-8?B?b2JGSUh0TTgyR1k3R29nNkpoQ1JQOFlMNGRNTE5YNkRFMG9uMUNuOTVSMXdq?=
 =?utf-8?B?SFBxUk9hOW43MEhpS1NGbTM0TURNQVBVVit2S3pkTUo5dzVZd0ZDM0kyZ1Ay?=
 =?utf-8?B?Um5mMnpKbGhGdjFyK1BENE1KUnh5K2RjL2ppVUVMTitKY0UvNndwN3V4SFcw?=
 =?utf-8?B?Mkxwem1ucDFNR3ZHci95YmNNVVlZKytCRGMwei9lK0xQUExsUzBaWlZ6b0JO?=
 =?utf-8?B?dFpSY1E5NnVqTGlqa1hDZVBOS3Qza1V2ejBWbU4yTVJjZlFZV05ocXd5d1JZ?=
 =?utf-8?B?a2ZFVWpObjdRZHFralJCbDUveGExQWRneEM1QnJadWRpL1Z6QWEyS0Nsa29a?=
 =?utf-8?B?dlFiU0FURkgrTFVMeE9XYjFOTVRPMzd6REUrVG1NYVhoWUlybVN1YmpTMEpj?=
 =?utf-8?B?MDZuck91VWNvQWhkbHhTRTZOMWN0WStGalV0Vll3NGxjWW9nWTlwTlhsZkpt?=
 =?utf-8?B?WURsaXBHRlpHNE41c0ZSV2g2RW9ERHA2T3dHY29Ccnh5WVRKMGJ6WkQxY0oy?=
 =?utf-8?B?b1FNS2tyYjNNeVAzbHVuaFhhWnY3dTBNb21oY3V6bDhJVzlaNW1HNVNxb1Bn?=
 =?utf-8?B?RGtiWEY0d1BGdzErcU4zNmNmOWVvYWVKYlpLbTNEOE9PdkFONnlUeVVOZzJ4?=
 =?utf-8?B?Nmo4alRXa0d4KzE3OEpCKzRQa3NRRmViOXA0dTZVaHlqUVZFZnYyUGxJM2tI?=
 =?utf-8?B?V3Rrb2RQb1IyV3hXYVN4QXAwcUdBVkdMN2JQUGpndjI1eS83Qk9PemJzSW10?=
 =?utf-8?B?RUNpNTBEcjZNeGZJSVIrcVVScVhaVUhraU9KUysyQW11emthNFVraytYd28x?=
 =?utf-8?B?TFdib2ZBTXIxcE45MDQvYm1FMWhncXh6R3NvSXVVRlptU011RkhCUmt6aEJH?=
 =?utf-8?B?QnFMSmJGZmE5VklEd1VzYkR5MzB3UFZOaUJ6ZDBaMlVQbWNJTHRUdDZpUUV6?=
 =?utf-8?B?MmZhT1g3SmdGTmMxdFdlU1pPbWtDSjB4cWowMmNBamVuMW94QVhTRXhJVkVu?=
 =?utf-8?B?TExVc1Y0dWtuU1RZd25sZVh1SW8wM3lvTUxyYVdyL2pORlZHcmNWY0Iyb3h6?=
 =?utf-8?B?NXQ5dzgyQ2Z1M3laVWduTVlOT1A4R01ZRjJvN2U3bXBiY0htK0d1dFpqN3Jr?=
 =?utf-8?B?S2RCVkt1R3Z4NVgwdTNOb0pQU3FqN3dTUllMMVgySHVVQkZhKzFpVVdmcjFn?=
 =?utf-8?B?WjlGSjJVZDVkZGR3TmVyenk3Q2RMY2tUaE1PaHorblpDNkhIRjc0OWlnM1Ax?=
 =?utf-8?Q?+SMk/k/dMv/K4UHxJQuoede9QbroKcdBizuSxEj?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4773.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e287ca2-cd05-46ae-c2c5-08d8cf718f25
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 16:16:31.1396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Koaq0Lh1YYLzbzPYyZ4IkvdF4DgOzrFdW1qJEFIHEaHAjL4BlKpUoAix0CeI+RRPrAT+H3XSArbcBm0Vf6x8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1970
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gQWgsIHNvIGlmIHRoaXMgaXMgZm9yIGEgUFRQIHJlbGF0ZWQgZHJpdmVyLCBpdCBzaG91
bGQgcHJvYmFibHkgYmUgaW50ZWdyYXRlZCBpbnRvDQo+IHRoZSBQVFAgc3Vic3lzdGVtIHJhdGhl
ciB0aGFuIGJlaW5nIGEgc2VwYXJhdGUgY2xhc3MuDQo+IA0KDQpJIHdhcyB0cnlpbmcgdG8gYWRk
IHRoZXNlIGZ1bmN0aW9ucyB0byBQSEMgc3Vic3lzdGVtIGJ1dCB3YXMgbm90IGFjY2VwdGVkIGJl
Y2F1c2UgdGhlIGZ1bmN0aW9ucw0KYXJlIHNwZWNpZmljIHRvIFJlbmVzYXMgZGV2aWNlIGFuZCB0
aGVyZSBpcyBubyBwbGFjZSBmb3IgdGhvc2UgZnVuY3Rpb25zIGluIFBIQyBkcml2ZXIuDQoNCj4g
PiA+IEEgcHVyZSBsaXN0IG9mIHJlZ2lzdGVyIHZhbHVlcyBzZWVtcyBuZWl0aGVyIHBhcnRpY3Vs
YXIgcG9ydGFibGUgbm9yDQo+IGludHVpdGl2ZS4NCj4gPiA+IEhvdyBpcyBhIHVzZXIgZXhwZWN0
ZWQgdG8gaW50ZXJwcmV0IHRoZXNlLCBhbmQgYXJlIHlvdSBzdXJlIHRoYXQgYW55DQo+ID4gPiBk
cml2ZXIgZm9yIHRoaXMgY2xhc3Mgd291bGQgaGF2ZSB0aGUgc2FtZSBpbnRlcnByZXRhdGlvbiBh
dCB0aGUgc2FtZQ0KPiByZWdpc3RlciBpbmRleD8NCj4gPiA+DQo+ID4NCj4gPiBZZXMgd2UgbmVl
ZCBhIHdheSB0byBkdW1wIHJlZ2lzdGVyIHZhbHVlcyB3aGVuIHJlbW90ZSBkZWJ1Z2dpbmcgd2l0
aA0KPiBjdXN0b21lcnMuDQo+ID4gQW5kIGFsbCB0aGUgUmVuZXNhcyBTTVUgaGFzIHNpbWlsYXIg
cmVnaXN0ZXIgbGF5b3V0DQo+IA0KPiBBIHN5c2ZzIGludGVyZmFjZSBpcyBhIHBvb3IgY2hvaWNl
IGZvciB0aGlzIHRob3VnaCAtLSBob3cgY2FuIHlvdSBndWFyYW50ZWUNCj4gdGhhdCBldmVuIGZ1
dHVyZSBSZW5lc2FzIGRldmljZXMgZm9sbG93IHRoZSBleGFjdCBzYW1lIHJlZ2lzdGVyIGxheW91
dD8gQnkNCj4gZW5jb2RpbmcgdGhlIGN1cnJlbnQgaGFyZHdhcmUgZ2VuZXJhdGlvbiBpbnRvIHRo
ZSB1c2VyIGludGVyZmFjZSwgeW91IHdvdWxkDQo+IGVuZCB1cCBoYXZpbmcgdG8gZW11bGF0ZSB0
aGlzIG9uIG90aGVyIGNoaXBzIHlvdSB3YW50IHRvIHN1cHBvcnQgbGF0ZXIuDQo+IA0KPiBJZiBp
dCdzIG9ubHkgZm9yIGRlYnVnZ2luZywgYmVzdCBsZWF2ZSBpdCBvdXQgb2YgdGhlIHB1YmxpYyBp
bnRlcmZhY2UsIGFuZCBvbmx5DQo+IGhhdmUgaXQgaW4geW91ciBvd24gY29weSBvZiB0aGUgZHJp
dmVyIHVudGlsIHRoZSBidWdzIGFyZSBnb25lLCBvciBhZGQgYQ0KPiBkZWJ1Z2ZzIGludGVyZmFj
ZS4NCj4gDQoNCkkgd2lsbCBkcm9wIHRoZSBzeXNmcyBjaGFuZ2UgaW4gdGhlIG5ldyBwYXRjaA0K
DQo+IA0KPiBVbml0IHRlc3RzIGFyZSBnb29kLCBidXQgaXQncyBiZXR0ZXIgdG8gaGF2ZSB0aGVt
IGluIHRoZSBrZXJuZWwuDQo+IENhbiB5b3UgYWRkIHRoZSB1bml0IHRlc3QgaW50byB0aGUgcGF0
Y2ggdGhlbj8NCj4gV2Ugbm93IGhhdmUgdGhlIGt1bml0IGZyYW1ld29yayBmb3IgcnVubmluZyB1
bml0IHRlc3RzLg0KPiANCg0KT3VyIHVuaXQgdGVzdCBpcyBiYXNlZCBvbiBjZWVkbGluZy4gQnV0
IEkgd2lsbCBkZWZpbml0ZWx5IGxvb2sgaW50byB0aGUga3VuaXQgYW5kIHRyeSB0bw0KVHJhbnNm
ZXIgaXQgdG8ga3VuaXQgZm9yIHRoZSBuZXh0IHJlbGVhc2UuDQoNCj4gPiA+IFRoaXMgdGVsbHMg
bWUgdGhhdCB5b3UgZ290IHRoZSBhYnN0cmFjdGlvbiB0aGUgd3Jvbmcgd2F5OiB0aGUgY29tbW9u
DQo+ID4gPiBmaWxlcyBzaG91bGQgbm90IG5lZWQgdG8ga25vdyBhbnl0aGluZyBhYm91dCB0aGUg
c3BlY2lmaWMNCj4gaW1wbGVtZW50YXRpb25zLg0KPiA+ID4NCj4gPiA+IEluc3RlYWQsIHRoZXNl
IHNob3VsZCBiZSBpbiBzZXBhcmF0ZSBtb2R1bGVzIHRoYXQgY2FsbCBleHBvcnRlZA0KPiA+ID4g
ZnVuY3Rpb25zIGZyb20gdGhlIGNvbW1vbiBjb2RlLg0KPiA+ID4NCj4gPiA+DQo+ID4NCj4gPiBJ
IGdvdCB3aGF0IHlvdSBtZWFuLiBCdXQgc28gZmFyIGl0IG9ubHkgc3VwcG9ydHMgc21hbGwgc2V0
IG9mDQo+ID4gZnVuY3Rpb25zLCB3aGljaCBpcyB3aHkgSSBkb24ndCBmZWV0IGl0IGlzIHdvcnRo
IHRoZSBlZmZvcnQgdG8gb3ZlciBhYnN0cmFjdA0KPiB0aGluZ3MuDQo+IA0KPiBUaGVuIG1heWJl
IHBpY2sgb25lIG9mIHRoZSB0d28gaGFyZHdhcmUgdmFyaWFudHMgYW5kIGRyb3AgdGhlIGFic3Ry
YWN0aW9uDQo+IHlvdSBoYXZlLiBZb3UgY2FuIHRoZW4gYWRkIG1vcmUgZmVhdHVyZXMgYmVmb3Jl
IHlvdSBhZGQgYSBwcm9wZXINCj4gYWJzdHJhY3Rpb24gbGF5ZXIgYW5kIHRoZW4gdGhlIHNlY29u
ZCBkcml2ZXIuDQo+IA0KDQpJZiBJIGNvbWUgdXAgd2l0aCBhIG5ldyBmaWxlIGFuZCBtb3ZlIGFs
bCB0aGUgYWJzdHJhY3Rpb24gY29kZSB0aGVyZSwgZG9lcyB0aGF0IHdvcms/DQo=
