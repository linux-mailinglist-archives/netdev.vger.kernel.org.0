Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9839CDB5CF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438401AbfJQSU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:20:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403968AbfJQSU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:20:56 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41A141400F693;
        Thu, 17 Oct 2019 11:20:56 -0700 (PDT)
Date:   Thu, 17 Oct 2019 14:20:55 -0400 (EDT)
Message-Id: <20191017.142055.130965767343659716.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH] usb: hso: obey DMA rules in tiocmget
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017.141955.1615614075310331285.davem@davemloft.net>
References: <20191017095339.25034-1-oneukum@suse.com>
        <20191017.141955.1615614075310331285.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 11:20:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAxNyBP
Y3QgMjAxOSAxNDoxOTo1NSAtMDQwMCAoRURUKQ0KDQo+IEZyb206IE9saXZlciBOZXVrdW0gPG9u
ZXVrdW1Ac3VzZS5jb20+DQo+IERhdGU6IFRodSwgMTcgT2N0IDIwMTkgMTE6NTM6MzggKzAyMDAN
Cj4gDQo+PiBUaGUgc2VyaWFsIHN0YXRlIGluZm9ybWF0aW9uIG11c3Qgbm90IGJlIGVtYmVkZGVk
IGludG8gYW5vdGhlcg0KPj4gZGF0YSBzdHJ1Y3R1cmUsIGFzIHRoaXMgaW50ZXJmZXJlcyB3aXRo
IGNhY2hlIGhhbmRsaW5nIGZvciBETUENCj4+IG9uIGFyY2hpdGVjdHVyZXMgd2l0aG91dCBjYWNo
ZSBjb2hlcmVuY2UuLg0KPj4gVGhhdCB3b3VsZCByZXN1bHQgaW4gZGF0YSBjb3JydXB0aW9uIG9u
IHNvbWUgYXJjaGl0ZWN0dXJlcw0KPj4gQWxsb2NhdGluZyBpdCBzZXBhcmF0ZWx5Lg0KPj4gDQo+
PiBTaWduZWQtb2ZmLWJ5OiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPg0KPiANCj4g
QXBwbGllZCwgdGhhbmtzIE9saXZlci4NCg0KVWdoLCBPbGl2ZXIgZGlkIHlvdSBldmVuIGJ1aWxk
IHRlc3QgdGhpcz8NCg0KZHJpdmVycy9uZXQvdXNiL2hzby5jOjE4OTo5OiBlcnJvcjogZXhwZWN0
ZWQgoXuiIGJlZm9yZSChKqIgdG9rZW4NCiAgMTg5IHwgIHN0cnVjdCAqaHNvX3NlcmlhbF9zdGF0
ZV9ub3RpZmljYXRpb24gc2VyaWFsX3N0YXRlX25vdGlmaWNhdGlvbjsNCg0KU2VyaW91c2x5LCBJ
IGV4cGVjdCBiZXR0ZXIgZnJvbSBhbiBleHBlcmllbmNlZCBkZXZlbG9wZXIgc3VjaCBhcw0KeW91
cnNlbGYuDQo=
