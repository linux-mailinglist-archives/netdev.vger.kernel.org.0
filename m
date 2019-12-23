Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D90129B66
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 23:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWWM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 17:12:58 -0500
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:62852
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbfLWWM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 17:12:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKWK4fX/9bfo72hh3OUmsfOa4ETKoVFw6ylkZZgC9WeIRxDX5uipEZhpC5nCtQCbsX+YymgO4/ULgOZvFUkco8f6Mh/LGpAxBQVH6sm3WD4Zl06OOhnyE+3kPkliIyRm43ZaYISdbUURppoNlRWjtGHitDny5fGJN4vEQNzMdFHOLuZ6rQFmR4m72JOes0MSLdU0BGOKJQ1IJxjbniYDj8Au0K1n0fpFyWyrutLyKVCblrqCZ4BGiwewOopMHaIvhS+9zXVO9lXSZReERwuJ4alZltU9z+mD490JRP4kypDAeguVJbqFvLMQ0KrcROdaoVq2wWQZt3uZaBjfpCCRoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wk922ffYKHv0OlFG9W32yewuGF+70ZYeAcJ3109ak4=;
 b=dD3AMEhyUQ8EeTSES9zkPlwETqvhqXdnXVOet3hJgoZWl+F96sR6bQ9RD+KlWk/ItmfJ1BSItF200psKjsHKpqVBhsygyaStzaSQ8Q/SeZZLIanjRZxpU474OgXThHlP3//Lg/dhB8fUG13iwxi7Xm7xdl2vRhgNfvflUGIMsCBhMST6bg6wiWs6tXJNmyYYKXgZ1sgzPuLXug3O8bVUXrDM9qj3S7hzOJWF3BhFRbugzt9kx05QfLvxyLjMPRz/bI2IdpAgwqOv6po8AbqltvFXpgox2sEJ8AasopCJYuKv8ZMPcXOqXba7TyqCCXf1vFfH8zxrhM7p5YoDr2bqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wk922ffYKHv0OlFG9W32yewuGF+70ZYeAcJ3109ak4=;
 b=I6ZJc7r8pY1dQf3xTK/yWajEDRPPVBP+1Qe/8zLAltaLazoV6tTyF8OE0aBDcw4X/EAgjfREr/0S7R1huPfleKNojva1ODUo+iMHUDgPIOr2wDedKO0Od8AJJGu3WgDXNxNYbYH9h/VdFX2BOrKbYmT2lR6LYh/94gYdq41Klhc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3471.eurprd05.prod.outlook.com (10.170.239.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.16; Mon, 23 Dec 2019 22:12:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 22:12:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
CC:     Guy Twig <guyt@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: refcount issue with net/mlx5: DR, Expose steering table
 functionality
Thread-Topic: refcount issue with net/mlx5: DR, Expose steering table
 functionality
Thread-Index: AQHVtbuE/6AVP1evdkm0jQCgNoVeBqfIUMKA
Date:   Mon, 23 Dec 2019 22:12:52 +0000
Message-ID: <a7f02d224e6a4ce568691d623662669d12749291.camel@mellanox.com>
References: <20191218155458.GB193062@localhost.localdomain>
In-Reply-To: <20191218155458.GB193062@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4a0503d-c6de-4ffd-bc81-08d787f540ef
x-ms-traffictypediagnostic: VI1PR05MB3471:|VI1PR05MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB34714C9B7C456739A72CC42BBE2E0@VI1PR05MB3471.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(199004)(189003)(51444003)(51914003)(186003)(2906002)(316002)(6506007)(8936002)(86362001)(2616005)(6916009)(6512007)(26005)(81156014)(8676002)(81166006)(36756003)(5660300002)(6486002)(4001150100001)(107886003)(66476007)(76116006)(54906003)(478600001)(71200400001)(4326008)(91956017)(64756008)(66556008)(66446008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3471;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXfcR6X/UU+50KM6iFVIlg0COO0KBPtlaheIUMnm0LvmGiXPUj787DLLR+rddxsxfwzMf16Kal5RKlxBWDVEfYNmzJNUGxnFNpsEDahnGiutKgZ9elbeog1kSEj/R/k+aYqjMPUdg/CsYwnj05aAyUaXUOkSFvuBnZCR95mCmZcqY3QVuiUP+iXV7QjCCbesmsqpZCxWMYTanadzdSBtLH//HTocteAQOd3MXobJGultsP0ARstX2LmyZGodLvbpXfHofsmNmoan0eXFJvZRxu+9sT44Ko4BO7b7TVcMx8MSlK9uJkBZeOez0AVd6/6MpY/IOwBQK7XJSp+tOkeY58UgFbaHUWrDudjPiQXO+UJfQ/We8BsR5MQgBZ6Q6oAR2adXBG5BTLaTLYFNVzSksy0M3mwPXW6DHQ6WTMfLojYUZoeGgxINEodmNhX1Ak+wRojVXKnmH3I5004To1wyuPXaKK+/YPgZqdLYI5Z+8jM2ke/3mUSf2N9SHL5SvJX/u7SqYrrHhbRe8ma3DLsdgg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <711B329B9AC18544998564583F73C4B2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a0503d-c6de-4ffd-bc81-08d787f540ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 22:12:52.0296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g9t4tx/7uIOJ2hqSjzm8uTFFBiIufon+MXAwB4Vmcv3yTjzC3K+9bPkndCNVhmeMWrgd+tOAvXQu6KuFdEG8cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTE4IGF0IDEyOjU0IC0wMzAwLCBNYXJjZWxvIFJpY2FyZG8gTGVpdG5l
ciB3cm90ZToNCj4gSGksDQo+IA0KPiAodXNpbmcgYSByZXBseSB0byB0aGUgb3JpZ2luYWwgcGF0
Y2ggYXMgYmFzZSBmb3IgdGhpcyBlbWFpbCkNCj4gDQo+IE9uIFR1ZSwgU2VwIDAzLCAyMDE5IGF0
IDA4OjA0OjQ0UE0gKzAwMDAsIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiAuLi4NCj4gPiArc3Rh
dGljIGludCBkcl90YWJsZV9pbml0X25pYyhzdHJ1Y3QgbWx4NWRyX2RvbWFpbiAqZG1uLA0KPiA+
ICsJCQkgICAgIHN0cnVjdCBtbHg1ZHJfdGFibGVfcnhfdHggKm5pY190YmwpDQo+ID4gK3sNCj4g
PiArCXN0cnVjdCBtbHg1ZHJfZG9tYWluX3J4X3R4ICpuaWNfZG1uID0gbmljX3RibC0+bmljX2Rt
bjsNCj4gPiArCXN0cnVjdCBtbHg1ZHJfaHRibF9jb25uZWN0X2luZm8gaW5mbzsNCj4gPiArCWlu
dCByZXQ7DQo+ID4gKw0KPiA+ICsJbmljX3RibC0+ZGVmYXVsdF9pY21fYWRkciA9IG5pY19kbW4t
PmRlZmF1bHRfaWNtX2FkZHI7DQo+ID4gKw0KPiA+ICsJbmljX3RibC0+c19hbmNob3IgPSBtbHg1
ZHJfc3RlX2h0YmxfYWxsb2MoZG1uLT5zdGVfaWNtX3Bvb2wsDQo+ID4gKwkJCQkJCSAgRFJfQ0hV
TktfU0laRV8xLA0KPiA+ICsJCQkJCQkgIE1MWDVEUl9TVEVfTFVfVFlQRV9ETw0KPiA+IE5UX0NB
UkUsDQo+ID4gKwkJCQkJCSAgMCk7DQo+IA0KPiBbQV0NCj4gDQo+ID4gKwlpZiAoIW5pY190Ymwt
PnNfYW5jaG9yKQ0KPiA+ICsJCXJldHVybiAtRU5PTUVNOw0KPiA+ICsNCj4gPiArCWluZm8udHlw
ZSA9IENPTk5FQ1RfTUlTUzsNCj4gPiArCWluZm8ubWlzc19pY21fYWRkciA9IG5pY19kbW4tPmRl
ZmF1bHRfaWNtX2FkZHI7DQo+ID4gKwlyZXQgPSBtbHg1ZHJfc3RlX2h0YmxfaW5pdF9hbmRfcG9z
dHNlbmQoZG1uLCBuaWNfZG1uLA0KPiA+ICsJCQkJCQluaWNfdGJsLT5zX2FuY2hvciwNCj4gPiAr
CQkJCQkJJmluZm8sIHRydWUpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlnb3RvIGZyZWVfc19h
bmNob3I7DQo+ID4gKw0KPiA+ICsJbWx4NWRyX2h0YmxfZ2V0KG5pY190YmwtPnNfYW5jaG9yKTsN
Cj4gDQo+IFdlIGhhdmUgYW4gaXNzdWUgaGVyZS4gbWx4NWRyX3N0ZV9odGJsX2FsbG9jKCkgYWJv
dmUgaW4gW0FdIHdpbGw6DQo+ICAgICAgICAgcmVmY291bnRfc2V0KCZodGJsLT5yZWZjb3VudCwg
MCk7DQo+IGFuZCB0aGVuLCBpZiBubyBlcnJvciBoYXBwZW5zLCBoZXJlIGl0IGdldHMgaW5jcmVt
ZW50ZWQuIEJ1dDoNCj4gDQo+IHN0YXRpYyBpbmxpbmUgdm9pZCBtbHg1ZHJfaHRibF9nZXQoc3Ry
dWN0IG1seDVkcl9zdGVfaHRibCAqaHRibCkNCj4gew0KPiAgICAgICAgIHJlZmNvdW50X2luYygm
aHRibC0+cmVmY291bnQpOw0KPiANCj4gICogV2lsbCBXQVJOIGlmIHRoZSByZWZjb3VudCBpcyAw
LCBhcyB0aGlzIHJlcHJlc2VudHMgYSBwb3NzaWJsZSB1c2UtDQo+IGFmdGVyLWZyZWUNCj4gICog
Y29uZGl0aW9uLg0KPiAgKi8NCj4gc3RhdGljIGlubGluZSB2b2lkIHJlZmNvdW50X2luYyhyZWZj
b3VudF90ICpyKQ0KPiB7DQo+ICAgICAgICAgcmVmY291bnRfYWRkKDEsIHIpOw0KPiANCj4gYW5k
IHRoYXQncyBleGFjdGx5IHdoYXQgaGFwcGVucyBoZXJlIChjb21taXQNCj4gMjE4N2YyMTVlYmFh
YzczZGRiZDgxNDY5NmQ3YzdmYTM0ZjBjM2RlMCk6DQo+IFsgIDE2My4zNzk1MjZdIG1seDVfY29y
ZSAwMDAwOjgyOjAwLjA6IEUtU3dpdGNoOiBEaXNhYmxlOg0KPiBtb2RlKExFR0FDWSksIG52ZnMo
NCksIGFjdGl2ZSB2cG9ydHMoNSkNCj4gWyAgMTY2Ljg2MjE3MV0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tDQo+IFsgIDE2Ni44NjczMzFdIHJlZmNvdW50X3Q6IGFkZGl0aW9u
IG9uIDA7IHVzZS1hZnRlci1mcmVlLg0KPiBbICAxNjYuODczMDk0XSBXQVJOSU5HOiBDUFU6IDQ5
IFBJRDogNTQxNCBhdCBsaWIvcmVmY291bnQuYzoyNQ0KPiByZWZjb3VudF93YXJuX3NhdHVyYXRl
KzB4NmQvMHhmMA0KPiBbICAxNjYuODgyNTExXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzog
cGFuaWNfb25fd2FybiBzZXQgLi4uDQo+IFsgIDE2Ni44ODg5MjNdIENQVTogNDkgUElEOiA1NDE0
IENvbW06IGRldmxpbmsgS2R1bXA6IGxvYWRlZCBOb3QNCj4gdGFpbnRlZCA1LjUuMC1yYzIrICMy
DQo+IC4uLg0KPiBbICAxNjYuOTU1MzM3XSBSSVA6IDAwMTA6cmVmY291bnRfd2Fybl9zYXR1cmF0
ZSsweDZkLzB4ZjANCj4gLi4uDQo+IFsgIDE2Ny4wMjc2NjZdICA/IHJlZmNvdW50X3dhcm5fc2F0
dXJhdGUrMHg2ZC8weGYwDQo+IFsgIDE2Ny4wMzI3NzJdICBkcl90YWJsZV9pbml0X25pYysweGQx
LzB4ZTAgW21seDVfY29yZV0NCj4gWyAgMTY3LjAzODMzOV0gIG1seDVkcl90YWJsZV9jcmVhdGUr
MHgxMmUvMHgyNjAgW21seDVfY29yZV0NCj4gWyAgMTY3LjA0NDI5MF0gIG1seDVfY21kX2RyX2Ny
ZWF0ZV9mbG93X3RhYmxlKzB4MzEvMHhkMCBbbWx4NV9jb3JlXQ0KPiBbICAxNjcuMDUxMDEzXSAg
X19tbHg1X2NyZWF0ZV9mbG93X3RhYmxlKzB4MjIyLzB4NjgwIFttbHg1X2NvcmVdDQo+IFsgIDE2
Ny4wNTc0NTBdICBlc3dfY3JlYXRlX29mZmxvYWRzX2ZkYl90YWJsZXMrMHgxNjkvMHg0YzANCj4g
W21seDVfY29yZV0NCj4gWyAgMTY3LjA2NDQ2OF0gIGVzd19vZmZsb2Fkc19lbmFibGUrMHgxNmMv
MHg1MTAgW21seDVfY29yZV0NCj4gWyAgMTY3LjA3MDQxN10gID8gbWx4NV9hZGRfZGV2aWNlKzB4
OWQvMHhlMCBbbWx4NV9jb3JlXQ0KPiBbICAxNjcuMDc1OTgyXSAgbWx4NV9lc3dpdGNoX2VuYWJs
ZSsweGY5LzB4NGYwIFttbHg1X2NvcmVdDQo+IFsgIDE2Ny4wODE4MzhdICBtbHg1X2Rldmxpbmtf
ZXN3aXRjaF9tb2RlX3NldCsweDExYi8weDFiMCBbbWx4NV9jb3JlXQ0KPiBbICAxNjcuMDg4NzM4
XSAgZGV2bGlua19ubF9jbWRfZXN3aXRjaF9zZXRfZG9pdCsweDQ0LzB4YzANCj4gWyAgMTY3LjA5
NDQ2Nl0gIGdlbmxfcmN2X21zZysweDFmOS8weDQ0MA0KPiBbICAxNjcuMDk4NTQ1XSAgPyBnZW5s
X2ZhbWlseV9yY3ZfbXNnX2F0dHJzX3BhcnNlKzB4MTEwLzB4MTEwDQo+IFsgIDE2Ny4xMDQ2NjZd
ICBuZXRsaW5rX3Jjdl9za2IrMHg0OS8weDExMA0KPiBbICAxNjcuMTA4OTQ1XSAgZ2VubF9yY3Yr
MHgyNC8weDQwDQo+IFsgIDE2Ny4xMTI0NDldICBuZXRsaW5rX3VuaWNhc3QrMHgxYTUvMHgyODAN
Cj4gWyAgMTY3LjExNjgyNV0gIG5ldGxpbmtfc2VuZG1zZysweDIzZC8weDQ3MA0KPiBbICAxNjcu
MTIxMjAyXSAgc29ja19zZW5kbXNnKzB4NWIvMHg2MA0KPiBbICAxNjcuMTI1MDkzXSAgX19zeXNf
c2VuZHRvKzB4ZWUvMHgxNjANCj4gDQo+IE9uZSBxdWljayBmaXggaXMgdG8ganVzdCBpbml0aWFs
aXplIGl0IGFzIDEuICBJIHdhcyBza2V0Y2hpbmcgYSBwYXRjaA0KPiBidXQgZ2F2ZSB1cCBhcyBt
bHg1ZHJfc3RlX2h0YmxfYWxsb2MoKSBhbHNvIGRvZXM6DQo+ICAgICAgICAgICAgICAgICByZWZj
b3VudF9zZXQoJnN0ZS0+cmVmY291bnQsIDApOw0KPiANCj4gYW5kIGl0IGlzIHVzZWQgbGlrZToN
Cj4gYm9vbCBtbHg1ZHJfc3RlX25vdF91c2VkX3N0ZShzdHJ1Y3QgbWx4NWRyX3N0ZSAqc3RlKQ0K
PiB7DQo+ICAgICAgICAgcmV0dXJuICFyZWZjb3VudF9yZWFkKCZzdGUtPnJlZmNvdW50KTsNCj4g
DQo+IFNvIHRoZSBzYW1lIGVhc3kgZml4IGRvZXNuJ3Qgd29yayBoZXJlIGFuZDoNCj4gDQo+IHN0
YXRpYyBpbmxpbmUgdm9pZCBtbHg1ZHJfc3RlX3B1dChzdHJ1Y3QgbWx4NWRyX3N0ZSAqc3RlLA0K
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG1seDVkcl9tYXRjaGVy
ICptYXRjaGVyLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG1s
eDVkcl9tYXRjaGVyX3J4X3R4DQo+ICpuaWNfbWF0Y2hlcikNCj4gew0KPiAgICAgICAgIGlmIChy
ZWZjb3VudF9kZWNfYW5kX3Rlc3QoJnN0ZS0+cmVmY291bnQpKQ0KPiAgICAgICAgICAgICAgICAg
bWx4NWRyX3N0ZV9mcmVlKHN0ZSwgbWF0Y2hlciwgbmljX21hdGNoZXIpOw0KPiANCj4gT24gd2hp
Y2gsIEFGQUlDVCwgcmVtb3ZlcyBpdCBmcm9tIHRoZSBIVyBidXQgbm90IGZyZWUgdGhlIFNURSBl
bnRyeQ0KPiBpdHNlbGYuIFNvIEkgdGhpbmsgdGhhdCB0aGUgdXNhZ2Ugb2YgcmVmY291bnRfZGVj
X2FuZF90ZXN0KCkgd291bGQgYmUNCj4gYnJva2VuIGhlcmUgaWYgd2UganVzdCBvZmZzZXQgdGhl
IHJlZmNvdW50IGJ5IDEuDQo+IA0KPiBUaG91Z2h0cz8NCj4gDQoNCkhpIE1hcmNlbG8sIHRoYW5r
cyBmb3IgdGhlIHJlcG9ydCwgDQpXZSBhcmUgd29ya2luZyBvbiBhIHBhdGNoIHRvIHJlbW92ZSB0
aGUgdXNlIG9mIHJlZmNvdW50IEFQSSBpbiBtbHg1IERSLA0Kc2luY2UgaXQgaXMgcmVkdW5kYW50
IGFuZCBhbGwgdXBkYXRlcyBhcmUgYWxyZWFkeSBkb25lIHVuZGVyIGEgZ2xvYmFsDQpsb2NrIGZv
ciBub3cuDQoNCkkgd2lsbCBDQyB5b3Ugb24gdGhhdCBwYXRjaCBwcmlvciB0byBzdWJtaXNzaW9u
Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICsNCj4g
PiArZnJlZV9zX2FuY2hvcjoNCj4gPiArCW1seDVkcl9zdGVfaHRibF9mcmVlKG5pY190YmwtPnNf
YW5jaG9yKTsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4gK30NCj4gPiArDQo=
