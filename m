Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A196928797B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbgJHQAC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Oct 2020 12:00:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25923 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731413AbgJHP7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:59:32 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-238-6KcKqProOHmg7Vl2R1BbrA-1; Thu, 08 Oct 2020 16:59:28 +0100
X-MC-Unique: 6KcKqProOHmg7Vl2R1BbrA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 8 Oct 2020 16:59:28 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 8 Oct 2020 16:59:28 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Taehee Yoo' <ap420073@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Subject: RE: [PATCH net 000/117] net: avoid to remove module when its debugfs
 is being used
Thread-Topic: [PATCH net 000/117] net: avoid to remove module when its debugfs
 is being used
Thread-Index: AQHWnYreCEbA8QiKJ0qlgP86SUSOo6mN3D7w
Date:   Thu, 8 Oct 2020 15:59:28 +0000
Message-ID: <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
References: <20201008155048.17679-1-ap420073@gmail.com>
In-Reply-To: <20201008155048.17679-1-ap420073@gmail.com>
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

From: Taehee Yoo
> Sent: 08 October 2020 16:49
> 
> When debugfs file is opened, its module should not be removed until
> it's closed.
> Because debugfs internally uses the module's data.
> So, it could access freed memory.
> 
> In order to avoid panic, it just sets .owner to THIS_MODULE.
> So that all modules will be held when its debugfs file is opened.

Can't you fix it in common code?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

