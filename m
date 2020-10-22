Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0EA2966FA
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 00:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370028AbgJVWHJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 18:07:09 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43598 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2898305AbgJVWHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 18:07:08 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-164-7-H9NMQeNwGwZfcU7aRApw-1; Thu, 22 Oct 2020 23:07:03 +0100
X-MC-Unique: 7-H9NMQeNwGwZfcU7aRApw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 22 Oct 2020 23:07:02 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 22 Oct 2020 23:07:02 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Al Viro' <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        "David Hildenbrand" <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: RE: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Thread-Topic: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Thread-Index: AQHWqE5GNDfnH4y9nkGWtfqJueR1KKmjTCJQgAAN4UiAAAD2IIAAQY5tgAAwVkCAADSfg4AALKrQ
Date:   Thu, 22 Oct 2020 22:07:02 +0000
Message-ID: <f35a74d034054d7fa8ce8835afb1ca6c@AcuMS.aculab.com>
References: <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022132342.GB8781@lst.de>
 <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com>
 <CAKwvOdnix6YGFhsmT_mY8ORNPTOsN3HwS33Dr0Ykn-pyJ6e-Bw@mail.gmail.com>
 <CAK8P3a3LjG+ZvmQrkb9zpgov8xBkQQWrkHBPgjfYSqBKGrwT4w@mail.gmail.com>
 <CAKwvOdnhONvrHLAuz_BrAuEpnF5mD9p0YPGJs=NZZ0EZNo7dFQ@mail.gmail.com>
 <20201022192458.GV3576660@ZenIV.linux.org.uk>
In-Reply-To: <20201022192458.GV3576660@ZenIV.linux.org.uk>
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
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro
> Sent: 22 October 2020 20:25
> 
> On Thu, Oct 22, 2020 at 12:04:52PM -0700, Nick Desaulniers wrote:
> 
> > Passing an `unsigned long` as an `unsigned int` does no such
> > narrowing: https://godbolt.org/z/TvfMxe (same vice-versa, just tail
> > calls, no masking instructions).
> > So if rw_copy_check_uvector() is inlined into import_iovec() (looking
> > at the mainline@1028ae406999), then children calls of
> > `rw_copy_check_uvector()` will be interpreting the `nr_segs` register
> > unmodified, ie. garbage in the upper 32b.
> 
> FWIW,
> 
> void f(unsinged long v)
> {
> 	if (v != 1)
> 		printf("failed\n");
> }
> 
> void g(unsigned int v)
> {
> 	f(v);
> }
> 
> void h(unsigned long v)
> {
> 	g(v);
> }
> 
> main()
> {
> 	h(0x100000001);
> }
> 
> must not produce any output on a host with 32bit int and 64bit long, regardless of
> the inlining, having functions live in different compilation units, etc.
> 
> Depending upon the calling conventions, compiler might do truncation in caller or
> in a callee, but it must be done _somewhere_.

Put g() in a separate compilation unit and use the 'wrong' type
in the prototypes t() used to call g() and g() uses to call f().

Then you might see where and masking does (or does not) happen.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

