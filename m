Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470F82581DE
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgHaThL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgHaThK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:37:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA38C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:37:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39002128967D1;
        Mon, 31 Aug 2020 12:20:24 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:37:10 -0700 (PDT)
Message-Id: <20200831.123710.140170643696361053.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 0/2 v3 net-next] 8390: core cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831.123621.1837178929086250340.davem@davemloft.net>
References: <20200829111701.GA9219@mx-linux-amd>
        <20200831.123621.1837178929086250340.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:20:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogTW9uLCAzMSBB
dWcgMjAyMCAxMjozNjoyMSAtMDcwMCAoUERUKQ0KDQo+IEZyb206IEFybWluIFdvbGYgPFdfQXJt
aW5AZ214LmRlPg0KPiBEYXRlOiBTYXQsIDI5IEF1ZyAyMDIwIDEzOjE3OjMyICswMjAwDQo+IA0K
Pj4gVGhlIHB1cnBvc2Ugb2YgdGhpcyBwYXRjaHNldCBpcyB0byBkbyBzb21lDQo+PiBjbGVhbnVw
cyBpbiBsaWI4MzkwLmMgYW5kIDgzOTAuYy4NCj4+IA0KPj4gV2hpbGUgbW9zdCBjaGFuZ2VzIGFy
ZSBjb2Rpbmctc3R5bGUgcmVsYXRlZCwNCj4+IHByX2NvbnQoKSB1c2FnZSBpbiBsaWI4MzkwLmMg
d2FzIHJlcGxhY2VkIGJ5DQo+PiBhIG1vcmUgU01QLXNhZmUgY29uc3RydWN0Lg0KPj4gDQo+PiBP
dGhlciBmdW5jdGlvbmFsIGNoYW5nZXMgaW5jbHVkZSB0aGUgcmVtb3ZhbCBvZg0KPj4gdmVyc2lv
bi1wcmludGluZyBpbiBsaWI4MzkwLmMgc28gbW9kdWxlcyB1c2luZyBsaWI4MzkwLmMNCj4+IGRv
IG5vdCBuZWVkIGEgZ2xvYmFsIHZlcnNpb24tc3RyaW5nIGluIG9yZGVyIHRvIGNvbXBpbGUNCj4+
IHN1Y2Nlc3NmdWxseS4NCj4+IA0KPj4gUGF0Y2hlcyBkbyBjb21waWxlIGFuZCBydW4gZmxhd2xl
c3Mgb24gNS45LjAtcmMxIHdpdGgNCj4+IGEgUlRMODAyOUFTIG5pYyB1c2luZyBuZTJrLXBjaS4N
Cj4gIC4uLg0KPiANCj4gU2VyaWVzIGFwcGxpZWQgdG8gbmV0LW5leHQuDQoNCkFjdHVhbGx5IHJl
dmVydGVkLCB0aGlzIGFkZHMgYSBuZXcgYnVpbGQgd2FybmluZzoNCg0KZHJpdmVycy9uZXQvZXRo
ZXJuZXQvODM5MC9heDg4Nzk2LmM6NTg6MjI6IHdhcm5pbmc6IKF2ZXJzaW9uoiBkZWZpbmVkIGJ1
dCBub3QgdXNlZCBbLVd1bnVzZWQtdmFyaWFibGVdDQogICA1OCB8IHN0YXRpYyB1bnNpZ25lZCBj
aGFyIHZlcnNpb25bXSA9ICJheDg4Nzk2LmM6IENvcHlyaWdodCAyMDA1LDIwMDcgU2ltdGVjIEVs
ZWN0cm9uaWNzXG4iOw0KICAgICAgfCAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+DQogIEMt
YyBDLWNtYWtlWzJdOiAqKiogRGVsZXRpbmcgZmlsZSAnbmV0L3N1bnJwYy9hdXRoLm8nDQo=
