Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7402647216
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfFOUgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:36:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOUgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:36:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDB6A14EB862F;
        Sat, 15 Jun 2019 13:36:48 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:36:48 -0700 (PDT)
Message-Id: <20190615.133648.604999451957743947.davem@davemloft.net>
To:     18oliveira.charles@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rodrigosiqueiramelo@gmail.com
Subject: Re: [PATCH] net: ipva: fix uninitialized variable warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613172841.s4ig3p53wpd2z3nb@debie>
References: <20190613172841.s4ig3p53wpd2z3nb@debie>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:36:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hhcmxlcyA8MThvbGl2ZWlyYS5jaGFybGVzQGdtYWlsLmNvbT4NCkRhdGU6IFRodSwg
MTMgSnVuIDIwMTkgMTQ6Mjg6NDEgLTAzMDANCg0KPiBBdm9pZCBmb2xsb3dpbmcgY29tcGlsZXIg
d2FybmluZyBvbiB1bmluaXRpYWxpemVkIHZhcmlhYmxlDQo+IA0KPiBuZXQvaXB2NC9maWJfc2Vt
YW50aWNzLmM6IEluIGZ1bmN0aW9uIKFmaWJfY2hlY2tfbmhfdjRfZ3eiOg0KPiBuZXQvaXB2NC9m
aWJfc2VtYW50aWNzLmM6MTAyMzoxMjogd2FybmluZzogoWVycqIgbWF5IGJlIHVzZWQNCj4gdW5p
bml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRdDQo+ICAg
IGlmICghdGJsIHx8IGVycikgew0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hhcmxlcyBPbGl2ZWly
YSA8MThvbGl2ZWlyYS5jaGFybGVzQGdtYWlsLmNvbT4NCg0KVGhpcyBpcyBhbHJlYWR5IGZpeGVk
IGluIHRoZSAnbmV0JyBHSVQgdHJlZSwgcGxlYXNlIGFsd2F5cyBzdWJtaXQgbmV0d29ya2luZw0K
cGF0Y2hlcyBhZ2FpbnN0IHRoZSBhcHByb3ByaWF0ZSB0cmVlLg0KDQpUaGFuayB5b3UuDQo=
