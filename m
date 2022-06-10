Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDBF54694F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiFJPVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbiFJPVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:21:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B814265
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:21:34 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-59-3XeYKv6ROXaVTwy4GIdTWg-1; Fri, 10 Jun 2022 16:21:31 +0100
X-MC-Unique: 3XeYKv6ROXaVTwy4GIdTWg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 10 Jun 2022 16:21:30 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 10 Jun 2022 16:21:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ronny Meeus' <ronny.meeus@gmail.com>,
        Eric Dumazet <erdnetdev@gmail.com>
CC:     netdev <netdev@vger.kernel.org>
Subject: RE: TCP socket send return EAGAIN unexpectedly when sending small
 fragments
Thread-Topic: TCP socket send return EAGAIN unexpectedly when sending small
 fragments
Thread-Index: AQHYfN0TJsDCdrZ+c0ev9WBgDEvfYK1IwQZA
Date:   Fri, 10 Jun 2022 15:21:30 +0000
Message-ID: <0e02ea2593204cd9805c6ed4b7f46c98@AcuMS.aculab.com>
References: <CAMJ=MEcPzkBLynL7tpjdv0TCRA=Cmy13e7wmFXrr-+dOVcshKA@mail.gmail.com>
 <f0f30591-f503-ae7c-9293-35cca4ceec84@gmail.com>
 <CAMJ=MEdctBNSihixym1ZO9RVaCa_FpTQ8e4xFukz3eN8F1P8bQ@mail.gmail.com>
In-Reply-To: <CAMJ=MEdctBNSihixym1ZO9RVaCa_FpTQ8e4xFukz3eN8F1P8bQ@mail.gmail.com>
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
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li4uDQo+IElmIHRoZSA1IHF1ZXVlZCBwYWNrZXRzIG9uIHRoZSBzZW5kaW5nIHNpZGUgd291bGQg
Y2F1c2UgdGhlIEVBR0FJTg0KPiBpc3N1ZSwgdGhlIHJlYWwgcXVlc3Rpb24gbWF5YmUgaXMgd2h5
IHRoZSByZWNlaXZpbmcgc2lkZSBpcyBub3QNCj4gc2VuZGluZyB0aGUgQUNLIHdpdGhpbiB0aGUg
MTBtcyB3aGlsZSBmb3IgZWFybGllciBtZXNzYWdlcyB0aGUgQUNLIGlzDQo+IHNlbnQgbXVjaCBz
b29uZXIuDQoNCkhhdmUgeW91IGRpc2FibGVkIE5hZ2xlIChUQ1BfTk9ERUxBWSkgPw0KDQpOYWds
ZSBvbmx5IHJlYWxseSB3b3JrcyBmb3IgYnVsayBkYXRhIHRyYW5zZmVyIChsYXJnZSBzZW5kcykN
CmFuZCBpbnRlcmFjdGl2ZSBzZXNzaW9ucyAoY29tbWFuZCAtIHJlc3BvbnNlKS4NCkZvciBuZWFy
bHkgZXZlcnl0aGluZyBlbHNlIGl0IGFkZHMgdW53YW50ZWQgMTAwbXMgZGVsYXlzLg0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

