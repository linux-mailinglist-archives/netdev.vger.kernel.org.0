Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C866E88390
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfHIT5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:57:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfHIT5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:57:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D36E12F7A9DD;
        Fri,  9 Aug 2019 12:57:52 -0700 (PDT)
Date:   Fri, 09 Aug 2019 12:57:51 -0700 (PDT)
Message-Id: <20190809.125751.1142334849531721357.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, jiri@resnulli.us, wenxu@ucloud.cn,
        saeedm@mellanox.com, paulb@mellanox.com, gerlitz.or@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH 0/2 net,v4] flow_offload hardware priority fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809.123741.733240603302377585.davem@davemloft.net>
References: <20190806160310.6663-1-pablo@netfilter.org>
        <20190809.123741.733240603302377585.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 12:57:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogRnJpLCAwOSBB
dWcgMjAxOSAxMjozNzo0MSAtMDcwMCAoUERUKQ0KDQo+IEZyb206IFBhYmxvIE5laXJhIEF5dXNv
IDxwYWJsb0BuZXRmaWx0ZXIub3JnPg0KPiBEYXRlOiBUdWUsICA2IEF1ZyAyMDE5IDE4OjAzOjA4
ICswMjAwDQo+IA0KPj4gVGhpcyBwYXRjaHNldCBjb250YWlucyB0d28gdXBkYXRlcyBmb3IgdGhl
IGZsb3dfb2ZmbG9hZCB1c2VyczoNCj4+IA0KPj4gMSkgUGFzcyB0aGUgbWFqb3IgdGMgcHJpb3Jp
dHkgdG8gZHJpdmVycyBzbyB0aGV5IGRvIG5vdCBoYXZlIHRvDQo+PiAgICBsc2hpZnQgaXQuIFRo
aXMgaXMgYSBwcmVwYXJhdGlvbiBwYXRjaCBmb3IgdGhlIGZpeCBjb21pbmcgaW4NCj4+ICAgIHBh
dGNoICMyLg0KPj4gDQo+PiAyKSBTZXQgdGhlIGhhcmR3YXJlIHByaW9yaXR5IGZyb20gdGhlIG5l
dGZpbHRlciBiYXNlY2hhaW4gcHJpb3JpdHksDQo+PiAgICBzb21lIGRyaXZlcnMgYnJlYWsgd2hl
biB1c2luZyB0aGUgZXhpc3RpbmcgaGFyZHdhcmUgcHJpb3JpdHkNCj4+ICAgIG51bWJlciB0aGF0
IGlzIHNldCB0byB6ZXJvLg0KPiANCj4gU2VyaWVzIGFwcGxpZWQuDQoNClNvcnJ5LCBJIGhhZCB0
byByZXZlcnQ6DQoNCltkYXZlbUBsb2NhbGhvc3QgbmV0XSQgbWFrZSAtcyAtajE0DQpJbiBmaWxl
IGluY2x1ZGVkIGZyb20gLi9pbmNsdWRlL2xpbnV4L2xpc3QuaDo5LA0KICAgICAgICAgICAgICAg
ICBmcm9tIC4vaW5jbHVkZS9saW51eC9tb2R1bGUuaDo5LA0KICAgICAgICAgICAgICAgICBmcm9t
IG5ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX29mZmxvYWQuYzozOg0KbmV0L25ldGZpbHRlci9uZl90
YWJsZXNfb2ZmbG9hZC5jOiBJbiBmdW5jdGlvbiChbmZ0X2NoYWluX29mZmxvYWRfcHJpb3JpdHmi
Og0KLi9pbmNsdWRlL2xpbnV4L2tlcm5lbC5oOjI2OToyMzogd2FybmluZzogb3ZlcmZsb3cgaW4g
Y29udmVyc2lvbiBmcm9tIKFzaG9ydCBpbnSiIHRvIKFzaWduZWQgY2hhcqIgY2hhbmdlcyB2YWx1
ZSBmcm9tIKEtMzI3NjiiIHRvIKEwoiBbLVdvdmVyZmxvd10NCiAgKHsgc2lnbmVkIHR5cGUgX194
ID0gKHgpOyBfX3ggPCAwID8gLV9feCA6IF9feDsgfSksIG90aGVyKQ0KICAgICAgICAgICAgICAg
ICAgICAgICBeDQouL2luY2x1ZGUvbGludXgva2VybmVsLmg6MjU2OjE2OiBub3RlOiBpbiBleHBh
bnNpb24gb2YgbWFjcm8goV9fYWJzX2Nob29zZV9leHByog0KICNkZWZpbmUgYWJzKHgpIF9fYWJz
X2Nob29zZV9leHByKHgsIGxvbmcgbG9uZywgICAgXA0KICAgICAgICAgICAgICAgIF5+fn5+fn5+
fn5+fn5+fn5+DQouL2luY2x1ZGUvbGludXgva2VybmVsLmg6MjU3OjM6IG5vdGU6IGluIGV4cGFu
c2lvbiBvZiBtYWNybyChX19hYnNfY2hvb3NlX2V4cHKiDQogICBfX2Fic19jaG9vc2VfZXhwcih4
LCBsb25nLCAgICBcDQogICBefn5+fn5+fn5+fn5+fn5+fg0KLi9pbmNsdWRlL2xpbnV4L2tlcm5l
bC5oOjI1ODozOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8goV9fYWJzX2Nob29zZV9leHBy
og0KICAgX19hYnNfY2hvb3NlX2V4cHIoeCwgaW50LCAgICBcDQogICBefn5+fn5+fn5+fn5+fn5+
fg0KLi9pbmNsdWRlL2xpbnV4L2tlcm5lbC5oOjI1OTozOiBub3RlOiBpbiBleHBhbnNpb24gb2Yg
bWFjcm8goV9fYWJzX2Nob29zZV9leHByog0KICAgX19hYnNfY2hvb3NlX2V4cHIoeCwgc2hvcnQs
ICAgIFwNCiAgIF5+fn5+fn5+fn5+fn5+fn5+DQouL2luY2x1ZGUvbGludXgva2VybmVsLmg6MjYw
OjM6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyChX19hYnNfY2hvb3NlX2V4cHKiDQogICBf
X2Fic19jaG9vc2VfZXhwcih4LCBjaGFyLCAgICBcDQogICBefn5+fn5+fn5+fn5+fn5+fg0KbmV0
L25ldGZpbHRlci9uZl90YWJsZXNfb2ZmbG9hZC5jOjEzNDozNTogbm90ZTogaW4gZXhwYW5zaW9u
IG9mIG1hY3JvIKFhYnOiDQogIHJldHVybiBiYXNlY2hhaW4tPm9wcy5wcmlvcml0eSArIGFicyhT
SFJUX01JTik7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fg0KLi9pbmNs
dWRlL2xpbnV4L2tlcm5lbC5oOjI2MzozMTogd2FybmluZzogb3ZlcmZsb3cgaW4gY29udmVyc2lv
biBmcm9tIKFzaG9ydCBpbnSiIHRvIKFzaWduZWQgY2hhcqIgY2hhbmdlcyB2YWx1ZSBmcm9tIKEt
MzI3NjiiIHRvIKEwoiBbLVdvdmVyZmxvd10NCiAgICAoY2hhcikoeyBzaWduZWQgY2hhciBfX3gg
PSAoeCk7IF9feDwwPy1fX3g6X194OyB9KSwgXA0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF4NCi4vaW5jbHVkZS9saW51eC9rZXJuZWwuaDoyNjk6NTQ6IG5vdGU6IGluIGRlZmluaXRp
b24gb2YgbWFjcm8goV9fYWJzX2Nob29zZV9leHByog0KICAoeyBzaWduZWQgdHlwZSBfX3ggPSAo
eCk7IF9feCA8IDAgPyAtX194IDogX194OyB9KSwgb3RoZXIpDQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fg0KLi9pbmNsdWRlL2xpbnV4
L2tlcm5lbC5oOjI1NzozOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8goV9fYWJzX2Nob29z
ZV9leHByog0KICAgX19hYnNfY2hvb3NlX2V4cHIoeCwgbG9uZywgICAgXA0KICAgXn5+fn5+fn5+
fn5+fn5+fn4NCi4vaW5jbHVkZS9saW51eC9rZXJuZWwuaDoyNTg6Mzogbm90ZTogaW4gZXhwYW5z
aW9uIG9mIG1hY3JvIKFfX2Fic19jaG9vc2VfZXhwcqINCiAgIF9fYWJzX2Nob29zZV9leHByKHgs
IGludCwgICAgXA0KICAgXn5+fn5+fn5+fn5+fn5+fn4NCi4vaW5jbHVkZS9saW51eC9rZXJuZWwu
aDoyNTk6Mzogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIKFfX2Fic19jaG9vc2VfZXhwcqIN
CiAgIF9fYWJzX2Nob29zZV9leHByKHgsIHNob3J0LCAgICBcDQogICBefn5+fn5+fn5+fn5+fn5+
fg0KLi9pbmNsdWRlL2xpbnV4L2tlcm5lbC5oOjI2MDozOiBub3RlOiBpbiBleHBhbnNpb24gb2Yg
bWFjcm8goV9fYWJzX2Nob29zZV9leHByog0KICAgX19hYnNfY2hvb3NlX2V4cHIoeCwgY2hhciwg
ICAgXA0KICAgXn5+fn5+fn5+fn5+fn5+fn4NCm5ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX29mZmxv
YWQuYzoxMzQ6MzU6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyChYWJzog0KICByZXR1cm4g
YmFzZWNoYWluLT5vcHMucHJpb3JpdHkgKyBhYnMoU0hSVF9NSU4pOw0KICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBefn4NCg==
