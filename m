Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E949C3D4791
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 14:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhGXLep convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 24 Jul 2021 07:34:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:55771 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232093AbhGXLeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 07:34:44 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-184-PbhWv6FXOqCKOHTvwAuzBw-1; Sat, 24 Jul 2021 13:15:13 +0100
X-MC-Unique: PbhWv6FXOqCKOHTvwAuzBw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Sat, 24 Jul 2021 13:15:10 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Sat, 24 Jul 2021 13:15:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Luis Chamberlain' <mcgrof@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andriin@fb.com" <andriin@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "weiwan@google.com" <weiwan@google.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>
CC:     "jeyu@kernel.org" <jeyu@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "sergey.senozhatsky.work@gmail.com" 
        <sergey.senozhatsky.work@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "mbenes@suse.com" <mbenes@suse.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] kernel/module: add documentation for try_module_get()
Thread-Topic: [PATCH] kernel/module: add documentation for try_module_get()
Thread-Index: AQHXf0eaxD6lEmY4bU6QViNa8xuU1KtSAuiA
Date:   Sat, 24 Jul 2021 12:15:10 +0000
Message-ID: <dbf27fa2f8864e1d91f7015249b1a5f1@AcuMS.aculab.com>
References: <20210722221905.1718213-1-mcgrof@kernel.org>
In-Reply-To: <20210722221905.1718213-1-mcgrof@kernel.org>
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

From: Luis Chamberlain
> Sent: 22 July 2021 23:19
> 
> There is quite a bit of tribal knowledge around proper use of
> try_module_get() and that it must be used only in a context which
> can ensure the module won't be gone during the operation. Document
> this little bit of tribal knowledge.
> 
...

Some typos.

> +/**
> + * try_module_get - yields to module removal and bumps reference count otherwise
> + * @module: the module we should check for
> + *
> + * This can be used to check if userspace has requested to remove a module,
                                                           a module be removed
> + * and if so let the caller give up. Otherwise it takes a reference count to
> + * ensure a request from userspace to remove the module cannot happen.
> + *
> + * Care must be taken to ensure the module cannot be removed during
> + * try_module_get(). This can be done by having another entity other than the
> + * module itself increment the module reference count, or through some other
> + * means which gaurantees the module could not be removed during an operation.
                  guarantees
> + * An example of this later case is using this call in a sysfs file which the
> + * module created. The sysfs store / read file operation is ensured to exist
                                                            ^^^^^^^^^^^^^^^^^^^
Not sure what that is supposed to mean.
> + * and still be present by kernfs's active reference. If a sysfs file operation
> + * is being run, the module which created it must still exist as the module is
> + * in charge of removal of the sysfs file.
> + *
> + * The real value to try_module_get() is the module_is_live() check which
> + * ensures this the caller of try_module_get() can yields to userspace module
> + * removal requests and fail whatever it was about to process.
> + */

But is the comment even right?
I think you need to consider when try_module_get() can actually fail.
I believe the following is right.
The caller has to have valid module reference and module unload
must actually be in progress - ie the ref count is zero and
there are no active IO operations.

The module's unload function must (eventually) invalidate the
caller's module reference to stop try_module_get() being called
with a (very) stale pointer.

So there is a potentially horrid race:
The module unload is going to do:
	driver_data->module_ref = 0;
and elsewhere there'll be:
	ref = driver_data->module_ref;
	if (!ref || !try_module_get(ref))
		return -error;

You have to have try_module_get() to allow the module unload
function to sleep.
But the above code still needs a driver lock to ensure the
unload code doesn't race with the try_module_get() and the
'ref' be invalidated before try_module_get() looks at it.
(eg if an interrupt defers processing.)

So there can be no 'yielding'.

I'm pretty much certain try_module_get(THIS_MODULE) is pretty
much never going to fail.
(It is mostly needed to give a worker thread a reference.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

