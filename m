Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07F2885B4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733023AbgJIJAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:00:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:41103 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732962AbgJIJAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 05:00:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-236-3p11TCI_Nt6wuFytF7l0RQ-1; Fri, 09 Oct 2020 10:00:42 +0100
X-MC-Unique: 3p11TCI_Nt6wuFytF7l0RQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 9 Oct 2020 10:00:41 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 9 Oct 2020 10:00:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Johannes Berg' <johannes@sipsolutions.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nstange@suse.de" <nstange@suse.de>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>
Subject: RE: [CRAZY-RFF] debugfs: track open files and release on remove
Thread-Topic: [CRAZY-RFF] debugfs: track open files and release on remove
Thread-Index: AQHWnhTYAkCadt4V/kCnonv0tSsTz6mO7mnQ///1fYCAABMO0A==
Date:   Fri, 9 Oct 2020 09:00:41 +0000
Message-ID: <e086db3e422b401d9a4df896696f75b8@AcuMS.aculab.com>
References: <87v9fkgf4i.fsf@suse.de>
         <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
         <20201009080355.GA398994@kroah.com>
         <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
         <20201009081624.GA401030@kroah.com>
         <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
         <03c42bb5f57a4c3d9c782a023add28cd@AcuMS.aculab.com>
 <e3a807b1d5f728c178f43b453f3b495bf53abfce.camel@sipsolutions.net>
In-Reply-To: <e3a807b1d5f728c178f43b453f3b495bf53abfce.camel@sipsolutions.net>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9oYW5uZXMgQmVyZw0KPiBTZW50OiAwOSBPY3RvYmVyIDIwMjAgMDk6NDUNCj4gDQo+
IE9uIEZyaSwgMjAyMC0xMC0wOSBhdCAwODozNCArMDAwMCwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0K
PiA+DQouLi4NCj4gPiBEb2VzIGl0IGV2ZXIgbWFrZSBhbnkgc2Vuc2UgdG8gc2V0IC5vd25lciB0
byBhbnl0aGluZyBvdGhlciB0aGFuDQo+ID4gVEhJU19NT0RVTEU/DQo+IA0KPiBOby4gQnV0IEkg
YmVsaWV2ZSBUSElTX01PRFVMRSBpcyBOVUxMIGZvciBidWlsdC1pbiBjb2RlLCBzbyB3ZSBjYW4n
dA0KPiBqdXN0IFdBUk5fT04oIWZvcHMtPm93bmVyKS4NCi4uLg0KPiA+IEkgd2FzIGFsc28gd29u
ZGVyaW5nIGlmIHRoaXMgYWZmZWN0cyBub3JtYWwgb3BlbnM/DQo+ID4gVGhleSBzaG91bGQgaG9s
ZCBhIHJlZmVyZW5jZSBvbiB0aGUgbW9kdWxlIHRvIHN0b3AgaXQgYmVpbmcgdW5sb2FkZWQuDQo+
ID4gRG9lcyB0aGF0IHJlbHkgb24gLm93bmVyIGJlaW5nIHNldD8NCj4gDQo+IFllcy4NCg0KU291
bmQgbGlrZSB0aGUgbW9kdWxlIGxvYWQgY29kZSBzaG91bGQgYmUgdmVyaWZ5aW5nIGl0IHRoZW4u
DQoNCkxvb2tpbmcgYXQgb25lIG9mIG15IG1vZHVsZXMgKHdoaWNoIGRvZXMgc2V0IC5vd25lciku
DQpQZXJoYXBzIGNkZXZfaW5pdCgpIGNvdWxkIGJlIGEgI2RlZmluZSB0aGF0IHBpY2tzIHVwIFRI
SVNfTU9EVUxFLg0KVGhpcyBjb3VsZCB0aGVuIGJlIGNoZWNrZWQgYWdhaW5zdCB0aGUgb25lIGlu
IGZvcHMgb3Igc2F2ZWQNCmluIHRoZSAnc3RydWN0IGNkZXYnLg0KDQpJIHByZXN1bWUgZGVidWdm
cyAod2hpY2ggSSd2ZSBub3QgdXNlZCkgaGFzIHNvbWUgc2ltaWxhciBjYWxscy4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

