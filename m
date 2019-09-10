Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8600AEED7
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403925AbfIJPq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:46:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729802AbfIJPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:46:57 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3697E154F788C;
        Tue, 10 Sep 2019 08:46:55 -0700 (PDT)
Date:   Tue, 10 Sep 2019 17:46:53 +0200 (CEST)
Message-Id: <20190910.174653.800353422834551780.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Subject: Re: [PATCH] net: stmmac: socfpga: re-use the `interface` parameter
 from platform data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910.174544.945128884852877943.davem@davemloft.net>
References: <20190906123054.5514-1-alexandru.ardelean@analog.com>
        <20190910.174544.945128884852877943.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 08:46:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVHVlLCAxMCBT
ZXAgMjAxOSAxNzo0NTo0NCArMDIwMCAoQ0VTVCkNCg0KPiBGcm9tOiBBbGV4YW5kcnUgQXJkZWxl
YW4gPGFsZXhhbmRydS5hcmRlbGVhbkBhbmFsb2cuY29tPg0KPiBEYXRlOiBGcmksIDYgU2VwIDIw
MTkgMTU6MzA6NTQgKzAzMDANCj4gDQo+PiBUaGUgc29jZnBnYSBzdWItZHJpdmVyIGRlZmluZXMg
YW4gYGludGVyZmFjZWAgZmllbGQgaW4gdGhlIGBzb2NmcGdhX2R3bWFjYA0KPj4gc3RydWN0IGFu
ZCBwYXJzZXMgaXQgb24gaW5pdC4NCj4+IA0KPj4gVGhlIHNoYXJlZCBgc3RtbWFjX3Byb2JlX2Nv
bmZpZ19kdCgpYCBmdW5jdGlvbiBhbHNvIHBhcnNlcyB0aGlzIGZyb20gdGhlDQo+PiBkZXZpY2Ut
dHJlZSBhbmQgbWFrZXMgaXQgYXZhaWxhYmxlIG9uIHRoZSByZXR1cm5lZCBgcGxhdF9kYXRhYCAo
d2hpY2ggaXMNCj4+IHRoZSBzYW1lIGRhdGEgYXZhaWxhYmxlIHZpYSBgbmV0ZGV2X3ByaXYoKWAp
Lg0KPj4gDQo+PiBBbGwgdGhhdCdzIG5lZWRlZCBub3cgaXMgdG8gZGlnIHRoYXQgaW5mb3JtYXRp
b24gb3V0LCB2aWEgc29tZQ0KPj4gYGRldl9nZXRfZHJ2ZGF0YSgpYCAmJiBgbmV0ZGV2X3ByaXYo
KWAgY2FsbHMgYW5kIHJlLXVzZSBpdC4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1
IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNvbT4NCj4gDQo+IFRoaXMgZG9l
c24ndCBidWlsZCBldmVuIG9uIG5ldC1uZXh0Lg0KDQpTcGVjaWZpY2FsbHk6DQoNCmRyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXNvY2ZwZ2EuYzogSW4gZnVuY3Rpb24g
oXNvY2ZwZ2FfZ2VuNV9zZXRfcGh5X21vZGWiOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNy
by9zdG1tYWMvZHdtYWMtc29jZnBnYS5jOjI2NDo0NDogZXJyb3I6IKFwaHltb2RloiB1bmRlY2xh
cmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiChcGh5X21vZGVz
oj8NCiAgMjY0IHwgICBkZXZfZXJyKGR3bWFjLT5kZXYsICJiYWQgcGh5IG1vZGUgJWRcbiIsIHBo
eW1vZGUpOw0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgXn5+fn5+fg0KLi9pbmNsdWRlL2xpbnV4L2RldmljZS5oOjE0OTk6MzI6IG5vdGU6IGluIGRl
ZmluaXRpb24gb2YgbWFjcm8goWRldl9lcnKiDQogMTQ5OSB8ICBfZGV2X2VycihkZXYsIGRldl9m
bXQoZm10KSwgIyNfX1ZBX0FSR1NfXykNCiAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIF5+fn5+fn5+fn5+DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9k
d21hYy1zb2NmcGdhLmM6MjY0OjQ0OiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBp
cyByZXBvcnRlZCBvbmx5IG9uY2UgZm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbg0KICAy
NjQgfCAgIGRldl9lcnIoZHdtYWMtPmRldiwgImJhZCBwaHkgbW9kZSAlZFxuIiwgcGh5bW9kZSk7
DQogICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+
fn5+DQouL2luY2x1ZGUvbGludXgvZGV2aWNlLmg6MTQ5OTozMjogbm90ZTogaW4gZGVmaW5pdGlv
biBvZiBtYWNybyChZGV2X2VycqINCiAxNDk5IHwgIF9kZXZfZXJyKGRldiwgZGV2X2ZtdChmbXQp
LCAjI19fVkFfQVJHU19fKQ0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xn5+fn5+fn5+fn4NCmRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXNv
Y2ZwZ2EuYzogSW4gZnVuY3Rpb24goXNvY2ZwZ2FfZ2VuMTBfc2V0X3BoeV9tb2RlojoNCmRyaXZl
cnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXNvY2ZwZ2EuYzozNDA6NjogZXJy
b3I6IKFwaHltb2RloiB1bmRlY2xhcmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlvbik7IGRp
ZCB5b3UgbWVhbiChcGh5X21vZGVzoj8NCiAgMzQwIHwgICAgICBwaHltb2RlID09IFBIWV9JTlRF
UkZBQ0VfTU9ERV9NSUkgfHwNCiAgICAgIHwgICAgICBefn5+fn5+DQogICAgICB8ICAgICAgcGh5
X21vZGVzDQo=
