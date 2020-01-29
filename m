Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C9814C83B
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 10:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgA2Jk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 04:40:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2Jk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 04:40:58 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CE1315BFFC2E;
        Wed, 29 Jan 2020 01:40:56 -0800 (PST)
Date:   Wed, 29 Jan 2020 10:40:52 +0100 (CET)
Message-Id: <20200129.104052.577025513894647835.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     rdunlap@infradead.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net
Subject: [PATCH] mptcp: Fix build with PROC_FS disabled.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 01:40:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpuZXQvbXB0Y3Avc3ViZmxvdy5jOiBJbiBmdW5jdGlvbiChbXB0Y3Bfc3ViZmxvd19jcmVhdGVf
c29ja2V0ojoNCm5ldC9tcHRjcC9zdWJmbG93LmM6NjI0OjI1OiBlcnJvcjogoXN0cnVjdCBuZXRu
c19jb3JloiBoYXMgbm8gbWVtYmVyIG5hbWVkIKFzb2NrX2ludXNlog0KDQpSZXBvcnRlZC1ieTog
UmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQpTaWduZWQtb2ZmLWJ5OiBEYXZp
ZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQotLS0NCg0KQXBwbGllZCB0byAnbmV0
Jy4NCg0KIG5ldC9tcHRjcC9zdWJmbG93LmMgfCAyICsrDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L21wdGNwL3N1YmZsb3cuYyBiL25ldC9tcHRj
cC9zdWJmbG93LmMNCmluZGV4IDE2NjJlMTE3ODk0OS4uMjA1ZGNhMWMzMGI3IDEwMDY0NA0KLS0t
IGEvbmV0L21wdGNwL3N1YmZsb3cuYw0KKysrIGIvbmV0L21wdGNwL3N1YmZsb3cuYw0KQEAgLTYy
MSw3ICs2MjEsOSBAQCBpbnQgbXB0Y3Bfc3ViZmxvd19jcmVhdGVfc29ja2V0KHN0cnVjdCBzb2Nr
ICpzaywgc3RydWN0IHNvY2tldCAqKm5ld19zb2NrKQ0KIAkgKi8NCiAJc2YtPnNrLT5za19uZXRf
cmVmY250ID0gMTsNCiAJZ2V0X25ldChuZXQpOw0KKyNpZmRlZiBDT05GSUdfUFJPQ19GUw0KIAl0
aGlzX2NwdV9hZGQoKm5ldC0+Y29yZS5zb2NrX2ludXNlLCAxKTsNCisjZW5kaWYNCiAJZXJyID0g
dGNwX3NldF91bHAoc2YtPnNrLCAibXB0Y3AiKTsNCiAJcmVsZWFzZV9zb2NrKHNmLT5zayk7DQog
DQotLSANCjIuMjEuMQ0KDQo=
