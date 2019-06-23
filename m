Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CFE4F94F
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 02:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfFWAIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 20:08:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFWAIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 20:08:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDD2D1543566D;
        Sat, 22 Jun 2019 17:08:16 -0700 (PDT)
Date:   Sat, 22 Jun 2019 17:08:16 -0700 (PDT)
Message-Id: <20190622.170816.1879839685931480272.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190622.170712.2073255657139689928.davem@davemloft.net>
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
        <20190622.170712.2073255657139689928.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 17:08:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogU2F0LCAyMiBK
dW4gMjAxOSAxNzowNzoxMiAtMDcwMCAoUERUKQ0KDQo+IEFwcGxpZWQgYW5kIHF1ZXVlZCB1cCBm
b3IgLXN0YWJsZSwgdGhhbmtzLg0KDQpBY3R1YWxseSwgdGhpcyBuZWVkcyBhIHdhcm5pbmcgZml4
IGluIGJsdWV0b290aCBhbmQgbmV0ZmlsdGVyLiAgUGxlYXNlDQpmaXggdGhpcyB1cCwgZG8gYSBw
cm9wZXIgYWxsbW9kY29uZmlnIGJ1aWxkLCBhbmQgcmVzdWJtaXQuDQoNCm5ldC9ibHVldG9vdGgv
Nmxvd3Bhbi5jOiBJbiBmdW5jdGlvbiChcGVlcl9sb29rdXBfZHN0ojoNCm5ldC9ibHVldG9vdGgv
Nmxvd3Bhbi5jOjE4ODoxMTogd2FybmluZzogYXNzaWdubWVudCBkaXNjYXJkcyChY29uc3SiIHF1
YWxpZmllciBmcm9tIHBvaW50ZXIgdGFyZ2V0IHR5cGUgWy1XZGlzY2FyZGVkLXF1YWxpZmllcnNd
DQpuZXQvbmV0ZmlsdGVyL25mX2Zsb3dfdGFibGVfaXAuYzogSW4gZnVuY3Rpb24goW5mX2Zsb3df
b2ZmbG9hZF9pcHY2X2hvb2uiOg0KbmV0L25ldGZpbHRlci9uZl9mbG93X3RhYmxlX2lwLmM6NDgx
OjEwOiB3YXJuaW5nOiBhc3NpZ25tZW50IGRpc2NhcmRzIKFjb25zdKIgcXVhbGlmaWVyIGZyb20g
cG9pbnRlciB0YXJnZXQgdHlwZSBbLVdkaXNjYXJkZWQtcXVhbGlmaWVyc10NCg0KVGhhbmsgeW91
Lg0K
