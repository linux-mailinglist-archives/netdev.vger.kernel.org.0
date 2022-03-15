Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631304D99D7
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347762AbiCOLCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbiCOLCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:02:43 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFC54348C;
        Tue, 15 Mar 2022 04:01:29 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 88F165FD02;
        Tue, 15 Mar 2022 14:01:26 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647342086;
        bh=RW5IjNKHFJtjqsH4ITCzR2lYLoB/q/SCRxVZYrFoF2M=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=muk+0uigRIiMIRqEOQ2SYbS71/y0+PA7hbtudQIn3xYGeSHuKLRplpsW70W4IbNl7
         l7oxHA9vTTgKM6GJMg703xMSkaiyc6d8cWEjnwcLkYVUxYAl3wMa5Spbbd3m56jALy
         2lt8fEI1vQxzBno8Uyl0RHXUS6pqUghnEO5CSPdlytIkIRIuAHMGYTvMIQdc4LNkK9
         ghXaaMQ+uP7G36xYl/WO37ZBHnE0rWmFRg8GvPsyycv1d0eKPDVNpNS6iySZAMwML7
         p1KwCGkopfnevYJw36OQ74qLhtiF1/lQr160pV5AsyRVti3GkMCZHx3qi+Oh135p9e
         G5uzIoZc4q/pQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Tue, 15 Mar 2022 14:01:20 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/3] af_vsock: add two new tests for SOCK_SEQPACKET
Thread-Topic: [RFC PATCH v1 1/3] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Index: AQHYNTYb8Fo8I4zas06sN3idOLyY0qy/9J+AgAAmooA=
Date:   Tue, 15 Mar 2022 11:00:35 +0000
Message-ID: <74154bf9-06c9-5072-af60-38819ff01fe3@sberdevices.ru>
References: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
 <20220315084257.lbrbsilpndswv3zy@sgarzare-redhat>
In-Reply-To: <20220315084257.lbrbsilpndswv3zy@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E15ECCD410AEC24DAC43049E86EA6EAE@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/15 06:52:00 #18973197
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTUuMDMuMjAyMiAxMTo0MiwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBIaSBBcnNl
bml5LA0KPiANCj4gT24gRnJpLCBNYXIgMTEsIDIwMjIgYXQgMTA6NTI6MzZBTSArMDAwMCwgS3Jh
c25vdiBBcnNlbml5IFZsYWRpbWlyb3ZpY2ggd3JvdGU6DQo+PiBUaGlzIGFkZHMgdHdvIHRlc3Rz
OiBmb3IgcmVjZWl2ZSB0aW1lb3V0IGFuZCByZWFkaW5nIHRvIGludmFsaWQNCj4+IGJ1ZmZlciBw
cm92aWRlZCBieSB1c2VyLiBJIGZvcmdvdCB0byBwdXQgYm90aCBwYXRjaGVzIHRvIG1haW4NCj4+
IHBhdGNoc2V0Lg0KPj4NCj4+IEFyc2VuaXkgS3Jhc25vdigyKToNCj4+DQo+PiBhZl92c29jazog
U09DS19TRVFQQUNLRVQgcmVjZWl2ZSB0aW1lb3V0IHRlc3QNCj4+IGFmX3Zzb2NrOiBTT0NLX1NF
UVBBQ0tFVCBicm9rZW4gYnVmZmVyIHRlc3QNCj4+DQo+PiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zz
b2NrX3Rlc3QuYyB8IDE3MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4+IDEgZmlsZSBjaGFuZ2VkLCAxNzAgaW5zZXJ0aW9ucygrKQ0KPiANCj4gVGhhbmsgeW91IGZv
ciB0aGVzZSB0ZXN0cyENCg0KR3JlYXQhIFRoYW5rIFlvdQ0KDQo+IA0KPiBJIGxlZnQgYSBmZXcg
Y29tbWVudHMgYW5kIEknbSBub3Qgc3VyZSBhYm91dCB0aGUgJ2Jyb2tlbiBidWZmZXIgdGVzdCcg
YmVoYXZpb3IuDQoNCkFjaw0KDQo+IA0KPiBBYm91dCB0aGUgc2VyaWVzLCBpdCBzb3VuZHMgbGlr
ZSBzb21ldGhpbmcgaXMgd3Jvbmcgd2l0aCB5b3VyIHNldHVwLCB1c3VhbGx5IHRoZSBjb3ZlciBs
ZXR0ZXIgaXMgInBhdGNoIiAwLiBJbiB0aGlzIGNhc2UgSSB3b3VsZCBoYXZlIGV4cGVjdGVkOg0K
PiANCj4gwqDCoMKgIFswLzJdIGFmX3Zzb2NrOiBhZGQgdHdvIG5ldyB0ZXN0cyBmb3IgU09DS19T
RVFQQUNLRVQNCj4gwqDCoMKgIFsxLzJdIGFmX3Zzb2NrOiBTT0NLX1NFUVBBQ0tFVCByZWNlaXZl
IHRpbWVvdXQgdGVzdA0KPiDCoMKgwqAgWzIvMl0gYWZfdnNvY2s6IFNPQ0tfU0VRUEFDS0VUIGJy
b2tlbiBidWZmZXIgdGVzdA0KDQpBY2sNCg0KPiANCj4gQXJlIHlvdSB1c2luZyBgZ2l0IHNlbmQt
ZW1haWxgIG9yIGBnaXQgcHVibGlzaGA/DQo+IA0KDQpJJ20gdXNpbmcgdGh1bmRlcmJpcmQgdG8g
c2VuZCBwYXRjaGVzPjwsIGJlY2F1c2Ugd2UgZG9uJ3QgaGF2ZSBTTVRQIHNlcnZlcihleGNoYW5n
ZSBvbmx5KS4gDQoNCj4gDQo+IFdoZW4geW91IHdpbGwgcmVtb3ZlIHRoZSBSRkMsIHBsZWFzZSBh
ZGQgYG5ldC1uZXh0YCBsYWJlbDoNCj4gW1BBVENIIG5ldC1uZXh0IDAvMl0sIGV0Yy4uDQo+IA0K
PiBUaGFua3MsDQo+IFN0ZWZhbm8NCj4gDQoNCg==
