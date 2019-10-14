Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F07D5DDE
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfJNIt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:49:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25486 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730366AbfJNIt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:49:58 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-156-_sW8JPNkNx2thsgzGTGsDg-1; Mon, 14 Oct 2019 09:49:55 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 14 Oct 2019 09:49:54 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 14 Oct 2019 09:49:54 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
CC:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Thread-Topic: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Thread-Index: AQHVfcsgrQL6OT4GuU648eHSKFH716dQtSlAgAkkN96AAAI4YA==
Date:   Mon, 14 Oct 2019 08:49:54 +0000
Message-ID: <ae526ae5437349e9bbfdf97286603d94@AcuMS.aculab.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
 <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org>
 <CADvbK_fb9jjm-h-XyVci971Uu=YuwMsUjWEcv9ehUv9Q6W_VxQ@mail.gmail.com>
In-Reply-To: <CADvbK_fb9jjm-h-XyVci971Uu=YuwMsUjWEcv9ehUv9Q6W_VxQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: _sW8JPNkNx2thsgzGTGsDg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWGluIExvbmcgPGx1Y2llbi54aW5AZ21haWwuY29tPg0KPiBTZW50OiAxNCBPY3RvYmVy
IDIwMTkgMDk6MzcNCi4uLg0KPiBSRkMgYWN0dWFsbHkga2VlcHMgYWRkaW5nIG5ldyBub3RpZmlj
YXRpb25zLA0KDQpUaGF0IFJGQyBrZWVwcyBtb3ZpbmcgdGhlIGdvYWxwb3N0cy4NCkV2ZW4gdGhl
IHN0cnVjdHVyZXMgYXJlIGd1YXJhbnRlZWQgdG8gaGF2ZSBob2xlcy4NCg0KPiBhbmQgYSB1c2Vy
IHNob3VsZG4ndCBleHBlY3QNCj4gdGhlIHNwZWNpZmljIG5vdGlmaWNhdGlvbnMgY29taW5nIGlu
IHNvbWUgZXhhY3Qgb3JkZXJzLiBUaGV5IHNob3VsZCBqdXN0DQo+IGlnbm9yZSBpdCBhbmQgd2Fp
dCB1bnRpbCB0aGUgb25lcyB0aGV5IGV4cGVjdC4gSSBkb24ndCB0aGluayBzb21lIHVzZXJzDQo+
IHdvdWxkIGFib3J0IGl0cyBhcHBsaWNhdGlvbiB3aGVuIGdldHRpbmcgYW4gdW5leHBlY3RlZCBu
b3RpZmljYXRpb24uDQoNCkkndmUgYW4gZXhhbXBsZSBvZiBleGFjdGx5IDEgYXBwbGljYXRpb24u
DQpJdCB1c2VzIFRDUC1zdHlsZSBzb2NrZXRzIChhbmQgd2lsbCB3b3JrIG92ZXIgVENQKS4NCkl0
IGRvZXMgZ2V0c29ja29wdChTQ1RQX0VWRU5UUyksIHNldHMgc2N0cF9hc3NvY2lhdGlvbl9ldmVu
dCwgdGhlbiBzZXRzb2Nrb3B0KCkuDQpBbnkgTVNHX05PVElGSUNBVElPTiBpcyBhc3N1bWVkIHRv
IGJlIHRoZSBhIGNvbm5lY3Rpb24gcmVzZXQgKGVuYWJsZWQgYWJvdmUpDQphbmQgdHJlYXRlZCBh
cyBhbiBpbndhcmRzIGRpc2Nvbm5lY3QuDQoNClNvIGFueSB1bmV4cGVjdGVkIG5vdGlmaWNhdGlv
biB3aWxsIGtpbGwgdGhlIGNvbm5lY3Rpb24uDQoNCkkgc3VzcGVjdCBpdCBpc24ndCB0aGUgb25s
eSBvbmUuLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

