Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02063D89C1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 10:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbhG1I2U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Jul 2021 04:28:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47781 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235272AbhG1I2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 04:28:18 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-11-xmCxCxZxO7ayZHiHESiNOw-1; Wed, 28 Jul 2021 09:28:14 +0100
X-MC-Unique: xmCxCxZxO7ayZHiHESiNOw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 28 Jul 2021 09:28:11 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 28 Jul 2021 09:28:11 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Luis Chamberlain' <mcgrof@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "tj@kernel.org" <tj@kernel.org>,
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
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
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
        Douglas Gilbert <dgilbert@interlog.com>,
        "Hannes Reinecke" <hare@suse.de>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] kernel/module: add documentation for try_module_get()
Thread-Topic: [PATCH] kernel/module: add documentation for try_module_get()
Thread-Index: AQHXf0eaxD6lEmY4bU6QViNa8xuU1KtSAuiAgAVRuyeAALu/4A==
Date:   Wed, 28 Jul 2021 08:28:11 +0000
Message-ID: <6054c136290346d581e276abbb2e3ff1@AcuMS.aculab.com>
References: <20210722221905.1718213-1-mcgrof@kernel.org>
 <dbf27fa2f8864e1d91f7015249b1a5f1@AcuMS.aculab.com>
 <YQBCvKgH481C7o1c@bombadil.infradead.org> <YQBGemOIF4sp/ges@kroah.com>
 <YQBN2/K4Ne5orgzS@bombadil.infradead.org> <YQBSutZfhqfTzKQa@kroah.com>
 <YQByfUaDaXCUqrlo@bombadil.infradead.org>
In-Reply-To: <YQByfUaDaXCUqrlo@bombadil.infradead.org>
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

...
> sysfs files are safe to use try_module_get() because once they are
> active a removal of the file cannot happen, and so removal will wait.

I doubt it.

If the module_remove() function removes sysfs nodes then (something
like) this has to happen.

1) rmmod (or similar) tries to remove the module.
2) The reference count is zero so the remove is allowed.
3) Something tries to access a sysfs node in the module.
3a) If sysfs knew the nodes were in a module it could use
    try_module_get() to ensure the module wasn't being unloaded.
    Failure would cause the sysfs access to fail.
    But I'm not sure it does, and in any case it doesn't help.
3b) The sysfs thread calls into the module code and waits on a mutex.
3c) The rmmod thread gets around to calling into sysfs to remove the nodes.

At this point we hit the standard 'deregistering a callback' issue.
Exactly the same issue affects removal of per-device sysfs node
from a driver's .remove function.

Typically this is solved by making the deregister routing sleep
until all the callbacks have completed.

So this would require functions like SYSFS_REMOVE_GROUP() and
hwmon_device_unregister() to be allowed to sleep and not be
called with any locks (of any kind) held that the callback
functions acquire.

The module reference count is irrelevant.

	David

    

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

