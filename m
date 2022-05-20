Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604A252F541
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 23:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiETVnJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 May 2022 17:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiETVnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 17:43:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCBC69D4EB
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 14:43:07 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-315-NfpPflqFMR6zq5Voxa9kKA-1; Fri, 20 May 2022 22:43:04 +0100
X-MC-Unique: NfpPflqFMR6zq5Voxa9kKA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 20 May 2022 22:43:04 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 20 May 2022 22:43:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: GCC 12 warnings
Thread-Topic: GCC 12 warnings
Thread-Index: AQHYbG5wH+jIYDKK5Euo/3aEA4BZ960oS7qQ
Date:   Fri, 20 May 2022 21:43:03 +0000
Message-ID: <8608c7da4cfc45889f450a538fb0b443@AcuMS.aculab.com>
References: <20220519193618.6539f9d9@kernel.org>
        <202205200938.1EE1FD1@keescook> <20220520102355.273cae07@kernel.org>
In-Reply-To: <20220520102355.273cae07@kernel.org>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 20 May 2022 18:24
...
> > +ifeq ($(KBUILD_EXTRA_WARN),)
> > +CFLAGS_kvaser_usb_hydra.o += -Wno-array-bounds
> > +endif
> 
> Ah, thanks, I must have tried -Wno-array-bounds before I figured out
> the condition and reverted back to full $(call cc-disable-warning, ..)
> Let me redo the patches.

I think you need a check that the compiler actually supports
-Wno-array-bounds.
But that only needs be done once, not for every file
that needs the option.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

