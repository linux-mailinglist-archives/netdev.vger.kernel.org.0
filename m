Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8767C72B19
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGXJID convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Jul 2019 05:08:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:60521 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbfGXJIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:08:02 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-172-H7YwMkYqPje5KEVTEaV6bA-1; Wed, 24 Jul 2019 10:07:59 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed,
 24 Jul 2019 10:07:58 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 24 Jul 2019 10:07:58 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stephen Hemminger' <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "alexanderk@mellanox.com" <alexanderk@mellanox.com>,
        "mlxsw@mellanox.com" <mlxsw@mellanox.com>
Subject: RE: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Thread-Topic: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Thread-Index: AQHVQX+jEWvddLjk40i/ld9mPHU99qbZenKw
Date:   Wed, 24 Jul 2019 09:07:58 +0000
Message-ID: <48a250ba23394bdba024cd493717cb55@AcuMS.aculab.com>
References: <20190723112538.10977-1-jiri@resnulli.us>
 <20190723105401.4975396d@hermes.lan>
In-Reply-To: <20190723105401.4975396d@hermes.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: H7YwMkYqPje5KEVTEaV6bA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger
> Sent: 23 July 2019 18:54
> 
> On Tue, 23 Jul 2019 13:25:37 +0200
> Jiri Pirko <jiri@resnulli.us> wrote:
> 
> > From: Jiri Pirko <jiri@mellanox.com>
> >
> > One cannot depend on *argv being null in case of no arg is left on the
> > command line. For example in batch mode, this is not always true. Check
> > argc instead to prevent crash.

Hmmm... expecting the increments of argv and decrements of argc to match
it probably wishful thinking....
A lot of parsers don't even look at argc.

> Actually makeargs does NULL terminate the last arg so what input
> to batchmode is breaking this?

The 'usual' problem is an extra increment of argv because the last entry
was something that 'eats' two or more entries.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

