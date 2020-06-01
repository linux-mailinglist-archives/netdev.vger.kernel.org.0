Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B651EAF52
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgFATB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgFATB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:01:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C4EC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:01:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FDA6120477C4;
        Mon,  1 Jun 2020 12:01:26 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:01:25 -0700 (PDT)
Message-Id: <20200601.120125.700408609849004774.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] cls_flower: remove mpls_opts_policy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4158adb2a6a49cd652f3ad47d59f2a976b6c1d18.1590864517.git.gnault@redhat.com>
References: <4158adb2a6a49cd652f3ad47d59f2a976b6c1d18.1590864517.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:01:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR3VpbGxhdW1lIE5hdWx0IDxnbmF1bHRAcmVkaGF0LmNvbT4NCkRhdGU6IFNhdCwgMzAg
TWF5IDIwMjAgMjA6NDk6NTYgKzAyMDANCg0KPiBDb21waWxpbmcgd2l0aCBXPTEgZ2l2ZXMgdGhl
IGZvbGxvd2luZyB3YXJuaW5nOg0KPiBuZXQvc2NoZWQvY2xzX2Zsb3dlci5jOjczMToxOiB3YXJu
aW5nOiChbXBsc19vcHRzX3BvbGljeaIgZGVmaW5lZCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWNv
bnN0LXZhcmlhYmxlPV0NCj4gDQo+IFRoZSBUQ0FfRkxPV0VSX0tFWV9NUExTX09QVFMgY29udGFp
bnMgYSBsaXN0IG9mDQo+IFRDQV9GTE9XRVJfS0VZX01QTFNfT1BUU19MU0UuIFRoZXJlZm9yZSwg
dGhlIGF0dHJpYnV0ZXMgYWxsIGhhdmUgdGhlDQo+IHNhbWUgdHlwZSBhbmQgd2UgY2FuJ3QgcGFy
c2UgdGhlIGxpc3Qgd2l0aCBubGFfcGFyc2UqKCkgYW5kIGhhdmUgdGhlDQo+IGF0dHJpYnV0ZXMg
dmFsaWRhdGVkIGF1dG9tYXRpY2FsbHkgdXNpbmcgYW4gbmxhX3BvbGljeS4NCj4gDQo+IGZsX3Nl
dF9rZXlfbXBsc19vcHRzKCkgcHJvcGVybHkgdmVyaWZpZXMgdGhhdCBhbGwgYXR0cmlidXRlcyBp
biB0aGUNCj4gbGlzdCBhcmUgVENBX0ZMT1dFUl9LRVlfTVBMU19PUFRTX0xTRS4gVGhlbiBmbF9z
ZXRfa2V5X21wbHNfbHNlKCkNCj4gdXNlcyBubGFfcGFyc2VfbmVzdGVkKCkgb24gYWxsIHRoZXNl
IGF0dHJpYnV0ZXMsIHRodXMgdmVyaWZ5aW5nIHRoYXQNCj4gdGhleSBoYXZlIHRoZSBOTEFfRl9O
RVNURUQgZmxhZy4gU28gd2UgY2FuIHNhZmVseSBkcm9wIHRoZQ0KPiBtcGxzX29wdHNfcG9saWN5
Lg0KPiANCj4gUmVwb3J0ZWQtYnk6IGtidWlsZCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBHdWlsbGF1bWUgTmF1bHQgPGduYXVsdEByZWRoYXQuY29tPg0KDQpB
cHBsaWVkLCB0aGFuayB5b3UuDQo=
