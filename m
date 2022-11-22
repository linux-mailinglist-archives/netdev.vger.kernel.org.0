Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14506349F3
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiKVWXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiKVWXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:23:17 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CEF193EF
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:23:15 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-125-mXs9r8MRP7yhSUvfo49emw-1; Tue, 22 Nov 2022 22:23:13 +0000
X-MC-Unique: mXs9r8MRP7yhSUvfo49emw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 22 Nov
 2022 22:23:11 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Tue, 22 Nov 2022 22:23:11 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Julia Lawall" <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [patch V2 09/17] timers: Rename del_timer_sync() to
 timer_delete_sync()
Thread-Topic: [patch V2 09/17] timers: Rename del_timer_sync() to
 timer_delete_sync()
Thread-Index: AQHY/ppUj/KI6nvrHEK9CVCVTxMIma5Lgybg
Date:   Tue, 22 Nov 2022 22:23:11 +0000
Message-ID: <2c42cb1fe1fa4b11ba3c0263d7886b68@AcuMS.aculab.com>
References: <20221122171312.191765396@linutronix.de>
 <20221122173648.619071341@linutronix.de>
In-Reply-To: <20221122173648.619071341@linutronix.de>
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

RnJvbTogVGhvbWFzIEdsZWl4bmVyDQo+IFNlbnQ6IDIyIE5vdmVtYmVyIDIwMjIgMTc6NDUNCj4g
DQo+IFRoZSB0aW1lciByZWxhdGVkIGZ1bmN0aW9ucyBkbyBub3QgaGF2ZSBhIHN0cmljdCB0aW1l
cl8gcHJlZml4ZWQgbmFtZXNwYWNlDQo+IHdoaWNoIGlzIHJlYWxseSBhbm5veWluZy4NCj4gDQo+
IFJlbmFtZSBkZWxfdGltZXJfc3luYygpIHRvIHRpbWVyX2RlbGV0ZV9zeW5jKCkgYW5kIHByb3Zp
ZGUgZGVsX3RpbWVyX3N5bmMoKQ0KPiBhcyBhIHdyYXBwZXIuIERvY3VtZW50IHRoYXQgZGVsX3Rp
bWVyX3N5bmMoKSBpcyBub3QgZm9yIG5ldyBjb2RlLg0KDQpUbyBjaGFuZ2UgdGhlIGNvbG9bdV1y
IG9mIHRoZSBiaWtlc2hlZCwgd291bGQgaXQgYmUgYmV0dGVyIHRvDQpuYW1lIHRoZSBmdW5jdGlv
bnMgdGltZXJfc3RhcnQoKSBhbmQgdGltZXJfc3RvcFtfc3luY10oKS4NCg0KQW5kLCBhcyBJIGZv
dW5kIG91dCBmb3IgYSBsb2NhbCBkcml2ZXIsIGFkZGluZyBpdGVtcyB0byB3b3JrIHF1ZXVlcw0K
ZnJvbSB0aW1lciBjYWxsYmFja3MgcmVhbGx5IGlzbid0IGEgZ29vZCBpZGVhIGF0IGFsbCENClRo
ZSBkZWxheWVkX3dvcmsgZnVuY3Rpb25zIGhhbmRsZSBpdCBhIGxvdCBiZXR0ZXIuDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=

