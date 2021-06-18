Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77C53AC65A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhFRIob convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Jun 2021 04:44:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:55790 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233749AbhFRIoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:44:30 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-8-S_lREQziMlqph1PADEonZw-1; Fri, 18 Jun 2021 09:42:17 +0100
X-MC-Unique: S_lREQziMlqph1PADEonZw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 18 Jun
 2021 09:42:16 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 18 Jun 2021 09:42:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Recast pointer for trailing memcpy()
Thread-Topic: [PATCH] mac80211: Recast pointer for trailing memcpy()
Thread-Index: AQHXYzENJy6TjXiKVkqMQny50fQUFqsZdDaA
Date:   Fri, 18 Jun 2021 08:42:16 +0000
Message-ID: <1bd7df33fd484d1da656238f792bd6f7@AcuMS.aculab.com>
References: <20210617042709.2170111-1-keescook@chromium.org>
In-Reply-To: <20210617042709.2170111-1-keescook@chromium.org>
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

From: Kees Cook
> Sent: 17 June 2021 05:27
> 
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring array fields.
> 
> Give memcpy() a specific source pointer type so it can correctly
> calculate the bounds of the copy.

Doesn't the necessity of this sort of patch just sidestep the
run-time checking and really indicate that it is just a complete
waste of cpu resources?

I bet code changes to avoid/fix the reported errors will
introduce more bugs than the test itself will really find.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

