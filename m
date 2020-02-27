Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41E5170ED3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgB0DGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:06:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgB0DGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 22:06:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B28C15B36A32;
        Wed, 26 Feb 2020 19:06:47 -0800 (PST)
Date:   Wed, 26 Feb 2020 19:06:44 -0800 (PST)
Message-Id: <20200226.190644.1695114419188031888.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     christian.brauner@ubuntu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 0/9] net: fix sysfs permssions when device changes
 network
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226.173750.2149877624295674225.davem@davemloft.net>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
        <20200226081757.GF24447@kroah.com>
        <20200226.173750.2149877624295674225.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 19:06:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogV2VkLCAyNiBG
ZWIgMjAyMCAxNzozNzo1MCAtMDgwMCAoUFNUKQ0KDQo+IEZyb206IEdyZWcgS3JvYWgtSGFydG1h
biA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IERhdGU6IFdlZCwgMjYgRmViIDIwMjAg
MDk6MTc6NTcgKzAxMDANCj4gDQo+PiBPbiBUdWUsIEZlYiAyNSwgMjAyMCBhdCAwMjoxOToyOVBN
ICswMTAwLCBDaHJpc3RpYW4gQnJhdW5lciB3cm90ZToNCj4+PiBIZXkgZXZlcnlvbmUsDQo+Pj4g
DQo+Pj4gLyogdjYgKi8NCj4+PiBUaGlzIGlzIHY2IHdpdGggdHdvIHNtYWxsIGZpeHVwcy4gSSBt
aXNzZWQgYWRhcHRpbmcgdGhlIGNvbW1pdCBtZXNzYWdlDQo+Pj4gdG8gcmVmbGVjdCB0aGUgcmVu
YW1lZCBoZWxwZXIgZm9yIGNoYW5naW5nIHRoZSBvd25lciBvZiBzeXNmcyBmaWxlcyBhbmQNCj4+
PiBJIGFsc28gZm9yZ290IHRvIG1ha2UgdGhlIG5ldyBkcG0gaGVscGVyIHN0YXRpYyBpbmxpbmUu
DQo+PiANCj4+IEFsbCBvZiB0aGUgc3lzZnMgYW5kIGRyaXZlciBjb3JlIGJpdHMgbG9vayBnb29k
IHRvIG1lIG5vdy4gIFRoYW5rcyBmb3INCj4+IHRha2luZyB0aGUgdGltZSB0byB1cGRhdGUgdGhl
IGRvY3VtZW50YXRpb24gYW5kIG90aGVyIGJpdHMgYmFzZWQgb24NCj4+IHJldmlld3MuDQo+PiAN
Cj4+IFNvIG5vdyBpdCdzIGp1c3QgdXAgdG8gdGhlIG5ldGRldiBkZXZlbG9wZXJzIHRvIHJldmll
dyB0aGUgbmV0ZGV2IHBhcnRzIDopDQo+PiANCj4+IFRoZSBzeXNmcyBhbmQgZHJpdmVyIGNvcmUg
cGF0Y2hlcyBjYW4gYWxsIGdvIHRocm91Z2ggdGhlIG5ldGRldiB0cmVlIHRvDQo+PiBtYWtlIGl0
IGVhc2llciBmb3IgeW91Lg0KPiANCj4gSSdtIGZpbmUgd2l0aCB0aGVzZSBjaGFuZ2VzLCBhbmQg
d2lsbCBhcHBseSB0aGlzIHNlcmllcyB0byBuZXQtbmV4dC4NCg0KQWN0dWFsbHksIHlvdSdsbCBu
ZWVkIHRvIHJlc3BpbiB0aGlzIHdpdGggdGhlc2Ugd2FybmluZ3MgZml4ZWQsIHRoYW5rczoNCg0K
ZnMvc3lzZnMvZ3JvdXAuYzogSW4gZnVuY3Rpb24goXN5c2ZzX2dyb3VwX2NoYW5nZV9vd25lcqI6
DQpmcy9zeXNmcy9ncm91cC5jOjUxNzo5OiB3YXJuaW5nOiB1bnVzZWQgdmFyaWFibGUgoWdpZKIg
Wy1XdW51c2VkLXZhcmlhYmxlXQ0KICBrZ2lkX3QgZ2lkOw0KICAgICAgICAgXn5+DQpmcy9zeXNm
cy9ncm91cC5jOjUxNjo5OiB3YXJuaW5nOiB1bnVzZWQgdmFyaWFibGUgoXVpZKIgWy1XdW51c2Vk
LXZhcmlhYmxlXQ0KICBrdWlkX3QgdWlkOw0KICAgICAgICAgXn5+DQo=
