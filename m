Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1544781865
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 13:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfHELtR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Aug 2019 07:49:17 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:24266 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbfHELtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 07:49:16 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-160-NQwNEFbuMJmxd-wtY4RQAg-1; Mon, 05 Aug 2019 12:49:13 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 5 Aug 2019 12:49:12 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 5 Aug 2019 12:49:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joe Perches' <joe@perches.com>,
        Neil Horman <nhorman@tuxdriver.com>
CC:     Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: sctp: Rename fallthrough label to unhandled
Thread-Topic: [PATCH] net: sctp: Rename fallthrough label to unhandled
Thread-Index: AQHVSJCHKC4hvRwdKE+hlvEjJaGqZabsda0g
Date:   Mon, 5 Aug 2019 11:49:12 +0000
Message-ID: <40493bf4256c4b62b211e2e60fa7f8b8@AcuMS.aculab.com>
References: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
         <20190731111932.GA9823@hmswarspite.think-freely.org>
         <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
         <20190731121646.GD9823@hmswarspite.think-freely.org>
         <b93bbb17b407e27bb1dc196af84e4f289d9dfd93.camel@perches.com>
         <20190731205804.GE9823@hmswarspite.think-freely.org>
         <d68403ce9f7e8a68fff09d6b17e5d1327eb1e12d.camel@perches.com>
         <20190801105051.GA11487@hmswarspite.think-freely.org>
 <a9d003ddd0d59fb144db3ecda3453b3d9c0cb139.camel@perches.com>
In-Reply-To: <a9d003ddd0d59fb144db3ecda3453b3d9c0cb139.camel@perches.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: NQwNEFbuMJmxd-wtY4RQAg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches
> Sent: 01 August 2019 18:43
> On Thu, 2019-08-01 at 06:50 -0400, Neil Horman wrote:
> > On Wed, Jul 31, 2019 at 03:23:46PM -0700, Joe Perches wrote:
> []
> > You can say that if you want, but you made the point that your think the macro
> > as you have written is more readable.  You example illustrates though that /*
> > fallthrough */ is a pretty common comment, and not prefixing it makes it look
> > like someone didn't add a comment that they meant to.  The __ prefix is standard
> > practice for defining macros to attributes (212 instances of it by my count).  I
> > don't mind rewriting the goto labels at all, but I think consistency is
> > valuable.
> 
> Hey Neil.
> 
> Perhaps you want to make this argument on the RFC patch thread
> that introduces the fallthrough pseudo-keyword.
> 
> https://lore.kernel.org/patchwork/patch/1108577/

ISTM that the only place where you need something other than the
traditional comment is inside a #define where (almost certainly)
the comments have to get stripped too early.

Adding a 'fallthough' as unknown C keyword sucks...


	David

 

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

