Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1841DA1BC3
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfH2NqB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 09:46:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58982 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727073AbfH2NqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 09:46:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-80-WlFcJJsvMeS7xKcmA-zUBA-1; Thu, 29 Aug 2019 14:45:58 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 29 Aug 2019 14:45:57 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 29 Aug 2019 14:45:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Li,Rongqing'" <lirongqing@baidu.com>,
        Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>
Subject: RE: [PATCH][net-next] net: drop_monitor: change the stats variable to
 u64 in net_dm_stats_put
Thread-Topic: [PATCH][net-next] net: drop_monitor: change the stats variable
 to u64 in net_dm_stats_put
Thread-Index: AQHVWLIGAgIc40Kg3Eiuhdh+WrtPcKcHAAcAgAAI4YCACyV8oA==
Date:   Thu, 29 Aug 2019 13:45:57 +0000
Message-ID: <65dd5d8c5e7c48e0ba484711c8676ab7@AcuMS.aculab.com>
References: <1566454953-29321-1-git-send-email-lirongqing@baidu.com>
 <20190822115946.GA25090@splinter>
 <84063fe4df95437d81beb0d18f4043a5@baidu.com>
In-Reply-To: <84063fe4df95437d81beb0d18f4043a5@baidu.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: WlFcJJsvMeS7xKcmA-zUBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li,Rongqing
> Sent: 22 August 2019 13:32
> > On Thu, Aug 22, 2019 at 02:22:33PM +0800, Li RongQing wrote:
> > > only the element drop of struct net_dm_stats is used, so simplify it
> > > to u64
> >
> > Thanks for the patch, but I don't really see the value here. The struct allows for
> > easy extensions in the future. What do you gain from this change? We merely
> > read stats and report them to user space, so I guess it's not about
> > performance either.
> >
> 
> I think u64 can reduce to call memset and dereference stats.drop

The compiler should inline the memset().

Also you should have called it 'dropped' not 'stats'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

