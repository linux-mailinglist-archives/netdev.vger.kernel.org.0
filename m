Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64E61555C6
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGKeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:34:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBGKeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:34:17 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E0B015A33D82;
        Fri,  7 Feb 2020 02:34:14 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:34:13 +0100 (CET)
Message-Id: <20200207.113413.1857068725421133796.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hv_netvsc: Fix XDP refcnt for synthetic and VF NICs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581026465-36161-1-git-send-email-haiyangz@microsoft.com>
References: <1581026465-36161-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:34:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4NCkRhdGU6IFRodSwg
IDYgRmViIDIwMjAgMTQ6MDE6MDUgLTA4MDANCg0KPiBUaGUgY2FsbGVyIG9mIFhEUF9TRVRVUF9Q
Uk9HIGhhcyBhbHJlYWR5IGluY3JlbWVudGVkIHJlZmNudCBpbg0KPiBfX2JwZl9wcm9nX2dldCgp
LCBzbyBkcml2ZXJzIHNob3VsZCBvbmx5IGluY3JlbWVudCByZWZjbnQgYnkNCj4gbnVtX3F1ZXVl
cyAtIDEuDQo+IA0KPiBUbyBmaXggdGhlIGlzc3VlLCB1cGRhdGUgbmV0dnNjX3hkcF9zZXQoKSB0
byBhZGQgdGhlIGNvcnJlY3QgbnVtYmVyDQo+IHRvIHJlZmNudC4NCj4gDQo+IEhvbGQgYSByZWZj
bnQgaW4gbmV0dnNjX3hkcF9zZXQoKaJzIG90aGVyIGNhbGxlciwgbmV0dnNjX2F0dGFjaCgpLg0K
PiANCj4gQW5kLCBkbyB0aGUgc2FtZSBpbiBuZXR2c2NfdmZfc2V0eGRwKCkuIE90aGVyd2lzZSwg
ZXZlcnkgdGltZSB3aGVuIFZGIGlzDQo+IHJlbW92ZWQgYW5kIGFkZGVkIGZyb20gdGhlIGhvc3Qg
c2lkZSwgdGhlIHJlZmNudCB3aWxsIGJlIGRlY3JlYXNlZCBieSBvbmUsDQo+IHdoaWNoIG1heSBj
YXVzZSBwYWdlIGZhdWx0IHdoZW4gdW5sb2FkaW5nIHhkcCBwcm9ncmFtLg0KPiANCj4gRml4ZXM6
IDM1MWUxNTgxMzk1ZiAoImh2X25ldHZzYzogQWRkIFhEUCBzdXBwb3J0IikNCj4gU2lnbmVkLW9m
Zi1ieTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4NCg0KQXBwbGllZCwg
dGhhbmsgeW91Lg0K
