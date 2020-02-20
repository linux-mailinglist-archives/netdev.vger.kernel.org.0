Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B17166409
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgBTRLq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Feb 2020 12:11:46 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48534 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727709AbgBTRLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:11:45 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-251-ErT84Mw2OD2Kl-cunigafA-1; Thu, 20 Feb 2020 17:11:42 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 20 Feb 2020 17:11:41 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 20 Feb 2020 17:11:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kuniyuki Iwashima' <kuniyu@amazon.co.jp>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "kuni1840@gmail.com" <kuni1840@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "osa-contribution-log@amazon.com" <osa-contribution-log@amazon.com>
Subject: RE: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Thread-Topic: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Thread-Index: AQHV6AFTighrXj68Q0S8xkdYh/UVXqgkUKtw
Date:   Thu, 20 Feb 2020 17:11:41 +0000
Message-ID: <2aead5c10d7c4bc6b80bbc5f079bef8e@AcuMS.aculab.com>
References: <20200220152020.13056-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200220152020.13056-1-kuniyu@amazon.co.jp>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: ErT84Mw2OD2Kl-cunigafA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima
> Sent: 20 February 2020 15:20
> 
> Currently we fail to bind sockets to ephemeral ports when all of the ports
> are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
> we still have a chance to connect to the different remote hosts.
> 
> The second and third patches fix the behaviour to fully utilize all space
> of the local (addr, port) tuples.

Would it make sense to only do this for the implicit bind() done
when connect() is called on an unbound socket?
In that case only the quadruplet of the local and remote addresses
needs to be unique.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

