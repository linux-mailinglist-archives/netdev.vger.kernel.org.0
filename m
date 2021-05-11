Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7DD37A755
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhEKNMz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 May 2021 09:12:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:60924 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231270AbhEKNMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:12:53 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-276-_dglJdd_OOWp4RRZZJKlVQ-1; Tue, 11 May 2021 14:11:44 +0100
X-MC-Unique: _dglJdd_OOWp4RRZZJKlVQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 11 May 2021 14:11:42 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Tue, 11 May 2021 14:11:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Matthew Wilcox (Oracle)'" <willy@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: [PATCH] udp: Switch the order of arguments to copy_linear_skb
Thread-Topic: [PATCH] udp: Switch the order of arguments to copy_linear_skb
Thread-Index: AQHXRlmlQPna6YyAckavKt6/OjmurareQVGA
Date:   Tue, 11 May 2021 13:11:42 +0000
Message-ID: <ae8f4e176b17439b87420cad69fbabf9@AcuMS.aculab.com>
References: <20210511113400.1722975-1-willy@infradead.org>
In-Reply-To: <20210511113400.1722975-1-willy@infradead.org>
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

From: Matthew Wilcox
> Sent: 11 May 2021 12:34
> 
> All other skb functions use (off, len); this is the only one which
> uses (len, off).  Make it consistent.

I wouldn't change the order of the arguments without some other
change that ensures old code fails to compile.
(Like tweaking the function name.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

