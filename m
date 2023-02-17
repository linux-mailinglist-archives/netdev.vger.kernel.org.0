Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025C369B432
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBQUtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBQUtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:49:33 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33465E5BC
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:49:27 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-196-5TuHSd71N4O1B8chrN4m8g-1; Fri, 17 Feb 2023 20:49:25 +0000
X-MC-Unique: 5TuHSd71N4O1B8chrN4m8g-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Fri, 17 Feb
 2023 20:49:24 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Fri, 17 Feb 2023 20:49:24 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Richard Weinberger' <richard@nod.at>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>
Subject: RE: high latency with imx8mm compared to imx6q
Thread-Topic: high latency with imx8mm compared to imx6q
Thread-Index: AdlDEVDpXDR1Y7a5T/eRtXafdi7Ajg==
Date:   Fri, 17 Feb 2023 20:49:23 +0000
Message-ID: <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
In-Reply-To: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmljaGFyZCBXZWluYmVyZ2VyDQo+IFNlbnQ6IDE3IEZlYnJ1YXJ5IDIwMjMgMTY6NTMN
Ci4uLg0KPiBJJ20gaW52ZXN0aWdhdGluZyBpbnRvIGxhdGVuY3kgaXNzdWVzIG9uIGFuIGlteDht
bSBzeXN0ZW0gYWZ0ZXINCj4gbWlncmF0aW5nIGZyb20gaW14NnEuDQo+IEEgcmVncmVzc2lvbiB0
ZXN0IHNob3dlZCBtYXNzaXZlIGxhdGVuY3kgaW5jcmVhc2VzIHdoZW4gc2luZ2xlL3NtYWxsIHBh
Y2tldHMNCj4gYXJlIGV4Y2hhbmdlZC4NCj4gDQo+IEEgc2ltcGxlIHRlc3QgdXNpbmcgcGluZyBl
eGhpYml0cyB0aGUgcHJvYmxlbS4NCj4gUGluZ2luZyB0aGUgdmVyeSBzYW1lIGhvc3QgZnJvbSB0
aGUgaW14OG1tIGhhcyBhIHdheSBoaWdoZXIgUlRUIHRoYW4gZnJvbSB0aGUgaW14Ni4NCj4gDQo+
IFBpbmcsIDEwMCBwYWNrZXRzIGVhY2gsIGZyb20gaW14NnE6DQo+IHJ0dCBtaW4vYXZnL21heC9t
ZGV2ID0gMC42ODkvMC44NTEvMS4wMjcvMC4wODggbXMNCj4gDQo+IFBpbmcsIDEwMCBwYWNrZXRz
IGVhY2gsIGZyb20gaW14OG1tOg0KPiBydHQgbWluL2F2Zy9tYXgvbWRldiA9IDEuMDczLzIuMDY0
LzIuMTg5LzAuMzMwIG1zDQo+IA0KPiBZb3UgY2FuIHNlZSB0aGF0IHRoZSBhdmVyYWdlIFJUVCBo
YXMgbW9yZSB0aGFuIGRvdWJsZWQuDQouLi4NCg0KSXMgaXQganVzdCBpbnRlcnJ1cHQgbGF0ZW5j
eSBjYXVzZWQgYnkgaW50ZXJydXB0IGNvYWxlc2NpbmcNCnRvIGF2b2lkIGV4Y2Vzc2l2ZSBpbnRl
cnJ1cHRzPw0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

