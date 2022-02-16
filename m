Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E068F4B834F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiBPItI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:49:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiBPItD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:49:03 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45D3C2A8D10
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:48:51 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-34-IdaZJxN6M-y3QY1MjOo6oA-1; Wed, 16 Feb 2022 08:48:47 +0000
X-MC-Unique: IdaZJxN6M-y3QY1MjOo6oA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 16 Feb 2022 08:48:46 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 16 Feb 2022 08:48:46 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yonghong Song' <yhs@fb.com>, Shung-Hsi Yu <shung-hsi.yu@suse.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Connor O'Brien <connoro@google.com>,
        =?utf-8?B?TWljaGFsIFN1Y2jDoW5law==?= <msuchanek@suse.de>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: RE: BTF compatibility issue across builds
Thread-Topic: BTF compatibility issue across builds
Thread-Index: AQHYIpQ9o1wIZcx0Hk+HXDOO4VHmbayV3j7w
Date:   Wed, 16 Feb 2022 08:48:46 +0000
Message-ID: <634a6042dc76479bb12d6084ffe36f62@AcuMS.aculab.com>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
 <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
 <YgdIWvNsc0254yiv@syu-laptop.lan>
 <8a520fa1-9a61-c21d-f2c4-d5ba8d1b9c19@fb.com> <YgwBN8WeJvZ597/j@syu-laptop>
 <0867c12a-9aa3-418d-9102-3103cb784e99@fb.com>
