Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143AF258B09
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgIAJJF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Sep 2020 05:09:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:27551 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgIAJJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:09:02 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-283-TOoGT-t2Oa-s63UZlOFx8A-1; Tue, 01 Sep 2020 10:07:44 +0100
X-MC-Unique: TOoGT-t2Oa-s63UZlOFx8A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 1 Sep 2020 10:07:42 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 1 Sep 2020 10:07:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joe Perches' <joe@perches.com>, Denis Efremov <efremov@linux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Kees Cook" <keescook@chromium.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Alex Dewar <alex.dewar90@gmail.com>
CC:     York Sun <york.sun@nxp.com>, Borislav Petkov <bp@alien8.de>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "James Morse" <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Douglas Miller" <dougmill@linux.ibm.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        =?iso-8859-1?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Pete Zaitcev <zaitcev@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-i3c@lists.infradead.org" <linux-i3c@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: sysfs output without newlines
Thread-Topic: sysfs output without newlines
Thread-Index: AQHWfkO/+C/EB0p8Hk2MEQnp7JjooqlTgZKw
Date:   Tue, 1 Sep 2020 09:07:42 +0000
Message-ID: <5f0b48e0291b4b54bc1caeb8b5715c65@AcuMS.aculab.com>
References: <0f837bfb394ac632241eaac3e349b2ba806bce09.camel@perches.com>
         <4cd6275c-6e95-3aeb-9924-141f62e00449@linux.com>
 <b64a4cb0ee68fee01973616e5ef0f299ac191f6d.camel@perches.com>
In-Reply-To: <b64a4cb0ee68fee01973616e5ef0f299ac191f6d.camel@perches.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches
> Sent: 29 August 2020 21:34
...
> > On 8/29/20 9:23 PM, Joe Perches wrote:
> > > While doing an investigation for a possible treewide conversion of
> > > sysfs output using sprintf/snprintf/scnprintf, I discovered
> > > several instances of sysfs output without terminating newlines.
> > >
> > > It seems likely all of these should have newline terminations
> > > or have the \n\r termination changed to a single newline.
> >
> > I think that it could break badly written scripts in rare cases.
> 
> Maybe.
> 
> Is sysfs output a nominally unchangeable api like seq_?
> Dunno.  seq_ output is extended all the time.
> 
> I think whitespace isn't generally considered part of
> sscanf type input content awareness.

The shell will remove trailing '\n' (but not '\r') from:
	foo=$(cat bar)
So shell scripts are unlikely to be affected.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

