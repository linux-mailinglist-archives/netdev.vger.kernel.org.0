Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE9E533757
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 09:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243073AbiEYH2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 03:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242414AbiEYH2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 03:28:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 927C72655C
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 00:28:48 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-65-lGosZu97PwGkUJVPnzJ0HA-1; Wed, 25 May 2022 08:28:43 +0100
X-MC-Unique: lGosZu97PwGkUJVPnzJ0HA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 25 May 2022 08:28:42 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 25 May 2022 08:28:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Pavan Chebbi' <pavan.chebbi@broadcom.com>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: RE: tg3 dropping packets at high packet rates
Thread-Topic: tg3 dropping packets at high packet rates
Thread-Index: AdhqyKyabzDEQq15SKKGm31SHwTbKwAC24IAAAoYsMAABXOQgAASBiKAAAHW4wAABHST0AACH9sAAAKZZrD///3FgP//7fNg//44TdD/98XoIAIPG/gA//+b67D//PxWwA==
Date:   Wed, 25 May 2022 07:28:42 +0000
Message-ID: <3bbe3c3762c44ffa932101092117853c@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
 <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
 <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
 <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
 <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
 <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
 <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
 <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com>
 <CALs4sv2M+9N1joECMQrOGKHQ_YjMqzeF1gPD_OBQ2_r+SJwOwQ@mail.gmail.com>
 <1bc5053ef6f349989b42117eda7d2515@AcuMS.aculab.com>
 <ae631eefb45947ac84cfe0468d0b7508@AcuMS.aculab.com>
 <9119f62fadaa4342a34882cac835c8b0@AcuMS.aculab.com>
 <CALs4sv13Y7CoMvrYm2c58vP6FKyK+_qrSp2UBCv0MURTAkv8hg@mail.gmail.com>
 <71de7bfbb0854449bce509d67e9cf58c@AcuMS.aculab.com>
In-Reply-To: <71de7bfbb0854449bce509d67e9cf58c@AcuMS.aculab.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDIzIE1heSAyMDIyIDIyOjIzDQouLi4NCj4gQXMg
dGhlIHRyYWNlIGJlbG93IHNob3dzIEkgdGhpbmsgdGhlIHVuZGVybHlpbmcgcHJvYmxlbQ0KPiBp
cyB0aGF0IHRoZSBuYXBpIGNhbGxiYWNrcyBhcmVuJ3QgYmVpbmcgbWFkZSBpbiBhIHRpbWVseSBt
YW5uZXIuDQoNCkZ1cnRoZXIgaW52ZXN0aWdhdGlvbnMgaGF2ZSBzaG93biB0aGF0IHRoaXMgaXMg
YWN0dWFsbHkNCmEgZ2VuZXJpYyBwcm9ibGVtIHdpdGggdGhlIHdheSBuYXBpIGNhbGxiYWNrcyBh
cmUgY2FsbGVkDQpmcm9tIHRoZSBzb2Z0aW50IGhhbmRsZXIuDQoNClRoZSB1bmRlcmx5aW5nIHBy
b2JsZW0gaXMgdGhlIGVmZmVjdCBvZiB0aGlzIGNvZGUNCmluIF9fZG9fc29mdGlycSgpLg0KDQog
ICAgICAgIHBlbmRpbmcgPSBsb2NhbF9zb2Z0aXJxX3BlbmRpbmcoKTsNCiAgICAgICAgaWYgKHBl
bmRpbmcpIHsNCiAgICAgICAgICAgICAgICBpZiAodGltZV9iZWZvcmUoamlmZmllcywgZW5kKSAm
JiAhbmVlZF9yZXNjaGVkKCkgJiYNCiAgICAgICAgICAgICAgICAgICAgLS1tYXhfcmVzdGFydCkN
CiAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gcmVzdGFydDsNCg0KICAgICAgICAgICAgICAg
IHdha2V1cF9zb2Z0aXJxZCgpOw0KICAgICAgICB9DQoNClRoZSBuYXBpIHByb2Nlc3NpbmcgY2Fu
IGxvb3AgdGhyb3VnaCBoZXJlIGFuZCBuZWVkcyB0byBkbw0KdGhlICdnb3RvIHJlc3RhcnQnIC0g
bm90IGRvaW5nIHNvIHdpbGwgZHJvcCBwYWNrZXRzLg0KVGhlIG5lZWRfcmVzY2hlZCgpIHRlc3Qg
aXMgcGFydGljdWxhcmx5IHRyb3VibGVzb21lLg0KSSd2ZSBhbHNvIGhhZCB0byBpbmNyZWFzZSB0
aGUgbGltaXQgZm9yICdtYXhfcmVzdGFydCcgZnJvbQ0KaXRzIChoYXJkIGNvZGVkKSAxMCB0byAx
MDAwICgxMDAgaXNuJ3QgZW5vdWdoKS4NCkknbSBub3Qgc3VyZSB3aGV0aGVyIEknbSBoaXR0aW5n
IHRoZSBqaWZmaWVzIGxpbWl0LA0KYnV0IHRoYXQgaXMgaGFyZCBjb2RlZCBhdCAyLg0KDQpJJ20g
Z29pbmcgdG8gc3RhcnQgYW5vdGhlciB0aHJlYWQuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVk
IEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5l
cywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

