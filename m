Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C597B4CF
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfG3VKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:10:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55370 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfG3VKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:10:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 891191481C4CD;
        Tue, 30 Jul 2019 14:10:46 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:10:44 -0700 (PDT)
Message-Id: <20190730.141044.1176464821256858329.davem@davemloft.net>
To:     kirjanov@gmail.com
Cc:     kda@linux-powerpc.org, petkan@nucleusys.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: fix improper read if
 get_registers() fail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHj3AVm2EZB7n9UBxiBmA+6XN+EgAC_FRoHjh6kO3WMT8KVd6g@mail.gmail.com>
References: <20190730131357.30697-1-dkirjanov@suse.com>
        <20190730.102434.1438984182304969810.davem@davemloft.net>
        <CAHj3AVm2EZB7n9UBxiBmA+6XN+EgAC_FRoHjh6kO3WMT8KVd6g@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 14:10:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGVuaXMgS2lyamFub3YgPGtpcmphbm92QGdtYWlsLmNvbT4NCkRhdGU6IFR1ZSwgMzAg
SnVsIDIwMTkgMjE6MTk6NDYgKzAzMDANCg0KPiBPbiBUdWVzZGF5LCBKdWx5IDMwLCAyMDE5LCBE
YXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+IHdyb3RlOg0KPiANCj4+IEZyb206IERl
bmlzIEtpcmphbm92IDxrZGFAbGludXgtcG93ZXJwYy5vcmc+DQo+PiBEYXRlOiBUdWUsIDMwIEp1
bCAyMDE5IDE1OjEzOjU3ICswMjAwDQo+Pg0KPj4gPiBnZXRfcmVnaXN0ZXJzKCkgbWF5IGZhaWwg
d2l0aCAtRU5PTUVNIGFuZCBpbiB0aGlzDQo+PiA+IGNhc2Ugd2UgY2FuIHJlYWQgYSBnYXJiYWdl
IGZyb20gdGhlIHN0YXR1cyB2YXJpYWJsZSB0bXAuDQo+PiA+DQo+PiA+IFJlcG9ydGVkLWJ5OiBz
eXpib3QrMzQ5OWE4M2IyZDA2MmFlNDA5ZDRAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0KPj4g
PiBTaWduZWQtb2ZmLWJ5OiBEZW5pcyBLaXJqYW5vdiA8a2RhQGxpbnV4LXBvd2VycGMub3JnPg0K
Pj4NCj4+IFdoeSBkaWQgeW91IHBvc3QgdGhpcyBwYXRjaCB0d2ljZT8gIFdoYXQgaXMgZGlmZmVy
ZW50IGJldHdlZW4gdGhlIHR3bw0KPj4gdmVyc2lvbnM/DQo+IA0KPiANCj4gTG9va3MgbGlrZSBp
dKJzIHRoZSBpc3N1ZSB3aXRoIGdpdCBzZW5kLWVtYWlsIDovDQo+IERvIHlvdSB3YW50IG1lIHRv
IGZpZ3VyZSBvdXQgdGhlIHJlYXNvbiBhbmQgcmVzZW5kPw0KDQpObyBuZWVkLCBJIHdhcyBqdXN0
IGN1cmlvdXMuDQo=
