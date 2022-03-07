Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92A44D02D0
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 16:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243802AbiCGP2H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Mar 2022 10:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242393AbiCGP16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:27:58 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82A3392D06
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 07:27:00 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-85-dcBRBPURPaqNT771jbYVzw-1; Mon, 07 Mar 2022 15:26:52 +0000
X-MC-Unique: dcBRBPURPaqNT771jbYVzw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Mon, 7 Mar 2022 15:26:48 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Mon, 7 Mar 2022 15:26:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dan Carpenter' <dan.carpenter@oracle.com>,
        Jakob Koschel <jakobkoschel@gmail.com>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jason Gunthorpe <jgg@ziepe.ca>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Arnd Bergman" <arnd@arndb.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
Subject: RE: [PATCH 0/6] Remove usage of list iterator past the loop body
Thread-Topic: [PATCH 0/6] Remove usage of list iterator past the loop body
Thread-Index: AQHYMjRtYqIeET2JD0yO+p9PX3jHEKy0Bmqg
Date:   Mon, 7 Mar 2022 15:26:48 +0000
Message-ID: <f7ffd78aa68340e1ade6af15fa2f06d8@AcuMS.aculab.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220307150037.GD3293@kadam>
In-Reply-To: <20220307150037.GD3293@kadam>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter
> Sent: 07 March 2022 15:01
> 
> Updating this API is risky because some places rely on the old behavior
> and not all of them have been updated.  Here are some additional places
> you might want to change.

I really can't help thinking that trying to merge this patch is
actually impossible.
It affects far too many different parts of the tree.

Since (I believe) this is a doubly linked list with forwards and
backwards pointers that point to a 'node' (not that there is a
nice comment to that effect in the header - and there are lots of
ways to do linked lists) the 'head' pretty much has to be a 'node'.

I'd write the following new defines (but I might be using
the old names here):

list_first(head, field) First item, NULL if empty.
list_last(head, field) Last item NULL if empty.
list_next(head, item, field) Item after 'item', NULL if last.
list_prev(head, item. field) Item before 'item', NULL if first.

You get (something like):
#define list_first(head, field) \
	head->next == &head ? NULL : list_item(head->next, field)
(probably needs typeof(item) from somewhere).

The iterator loop is then just:
#define loop_iterate(item, head, field) \
	for (item = list_first(head, field); item; \
		item = list_next(head, item, field)

I'm not sure, but making the 'head' be a structure that contains
a single member that is a 'node' might help type checking.

Then all the code that uses the current defines can slowly be
moved over (probably a couple of releases) before the existing
defines are deleted.

That should simplify all the open-coded search loops that are
just as likely to be buggy (possibly more so).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

