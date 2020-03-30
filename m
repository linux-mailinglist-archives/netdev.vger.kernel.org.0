Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8311982B8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgC3RvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:51:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40246 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgC3RvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:51:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C73615C399AA;
        Mon, 30 Mar 2020 10:51:07 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:51:06 -0700 (PDT)
Message-Id: <20200330.105106.136985527934005976.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/26] Netfilter/IPVS updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330.104857.921940685428035705.davem@davemloft.net>
References: <20200330003708.54017-1-pablo@netfilter.org>
        <20200330.104857.921940685428035705.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:51:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogTW9uLCAzMCBN
YXIgMjAyMCAxMDo0ODo1NyAtMDcwMCAoUERUKQ0KDQo+IEZyb206IFBhYmxvIE5laXJhIEF5dXNv
IDxwYWJsb0BuZXRmaWx0ZXIub3JnPg0KPiBEYXRlOiBNb24sIDMwIE1hciAyMDIwIDAyOjM2OjQy
ICswMjAwDQo+IA0KPj4gWW91IGNhbiBwdWxsIHRoZXNlIGNoYW5nZXMgZnJvbToNCj4+IA0KPj4g
ICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcGFibG8vbmYt
bmV4dC5naXQNCj4gDQo+IFB1bGxlZCwgdGhhbmtzLg0KDQpBY3R1YWxseSwgSSBoYWQgdG8gcmV2
ZXJ0LCBwbGVhc2UgZml4IHRoZXNlIHdhcm5pbmdzOg0KDQpuZXQvbmV0ZmlsdGVyL2lwdnMvaXBf
dnNfY29yZS5jOiBJbiBmdW5jdGlvbiChaXBfdnNfaW5faWNtcKI6DQouL2luY2x1ZGUvbmV0L2lw
X3ZzLmg6MjMzOjQ6IHdhcm5pbmc6IKFvdXRlcl9wcm90b6IgbWF5IGJlIHVzZWQgdW5pbml0aWFs
aXplZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRdDQogICAgcHJpbnRr
KEtFUk5fREVCVUcgcHJfZm10KG1zZyksICMjX19WQV9BUkdTX18pOyBcDQogICAgXn5+fn5+DQpu
ZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfY29yZS5jOjE2NjY6ODogbm90ZTogoW91dGVyX3Byb3Rv
oiB3YXMgZGVjbGFyZWQgaGVyZQ0KICBjaGFyICpvdXRlcl9wcm90bzsNCiAgICAgICAgXn5+fn5+
fn5+fn4NCg==
