Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1311DFBEC
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388244AbgEWXgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbgEWXgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:36:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7290C061A0E;
        Sat, 23 May 2020 16:36:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67D841286F3B3;
        Sat, 23 May 2020 16:36:23 -0700 (PDT)
Date:   Sat, 23 May 2020 16:36:22 -0700 (PDT)
Message-Id: <20200523.163622.615775239274039260.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, yotam.gi@gmail.com,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH net-next v2] net: psample: fix build error when
 CONFIG_INET is not enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ca2be940-4514-4027-13f9-4e6bd99152ab@infradead.org>
References: <ca2be940-4514-4027-13f9-4e6bd99152ab@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:36:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQpEYXRlOiBGcmksIDIy
IE1heSAyMDIwIDEzOjA1OjI2IC0wNzAwDQoNCj4gRnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFw
QGluZnJhZGVhZC5vcmc+DQo+IA0KPiBGaXggcHNhbXBsZSBidWlsZCBlcnJvciB3aGVuIENPTkZJ
R19JTkVUIGlzIG5vdCBzZXQvZW5hYmxlZCBieQ0KPiBicmFja2V0aW5nIHRoZSB0dW5uZWwgY29k
ZSBpbiAjaWZkZWYgQ09ORklHX05FVCAvICNlbmRpZi4NCj4gDQo+IC4uL25ldC9wc2FtcGxlL3Bz
YW1wbGUuYzogSW4gZnVuY3Rpb24goV9fcHNhbXBsZV9pcF90dW5fdG9fbmxhdHRyojoNCj4gLi4v
bmV0L3BzYW1wbGUvcHNhbXBsZS5jOjIxNjoyNTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9u
IG9mIGZ1bmN0aW9uIKFpcF90dW5uZWxfaW5mb19vcHRzojsgZGlkIHlvdSBtZWFuIKFpcF90dW5u
ZWxfaW5mb19vcHRzX3NldKI/IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9u
XQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5v
cmc+DQo+IENjOiBZb3RhbSBHaWdpIDx5b3RhbS5naUBnbWFpbC5jb20+DQo+IENjOiBDb25nIFdh
bmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbT4NCj4gLS0tDQo+IHYyOiBKdXN0IGJyYWNrZXQg
dGhlIG5ldyB0dW5uZWwgc3VwcG9ydCBjb2RlIGluc2lkZSBpZmRlZi9lbmRpZiAoQ29uZyBXYW5n
KS4NCg0KQXBwbGllZCwgdGhhbmtzIFJhbmR5Lg0K
