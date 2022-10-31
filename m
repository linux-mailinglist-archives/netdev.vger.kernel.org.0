Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F7613548
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiJaMD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiJaMDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:03:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1AE558E
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:03:19 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-13-_QyoVJI9MFyAK1DDhaJozg-1; Mon, 31 Oct 2022 12:03:17 +0000
X-MC-Unique: _QyoVJI9MFyAK1DDhaJozg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 31 Oct
 2022 12:03:15 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Mon, 31 Oct 2022 12:03:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Jiri Olsa <jolsa@kernel.org>
Subject: RE: Linux 6.1-rc3 build fail in include/linux/bpf.h
Thread-Topic: Linux 6.1-rc3 build fail in include/linux/bpf.h
Thread-Index: AdjtGTCPbw9N9pokSJmsEaDNMnM9HgAB0qww
Date:   Mon, 31 Oct 2022 12:03:15 +0000
Message-ID: <439af02a169149f28ba0a4e3bbc729ee@AcuMS.aculab.com>
References: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
In-Reply-To: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDMxIE9jdG9iZXIgMjAyMiAxMToxNQ0KPiANCj4g
VGhlIDYuMS1yYzMgc291cmNlcyBmYWlsIHRvIGJ1aWxkIGJlY2F1c2UgYnBmLmggdW5jb25kaXRp
b25hbGx5DQo+ICNkZWZpbmUgQlBGX0RJU1BBVENIRVJfQVRUUklCVVRFUyBfX2F0dHJpYnV0ZV9f
KChwYXRjaGFibGVfZnVuY3Rpb25fZW50cnkoNSkpKQ0KPiBmb3IgWDg2XzY0IGJ1aWxkcy4NCj4g
DQo+IEknbSBwcmV0dHkgc3VyZSB0aGF0IHNob3VsZCBkZXBlbmQgb24gc29tZSBvdGhlciBvcHRp
b25zDQo+IHNpbmNlIHRoZSBjb21waWxlciBpc24ndCByZXF1aXJlZCB0byBzdXBwb3J0IGl0Lg0K
PiAoVGhlIGdjYyA3LjUuMCBvbiBteSBVYnVudGkgMTguMDQgc3lzdGVtIGNlcnRhaW5seSBkb2Vz
bid0KQ0KPiANCj4gVGhlIG9ubHkgb3RoZXIgcmVmZXJlbmNlIHRvIHRoYXQgYXR0cmlidXRlIGlz
IGluIHRoZSBkZWZpbml0aW9uDQo+IG9mICdub3RyYWNlJyBpbiBjb21waWxlci5oLg0KDQpJIHRo
aW5rIHBhdGNoYWJsZV9mdW5jdGlvbl9lbnRyeSB3YXMgYWRkZWQgaW4gZ2NjIDguDQpEb2N1bWVu
dGF0aW9uL3Byb2Nlc3MvY2hhbmdlcy5yc3QgZ2l2ZXMgdGhlIG1pbmltYWwgZ2NjIHZlcnNpb24g
Zm9yDQpidWlsZGluZyB0aGUga2VybmVsIGFzIDUuMS4NCg0KSSBkb3VidCBhIGluY3JlYXNpbmcg
aXQgdG8gOCBpcyBhY2NlcHRhYmxlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

