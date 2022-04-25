Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5950D7BC
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbiDYDoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240826AbiDYDnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:43:41 -0400
Received: from m1541.mail.126.com (m1541.mail.126.com [220.181.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF2CB645E;
        Sun, 24 Apr 2022 20:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=Xb2jU
        I68L4ingevBNbIwSF+oSRTmjSydhDTtvsIxWcs=; b=pFYM06IGpHTkeYdf0zJK8
        +GSBQZCR2VR6HNUh6tNvRFpRpwCXpr7bY9XUlgBFkn2vjdilIyecsrQSVdy9lRd9
        bpKLnWsW46UYad2Yv2T7a0Tl6uAk846LQizehMhZytT7oOvoYiNQnQXECBDZskko
        /wBb7WgdTAp6yJc+RnfCNA=
Received: from zhaojunkui2008$126.com ( [112.80.34.205] ) by
 ajax-webmail-wmsvr41 (Coremail) ; Mon, 25 Apr 2022 11:40:02 +0800 (CST)
X-Originating-IP: [112.80.34.205]
Date:   Mon, 25 Apr 2022 11:40:02 +0800 (CST)
From:   z <zhaojunkui2008@126.com>
To:     "Jakub Kicinski" <kubakici@wp.pl>
Cc:     "Kalle Valo" <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re:Re: [PATCH v2] mediatek/mt7601u: add debugfs exit function
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210622(1d4788a8)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220422124704.259244e7@kicinski-fedora-PC1C0HJN>
References: <20220422080854.490379-1-zhaojunkui2008@126.com>
 <20220422124704.259244e7@kicinski-fedora-PC1C0HJN>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <15b4f.2aad.1805ece06a1.Coremail.zhaojunkui2008@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: KcqowABHV98TGGZi9k4TAA--.52204W
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiqBPtqlpD9keacgAAs8
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkF0IDIwMjItMDQtMjMgMDM6NDc6MDQsICJKYWt1YiBLaWNpbnNraSIgPGt1YmFraWNpQHdwLnBs
PiB3cm90ZToKPk9uIEZyaSwgMjIgQXByIDIwMjIgMDE6MDg6NTQgLTA3MDAgQmVybmFyZCBaaGFv
IHdyb3RlOgo+PiBXaGVuIG10NzYwMXUgbG9hZGVkLCB0aGVyZSBhcmUgdHdvIGNhc2VzOgo+PiBG
aXJzdCB3aGVuIG10NzYwMXUgaXMgbG9hZGVkLCBpbiBmdW5jdGlvbiBtdDc2MDF1X3Byb2JlLCBp
Zgo+PiBmdW5jdGlvbiBtdDc2MDF1X3Byb2JlIHJ1biBpbnRvIGVycm9yIGxhYmxlIGVycl9odywK
Pj4gbXQ3NjAxdV9jbGVhbnVwIGRpZG5gdCBjbGVhbnVwIHRoZSBkZWJ1Z2ZzIG5vZGUuCj4+IFNl
Y29uZCB3aGVuIHRoZSBtb2R1bGUgZGlzY29ubmVjdCwgaW4gZnVuY3Rpb24gbXQ3NjAxdV9kaXNj
b25uZWN0LAo+PiBtdDc2MDF1X2NsZWFudXAgZGlkbmB0IGNsZWFudXAgdGhlIGRlYnVnZnMgbm9k
ZS4KPj4gVGhpcyBwYXRjaCBhZGQgZGVidWdmcyBleGl0IGZ1bmN0aW9uIGFuZCB0cnkgdG8gY2xl
YW51cCBkZWJ1Z2ZzCj4+IG5vZGUgd2hlbiBtdDc2MDF1IGxvYWRlZCBmYWlsIG9yIHVubG9hZGVk
Lgo+PiAKPj4gU2lnbmVkLW9mZi1ieTogQmVybmFyZCBaaGFvIDx6aGFvanVua3VpMjAwOEAxMjYu
Y29tPgo+Cj5BaCwgbWlzc2VkIHRoYXQgdGhlcmUgd2FzIGEgdjIuIE15IHBvaW50IHN0YW5kcywg
d2lwaHkgZGVidWdmcyBkaXIKPnNob3VsZCBkbyB0aGUgY2xlYW51cC4KPgo+RG8geW91IGVuY291
bnRlciBwcm9ibGVtcyBpbiBwcmFjdGljZSBvciBhcmUgeW91IHNlbmRpbmcgdGhpcyBwYXRjaGVz
Cj5iYXNlZCBvbiByZWFkaW5nIC8gc3RhdGljIGFuYWx5c2lzIG9mIHRoZSBjb2RlIG9ubHkuCgpI
aSBKYWt1YiBLaWNpbnNraToKClRoZSBpc3N1ZSBoZXJlIGlzIGZvdW5kIGJ5IHJlYWRpbmcgY29k
ZS4KSSByZWFkIHRoZSBkcml2ZXJzL25ldC93aXJlbGVzcyBjb2RlIGFuZCBmb3VuZCB0aGF0IG1h
bnkgbW9kdWxlcyBhcmUgbm90IGNsZWFudXAgdGhlIGRlYnVnZnMuIApJIHNvcnRlZCBvdXQgdGhl
IG1vZHVsZXMgdGhhdCB3ZXJlIG5vdCBjbGVhbmVkIHVwIHRoZSBkZWJ1Z2ZzOgouL3RpL3dsMTh4
eAouL3RpL3dsMTJ4eAouL2ludGVsL2l3bHdpZmkKLi9pbnRlbC9pd2x3aWZpCi4vbWVkaWF0ZWsv
bXQ3NgpJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhpcyBwYXJ0IGlzIHdlbGNvbWUgdG8ga2VybmVs
IHNvIEkgc3VibWl0dGVkIGEgcGF0Y2guCklmIHlvdSBoYXZlIGFueSBzdWdnZXN0aW9ucywgd2Vs
Y29tZSB0byBwdXQgZm9yd2FyZCBmb3IgZGlzY3Vzc2lvbiwgdGhhbmsgeW91o6EKCkJSLy9CZXJu
YXJkCgo=
