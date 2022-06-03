Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E753CA72
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 15:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiFCNJk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jun 2022 09:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiFCNJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 09:09:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B3EA2D1C1
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 06:09:37 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-65-jWL626UDN9KEuA-mgpfsFw-1; Fri, 03 Jun 2022 14:09:34 +0100
X-MC-Unique: jWL626UDN9KEuA-mgpfsFw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 3 Jun 2022 14:09:32 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 3 Jun 2022 14:09:32 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Frederik Deweerdt' <frederik.deweerdt@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
Thread-Topic: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown
 scenario
Thread-Index: AQHYdguKgdO0O+cjykaafLt/qHAria09qgMg
Date:   Fri, 3 Jun 2022 13:09:32 +0000
Message-ID: <8362c86f9b004b449ad4105d8f7489e9@AcuMS.aculab.com>
References: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
 <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com>
 <Ypfvs+VsNHWQKT6H@fractal.lan>
In-Reply-To: <Ypfvs+VsNHWQKT6H@fractal.lan>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> Sent: 02 June 2022 00:01
> >
> > A socket must not be closed until all completion notifications have
> > been received.
> >
> > Calling shutdown is an optional step. It may be sufficient to simply
> > delay close.

What happens if the process gets killed - eg by SIGSEGV?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

