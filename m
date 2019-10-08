Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0844BCFADB
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbfJHNDB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Oct 2019 09:03:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25085 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731024AbfJHNDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 09:03:00 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-46-wxSGgauhNkmtrc5dkymLZQ-1; Tue, 08 Oct 2019 14:02:57 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 8 Oct 2019 14:02:57 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 8 Oct 2019 14:02:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Thread-Topic: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Thread-Index: AQHVfcsgrQL6OT4GuU648eHSKFH716dQtSlA
Date:   Tue, 8 Oct 2019 13:02:57 +0000
Message-ID: <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
In-Reply-To: <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: wxSGgauhNkmtrc5dkymLZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long
> Sent: 08 October 2019 12:25
> 
> This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> the Potentially Failed Path State", by which users can change
> pf_expose per sock and asoc.

If I read these patches correctly the default for this sockopt in 'enabled'.
Doesn't this mean that old application binaries will receive notifications
that they aren't expecting?

I'd have thought that applications would be required to enable it.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

