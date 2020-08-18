Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7221B249019
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHRV2s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 17:28:48 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:32657 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgHRV2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:28:48 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-257-U8zTTHz2NYCSMZnRqMw9mw-1; Tue, 18 Aug 2020 22:28:43 +0100
X-MC-Unique: U8zTTHz2NYCSMZnRqMw9mw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 18 Aug 2020 22:28:43 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 18 Aug 2020 22:28:43 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Subject: RE: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Thread-Topic: [PATCH] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Index: AdZ1bPXrgdZCqbhgQru55h+86tsQbgAJIzsAAAUst+A=
Date:   Tue, 18 Aug 2020 21:28:43 +0000
Message-ID: <507feeb112794dcbb206ab630bf6b6be@AcuMS.aculab.com>
References: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
 <20200818.125808.1491339435094413330.davem@davemloft.net>
In-Reply-To: <20200818.125808.1491339435094413330.davem@davemloft.net>
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

From: David Miller
> Sent: 18 August 2020 20:58
> 
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Tue, 18 Aug 2020 14:36:58 +0000
> 
> > Fixes 2075e50caf5ea.
> >
> > Signed-off-by: David Laight <david.laight@aculab.com>
> 
> This is not the correct format for a Fixes tag, also it should not
> be separated by empty lines from other tags such as Signed-off-by
> and Acked-by.
> 
> As someone who reads netdev frequently, these patterns should be
> etched into your brain by now. :-)

Sorry I don't often write patches - I'm only paid to support
our drivers, not fix the Linux kernel :-)
(We don't ship a kernel, our drivers have to work in disto kernels.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

