Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A193D2D4CCF
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbgLIV0i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Dec 2020 16:26:38 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:51627 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729686AbgLIV0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 16:26:37 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-10-FRqOu4oLPtGhG-jw1oU_BA-1; Wed, 09 Dec 2020 21:21:54 +0000
X-MC-Unique: FRqOu4oLPtGhG-jw1oU_BA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 9 Dec 2020 21:21:54 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 9 Dec 2020 21:21:54 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Subject: RE: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
Thread-Topic: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
Thread-Index: AQHWzdxRX1QgNEu/LUu372JTopy8S6nvRYJA
Date:   Wed, 9 Dec 2020 21:21:53 +0000
Message-ID: <801dc0320e484bf7a5048c0cddac12af@AcuMS.aculab.com>
References: <20201209033346.83742-1-xie.he.0141@gmail.com>
In-Reply-To: <20201209033346.83742-1-xie.he.0141@gmail.com>
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

From: Xie He
> Sent: 09 December 2020 03:34
> 
> According to the X.25 documentation, there was a plan to implement
> X.25-over-802.2-LLC. It never finished but left various code stubs in the
> X.25 code. At this time it is unlikely that it would ever finish so it
> may be better to remove those code stubs.

I always wondered about running Class 2 transport directly over LLC2
(rather than Class 4 over LLC1).
But the only LLC2 user was netbios - and microsoft's LLC2 was broken.
Not to mention the window probing needed to handle systems that
said they supported a window of (IIRC) 15 but would discard the
5th back to back frame.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

