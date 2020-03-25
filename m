Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B11192EFD
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgCYRNh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 13:13:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:56887 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgCYRNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:13:37 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-230-3n1yfLUPMYKh_QX_51XZuA-1; Wed, 25 Mar 2020 17:13:33 +0000
X-MC-Unique: 3n1yfLUPMYKh_QX_51XZuA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 25 Mar 2020 17:13:32 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 25 Mar 2020 17:13:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stephen Hemminger' <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Bug 206919] New: Very bad performance of sendto function
Thread-Topic: [Bug 206919] New: Very bad performance of sendto function
Thread-Index: AQHWATRrsxEvPdIshEaAhC66MnYw06hZjinA
Date:   Wed, 25 Mar 2020 17:13:32 +0000
Message-ID: <a289e3d695494e84a3b2839067732f4e@AcuMS.aculab.com>
References: <20200323095918.1f6d6400@hermes.lan>
In-Reply-To: <20200323095918.1f6d6400@hermes.lan>
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

From: Stephen Hemminger
> Sent: 23 March 2020 16:59
> To: netdev@vger.kernel.org
> Subject: Fw: [Bug 206919] New: Very bad performance of sendto function
> 
> There maybe something here but probably not.

They need to raise it with wine.

They don't even say what sort of message rate they are getting
(or trying to get).

	David

> Begin forwarded message:
> 
> Date: Sun, 22 Mar 2020 11:22:46 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 206919] New: Very bad performance of sendto function
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206919
> 
>             Bug ID: 206919
>            Summary: Very bad performance of sendto function
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.4.13
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: bernat.arlandis@gmail.com
>         Regression: No
> 
> Created attachment 288007
>   --> https://bugzilla.kernel.org/attachment.cgi?id=288007&action=edit
> Sysprof capture file
> 
> Hi,
> 
> I have a case where the sendto function is slowing down the software I'm trying
> to use. Sysprof capture file attached.
> 
> It's probably being called at a high frequency and the __netlink_dump_start
> function spends a lot of time in the mutex lock, then also in the netlink_dump
> call.
> 
> This is causing the threads calling the function to stall. At least this is my
> interpretation of the profiling session.
> 
> I don't have any knowledge about the way networking code works. I'd like to
> know if the flaw is in the user-space software or in the kernel. Can I provide
> any more info or do some test to help determine what's happening? I'd like to
> help fix it.
> 
> My NIC: Intel Corporation I211 Gigabit Network Connection (rev 03)
> 
> My system: Debian 10 with kernel 5.4.13.
> 
> Thanks.
> 
> --
> You are receiving this mail because:
> You are the assignee for the bug.

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

