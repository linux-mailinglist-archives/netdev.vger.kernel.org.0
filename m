Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1361350F33
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfFXOxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:53:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFXOxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:53:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42B3F15042E9E;
        Mon, 24 Jun 2019 07:53:24 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:53:23 -0700 (PDT)
Message-Id: <20190624.075323.2257534731180163594.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH v2 net-next 0/4] cxgb4: Reference count MPS TCAM
 entries within a PF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624.075132.2137301224911651949.davem@davemloft.net>
References: <20190624085037.2358-1-rajur@chelsio.com>
        <20190624.075132.2137301224911651949.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:53:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogTW9uLCAyNCBK
dW4gMjAxOSAwNzo1MTozMiAtMDcwMCAoUERUKQ0KDQo+IEZyb206IFJhanUgUmFuZ29qdSA8cmFq
dXJAY2hlbHNpby5jb20+DQo+IERhdGU6IE1vbiwgMjQgSnVuIDIwMTkgMTQ6MjA6MzMgKzA1MzAN
Cj4gDQo+PiBGaXJtd2FyZSByZWZlcmVuY2UgY291bnRzIHRoZSBNUFMgVENBTSBlbnRyaWVzIGJ5
IFBGIGFuZCBWRiwNCj4+IGJ1dCBpdCBkb2VzIG5vdCBkbyBpdCBmb3IgdXNhZ2Ugd2l0aGluIGEg
UEYgb3IgVkYuIFRoaXMgcGF0Y2gNCj4+IGFkZHMgdGhlIHN1cHBvcnQgdG8gdHJhY2sgTVBTIFRD
QU0gZW50cmllcyB3aXRoaW4gYSBQRi4NCj4+IA0KPj4gdjEtPnYyOg0KPj4gIFVzZSByZWZjb3Vu
dF90IHR5cGUgaW5zdGVhZCBvZiBhdG9taWNfdCBmb3IgbXBzIHJlZmVyZW5jZSBjb3VudA0KPiAN
Cj4gU2VyaWVzIGFwcGxpZWQsIHRoYW5rcy4NCg0KVW1tLCBSRUFMTFk/IT8hPyENCg0KZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2hlbHNpby9jeGdiNC9jeGdiNF9tcHMuYzogSW4gZnVuY3Rpb24goWN4
Z2I0X21wc19yZWZfZGVjX2J5X21hY6I6DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9jaGVsc2lvL2N4
Z2I0L2N4Z2I0X21wcy5jOjE3OjI5OiBlcnJvcjogcGFzc2luZyBhcmd1bWVudCAxIG9mIKFhdG9t
aWNfZGVjX2FuZF90ZXN0oiBmcm9tIGluY29tcGF0aWJsZSBwb2ludGVyIHR5cGUgWy1XZXJyb3I9
aW5jb21wYXRpYmxlLXBvaW50ZXItdHlwZXNdDQogICAgaWYgKCFhdG9taWNfZGVjX2FuZF90ZXN0
KCZtcHNfZW50cnktPnJlZmNudCkpIHsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+
fn5+fn5+fn5+fn5+fn5+DQoNCllvdSBqdXN0IGNoYW5nZWQgaXQgdG8gYSByZWZjb3VudF90IGFu
ZCBkaWRuJ3QgdHJ5IGNvbXBpbGluZyB0aGUNCnJlc3VsdD8NCg0KVGhlIHdob2xlIHBvaW50IG9m
IHJlZmNvdW50X3QgaXMgdGhhdCBpdCB1c2VzIGEgZGlmZmVyZW50IHNldCBvZg0KaW50ZXJmYWNl
cyB0byBtYW5pcHVsYXRlIHRoZSBvYmplY3QgYW5kIHlvdSBoYXZlIHRvIHRoZXJlZm9yZQ0KdXBk
YXRlIGFsbCB0aGUgY2FsbCBzaXRlcyBwcm9wZXJseS4NCg0KUmV2ZXJ0ZWQuLi4NCg==
