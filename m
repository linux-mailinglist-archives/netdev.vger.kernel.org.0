Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C51E3BFB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgE0Ibp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 May 2020 04:31:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:27984 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725949AbgE0Ibo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 04:31:44 -0400
X-Greylist: delayed 57110 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2020 04:31:43 EDT
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-89-NiIl-uWIP3-PCjHOUhpORQ-1; Wed, 27 May 2020 09:31:39 +0100
X-MC-Unique: NiIl-uWIP3-PCjHOUhpORQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 27 May 2020 09:31:39 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 27 May 2020 09:31:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 net-next 1/8] sctp: setsockopt, expand some #defines
Thread-Topic: [PATCH v3 net-next 1/8] sctp: setsockopt, expand some #defines
Thread-Index: AdYze5zo5xQMv/KcR+CMEQN8gd6YZwAATgFgAAo43YAAFr9esA==
Date:   Wed, 27 May 2020 08:31:39 +0000
Message-ID: <f4662a514b374d2e85ada6d400aed31e@AcuMS.aculab.com>
References: <bab9a624ee2d4e05b1198c3f7344a200@AcuMS.aculab.com>
        <8bb56a30edfb4ff696d44cf9af909d82@AcuMS.aculab.com>
 <20200526.153631.1486651154492951372.davem@davemloft.net>
In-Reply-To: <20200526.153631.1486651154492951372.davem@davemloft.net>
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
> Sent: 26 May 2020 23:37
> > This should be 3/8.
> 
> David just respin this at some point and with this fixed and also the
> header posting saying "0/8" properly instead of "0/1", this is really
> messy.

I have to copy patches onto a windows box.
Then open them in wordpad so I can cut&paste the tabs into outlook.
Then find the correct 'to' address list.

It is somewhat too manual and error prone.

But I'll fix the masters for the next respin (bound to be one).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

