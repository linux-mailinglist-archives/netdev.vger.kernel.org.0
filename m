Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5716528FA9E
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 23:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgJOVYE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Oct 2020 17:24:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:33476 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730383AbgJOVYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 17:24:03 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-195-UU4LVtVANySkwc75KN0fuA-1; Thu, 15 Oct 2020 22:23:59 +0100
X-MC-Unique: UU4LVtVANySkwc75KN0fuA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 15 Oct 2020 22:23:58 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 15 Oct 2020 22:23:58 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Michael Tuexen" <tuexen@fh-muenster.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gnault@redhat.com" <gnault@redhat.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Thread-Topic: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Thread-Index: AQHWoxqgOwMtvPpvUkG+LluVFgP1pqmZK0hg
Date:   Thu, 15 Oct 2020 21:23:58 +0000
Message-ID: <a5ee7f3c99b14e43aac8938434fd9264@AcuMS.aculab.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
 <20201015174252.GB11030@localhost.localdomain>
In-Reply-To: <20201015174252.GB11030@localhost.localdomain>
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

From: Marcelo Ricardo Leitner
> Sent: 15 October 2020 18:43
> 
> Actually..
> 
> On Tue, Oct 13, 2020 at 03:27:41PM +0800, Xin Long wrote:
> ...
> > Also add sysctl udp_port to allow changing the listening
> > sock's port by users.

I've not read through this change...

But surely the UDP port (or ports) that you need to use
will depend on the remote system's configuration.

So they need to be a property of the socket, not a
system-wide value.

I can easily imagine my M3UA code connecting to different
network providers which have decided to use different
UDP port numbers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

