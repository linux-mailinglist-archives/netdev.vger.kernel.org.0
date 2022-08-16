Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008F4595713
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiHPJvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiHPJuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:50:51 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE5D8106501
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:03:17 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-248-iRnsx6CYM8CFewHGlDfzjg-1; Tue, 16 Aug 2022 09:03:15 +0100
X-MC-Unique: iRnsx6CYM8CFewHGlDfzjg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38; Tue, 16 Aug 2022 09:03:14 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.040; Tue, 16 Aug 2022 09:03:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kirill Tkhai' <tkhai@ya.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH v2 1/2] fs: Export __receive_fd()
Thread-Topic: [PATCH v2 1/2] fs: Export __receive_fd()
Thread-Index: AQHYsQ/E5egn5U5P0k6Simqj85Zt/a2xKtgw
Date:   Tue, 16 Aug 2022 08:03:14 +0000
Message-ID: <e3e2fe6a2b8f4a65a4e28d9d7fddd558@AcuMS.aculab.com>
References: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
 <3a8da760-d58b-04fe-e251-e0d143493df1@ya.ru>
In-Reply-To: <3a8da760-d58b-04fe-e251-e0d143493df1@ya.ru>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2lyaWxsIFRraGFpDQo+IFNlbnQ6IDE1IEF1Z3VzdCAyMDIyIDIyOjE1DQo+IA0KPiBU
aGlzIGlzIG5lZWRlZCB0byBtYWtlIHJlY2VpdmVfZmRfdXNlcigpIGF2YWlsYWJsZSBpbiBtb2R1
bGVzLCBhbmQgaXQgd2lsbCBiZSB1c2VkIGluIG5leHQgcGF0Y2guDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBLaXJpbGwgVGtoYWkgPHRraGFpQHlhLnJ1Pg0KPiAtLS0NCj4gdjI6IE5ldw0KPiAgZnMv
ZmlsZS5jIHwgICAgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+
IGRpZmYgLS1naXQgYS9mcy9maWxlLmMgYi9mcy9maWxlLmMNCj4gaW5kZXggM2JjYzFlY2MzMTRh
Li5lNDVkNDVmMWRkNDUgMTAwNjQ0DQo+IC0tLSBhL2ZzL2ZpbGUuYw0KPiArKysgYi9mcy9maWxl
LmMNCj4gQEAgLTExODEsNiArMTE4MSw3IEBAIGludCBfX3JlY2VpdmVfZmQoc3RydWN0IGZpbGUg
KmZpbGUsIGludCBfX3VzZXIgKnVmZCwgdW5zaWduZWQgaW50IG9fZmxhZ3MpDQo+ICAJX19yZWNl
aXZlX3NvY2soZmlsZSk7DQo+ICAJcmV0dXJuIG5ld19mZDsNCj4gIH0NCj4gK0VYUE9SVF9TWU1C
T0xfR1BMKF9fcmVjZWl2ZV9mZCk7DQoNCkl0IGRvZXNuJ3Qgc2VlbSByaWdodCAodG8gbWUpIHRv
IGJlIGV4cG9ydGluZyBhIGZ1bmN0aW9uDQp3aXRoIGEgX18gcHJlZml4Lg0KDQoJRGF2aWQNCg0K
LQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0s
IE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdh
bGVzKQ0K

