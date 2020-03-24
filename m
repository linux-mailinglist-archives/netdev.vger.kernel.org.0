Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB0E190A85
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgCXKTQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Mar 2020 06:19:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20139 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgCXKTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:19:16 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-116-XvYZ5o_bPUynf6oKBNu4hQ-1; Tue, 24 Mar 2020 10:19:11 +0000
X-MC-Unique: XvYZ5o_bPUynf6oKBNu4hQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 24 Mar 2020 10:19:11 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 24 Mar 2020 10:19:11 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] Remove DST_HOST
Thread-Topic: [PATCH net-next] Remove DST_HOST
Thread-Index: AdYBH4gs8HTGreJ2SnCmnalhRsiIuQAeUTUAAAsrx2A=
Date:   Tue, 24 Mar 2020 10:19:11 +0000
Message-ID: <9d3bd683e9d24d1da098b725d44812a0@AcuMS.aculab.com>
References: <746901f88f174ea8bda66e37f92961e6@AcuMS.aculab.com>
 <20200323.215804.1954283596047238734.davem@davemloft.net>
In-Reply-To: <20200323.215804.1954283596047238734.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller
> Sent: 24 March 2020 04:58
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Mon, 23 Mar 2020 14:31:19 +0000
> 
> > Previous changes to the IP routing code have removed all the
> > tests for the DS_HOST route flag.
> > Remove the flags and all the code that sets it.
> >
> > Signed-off-by: David Laight <david.laight@aculab.com>
> 
> Applied, thanks.
> 
> > NB this may need rebasing.
> 
> It wasn't too bad.

Thanks.
I need to generate a clean git tree agian.
Then try to add some of my patches.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

