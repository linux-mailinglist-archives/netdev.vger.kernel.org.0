Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B56837A7FC
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhEKNp7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 May 2021 09:45:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:53765 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231643AbhEKNpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:45:55 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-90-u6_30JzFPh2ZNfstzjEviw-1; Tue, 11 May 2021 14:44:46 +0100
X-MC-Unique: u6_30JzFPh2ZNfstzjEviw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 11 May 2021 14:44:45 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Tue, 11 May 2021 14:44:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matthew Wilcox' <willy@infradead.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: [PATCH] udp: Switch the order of arguments to copy_linear_skb
Thread-Topic: [PATCH] udp: Switch the order of arguments to copy_linear_skb
Thread-Index: AQHXRlmlQPna6YyAckavKt6/OjmurareQVGA///3HICAABItsA==
Date:   Tue, 11 May 2021 13:44:45 +0000
Message-ID: <73f91574e34f4b92910e2afd012e16f4@AcuMS.aculab.com>
References: <20210511113400.1722975-1-willy@infradead.org>
 <ae8f4e176b17439b87420cad69fbabf9@AcuMS.aculab.com>
 <YJqI3Vixcqr+jyZX@casper.infradead.org>
In-Reply-To: <YJqI3Vixcqr+jyZX@casper.infradead.org>
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

From: Matthew Wilcox
> Sent: 11 May 2021 14:39
> 
> On Tue, May 11, 2021 at 01:11:42PM +0000, David Laight wrote:
> > From: Matthew Wilcox
> > > Sent: 11 May 2021 12:34
> > >
> > > All other skb functions use (off, len); this is the only one which
> > > uses (len, off).  Make it consistent.
> >
> > I wouldn't change the order of the arguments without some other
> > change that ensures old code fails to compile.
> > (Like tweaking the function name.)
> 
> Yes, some random essentially internal function that has had no new
> users since it was created in 2017 should get a new name *eyeroll*.
> 
> Please find more useful things to critique.  Or, you know, write some
> damned code yourself instead of just having opinions.

You could easily completely screw up any code that isn't committed
to the kernel source tree.
It isn't the sort of bug I'd want to diagnose.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

