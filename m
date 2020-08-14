Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808B424484B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgHNKu1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Aug 2020 06:50:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:55022 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727074AbgHNKuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 06:50:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-77-hlXDbR_fMUqZEGGj0cm_GA-1; Fri, 14 Aug 2020 11:50:21 +0100
X-MC-Unique: hlXDbR_fMUqZEGGj0cm_GA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 14 Aug 2020 11:50:20 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Aug 2020 11:50:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: num_ostreams and max_instreams negotiation
Thread-Topic: num_ostreams and max_instreams negotiation
Thread-Index: AdZyJ9ADjH3a7lNFS5SQSVqLsdlEog==
Date:   Fri, 14 Aug 2020 10:50:20 +0000
Message-ID: <0b4319e4b2cf4ee68fc2b0183536aa7a@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At some point the negotiation of the number of SCTP streams
seems to have got broken.
I've definitely tested it in the past (probably 10 years ago!)
but on a 5.8.0 kernel getsockopt(SCTP_INFO) seems to be
returning the 'num_ostreams' set by setsockopt(SCTP_INIT)
rather than the smaller of that value and that configured
at the other end of the connection.

I'll do a bit of digging.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

