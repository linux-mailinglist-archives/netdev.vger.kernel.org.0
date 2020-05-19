Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B991DA4A8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgESWkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgESWkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:40:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609C2C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:40:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6863E128EDAD5;
        Tue, 19 May 2020 15:40:20 -0700 (PDT)
Date:   Tue, 19 May 2020 15:40:19 -0700 (PDT)
Message-Id: <20200519.154019.1247104207621510920.davem@davemloft.net>
To:     a@unstable.cc
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net, toke@toke.dk,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org
Subject: Re: [PATCH] net/sch_generic.h: use sizeof_member() and get rid of
 unused variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519091333.20923-1-a@unstable.cc>
References: <20200519091333.20923-1-a@unstable.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:40:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW50b25pbyBRdWFydHVsbGkgPGFAdW5zdGFibGUuY2M+DQpEYXRlOiBUdWUsIDE5IE1h
eSAyMDIwIDExOjEzOjMzICswMjAwDQoNCj4gQ29tcGlsaW5nIHdpdGggLVd1bnVzZWQgdHJpZ2dl
cnMgdGhlIGZvbGxvd2luZyB3YXJuaW5nOg0KPiANCj4gLi9pbmNsdWRlL25ldC9zY2hfZ2VuZXJp
Yy5oOiBJbiBmdW5jdGlvbiChcWRpc2NfY2JfcHJpdmF0ZV92YWxpZGF0ZaI6DQo+IC4vaW5jbHVk
ZS9uZXQvc2NoX2dlbmVyaWMuaDo0NjQ6MjM6IHdhcm5pbmc6IHVudXNlZCB2YXJpYWJsZSChcWNi
oiBbLVd1bnVzZWQtdmFyaWFibGVdDQo+ICAgNDY0IHwgIHN0cnVjdCBxZGlzY19za2JfY2IgKnFj
YjsNCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgXn5+DQo+IA0KPiBhcyB0aGUgcWNi
IHZhcmlhYmxlIGlzIG9ubHkgdXNlZCB0byBjb21wdXRlIHRoZSBzaXplb2Ygb25lIG9mIGl0cyBt
ZW1iZXJzLg0KDQpJdCdzIHJlZmVyZW5jZWQgaW4gdGhlIGNvZGUsIHRoZXJlZm9yZSBpdCBpcyBu
b3QgInVudXNlZCIuDQoNCklmIGluIHNvbWUgY29uZmlndXJhdGlvbiBCVUlMRF9CVUdfT04oKSBk
b2VzIG5vdCByZWZlcmVuY2UgaXQncyBhcmd1bWVudHMsDQp0aGF0J3MgdGhlIGJ1ZyB0aGF0IG5l
ZWRzIHRvIGJlIGZpeGVkLg0K
