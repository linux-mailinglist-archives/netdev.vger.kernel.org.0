Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C627F170D7D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgB0Awl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:52:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35570 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgB0Awk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 19:52:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 019E115ADF491;
        Wed, 26 Feb 2020 16:52:39 -0800 (PST)
Date:   Wed, 26 Feb 2020 16:52:39 -0800 (PST)
Message-Id: <20200226.165239.940350760077316036.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, ayal@mellanox.com,
        saeedm@mellanox.com, ranro@mellanox.com, moshe@mellanox.com
Subject: Re: [patch net] mlx5: register lag notifier for init network
 namespace only
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226.165048.2228405992426450518.davem@davemloft.net>
References: <20200225092546.30710-1-jiri@resnulli.us>
        <20200226.165048.2228405992426450518.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 16:52:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogV2VkLCAyNiBG
ZWIgMjAyMCAxNjo1MDo0OCAtMDgwMCAoUFNUKQ0KDQo+IEZyb206IEppcmkgUGlya28gPGppcmlA
cmVzbnVsbGkudXM+DQo+IERhdGU6IFR1ZSwgMjUgRmViIDIwMjAgMTA6MjU6NDYgKzAxMDANCj4g
DQo+PiBGcm9tOiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4+IA0KPj4gVGhlIGN1
cnJlbnQgY29kZSBjYXVzZXMgcHJvYmxlbXMgd2hlbiB0aGUgdW5yZWdpc3RlcmluZyBuZXRkZXZp
Y2UgY291bGQNCj4+IGJlIGRpZmZlcmVudCB0aGVuIHRoZSByZWdpc3RlcmluZyBvbmUuDQo+PiAN
Cj4+IFNpbmNlIHRoZSBjaGVjayBpbiBtbHg1X2xhZ19uZXRkZXZfZXZlbnQoKSBkb2VzIG5vdCBh
bGxvdyBhbnkgb3RoZXINCj4+IG5ldHdvcmsgbmFtZXNwYWNlIGFueXdheSwgZml4IHRoaXMgYnkg
cmVnaXN0ZXJ0aW5nIHRoZSBsYWcgbm90aWZpZXINCj4+IHBlciBpbml0IG5ldHdvcmsgbmFtZXNw
YWNlIG9ubHkuDQo+PiANCj4+IEZpeGVzOiBkNDg4MzRmOWQ0YjQgKCJtbHg1OiBVc2UgZGV2X25l
dCBuZXRkZXZpY2Ugbm90aWZpZXIgcmVnaXN0cmF0aW9ucyIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBK
aXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4+IFRlc3RlZC1ieTogQXlhIExldmluIDxh
eWFsQG1lbGxhbm94LmNvbT4NCj4gDQo+IEFwcGxpZWQsIHRoYW5rIHlvdS4NCg0KQWN0dWFsbHks
IHlvdSBuZWVkIHRvIHJlc3BpbiB0aGlzIGFuZCBmaXggdGhlIGZvbGxvd2luZyB3YXJuaW5nOg0K
DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmM6IEluIGZ1
bmN0aW9uIKFtbHg1ZV91cGxpbmtfcmVwX2Rpc2FibGWiOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jOjE4NjQ6MjE6IHdhcm5pbmc6IHVudXNlZCB2YXJp
YWJsZSChbmV0ZGV2oiBbLVd1bnVzZWQtdmFyaWFibGVdDQogIHN0cnVjdCBuZXRfZGV2aWNlICpu
ZXRkZXYgPSBwcml2LT5uZXRkZXY7DQogICAgICAgICAgICAgICAgICAgICBefn5+fn4NCg0KWW91
IGNhbiByZXRhaW4gU2FlZWQncyBBQ0sgd2hlbiB5b3UgZG8gdGhpcy4NCg0KVGhhbmsgeW91Lg0K
