Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65153B9F49
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 12:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhGBKx0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Jul 2021 06:53:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:25398 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhGBKxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 06:53:25 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-150-Bxw1W3zEMVaEw8DsBi7IuQ-1; Fri, 02 Jul 2021 11:50:43 +0100
X-MC-Unique: Bxw1W3zEMVaEw8DsBi7IuQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 2 Jul
 2021 11:50:43 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 2 Jul 2021 11:50:43 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Martin KaFai Lau' <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: RE: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do
 bpf_(get|set)sockopt
Thread-Topic: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do
 bpf_(get|set)sockopt
Thread-Index: AQHXbrR5lp8o74ToykatvjOHrXTIrKsvgj0w
Date:   Fri, 2 Jul 2021 10:50:43 +0000
Message-ID: <dbf6bb3450ac440a9b201fb14a49394e@AcuMS.aculab.com>
References: <20210701200535.1033513-1-kafai@fb.com>
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
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

From: Martin KaFai Lau
> Sent: 01 July 2021 21:06
> 
> This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.

How does that work at all?

IIRC only setsockopt() was converted so that it is callable
with a kernel buffer.
The corresponding change wasn't done to getsockopt().

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

