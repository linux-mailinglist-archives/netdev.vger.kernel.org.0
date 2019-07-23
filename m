Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E8772173
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392048AbfGWVYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:24:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37004 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731769AbfGWVYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:24:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE123153BFAE5;
        Tue, 23 Jul 2019 14:24:48 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:24:48 -0700 (PDT)
Message-Id: <20190723.142448.414859031558093111.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 05/19] ionic: Add interrupts and doorbells
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722214023.9513-6-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
        <20190722214023.9513-6-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:24:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2hhbm5vbiBOZWxzb24gPHNuZWxzb25AcGVuc2FuZG8uaW8+DQpEYXRlOiBNb24sIDIy
IEp1bCAyMDE5IDE0OjQwOjA5IC0wNzAwDQoNCj4gVGhlIGlvbmljIGludGVycnVwdCBtb2RlbCBp
cyBiYXNlZCBvbiBpbnRlcnJ1cHQgY29udHJvbCBibG9ja3MNCj4gYWNjZXNzZWQgdGhyb3VnaCB0
aGUgUENJIEJBUi4gIERvb3JiZWxsIHJlZ2lzdGVycyBhcmUgdXNlZCBieQ0KPiB0aGUgZHJpdmVy
IHRvIHNpZ25hbCB0byB0aGUgTklDIHRoYXQgcmVxdWVzdHMgYXJlIHdhaXRpbmcgb24NCj4gdGhl
IG1lc3NhZ2UgcXVldWVzLiAgSW50ZXJydXB0cyBhcmUgdXNlZCBieSB0aGUgTklDIHRvIHNpZ25h
bA0KPiB0byB0aGUgZHJpdmVyIHRoYXQgYW5zd2VycyBhcmUgd2FpdGluZyBvbiB0aGUgY29tcGxl
dGlvbiBxdWV1ZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTaGFubm9uIE5lbHNvbiA8c25lbHNv
bkBwZW5zYW5kby5pbz4NCg0KQWZ0ZXIgYXBwbHlpbmcgdGhpcyBwYXRjaCB3ZSBnZXQgYSB3YXJu
aW5nOg0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9wZW5zYW5kby9pb25pYy9pb25pY19saWYuYzoz
MzoxMzogd2FybmluZzogoWlvbmljX2ludHJfZnJlZaIgZGVmaW5lZCBidXQgbm90IHVzZWQgWy1X
dW51c2VkLWZ1bmN0aW9uXQ0KIHN0YXRpYyB2b2lkIGlvbmljX2ludHJfZnJlZShzdHJ1Y3QgbGlm
ICpsaWYsIGludCBpbmRleCkNCiAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4NCmRyaXZlcnMv
bmV0L2V0aGVybmV0L3BlbnNhbmRvL2lvbmljL2lvbmljX2xpZi5jOjE1OjEyOiB3YXJuaW5nOiCh
aW9uaWNfaW50cl9hbGxvY6IgZGVmaW5lZCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9u
XQ0KIHN0YXRpYyBpbnQgaW9uaWNfaW50cl9hbGxvYyhzdHJ1Y3QgbGlmICpsaWYsIHN0cnVjdCBp
bnRyICppbnRyKQ0KICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fg0KDQpBbHNvOg0KDQo+ICsJ
bGlmLT5kYmlkX2ludXNlID0ga3phbGxvYyhCSVRTX1RPX0xPTkdTKGxpZi0+ZGJpZF9jb3VudCkg
KiBzaXplb2YobG9uZyksDQo+ICsJCQkJICBHRlBfS0VSTkVMKTsNCg0KWW91IGNhbiB1c2UgYml0
bWFwX2FsbG9jKCkgYW5kIGZyaWVuZHMgZnJvbSBsaW51eC9iaXRtYXAuaCBmb3IgdGhpcyBraW5k
IG9mIHN0dWZmLg0K
