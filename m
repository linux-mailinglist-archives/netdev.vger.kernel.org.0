Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC171C6098
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgEETAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbgEETAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:00:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC48C061A0F;
        Tue,  5 May 2020 12:00:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D183127FBFCF;
        Tue,  5 May 2020 12:00:50 -0700 (PDT)
Date:   Tue, 05 May 2020 12:00:49 -0700 (PDT)
Message-Id: <20200505.120049.635223866062154775.davem@davemloft.net>
To:     sjpark@amazon.com
Cc:     viro@zeniv.linux.org.uk, kuba@kernel.org,
        gregkh@linuxfoundation.org, edumazet@google.com,
        sj38.park@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sjpark@amazon.de
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505.114825.1476000329624313198.davem@davemloft.net>
References: <20200505081035.7436-1-sjpark@amazon.com>
        <20200505.114825.1476000329624313198.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 12:00:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVHVlLCAwNSBN
YXkgMjAyMCAxMTo0ODoyNSAtMDcwMCAoUERUKQ0KDQo+IFNlcmllcyBhcHBsaWVkIGFuZCBxdWV1
ZWQgdXAgZm9yIC1zdGFibGUsIHRoYW5rcy4NCg0KTmV2ZXJtaW5kLCB0aGlzIGRvZXNuJ3QgZXZl
biBjb21waWxlLg0KDQpuZXQvc21jL2FmX3NtYy5jOiBJbiBmdW5jdGlvbiChc21jX3N3aXRjaF90
b19mYWxsYmFja6I6DQpuZXQvc21jL2FmX3NtYy5jOjQ3MzoxOTogZXJyb3I6IKFzbWMtPmNsY3Nv
Y2stPndxoiBpcyBhIHBvaW50ZXI7IGRpZCB5b3UgbWVhbiB0byB1c2UgoS0+oj8NCiAgNDczIHwg
ICBzbWMtPmNsY3NvY2stPndxLmZhc3luY19saXN0ID0NCiAgICAgIHwgICAgICAgICAgICAgICAg
ICAgXg0KICAgICAgfCAgICAgICAgICAgICAgICAgICAtPg0KbmV0L3NtYy9hZl9zbWMuYzo0NzQ6
MjU6IGVycm9yOiChc21jLT5zay5za19zb2NrZXQtPndxoiBpcyBhIHBvaW50ZXI7IGRpZCB5b3Ug
bWVhbiB0byB1c2UgoS0+oj8NCiAgNDc0IHwgICAgc21jLT5zay5za19zb2NrZXQtPndxLmZhc3lu
Y19saXN0Ow0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICBeDQogICAgICB8ICAgICAg
ICAgICAgICAgICAgICAgICAgIC0+DQoNClNvIEkgaGFkIHRvIHJldmVydCB0aGVzZSBjaGFuZ2Vz
Lg0KDQpXaGVuIHlvdSBtYWtlIGEgY2hhbmdlIG9mIHRoaXMgbWFnbml0dWRlIGFuZCBzY29wZSB5
b3UgbXVzdCBkbyBhbg0KYWxsbW9kY29uZmlnIGJ1aWxkLg0KDQpUaGFuayB5b3UuDQo=
