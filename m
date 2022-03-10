Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D54D474D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 13:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242158AbiCJMxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 07:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbiCJMwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 07:52:51 -0500
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC9149942;
        Thu, 10 Mar 2022 04:51:49 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id EDDC85FD09;
        Thu, 10 Mar 2022 15:34:11 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1646915652;
        bh=WoWZF6JdRoVodgu3ddI177kqneb6g0k7m43k6/r1Ruw=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=USSXzpxiPfwr7a9JCJn34ZjPZk9YojsNvAZSdOpg50EXXFRfGA7SAqPmcWL8W4llO
         a4emh46I/WLqjkPi7Ah9Ni8W4+opOzpdXAiVb2AEr58p1bnm1E0m6n04yrJy3uLpPv
         03vrIjQhT/DmshdVpSLlSs8hCKwbEvd5pJoUShFSkBTjP1m7o7lPmpHgxOjdJHJ/Yx
         KPZvazQTmaTta4R25liMx+Rna4BiFhLCbQxdL7Xovi2+K+b9Bdcw+ZYa7s+bzfnuS5
         LZJjU8HI/yh64YAw0VOMT1fPqqACAIoT4Lh7jG/Ur6PSdBJRKiHhY+7cMyDUi6nOKV
         5VHtaZ/Mgb8+g==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 10 Mar 2022 15:34:09 +0300 (MSK)
From:   =?utf-8?B?0JrRgNCw0YHQvdC+0LIg0JDRgNGB0LXQvdC40Lkg0JLQu9Cw0LTQuNC80Lg=?=
         =?utf-8?B?0YDQvtCy0LjRhw==?= <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        =?utf-8?B?0KDQvtC60L7RgdC+0LIg0JTQvNC40YLRgNC40Lkg0JTQvNC40YLRgNC40LU=?=
         =?utf-8?B?0LLQuNGH?= <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 
Thread-Index: AQHYNHsXWbmmC89VRku31NTu4j+BVA==
Date:   Thu, 10 Mar 2022 12:33:48 +0000
Message-ID: <17514ec6-6e04-6ef9-73ba-b21da09f0f6f@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF9BC9CDA3BBB44483732DEEF87BACFB@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/10 08:46:00 #18933400
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSA2MjY5ZjhlZWZlYzcxYjM5YjIwNTFkMjAyYzUzNTllYjg3N2FhMTExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogQXJzZW5peSBLcmFzbm92IDxBVmxhZGltS3Jhc25vdkBzYmVy
YmFuay5ydT4NCkRhdGU6IFRodSwgMTcgRmViIDIwMjIgMDk6NTY6MjggKzAzMDANClN1YmplY3Q6
IFtSRkMgUEFUQ0ggdjEgMS8zXSBhZl92c29jazogYWRkIHR3byBuZXcgdGVzdHMgZm9yIFNPQ0tf
U0VRUEFDS0VUDQoNClRoaXMgYWRkcyB0d28gdGVzdHM6IGZvciByZWNlaXZlIHRpbWVvdXQgYW5k
IHJlYWRpbmcgdG8gaW52YWxpZA0KYnVmZmVyIHByb3ZpZGVkIGJ5IHVzZXIuIEkgZm9yZ290IHRv
IHB1dCBib3RoIHBhdGNoZXMgdG8gbWFpbg0KcGF0Y2hzZXQuDQoNCkFyc2VuaXkgS3Jhc25vdigy
KToNCg0KYWZfdnNvY2s6IFNPQ0tfU0VRUEFDS0VUIHJlY2VpdmUgdGltZW91dCB0ZXN0DQphZl92
c29jazogU09DS19TRVFQQUNLRVQgYnJva2VuIGJ1ZmZlciB0ZXN0DQoNCnRvb2xzL3Rlc3Rpbmcv
dnNvY2svdnNvY2tfdGVzdC5jIHwgMTcwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KMSBmaWxlIGNoYW5nZWQsIDE3MCBpbnNlcnRpb25zKCspDQoNCi0tIA0KMi4yNS4x
DQo=
