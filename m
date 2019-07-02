Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626A95D6A1
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfGBTJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:09:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGBTJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:09:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C045F13AEC9F2;
        Tue,  2 Jul 2019 12:09:45 -0700 (PDT)
Date:   Tue, 02 Jul 2019 12:09:45 -0700 (PDT)
Message-Id: <20190702.120945.2105185642385395522.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, geert@linux-m68k.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: Fix uninitialized error code in
 rxrpc_send_data_packet()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156207932870.853.14700731055154895417.stgit@warthog.procyon.org.uk>
References: <156207932870.853.14700731055154895417.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 12:09:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgSG93ZWxscyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4NCkRhdGU6IFR1ZSwgMDIg
SnVsIDIwMTkgMTU6NTU6MjggKzAxMDANCg0KPiBXaXRoIGdjYyA0LjE6DQo+IA0KPiAgICAgbmV0
L3J4cnBjL291dHB1dC5jOiBJbiBmdW5jdGlvbiChcnhycGNfc2VuZF9kYXRhX3BhY2tldKI6DQo+
ICAgICBuZXQvcnhycGMvb3V0cHV0LmM6MzM4OiB3YXJuaW5nOiChcmV0oiBtYXkgYmUgdXNlZCB1
bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rpb24NCj4gDQo+IEluZGVlZCwgaWYgdGhlIGZpcnN0
IGp1bXAgdG8gdGhlIHNlbmRfZnJhZ21lbnRhYmxlIGxhYmVsIGlzIG1hZGUsIGFuZA0KPiB0aGUg
YWRkcmVzcyBmYW1pbHkgaXMgbm90IGhhbmRsZWQgaW4gdGhlIHN3aXRjaCgpIHN0YXRlbWVudCwg
cmV0IHdpbGwgYmUNCj4gdXNlZCB1bmluaXRpYWxpemVkLg0KPiANCj4gRml4IHRoaXMgYnkgQlVH
KCknaW5nIGFzIGlzIGRvbmUgaW4gb3RoZXIgcGxhY2VzIGluIHJ4cnBjIHdoZXJlIGludGVybmFs
DQo+IHN1cHBvcnQgZm9yIGZ1dHVyZSBhZGRyZXNzIGZhbWlsaWVzIHdpbGwgbmVlZCBhZGRpbmcu
ICBJdCBzaG91bGQgbm90IGJlDQo+IHBvc3NpYmxlIHRvIHJlYWNoIHRoaXMgbm9ybWFsbHkgYXMg
dGhlIGFkZHJlc3MgZmFtaWxpZXMgYXJlIGNoZWNrZWQNCj4gdXAtZnJvbnQuDQo+IA0KPiBGaXhl
czogNWE5MjRiODk1MWY4MzViNSAoInJ4cnBjOiBEb24ndCBzdG9yZSB0aGUgcnhycGMgaGVhZGVy
IGluIHRoZSBUeCBxdWV1ZSBza19idWZmcyIpDQo+IFJlcG9ydGVkLWJ5OiBHZWVydCBVeXR0ZXJo
b2V2ZW4gPGdlZXJ0QGxpbnV4LW02OGsub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBIb3dl
bGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPg0KDQpBcHBsaWVkLCB0aGFua3MgRGF2aWQuDQo=
