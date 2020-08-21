Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DC624CFB5
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgHUHlg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Aug 2020 03:41:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58846 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728271AbgHUHlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:41:05 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-8-fn6uvl5FOH6NC0zfgMsnLQ-1; Fri, 21 Aug 2020 08:41:00 +0100
X-MC-Unique: fn6uvl5FOH6NC0zfgMsnLQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 21 Aug 2020 08:41:00 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 21 Aug 2020 08:41:00 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Subject: RE: [PATCH v2] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Topic: [PATCH v2] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Index: AdZ2Jpt5uFDQ+GlJS8asoZmPH8fG2QAD/p2wAEMD3AAAEu3KMA==
Date:   Fri, 21 Aug 2020 07:41:00 +0000
Message-ID: <abecfca0ee6d4fa1835e9f0a0338a04a@AcuMS.aculab.com>
References: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
        <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
 <20200820.163838.2031881871934638484.davem@davemloft.net>
In-Reply-To: <20200820.163838.2031881871934638484.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller
> Sent: 21 August 2020 00:39
> 
> >
> > The number of output and input streams was never being reduced, eg when
> > processing received INIT or INIT_ACK chunks.
> > The effect is that DATA chunks can be sent with invalid stream ids
> > and then discarded by the remote system.
> >
> > Fixes: 2075e50caf5ea ("sctp: convert to genradix")
> > Signed-off-by: David Laight <david.laight@aculab.com>
> 
> Applied and queued up for -stable, thanks David.

Thank you.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

