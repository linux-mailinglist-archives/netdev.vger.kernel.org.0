Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC1951D678
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 13:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391255AbiEFLTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 07:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244042AbiEFLTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 07:19:49 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C6575DA3F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 04:16:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-141-5bFZsmBPMJaCVZ5XX50WZg-1; Fri, 06 May 2022 12:15:26 +0100
X-MC-Unique: 5bFZsmBPMJaCVZ5XX50WZg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 6 May 2022 12:15:23 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 6 May 2022 12:15:23 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Johannes Berg' <johannes@sipsolutions.net>,
        Keith Packard <keithp@keithp.com>,
        Kees Cook <keescook@chromium.org>
CC:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Andrew Gabbasov" <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Christian Brauner <brauner@kernel.org>,
        =?utf-8?B?Q2hyaXN0aWFuIEfDtnR0c2NoZQ==?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        "David Gow" <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "Dmitry Kasatkin" <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        "Eugeniu Rosca" <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Hante Meuleman" <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "kunit-dev@googlegroups.com" <kunit-dev@googlegroups.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Max Filippov" <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?utf-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        "Rich Felker" <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        Wei Liu <wei.liu@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        "Yang Yingliang" <yangyingliang@huawei.com>
Subject: RE: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
Thread-Topic: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
Thread-Index: AQHYYLyA1R9dSzYVM0KNCrE+uTLPFK0RsSYw
Date:   Fri, 6 May 2022 11:15:23 +0000
Message-ID: <46ec2f1d6e9347eaba1feeb00e8c508a@AcuMS.aculab.com>
References: <20220504014440.3697851-1-keescook@chromium.org>
         <20220504014440.3697851-3-keescook@chromium.org>
         <d3b73d80f66325fdfaf2d1f00ea97ab3db03146a.camel@sipsolutions.net>
         <202205040819.DEA70BD@keescook>
         <970a674df04271b5fd1971b495c6b11a996c20c2.camel@sipsolutions.net>
         <871qx8qabo.fsf@keithp.com> <202205051228.4D5B8CD624@keescook>
         <87pmkrpwrs.fsf@keithp.com>
 <e1ea4926f105b456f6a86ce30a0380ee5f48fe6d.camel@sipsolutions.net>
In-Reply-To: <e1ea4926f105b456f6a86ce30a0380ee5f48fe6d.camel@sipsolutions.net>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9oYW5uZXMgQmVyZw0KPiBTZW50OiAwNSBNYXkgMjAyMiAyMToxMw0KPiBPbiBUaHUs
IDIwMjItMDUtMDUgYXQgMTM6MDggLTA3MDAsIEtlaXRoIFBhY2thcmQgd3JvdGU6DQo+IA0KPiAN
Cj4gPiBJIGJldCB5b3UndmUgYWxyZWFkeSBjb25zaWRlcmVkIHRoZSBzaW1wbGVyIGZvcm06DQo+
ID4NCj4gPiAgICAgICAgIHN0cnVjdCBzb21ldGhpbmcgKmluc3RhbmNlID0gbWVtX3RvX2ZsZXhf
ZHVwKGJ5dGVfYXJyYXksIGNvdW50LCBHRlBfS0VSTkVMKTsNCj4gPiAgICAgICAgIGlmIChJU19F
UlIoaW5zdGFuY2UpKQ0KPiA+ICAgICAgICAgICAgIHJldHVybiBQVFJfRVJSKGluc3RhbmNlKTsN
Cj4gPg0KPiANCj4gU2FkbHksIHRoaXMgZG9lc24ndCB3b3JrIGluIGFueSB3YXkgYmVjYXVzZSBt
ZW1fdG9fZmxleF9kdXAoKSBuZWVkcyB0bw0KPiBrbm93IGF0IGxlYXN0IHRoZSB0eXBlLCBoZW5j
ZSBwYXNzaW5nICdpbnN0YW5jZScsIHdoaWNoIGlzIHNpbXBsZXIgdGhhbg0KPiBwYXNzaW5nICdz
dHJ1Y3Qgc29tZXRoaW5nJy4NCg0KWW91IGNhbiB1c2U6DQogICAgICAgICBzdHJ1Y3Qgc29tZXRo
aW5nICppbnN0YW5jZTsNCiAgICAgICAgIG1lbV90b19mbGV4X2R1cChpbnN0YW5jZSwgYnl0ZV9h
cnJheSwgY291bnQsIEdGUF9LRVJORUwpOw0KICAgICAgICAgaWYgKElTX0VSUihpbnN0YW5jZSkp
DQogICAgICAgICAgICAgcmV0dXJuIFBUUl9FUlIoaW5zdGFuY2UpOw0KYW5kIGhhdmUgbWVtX3Rv
X2ZsZXhfZHVwKCkgKHdoaWNoIG11c3QgYmUgYSAjZGVmaW5lKSB1cGRhdGUgJ2luc3RhbmNlJy4N
CihZb3UgY2FuIHJlcXVpcmUgJmluc3RhbmNlIC0gYW5kIGp1c3QgcHJlY2VkZSBhbGwgdGhlIHVz
ZXMgd2l0aA0KYW4gZXh0cmEgJyonIHRvIG1ha2UgaXQgbW9yZSBvYnZpb3VzIHRoZSB2YXJpYWJs
ZSBpcyB1cGRhdGVkLg0KQnV0IHRoZXJlIGlzIGxpdHRsZSBwb2ludCByZXF1aXJpbmcgaXQgYmUg
TlVMTC4pDQoNCklmIHlvdSByZWFsbHkgd2FudCB0byBkZWZpbmUgdGhlIHZhcmlhYmxlIG1pZC1i
bG9jayB5b3UgY2FuIHVzZToNCiAgICAgICAgIG1lbV90b19mbGV4X2R1cChzdHJ1Y3Qgc29tZXRo
aW5nICosIGluc3RhbmNlLCBieXRlX2FycmF5LCBjb3VudCwgR0ZQX0tFUk5FTCk7DQoNCmJ1dCBJ
IHJlYWxseSBoYXRlIGhhdmluZyBkZWNsYXJhdGlvbnMgYW55d2hlcmUgb3RoZXIgdGhhbiB0aGUg
dG9wIG9mDQphIGZ1bmN0aW9uIGJlY2F1c2UgaXQgbWFrZXMgdGhlbSBoYXJkIGZvciB0aGUgJ21r
MSBleWViYWxsJyB0byBzcG90Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExh
a2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQs
IFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

