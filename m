Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA5C2A926F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgKFJYP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Nov 2020 04:24:15 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39050 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgKFJYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:24:14 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-250-hzZtQnhQMkCNeOSWWF7H2w-1; Fri, 06 Nov 2020 09:24:10 +0000
X-MC-Unique: hzZtQnhQMkCNeOSWWF7H2w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 6 Nov 2020 09:24:09 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 6 Nov 2020 09:24:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joe Perches' <joe@perches.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/dsa: remove unused macros to tame gcc warning
Thread-Topic: [PATCH] net/dsa: remove unused macros to tame gcc warning
Thread-Index: AQHWtAckDoDYS6gyQUa+zdC/SmUjzqm61E4A
Date:   Fri, 6 Nov 2020 09:24:09 +0000
Message-ID: <fcfd34532a8349cabad2cbd561fa1a60@AcuMS.aculab.com>
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
 <71dc38c1646980840fb83d82fc588501af72e05f.camel@perches.com>
In-Reply-To: <71dc38c1646980840fb83d82fc588501af72e05f.camel@perches.com>
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

From: Joe Perches
> Sent: 06 November 2020 06:36
> 
> On Fri, 2020-11-06 at 13:37 +0800, Alex Shi wrote:
> > There are some macros unused, they causes much gcc warnings. Let's
> > remove them to tame gcc.
> 
> I believe these to be essentially poor warnings.

Indeed.

One 'solution' is to move the #defines into an included .h file.

> Aren't these warnings generated only when adding  W=2 to the make
> command line?
> 
> Perhaps it's better to move the warning to level 3

I'd move then to level 9999999999.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

