Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0C03A5840
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 14:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFMMTx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Jun 2021 08:19:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:49247 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 08:19:51 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-245-2rowExfsN32CZdeXwWA3Lg-1; Sun, 13 Jun 2021 13:17:46 +0100
X-MC-Unique: 2rowExfsN32CZdeXwWA3Lg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 13 Jun
 2021 13:17:45 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Sun, 13 Jun 2021 13:17:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Alexander Aring <aahringo@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        =?iso-8859-1?Q?Aur=E9lien_Aptel?= <aaptel@suse.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        "Steven Whitehouse" <swhiteho@redhat.com>
Subject: RE: quic in-kernel implementation?
Thread-Topic: quic in-kernel implementation?
Thread-Index: AQHXXU9D5dOcWjzpmkiJ27fvmvFu8asR4Naw
Date:   Sun, 13 Jun 2021 12:17:45 +0000
Message-ID: <166ca5b32a9d4576bc02cd8972a281e9@AcuMS.aculab.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
        <87pmwxsjxm.fsf@suse.com>
        <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
        <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
        <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
        <20210608153349.0f02ba71@hermes.local>
 <20210609094818.7aaf21bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210609094818.7aaf21bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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
> Sent: 09 June 2021 17:48
...
> > > I think two veth interfaces can help to test something like that,
> > > either with a "fuse-like socket" on the other end or an user space
> > > application. Just doing a ping-pong example.
> > >
> > > Afterwards we can look at how to replace the user generated socket
> > > application with any $LIBQUIC e.g. msquic implementation as second
> > > step.
> >
> > Socket state management is complex and timers etc in userspace are hard.
> 
> +1 seeing the struggles fuse causes in storage land "fuse for sockets"
> is not an exciting temporary solution IMHO..

Especially since you'd want reasonable performance for quic.

Fuse is normally used to access obscure filesystems where
you just need access, rather than something that really
needs to be quick.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

