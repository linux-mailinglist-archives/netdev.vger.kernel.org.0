Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAF857F82C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 04:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiGYCJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 22:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbiGYCIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 22:08:54 -0400
Received: from m13114.mail.163.com (m13114.mail.163.com [220.181.13.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0C8FF582
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 19:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=dBony
        8quVwY2JIJZz0+wYGLL1ZSTYVcvE4c5ekRQf5M=; b=d9R1L0dihKrP7K/+DDH5v
        0YR1Dblmd6+8dilp51zM5FC+oe9xjQAP30K9rKJj30D+4eupcsf9EUp6mxgTsLtf
        HF04ClRKxV7SNCtd/USWtXVInT5y3eYp7bJ7nlgWCnhUZ3mqXLoNT8Au2T5xaJUu
        GhMqb/zz9pM38IUwOH9jkI=
Received: from slark_xiao$163.com ( [112.97.48.126] ) by
 ajax-webmail-wmsvr114 (Coremail) ; Mon, 25 Jul 2022 09:53:23 +0800 (CST)
X-Originating-IP: [112.97.48.126]
Date:   Mon, 25 Jul 2022 09:53:23 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "Alexandra Winter" <wintera@linux.ibm.com>,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        wenjia@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] s390/qeth: Fix typo 'the the' in comment
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <20220722115536.0d450512@kernel.org>
References: <20220722093834.77864-1-slark_xiao@163.com>
 <434e604c-7fd3-6422-d13b-309a7c1fe0d3@linux.ibm.com>
 <20220722115536.0d450512@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <7609758.aa4.182330f18b8.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: csGowADH_9KT991itw8lAA--.65143W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbCdRZJZGBbEd2eHgABs4
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjItMDctMjMgMDI6NTU6MzYsICJKYWt1YiBLaWNpbnNraSIg
PGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6Cj5PbiBGcmksIDIyIEp1bCAyMDIyIDEyOjIzOjA2ICsw
MjAwIEFsZXhhbmRyYSBXaW50ZXIgd3JvdGU6Cj4+IE9uIDIyLjA3LjIyIDExOjM4LCBTbGFyayBY
aWFvIHdyb3RlOgo+PiA+IFJlcGxhY2UgJ3RoZSB0aGUnIHdpdGggJ3RoZScgaW4gdGhlIGNvbW1l
bnQuCj4+ID4gCj4+ID4gU2lnbmVkLW9mZi1ieTogU2xhcmsgWGlhbyA8c2xhcmtfeGlhb0AxNjMu
Y29tPgo+PiA+IC0tLQo+PiA+ICBkcml2ZXJzL3MzOTAvbmV0L3FldGhfY29yZV9tYWluLmMgfCAy
ICstCj4+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+
PiA+IAo+PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3MzOTAvbmV0L3FldGhfY29yZV9tYWluLmMg
Yi9kcml2ZXJzL3MzOTAvbmV0L3FldGhfY29yZV9tYWluLmMKPj4gPiBpbmRleCA5ZTU0ZmU3NmE5
YjIuLjM1ZDRiMzk4YzE5NyAxMDA2NDQKPj4gPiAtLS0gYS9kcml2ZXJzL3MzOTAvbmV0L3FldGhf
Y29yZV9tYWluLmMKPj4gPiArKysgYi9kcml2ZXJzL3MzOTAvbmV0L3FldGhfY29yZV9tYWluLmMK
Pj4gPiBAQCAtMzU2NSw3ICszNTY1LDcgQEAgc3RhdGljIHZvaWQgcWV0aF9mbHVzaF9idWZmZXJz
KHN0cnVjdCBxZXRoX3FkaW9fb3V0X3EgKnF1ZXVlLCBpbnQgaW5kZXgsCj4+ID4gIAkJCWlmICgh
YXRvbWljX3JlYWQoJnF1ZXVlLT5zZXRfcGNpX2ZsYWdzX2NvdW50KSkgewo+PiA+ICAJCQkJLyoK
Pj4gPiAgCQkJCSAqIHRoZXJlJ3Mgbm8gb3V0c3RhbmRpbmcgUENJIGFueSBtb3JlLCBzbyB3ZQo+
PiA+IC0JCQkJICogaGF2ZSB0byByZXF1ZXN0IGEgUENJIHRvIGJlIHN1cmUgdGhlIHRoZSBQQ0kK
Pj4gPiArCQkJCSAqIGhhdmUgdG8gcmVxdWVzdCBhIFBDSSB0byBiZSBzdXJlIHRoZSBQQ0kKPj4g
PiAgCQkJCSAqIHdpbGwgd2FrZSBhdCBzb21lIHRpbWUgaW4gdGhlIGZ1dHVyZSB0aGVuIHdlCj4+
ID4gIAkJCQkgKiBjYW4gZmx1c2ggcGFja2VkIGJ1ZmZlcnMgdGhhdCBtaWdodCBzdGlsbCBiZQo+
PiA+ICAJCQkJICogaGFuZ2luZyBhcm91bmQsIHdoaWNoIGNhbiBoYXBwZW4gaWYgbm8gIAo+PiAK
Pj4gVGhpcyB0cml2aWFsIHR5cG8gaGFzIGJlZW4gc2VudCB0d2ljZSBhbHJlYWR5IHRvIHRoaXMg
bWFpbGluZ2xpc3Q6Cj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi9ZdGIxJTJGdVUr
amxjSTRqWHdAbGktNGEzYTRhNGMtMjhlNS0xMWIyLWE4NWMtYThkMTkyYzZmMDg5LmlibS5jb20v
VC8KPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzdhOTM1NzMwLWYzYTUtMGIxZi0y
YmRjLWE2Mjk3MTFhM2EwMUBsaW51eC5pYm0uY29tL3QvCj4KPlNvbWUgb2YgdGhlIGNvbW1lbnQg
c3BlbGxpbmcgZml4ZXMgZ2V0IG5hY2tlZCBpbiBidWxrIChlLmcuIHRoZQo+cHJldmlvdXMgb25l
IHdhcyBzZW50IHdpdGggYSBkYXRlIG9mIHRocmVlIGRheXMgcHJpb3IgdG8gdGhlIGFjdHVhbAo+
cG9zdGluZykuIFNpbmNlIHRoZXkgYXJlIG5vdCBpbiBhIHRocmVhZCB0aGUgbmFja3MgYXJlIGhh
cmQgdG8gc2VlLgo+T3IgbWF5YmUgdGhleSBnb3QgbG9zdCAnY2F1c2UgcGF0Y2h3b3JrIGRvZXMg
bm90IHVuZGVyc3RhbmQKPmRyaXZlcnMvczM5MC9uZXQgaXMgbmV0ZGV2LiBBbnl3YXksIHRoaXMg
b25lIGxvb2tzIGdvb2QsIHNvIGl0IHdpbGwKPmxpa2VseSBnbyBpbi4KWWVzLCBJIGp1c3QgdXBk
YXRlZCBteSBsb2NhbCBsaW51eC1uZXh0IHRocmVhZC4gU28gaXQncyBoYXJkIHRvIGtub3cgd2hl
dGhlciBvdGhlciB0aHJlYWQgaGFzIGFwcGxpZWQgc3VjaCBwYXRjaGVzLgpJdCBuZWVkcyB0aW1l
IHRvIG1lcmdlIGNoYW5nZXMgYmV0d2VlbiBkaWZmZXJlbnQgdGhyZWFkcy4gRXNwZWNpYWxseSBm
b3Igc29tZSBub24tZml4ZXMgY29tbWl0LgoKVGhhbmtzIQo=
