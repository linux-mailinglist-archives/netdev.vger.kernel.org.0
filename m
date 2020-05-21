Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3781DD25C
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgEUPwK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 May 2020 11:52:10 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20846 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbgEUPwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:52:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-160-ZrELJQGoMCmTAwclreW9Pg-1; Thu, 21 May 2020 16:52:05 +0100
X-MC-Unique: ZrELJQGoMCmTAwclreW9Pg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 21 May 2020 16:52:05 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 21 May 2020 16:52:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: RE: [PATCH net-next] sctp: Pull the user copies out of the individual
 sockopt functions.
Thread-Topic: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Thread-Index: AdYut/UmmYS4izffR6iTi1nqaxYM2QAziCeOAAA2HTA=
Date:   Thu, 21 May 2020 15:52:05 +0000
Message-ID: <4887e5a0858f4bd08734a92d1b8433af@AcuMS.aculab.com>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521153729.GB74252@localhost.localdomain>
 <20200521153955.GA19160@lst.de>
In-Reply-To: <20200521153955.GA19160@lst.de>
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

From: Christoph Hellwig
> Sent: 21 May 2020 16:40
> On Thu, May 21, 2020 at 12:37:29PM -0300, 'Marcelo Ricardo Leitner' wrote:
> > On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> >
> > I wish we could split this patch into multiple ones. Like, one for
> > each sockopt, but it doesn't seem possible. It's tough to traverse
> > trough 5k lines long patch. :-(
> 
> I have a series locally that started this, I an try to resurrect and
> finish it.

It is almost better just to look at the new file.
Possibly in a 'side by side' diff.

The only real split is getsockopt v setsockopt.
But they are in separated in the patch anyway.

Most of the patch is just mechanical changes to pass
the compiler and sparse.

Still took over a day to write.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