In-Reply-To: <0867c12a-9aa3-418d-9102-3103cb784e99@fb.com>
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWW9uZ2hvbmcgU29uZw0KPiBTZW50OiAxNSBGZWJydWFyeSAyMDIyIDE3OjQ3DQouLi4N
Cj4gPiBMZXQgbWUgdHJ5IHRha2UgYSBqYWIgYXQgaXQuIFNheSBoZXJlJ3MgYSBoeXBvdGhldGlj
YWwgQlRGIGZvciBhIGtlcm5lbA0KPiA+IG1vZHVsZSB3aGljaCBvbmx5IHR5cGUgaW5mb3JtYXRp
b24gZm9yIGBzdHJ1Y3Qgc29tZXRoaW5nICpgOg0KPiA+DQo+ID4gICAgWzVdIFBUUiAnKGFub24p
JyB0eXBlX2lkPTQNCj4gPg0KPiA+IFdoaWNoIGlzIGJ1aWx0IHVwb24gdGhlIGZvbGxvdyBiYXNl
IEJURjoNCj4gPg0KPiA+ICAgIFsxXSBJTlQgJ3Vuc2lnbmVkIGNoYXInIHNpemU9MSBiaXRzX29m
ZnNldD0wIG5yX2JpdHM9OCBlbmNvZGluZz0obm9uZSkNCj4gPiAgICBbMl0gUFRSICcoYW5vbikn
IHR5cGVfaWQ9Mw0KPiA+ICAgIFszXSBTVFJVQ1QgJ2xpc3RfaGVhZCcgc2l6ZT0xNiB2bGVuPTIN
Cj4gPiAgICAgICAgICAnbmV4dCcgdHlwZV9pZD0yIGJpdHNfb2Zmc2V0PTANCj4gPiAgICAgICAg
ICAncHJldicgdHlwZV9pZD0yIGJpdHNfb2Zmc2V0PTY0DQo+ID4gICAgWzRdIFNUUlVDVCAnc29t
ZXRoaW5nJyBzaXplPTIgdmxlbj0yDQo+ID4gICAgICAgICAgJ2xvY2tlZCcgdHlwZV9pZD0xIGJp
dHNfb2Zmc2V0PTANCj4gPiAgICAgICAgICAncGVuZGluZycgdHlwZV9pZD0xIGJpdHNfb2Zmc2V0
PTgNCj4gPg0KPiA+IER1ZSB0byB0aGUgc2l0dWF0aW9uIG1lbnRpb25lZCBpbiB0aGUgYmVnaW5u
aW5nIG9mIHRoZSB0aHJlYWQsIHRoZSAqcnVudGltZSoNCj4gPiBrZXJuZWwgaGF2ZSBhIGRpZmZl
cmVudCBiYXNlIEJURiwgaW4gdGhpcyBjYXNlIHR5cGUgSURzIGFyZSBvZmZzZXQgYnkgMSBkdWUN
Cj4gPiB0byBhbiBhZGRpdGlvbmFsIHR5cGVkZWYgZW50cnk6DQo+ID4NCj4gPiAgICBbMV0gVFlQ
RURFRiAndTgnIHR5cGVfaWQ9MQ0KPiA+ICAgIFsyXSBJTlQgJ3Vuc2lnbmVkIGNoYXInIHNpemU9
MSBiaXRzX29mZnNldD0wIG5yX2JpdHM9OCBlbmNvZGluZz0obm9uZSkNCj4gPiAgICBbM10gUFRS
ICcoYW5vbiknIHR5cGVfaWQ9Mw0KPiA+ICAgIFs0XSBTVFJVQ1QgJ2xpc3RfaGVhZCcgc2l6ZT0x
NiB2bGVuPTINCj4gPiAgICAgICAgICAnbmV4dCcgdHlwZV9pZD0yIGJpdHNfb2Zmc2V0PTANCj4g
PiAgICAgICAgICAncHJldicgdHlwZV9pZD0yIGJpdHNfb2Zmc2V0PTY0DQo+ID4gICAgWzVdIFNU
UlVDVCAnc29tZXRoaW5nJyBzaXplPTIgdmxlbj0yDQo+ID4gICAgICAgICAgJ2xvY2tlZCcgdHlw
ZV9pZD0xIGJpdHNfb2Zmc2V0PTANCj4gPiAgICAgICAgICAncGVuZGluZycgdHlwZV9pZD0xIGJp
dHNfb2Zmc2V0PTgNCj4gPg0KPiA+IFRoZW4gd2hlbiBsb2FkaW5nIHRoZSBCVEYgb24ga2VybmVs
IG1vZHVsZSBvbiB0aGUgcnVudGltZSwgdGhlIGtlcm5lbCB3aWxsDQo+ID4gbWlzdGFrZW5seSBp
bnRlcnByZXRzICJQVFIgJyhhbm9uKScgdHlwZV9pZD00IiBhcyBgc3RydWN0IGxpc3RfaGVhZCAq
YA0KPiA+IHJhdGhlciB0aGFuIGBzdHJ1Y3Qgc29tZXRoaW5nICpgLg0KPiA+DQo+ID4gRG9lcyB0
aGlzIHNob3VsZCBwb3NzaWJsZT8gKGF0IGxlYXN0IHRoZW9yZXRpY2FsbHkpDQo+IA0KPiBUaGFu
a3MgZm9yIGV4cGxhbmF0aW9uLiBZZXMsIGZyb20gQlRGIHR5cGUgcmVzb2x1dGlvbiBwb2ludCBv
ZiB2aWV3LA0KPiB5ZXMgaXQgaXMgcG9zc2libGUuDQoNClRoaXMgbG9va3Mgc28gbXVjaCBsaWtl
IHRoZSBvbGQgJ3NoYXJlZCBsaWJyYXJ5IGZ1bmN0aW9uIG51bWJlcicNCm9yZGluYWxzIGZyb20g
cHJlLVNZU1YgYW5kIGVhcmx5IHdpbmRvd3Mgc2hhcmVkIGxpYnJhcmllcy4NClRoZXJlIGlzIGEg
Z29vZCByZWFzb24gd2h5IGl0IGlzbid0IGRvbmUgdGhhdCB3YXkgYW55IG1vcmUuDQoNCkhhcyBz
b21lb25lIHJlLWludmVudGVkIHRoZSBzcXVhcmUgd2hlZWw/Pw0KDQoJRGF2aWQNCg0KLQ0KUmVn
aXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRv
biBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

