Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA264B02B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 04:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbfFSCd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 22:33:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSCd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 22:33:58 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AE5214DB3D3F;
        Tue, 18 Jun 2019 19:33:49 -0700 (PDT)
Date:   Tue, 18 Jun 2019 22:33:43 -0400 (EDT)
Message-Id: <20190618.223343.1129504320231308025.davem@davemloft.net>
To:     nhuck@google.com
Cc:     maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: mvpp2: cls: Add pmap to fs dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618160910.62922-1-nhuck@google.com>
References: <20190618083900.78eb88bd@bootlin.com>
        <20190618160910.62922-1-nhuck@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 19:33:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmF0aGFuIEh1Y2tsZWJlcnJ5IDxuaHVja0Bnb29nbGUuY29tPg0KRGF0ZTogVHVlLCAx
OCBKdW4gMjAxOSAwOTowOToxMCAtMDcwMA0KDQo+ICsJZGRlYnVnZnNfY3JlYXRlX2ZpbGUoInBt
YXAiLCAwNDQ0LCBwcnNfZW50cnlfZGlyLCBlbnRyeSwNCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWFydmVsbC9tdnBwMi9tdnBwMl9kZWJ1Z2ZzLmM6IEluIGZ1bmN0aW9uIKFtdnBwMl9kYmdmc19w
cnNfZW50cnlfaW5pdKI6DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212cHAyL212cHAy
X2RlYnVnZnMuYzo1Njk6MjogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9u
IKFkZGVidWdmc19jcmVhdGVfZmlsZaI7IGRpZCB5b3UgbWVhbiChZGVidWdmc19jcmVhdGVfZmls
ZaI/IFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KDQpUaGlzIGRvZXNu
J3QgY29tcGlsZSwgZGlkIHlvdSBidWlsZCB0ZXN0IHRoaXM/DQo=
