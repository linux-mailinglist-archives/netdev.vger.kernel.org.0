Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA89E529D9C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbiEQJMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243230AbiEQJMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:12:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6C70639E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:12:42 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-248-W1DiUE4lN7-y_bDmqqaGxw-1; Tue, 17 May 2022 10:12:40 +0100
X-MC-Unique: W1DiUE4lN7-y_bDmqqaGxw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Tue, 17 May 2022 10:12:39 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Tue, 17 May 2022 10:12:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: UDP receive performance drop since 3.10
Thread-Topic: UDP receive performance drop since 3.10
Thread-Index: AdhpCyTkrjZFcHw/Sxqn9+GJ1PBwvwAHdBAAACkms7A=
Date:   Tue, 17 May 2022 09:12:39 +0000
Message-ID: <94a05ca671ab4197a8f4304f18678d08@AcuMS.aculab.com>
References: <d11a2ce6ed394acd8c6da29d0358f7ce@AcuMS.aculab.com>
 <ca1ade8ae0f20695c687580b2e1fbb75bf8a5d4b.camel@redhat.com>
In-Reply-To: <ca1ade8ae0f20695c687580b2e1fbb75bf8a5d4b.camel@redhat.com>
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

RnJvbTogUGFvbG8gQWJlbmkNCj4gU2VudDogMTYgTWF5IDIwMjIgMTU6MjkNCj4gDQo+IE9uIE1v
biwgMjAyMi0wNS0xNiBhdCAxMjo1OCArMDAwMCwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IEkn
dmUgbm90aWNlZCBhIGRvdWJsaW5nIGluIHRoZSBjcHUgY29zdCBvZiB1ZHAgcHJvY2Vzc2luZw0K
PiA+IGJldHdlZW4gYSBSSEVMIDMuMTAga2VybmVsIGFuZCBhIDUuMTgtcmM2IG9uZS4NCj4gPg0K
PiA+IFRoaXMgaXMgKHByb2JhYmx5KSBhbGwgd2l0aGluIGlwX3JjdigpLg0KPiA+DQo+ID4gSSdt
IHRlc3RpbmcgdmVyeSBoaWdoIHJhdGUgVURQIHJlY2VpdmUgb2YgUlRQIGF1ZGlvLg0KPiA+IChU
aGUgdGFyZ2V0IGlzIDUwMDAwMCB1ZHAvc2VjLikNCj4gPiBJJ3ZlIGVuYWJsZSBSUFMgc28gdGhh
dCBpcF9yY3YoKSBydW5zIG9uIGRpZmZlcmVudCBtdWx0aXBsZQ0KPiA+IGNwdXMgZnJvbSB0aGUg
ZXRoZXJuZXQgY29kZS4NCj4gPiAoUlNTIG9uIHRoZSBCQ001NzIwICh0ZzMpIGRvZXNuJ3Qgc2Vl
bSB0byB3b3JrIHZlcnkgd2VsbC4pDQo+ID4NCj4gPiBPbiB0aGUgMy4xMCBrZXJuZWwgdGhlICdS
UFMnIGNwdSBzaG93IGFib3V0IDUlICdzb2Z0IGludCcgdGltZS4NCj4gPiBXaXRoIDUuMTAgdGhp
cyBoYXMgZG91YmxlZCB0byAxMCUgZm9yIG11Y2ggdGhlIHNhbWUgdGVzdC4NCj4gPg0KLi4uDQo+
ID4NCj4gPiBOb3cgSSBrbm93IHRoZSBjb3N0IG9mIGZ0cmFjZSBpcyBzaWduaWZpY2FudCAoYW5k
IHNlZW1zIHRvIGJlDQo+ID4gaGlnaGVyIGluIDUuMTgpIGJ1dCB0aGVyZSBhbHNvIHNlZW1zIHRv
IGJlIGEgbG90IG1vcmUgY29kZS4NCj4gPiBBcyB3ZWxsIGFzIHRoZSBleHRyYSByY3UgbG9ja3Mg
KHdoaWNoIGFyZSBwcm9iYWJseSBtb3N0bHkgZnRyYWNlDQo+ID4gb3ZlcmhlYWQsIGEgZmV3IG90
aGVyIHRoaW5ncyBzdGljayBvdXQ6DQo+ID4NCj4gPiAxKSBUaGUgc29ja19uZXRfdWlkKG5ldCwg
TlVMTCkgY2FsbHMuDQo+ID4gICAgVGhlc2UgYXJlIG1ha2Vfa3VpZChuZXQtPnVzZXJfbnMsIDAp
IC0gc28gcHJldHR5IG11Y2ggY29uc3RhbnQuDQo+ID4gICAgVGhleSBzZWVtIHRvIGVuZCB1cCBp
biBhIGxvb3AgaW4gbWFwX2lkX3JhbmdlX2Rvd25fYmFzZSgpLg0KPiA+ICAgIEFsbCBsb29rcyBl
eHBlbnNpdmUgaW4gdGhlIGRlZmF1bHQgbmV0d29yayBuYW1lc3BhY2Ugd2hlcmUNCj4gPiAgICAw
IG1hcHMgdG8gMC4NCj4gPg0KPiA+IDIpIEV4dHJhIGNvZGUgaW4gZmliX2xvb2t1cCgpLg0KPiA+
DQo+ID4gMykgQSBsb3QgbW9yZSBsb2NraW5nIGluIGVwX3BvbGxfY2FsbGJhY2soKS4NCj4gPg0K
PiA+IFRoZSA1LjE4IGtlcm5lbCBhbHNvIHNlZW1zIHRvIGhhdmUgQ09ORklHX0RFQlVHX1BSRUVN
UFQgc2V0Lg0KPiA+IEkgY2FuJ3QgZmluZCB0aGUgS2NvbmZpZyBlbnRyeSBmb3IgaXQuDQo+ID4g
SXQgZG9lc24ndCBleGlzdCBpbiB0aGUgb2xkIC5jb25maWcgYXQgYWxsLg0KPiA+IFNvIEknbSBu
b3Qgc3VyZSB3aHkgJ21ha2Ugb2xkY29uZmlnJyBwaWNrZWQgaXQgdXAuDQo+ID4NCj4gPiBUaGUg
b3RoZXIgcG9zc2liaWxpdHkgaXMgdGhhdCB0aGUgZXh0cmEgY29kZSBpcyB0aWNrX25vaHpfaWRs
ZV9leGl0KCkuDQo+ID4gVGhlIDMuMTAgdHJhY2UgaXMgZnJvbSBhIG5vbi1SUFMgY29uZmlnIHNv
IEkgY2FuJ3QgY29tcGFyZSBpdC4NCj4gPg0KPiA+IEknbSBnb2luZyB0byBkaXNhYmxlIENPTkZJ
R19ERUJVR19QUkVFTVBUIHRvIHNlZSBob3cgbXVjaA0KPiA+IGRpZmZlcmVuY2UgaXQgbWFrZXMu
DQo+ID4gQW55IGlkZWEgaWYgYW55IG90aGVyIGRlYnVnIG9wdGlvbnMgd2lsbCBoYXZlIGdvdCBw
aWNrZWQgdXA/DQo+IA0KPiBEbyB5b3UgaGF2ZSBDT05GSUdfUFJFRU1QVF9EWU5BTUlDIGluIHlv
dXIgY29uZmlnPyBUaGF0IHdhcyBub3QNCj4gYXZhaWxhYmxlIGluIDMuMTAgYW5kIGFwcGFyZW50
bHkgaXQgcHVsbHMgcXVpdGUgYSBiaXQgb2Ygc3R1ZmYsIHdoaWNoDQo+IGluIHRoZSBlbmQgc2hv
dWxkIGJlIHF1aXRlIG1lYXN1cmFibGUuIFRoZSBwcmVlbXB0IGNvdW50IGFsb25lIGFkZHMNCj4g
fjd1cyB0byB0aGUgYWJvdmUgc2FtcGxlLg0KDQpUaGF0IHdhcyBlbmFibGVkLCBJJ3ZlIG5vdyB0
dXJuZWQgaXQgb2ZmLg0KQnV0IHRoZSB0aW1pbmdzIGZyb20gYSBmdWxsIGZ0cmFjZSBhcmUgZG9t
aW5hdGVkIGJ5IGZ0cmFjZSBpdHNlbGYuDQpTbyB0aGUgfjd1cyBpcyBhIG1hc3NpdmUgb3ZlcnN0
YXRlbWVudC4NCg0KSSB3aWxsIGRvIHNvbWUgdGltaW5ncyBmb3IganVzdCBpcF9yY3YoKSBhbmQg
cHJvYmFibHkgZXBfcG9sbF9jYWxsYmFjaygpDQp0byBzZWUgaWYgSSBjYW4gaXNvbGF0ZSB0aGUg
aW5jcmVhc2UuDQpJJ2xsIG5lZWQgdG8gZ28gaW50byB0aGUgb2ZmaWNlIHRvIGJvb3QgdGhlIG9s
ZCBrZXJuZWwuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

