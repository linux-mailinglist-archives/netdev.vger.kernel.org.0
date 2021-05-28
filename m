Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC10E393E6E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 10:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbhE1ILT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 04:11:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:20447 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234226AbhE1ILS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 04:11:18 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-154-jW9gY-4NOEegDDbnS88x7w-1; Fri, 28 May 2021 09:09:41 +0100
X-MC-Unique: jW9gY-4NOEegDDbnS88x7w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 28 May 2021 09:09:39 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 28 May 2021 09:09:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrii Nakryiko' <andrii.nakryiko@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: RE: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Thread-Topic: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Thread-Index: AQHXUwZwxICJrzVIrECdOMP8p5MLKKr4istw
Date:   Fri, 28 May 2021 08:09:39 +0000
Message-ID: <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
References: <20210526080741.GW30378@techsingularity.net>
 <YK9SiLX1E1KAZORb@infradead.org> <20210527090422.GA30378@techsingularity.net>
 <YK9j3YeMTZ+0I8NA@infradead.org>
 <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
 <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com>
In-Reply-To: <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com>
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

RnJvbTogQW5kcmlpIE5ha3J5aWtvDQo+IFNlbnQ6IDI3IE1heSAyMDIxIDE1OjQyDQouLi4NCj4g
SSBhZ3JlZSB0aGF0IGVtcHR5IHN0cnVjdHMgYXJlIHVzZWZ1bCwgYnV0IGhlcmUgd2UgYXJlIHRh
bGtpbmcgYWJvdXQNCj4gcGVyLUNQVSB2YXJpYWJsZXMgb25seSwgd2hpY2ggaXMgdGhlIGZpcnN0
IHVzZSBjYXNlIHNvIGZhciwgYXMgZmFyIGFzDQo+IEkgY2FuIHNlZS4gSWYgd2UgaGFkIHBhaG9s
ZSAxLjIyIHJlbGVhc2VkIGFuZCB3aWRlbHkgcGFja2FnZWQgaXQgY291bGQNCj4gaGF2ZSBiZWVu
IGEgdmlhYmxlIG9wdGlvbiB0byBmb3JjZSBpdCBvbiBldmVyeW9uZS4gDQouLi4NCg0KV291bGQg
aXQgYmUgZmVhc2libGUgdG8gcHV0IHRoZSBzb3VyY2VzIGZvciBwYWhvbGUgaW50byB0aGUNCmtl
cm5lbCByZXBvc2l0b3J5IGFuZCBidWlsZCBpdCBhdCB0aGUgc2FtZSB0aW1lIGFzIG9ianRvb2w/
DQoNClRoYXQgd291bGQgcmVtb3ZlIGFueSBpc3N1ZXMgYWJvdXQgdGhlIGxhdGVzdCB2ZXJzaW9u
DQpub3QgYmVpbmcgYXZhaWxhYmxlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

