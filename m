Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BC41DB78B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgETO5M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 10:57:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47443 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgETO5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 10:57:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-198-oU5m7Sq8OWeamHa9CXHv9Q-1; Wed, 20 May 2020 15:57:08 +0100
X-MC-Unique: oU5m7Sq8OWeamHa9CXHv9Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 20 May 2020 15:57:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 20 May 2020 15:57:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Minor bugs in sctp_getsockopt()
Thread-Topic: Minor bugs in sctp_getsockopt()
Thread-Index: AdYutkRgUgUY6MdaR2Ggkk9vFBykug==
Date:   Wed, 20 May 2020 14:57:07 +0000
Message-ID: <a91c8461b73b499593d014e3fcadce71@AcuMS.aculab.com>
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

I've found 2 minor bugs in sctp_getsockopt().

sctp_getsockopt_peer_auth_chunks() fails to allow for the header
structure when checking the length of the user buffer.
So it can write beyond the end of the user buffer.

sctp_getsockopt_pr_streamstatus() fails to do the copy_to_user()
when streamoute is NULL.

I found these in the middle of writing another patch.
So generating the patch is tricky.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

