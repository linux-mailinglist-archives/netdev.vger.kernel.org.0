Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7CD27E39C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3IXX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Sep 2020 04:23:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:56120 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgI3IXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:23:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-241-KV6fPijRMkWryXuz3TcX2Q-1; Wed, 30 Sep 2020 09:23:16 +0100
X-MC-Unique: KV6fPijRMkWryXuz3TcX2Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 30 Sep 2020 09:23:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 30 Sep 2020 09:23:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>, Wei Wang <weiwan@google.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "Felix Fietkau" <nbd@nbd.name>
Subject: RE: [RFC PATCH net-next 0/6] implement kthread based napi poll
Thread-Topic: [RFC PATCH net-next 0/6] implement kthread based napi poll
Thread-Index: AQHWlqpf5e4ajsfgAEyc0khQ0bcmAamA19lw
Date:   Wed, 30 Sep 2020 08:23:15 +0000
Message-ID: <4600c4617b4b41fa8522ab2d0c8ea822@AcuMS.aculab.com>
References: <20200914172453.1833883-1-weiwan@google.com>
        <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
        <20200929121902.7ee1c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_BPT591fqFRqsM=k4urVXQ1sqL-31rMWjhvKQZm9-Lksg@mail.gmail.com>
 <20200929144847.05f3dcf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929144847.05f3dcf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

From: Jakub Kicinski
> Sent: 29 September 2020 22:49
...
> Isn't the fundamental problem that scheduler works at ms scale while
> where we're talking about 100us at most? And AFAICT scheduler doesn't
> have a knob to adjust migration cost per process? :(

Have you tried setting the application processes to RT priorities?
The scheduler tries very hard (maybe too hard) to avoid migrating
RT processes.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

