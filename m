Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440FF2A7A1A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgKEJKO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Nov 2020 04:10:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:27689 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730361AbgKEJKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:10:14 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-36-lTFCWq8_NQCw4aZKrI50dQ-1; Thu, 05 Nov 2020 09:10:10 +0000
X-MC-Unique: lTFCWq8_NQCw4aZKrI50dQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 5 Nov 2020 09:10:04 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 5 Nov 2020 09:10:04 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Thread-Topic: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Thread-Index: AQHWs0YkvDVQKZzs2ECZM+crj0xbk6m5Pz0w
Date:   Thu, 5 Nov 2020 09:10:04 +0000
Message-ID: <1d7f669ba4e444f1b35184264e5da601@AcuMS.aculab.com>
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
In-Reply-To: <20201105073434.429307-1-xie.he.0141@gmail.com>
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
> Sent: 05 November 2020 07:35
> 
> This driver transports LAPB (X.25 link layer) frames over TTY links.

I don't remember any requests to run LAPB over anything other
than synchronous links when I was writing LAPB implementation(s)
back in the mid 1980's.

If you need to run 'comms over async uart links' there
are better options.

I wonder what the actual use case was?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

