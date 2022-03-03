Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8D14CB613
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 05:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiCCE72 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Mar 2022 23:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiCCE7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 23:59:15 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1FA713D57E
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 20:58:28 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-5-c9saVIHFMHux_Sno3vxg6w-1; Thu, 03 Mar 2022 04:58:25 +0000
X-MC-Unique: c9saVIHFMHux_Sno3vxg6w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 3 Mar 2022 04:58:23 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 3 Mar 2022 04:58:23 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xiaomeng Tong' <xiam0nd.tong@gmail.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "bjohannesmeyer@gmail.com" <bjohannesmeyer@gmail.com>,
        "c.giuffrida@vu.nl" <c.giuffrida@vu.nl>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "h.j.bos@vu.nl" <h.j.bos@vu.nl>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jakobkoschel@gmail.com" <jakobkoschel@gmail.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>
Subject: RE: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Topic: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Index: AQHYLhg9+DU/OogLf0+tiSFmjztyUKysHu+QgADRVYCAACVtoA==
Date:   Thu, 3 Mar 2022 04:58:23 +0000
Message-ID: <39404befad5b44b385698ff65465abe5@AcuMS.aculab.com>
References: <1077f17e50d34dc2bbfdf4e52a1cb2fd@AcuMS.aculab.com>
 <20220303022729.9321-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220303022729.9321-1-xiam0nd.tong@gmail.com>
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

From: Xiaomeng Tong
> Sent: 03 March 2022 02:27
> 
> On Wed, 2 Mar 2022 14:04:06 +0000, David Laight
> <David.Laight@ACULAB.COM> wrote:
> > I think that it would be better to make any alternate loop macro
> > just set the variable to NULL on the loop exit.
> > That is easier to code for and the compiler might be persuaded to
> > not redo the test.
> 
> No, that would lead to a NULL dereference.

Why, it would make it b ethe same as the 'easy to use':
	for (item = head; item; item = item->next) {
		...
		if (...)
			break;
		...
	}
	if (!item)
		return;
 
> The problem is the mis-use of iterator outside the loop on exit, and
> the iterator will be the HEAD's container_of pointer which pointers
> to a type-confused struct. Sidenote: The *mis-use* here refers to
> mistakely access to other members of the struct, instead of the
> list_head member which acutally is the valid HEAD.

The problem is that the HEAD's container_of pointer should never
be calculated at all.
This is what is fundamentally broken about the current definition.

> IOW, you would dereference a (NULL + offset_of_member) address here.

Where?

> Please remind me if i missed something, thanks.
>
> Can you share your "alternative definitions" details? thanks!

The loop should probably use as extra variable that points
to the 'list node' in the next structure.
Something like:
	for (xxx *iter = head->next;
		iter == &head ? ((item = NULL),0) : ((item = list_item(iter),1));
		iter = item->member->next) {
	   ...
With a bit of casting you can use 'item' to hold 'iter'.

> 
> > OTOH there may be alternative definitions that can be used to get
> > the compiler (or other compiler-like tools) to detect broken code.
> > Even if the definition can't possibly generate a working kerrnel.
> 
> The "list_for_each_entry_inside(pos, type, head, member)" way makes
> the iterator invisiable outside the loop, and would be catched by
> compiler if use-after-loop things happened.

It is also a compete PITA for anything doing a search.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

