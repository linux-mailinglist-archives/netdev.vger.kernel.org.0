Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5240C4C9935
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbiCAXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbiCAXUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:20:36 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75ED39BAD6
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 15:19:52 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-274-hYNDa1-rPGCuZAB3qy-How-1; Tue, 01 Mar 2022 23:19:49 +0000
X-MC-Unique: hYNDa1-rPGCuZAB3qy-How-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 1 Mar 2022 23:19:46 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 1 Mar 2022 23:19:46 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>
CC:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        KVM list <kvm@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
        <kgdb-bugreport@lists.sourceforge.net>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Arnd Bergman" <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        "v9fs-developer@lists.sourceforge.net" 
        <v9fs-developer@lists.sourceforge.net>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        "Mike Rapoport" <rppt@kernel.org>
Subject: RE: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Topic: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Thread-Index: AQHYLZ9++DU/OogLf0+tiSFmjztyUKyrHL5AgAAJGICAAAEEcA==
Date:   Tue, 1 Mar 2022 23:19:46 +0000
Message-ID: <0ced2b155b984882b39e895f0211037c@AcuMS.aculab.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com>
 <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <282f0f8d-f491-26fc-6ae0-604b367a5a1a@amd.com>
 <b2d20961dbb7533f380827a7fcc313ff849875c1.camel@HansenPartnership.com>
 <7D0C2A5D-500E-4F38-AD0C-A76E132A390E@kernel.org>
 <73fa82a20910c06784be2352a655acc59e9942ea.camel@HansenPartnership.com>
 <CAHk-=wiT5HX6Kp0Qv4ZYK_rkq9t5fZ5zZ7vzvi6pub9kgp=72g@mail.gmail.com>
 <7dc860874d434d2288f36730d8ea3312@AcuMS.aculab.com>
 <CAHk-=whKqg89zu4T95+ctY-hocR6kDArpo2qO14-kV40Ga7ufw@mail.gmail.com>
In-Reply-To: <CAHk-=whKqg89zu4T95+ctY-hocR6kDArpo2qO14-kV40Ga7ufw@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMDEgTWFyY2ggMjAyMiAyMzowMw0KPiANCj4g
T24gVHVlLCBNYXIgMSwgMjAyMiBhdCAyOjU4IFBNIERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0
QGFjdWxhYi5jb20+IHdyb3RlOg0KPiA+DQo+ID4gQ2FuIGl0IGJlIHJlc29sdmVkIGJ5IG1ha2lu
ZzoNCj4gPiAjZGVmaW5lIGxpc3RfZW50cnlfaXNfaGVhZChwb3MsIGhlYWQsIG1lbWJlcikgKChw
b3MpID09IE5VTEwpDQo+ID4gYW5kIGRvdWJsZS1jaGVja2luZyB0aGF0IGl0IGlzbid0IHVzZWQg
YW55d2hlcmUgZWxzZSAoZXhjZXB0IGluDQo+ID4gdGhlIGxpc3QgbWFjcm9zIHRoZW1zZWx2ZXMp
Lg0KPiANCj4gV2VsbCwgeWVzLCBleGNlcHQgZm9yIHRoZSBmYWN0IHRoYXQgdGhlbiB0aGUgbmFt
ZSBpcyBlbnRpcmVseSBtaXNsZWFkaW5nLi4uDQo+IA0KPiBBbmQgc29tZWJvZHkgcG9zc2libHkg
dXNlcyBpdCB0b2dldGhlciB3aXRoIGxpc3RfZmlyc3RfZW50cnkoKSBldGMsIHNvDQo+IGl0IHJl
YWxseSBpcyBjb21wbGV0ZWx5IGJyb2tlbiB0byBtaXggdGhhdCBjaGFuZ2Ugd2l0aCB0aGUgbGlz
dA0KPiB0cmF2ZXJzYWwgY2hhbmdlLg0KDQpQcm9iYWJseSB0cnVlIDotKA0KDQpBY3R1YWxseSBh
ZGRpbmcgbGlzdF9lbnRyeV9ub3RfZm91bmQoKSBhcyBhIHN5bm9ueW0gZm9yDQpsaXN0X2VudHJ5
X2lzX2hlYWQoKSBhbmQgY2hhbmdpbmcgdGhlIDI1aXNoIHBsYWNlcyB0aGF0DQp1c2UgaXQgYWZ0
ZXIgYSBsb29wIG1pZ2h0IHdvcmsuDQoNCk9uY2UgdGhhdCBpcyBkb25lIHRoZSBsb29wIGNhbiBi
ZSBjaGFuZ2VkIGF0IHRoZSBzYW1lIHRpbWUNCmFzIGxpc3RfZW50cnlfbm90X2ZvdW5kKCkuDQpU
aGF0IHdvbid0IGFmZmVjdCB0aGUgaW4tdHJlZSBjYWxsZXJzLg0KKGFuZCBteSBvdXQgb2YgdHJl
ZSBtb2R1bGVzIGRvbid0IHVzZSB0aG9zZSBsaXN0cyAtIHNvIEkNCmRvbid0IGNhcmUgYWJvdXQg
dGhhdCEpDQoNCkhhdmluZyBzYWlkIHRoYXQgdGhlcmUgYXJlIHNvIGZldyB1c2VycyBvZiBsaXN0
X2VudHJ5X2lzX2hlYWQoKQ0KaXQgaXMgcmVhc29uYWJsZSB0byBnZW5lcmF0ZSB0d28gbmV3IG5h
bWVzLg0KT25lIGZvciB1c2UgYWZ0ZXIgbGlzdF9mb3JfZWFjaF9lbnRyeSgpIGFuZCBvbmUgZm9y
IGxpc3RfbmV4dF9lbnRyeSgpLg0KVGhlbiB0aGUgY2hhbmdlIGFsbCB0aGUgY2FsbCBzaXRlcy4N
CkFmdGVyIHRoYXQgbGlzdF9lbnRyeV9pc19oZWFkKCkgY2FuIGJlIGRlbGV0ZWQgLSBicmVha2lu
ZyBvdXQgb2YNCnRyZWUgY29tcGlsZXMuDQpGaW5hbGx5IGxpc3RfZm9yX2VhY2hfZW50cnkoKSBj
YW4gYmUgcmV3cml0dGVuIHRvIHNldCBOVUxMDQphdCB0aGUgZW5kIG9mIHRoZSBsaXN0Lg0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K

