Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034DD5260C8
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379814AbiEMLOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379808AbiEMLOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:14:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AF7A5DA12
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:14:38 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-181-0C1zEWiPPjqMic9fvV5MTA-1; Fri, 13 May 2022 12:14:35 +0100
X-MC-Unique: 0C1zEWiPPjqMic9fvV5MTA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 13 May 2022 12:14:34 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 13 May 2022 12:14:34 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Daniel Borkmann' <daniel@iogearbox.net>,
        liqiong <liqiong@nfschina.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>, Song Liu <songliubraving@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hukun@nfschina.com" <hukun@nfschina.com>,
        "qixu@nfschina.com" <qixu@nfschina.com>,
        "yuzhe@nfschina.com" <yuzhe@nfschina.com>,
        "renyu@nfschina.com" <renyu@nfschina.com>
Subject: RE: [PATCH 1/2] kernel/bpf: change "char *" string form to "char []"
Thread-Topic: [PATCH 1/2] kernel/bpf: change "char *" string form to "char []"
Thread-Index: AQHYZkM1stWiUR1QcEWMGKEEx9wika0cp5sg
Date:   Fri, 13 May 2022 11:14:34 +0000
Message-ID: <017900c07229451085f82ae1e71cd825@AcuMS.aculab.com>
References: <20220512142814.26705-1-liqiong@nfschina.com>
 <bd3d4379-e4aa-79c7-85b8-cc930a04f267@fb.com>
 <223f19c0-70a7-3b1f-6166-22d494b62b6e@nfschina.com>
 <92cc4844-5815-c3b0-63be-2e54dc36e1d9@iogearbox.net>
In-Reply-To: <92cc4844-5815-c3b0-63be-2e54dc36e1d9@iogearbox.net>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGFuaWVsIEJvcmttYW5uDQo+IFNlbnQ6IDEyIE1heSAyMDIyIDIyOjAwDQo+IA0KPiBP
biA1LzEyLzIyIDc6MDggUE0sIGxpcWlvbmcgd3JvdGU6DQo+ID4g5ZyoIDIwMjLlubQwNeaciDEy
5pelIDIzOjE2LCBZb25naG9uZyBTb25nIOWGmemBkzoNCj4gPj4NCj4gPj4gT24gNS8xMi8yMiA3
OjI4IEFNLCBsaXFpb25nIHdyb3RlOg0KPiA+Pj4gVGhlIHN0cmluZyBmb3JtIG9mICJjaGFyIFtd
IiBkZWNsYXJlcyBhIHNpbmdsZSB2YXJpYWJsZS4gSXQgaXMgYmV0dGVyDQo+ID4+PiB0aGFuICJj
aGFyICoiIHdoaWNoIGNyZWF0ZXMgdHdvIHZhcmlhYmxlcy4NCj4gPj4NCj4gPj4gQ291bGQgeW91
IGV4cGxhaW4gaW4gZGV0YWlscyBhYm91dCB3aHkgaXQgaXMgYmV0dGVyIGluIGdlbmVyYXRlZCBj
b2Rlcz8NCj4gPj4gSXQgaXMgbm90IGNsZWFyIHRvIG1lIHdoeSB5b3VyIHBhdGNoIGlzIGJldHRl
ciB0aGFuIHRoZSBvcmlnaW5hbCBjb2RlLg0KPiA+DQo+ID4gVGhlICBzdHJpbmcgZm9ybSBvZiAi
Y2hhciAqIiBjcmVhdGVzIHR3byB2YXJpYWJsZXMgaW4gdGhlIGZpbmFsIGFzc2VtYmx5IG91dHB1
dCwNCj4gPiBhIHN0YXRpYyBzdHJpbmcsIGFuZCBhIGNoYXIgcG9pbnRlciB0byB0aGUgc3RhdGlj
IHN0cmluZy4gIFVzZSAgIm9iamR1bXAgLVMgLUQgICoubyIsDQo+ID4gY2FuIGZpbmQgb3V0IHRo
ZSBzdGF0aWMgc3RyaW5nICBvY2N1cnJpbmcgIGF0ICJDb250ZW50cyBvZiBzZWN0aW9uIC5yb2Rh
dGEiLg0KPiANCj4gVGhlcmUgYXJlIH4zNjAgaW5zdGFuY2VzIG9mIHRoaXMgdHlwZSBpbiB0aGUg
dHJlZSBmcm9tIGEgcXVpY2sgZ3JlcCwgZG8geW91DQo+IHBsYW4gdG8gY29udmVydCBhbGwgdGhl
bSA/DQoNClRoZXJlIGFyZSBhbHNvIGFsbCB0aGUgcGxhY2VzIHdpdGggY29uc3QgY2hhciAqbmFt
ZXNbXSA9IC4uLjsNCndoZXJlIHRoZSBhY3R1YWwgbmFtZXMgYXJlIGFsbCBzaW1pbGFyIGxlbmd0
aCBzbyByZXBsYWNpbmcgd2l0aA0KY29uc3QgY2hhciBuYW1lc1tdW25dIHNhdmVzIHNwYWNlLg0K
DQpBbHRob3VnaCB0aGF0IHRyYW5zZm9ybWF0aW9uIGhhcyBhIGJpZ2dlciBlZmZlY3Qgb24gc2hh
cmVkIGxpYnMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

