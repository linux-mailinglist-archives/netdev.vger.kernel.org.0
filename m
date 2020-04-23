Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137BA1B577F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 10:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDWIwk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Apr 2020 04:52:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:24664 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgDWIwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 04:52:40 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-249-3s3UEB5WNNeoSKy84oN-Jw-1; Thu, 23 Apr 2020 09:52:36 +0100
X-MC-Unique: 3s3UEB5WNNeoSKy84oN-Jw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 23 Apr 2020 09:52:35 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 23 Apr 2020 09:52:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Cambda Zhu' <cambda@linux.alibaba.com>,
        netdev <netdev@vger.kernel.org>
CC:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: RE: [PATCH net-next] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
Thread-Topic: [PATCH net-next] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
Thread-Index: AQHWF9cH8Zim/sCPRESgmwx7O7Z1gKiGaD/A
Date:   Thu, 23 Apr 2020 08:52:35 +0000
Message-ID: <beaecc68abcc4b268d68ce558fc5766e@AcuMS.aculab.com>
References: <20200421121737.3269-1-cambda@linux.alibaba.com>
In-Reply-To: <20200421121737.3269-1-cambda@linux.alibaba.com>
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

From: Cambda Zhu
> Sent: 21 April 2020 13:18
> 
> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
> option has same behavior as TCP_LINGER2, except the tp->linger2 value
> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
> with CAP_NET_ADMIN.

Did you consider adding an extra sysctl so that the limit
for TCP_LINGER2 could be greater than the default?

It might even be sensible to set the limit to a few times
the default.

All users can set the socket buffer sizes to twice the default.
Being able to do the same for the linger timeout wouldn't be a problem.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

