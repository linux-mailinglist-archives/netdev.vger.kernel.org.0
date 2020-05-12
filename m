Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED50B1CEEF6
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgELIR7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 May 2020 04:17:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:60758 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgELIR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:17:59 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-239-SVp19TA-Ox-XgNqyYbzXlQ-1; Tue, 12 May 2020 09:17:55 +0100
X-MC-Unique: SVp19TA-Ox-XgNqyYbzXlQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 12 May 2020 09:17:54 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 12 May 2020 09:17:54 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when
 IP_HDRINCL set.
Thread-Topic: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when
 IP_HDRINCL set.
Thread-Index: AdYm44GMpCoVm8MoQ+GQh1uj0J52IAA6cwwAAALP/JAAAhWAAAAVCWAA
Date:   Tue, 12 May 2020 08:17:54 +0000
Message-ID: <1b516df0533643998bb206c9af77dfa3@AcuMS.aculab.com>
References: <6d52098964b54d848cbfd1957f093bd8@AcuMS.aculab.com>
        <20200511.134938.651986318503897703.davem@davemloft.net>
        <7e8f6c9831244d2bb7c39f9aa4204e90@AcuMS.aculab.com>
 <20200511.160950.1210644073123836829.davem@davemloft.net>
In-Reply-To: <20200511.160950.1210644073123836829.davem@davemloft.net>
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

From: David Miller <davem@davemloft.net>
> Sent: 12 May 2020 00:10
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Mon, 11 May 2020 21:28:18 +0000
> 
> > In this case the "modified in userspace meanwhile" just breaks the
> > application - it isn't any kind of security issue.
> 
> The kernel must provide correct behavior based upon the stable IP
> header that it copies into userspace.  I'm not moving on this
> requirement, sorry.
> 
> I'm sure you have great reasons why you can't use normal UDP sockets
> for RTP traffic, but that's how you will get a cached route and avoid
> this exact problem.

Not unless you can tell me how to create a UDP socket that doesn't
receive data.
Even if there is a corresponding RTP receive flow there is no reason
why it should use the same port numbers and IP addresses.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

