Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16B01621C
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 12:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfEGKsC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 May 2019 06:48:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:46485 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbfEGKsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 06:48:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-17-FGOFuhnMNn6udtXcfbbchQ-1; Tue, 07 May 2019 11:47:58 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 7 May 2019 11:47:57 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 7 May 2019 11:47:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jeff Kirsher' <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: RE: [net-next 13/15] ice: Use bitfields where possible
Thread-Topic: [net-next 13/15] ice: Use bitfields where possible
Thread-Index: AQHVAtQIMZDCHHo53Eewyfy3feGFlqZffokg
Date:   Tue, 7 May 2019 10:47:57 +0000
Message-ID: <dfd0b9bf9180413788b04984fd007b07@AcuMS.aculab.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
 <20190504234929.3005-14-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190504234929.3005-14-jeffrey.t.kirsher@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: FGOFuhnMNn6udtXcfbbchQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher
> Sent: 05 May 2019 00:49
> The driver was converted to not use bool, but it was
> neglected that the bools should have been converted to bit fields
> as bit fields in software structures are ok, as long as they
> use the correct kinds of unsigned types. This avoids
> wasting lots of storage space to store single bit values.
> 
> One of the change hunks moves a variable lport out of
> a group of "combinable" bit fields because all bits of
> the u8 lport are valid and the variable can be packed in the
> struct in struct holes.

How many copies of this structure are there?
You may find that the code size increases more than the date size reduction.
Also, unless the data size goes below a malloc threshold is saves
no memory at all.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

