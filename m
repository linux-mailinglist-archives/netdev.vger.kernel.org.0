Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A10D8E2E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392422AbfJPKm1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 06:42:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:29099 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389345AbfJPKm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 06:42:27 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-48-M0QBxUsRPUeymtDmQ2xm0A-1; Wed, 16 Oct 2019 11:42:24 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 16 Oct 2019 11:42:23 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 16 Oct 2019 11:42:23 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>,
        "lucien.xin@gmail.com" <lucien.xin@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
Subject: RE: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Thread-Topic: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Thread-Index: AQHVg7yU44xuaHxb70is56q5NyLqeqddFHmw
Date:   Wed, 16 Oct 2019 10:42:23 +0000
Message-ID: <1f6cf86fce074a9cbf7f8c2496cc7c84@AcuMS.aculab.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <20191015.175639.347136446069377956.davem@davemloft.net>
In-Reply-To: <20191015.175639.347136446069377956.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: M0QBxUsRPUeymtDmQ2xm0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller
> Sent: 16 October 2019 01:57
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon, 14 Oct 2019 14:14:43 +0800
> 
> > SCTP-PF was implemented based on a Internet-Draft in 2012:
> >
> >   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> >
> > It's been updated quite a few by rfc7829 in 2016.
> >
> > This patchset adds the following features:
> >
> >   1. add SCTP_ADDR_POTENTIALLY_FAILED notification
> >   2. add pf_expose per netns/sock/asoc
> >   3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
> >   4. add ps_retrans per netns/sock/asoc/transport
> >      (Primary Path Switchover)
> >   5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt
> 
> I would like to see some SCTP expert ACKs here.

I'm only an SCTP user, but I think some of the API changes aren't right.
I'm not going to try to grok the sctp code - it makes my brain hurt.
(Even though I've written plenty of protocol stack code.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

