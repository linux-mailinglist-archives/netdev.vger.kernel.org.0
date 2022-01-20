Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B7494A72
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbiATJMG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jan 2022 04:12:06 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:46730 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231572AbiATJMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 04:12:05 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-19-bOMb94O0NjOs2-b-Mij-8A-1; Thu, 20 Jan 2022 09:12:03 +0000
X-MC-Unique: bOMb94O0NjOs2-b-Mij-8A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 20 Jan 2022 09:12:00 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 20 Jan 2022 09:12:00 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Petr Mladek' <pmladek@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
CC:     Lucas De Marchi <lucas.demarchi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        "Mikita Lipski" <mikita.lipski@amd.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "Rasmus Villemoes" <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vishal Kulkarni" <vishal@chelsio.com>
Subject: RE: [PATCH 0/3] lib/string_helpers: Add a few string helpers
Thread-Topic: [PATCH 0/3] lib/string_helpers: Add a few string helpers
Thread-Index: AQHYDdkRJfmi1u3vzker6akA52hdRqxrnz8Q
Date:   Thu, 20 Jan 2022 09:12:00 +0000
Message-ID: <d63b56112a2249c6b6cdce003dec4967@AcuMS.aculab.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <YegPiR7LU8aVisMf@alley> <87tudzbykz.fsf@intel.com> <YekfbKMjOP9ecc5v@alley>
In-Reply-To: <YekfbKMjOP9ecc5v@alley>
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
> Yeah, and I am sorry for bikeshedding. Honestly, I do not know what is
> better. This is why I do not want to block this series when others
> like this.
> 
> My main motivation is to point out that:
> 
>     enabledisable(enable)
> 
> might be, for some people, more eye bleeding than
> 
>     enable ? "enable" : "disable"

Indeed - you need to look the former up, wasting brain time.

> The problem is not that visible with yesno() and onoff(). But as you said,
> onoff() confliscts with variable names. And enabledisable() sucks.
> As a result, there is a non-trivial risk of two mass changes:
> 
> now:
> 
> - contition ? "yes" : "no"
> + yesno(condition)
> 
> a few moths later:
> 
> - yesno(condition)
> + str_yes_no(condition)

Followed by:
- str_yes_no(x)
+ no_yes_str(x)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

