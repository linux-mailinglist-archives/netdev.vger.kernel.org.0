Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D527FA7D7
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfKMEIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:08:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbfKMEIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:08:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 228C0155010F4;
        Tue, 12 Nov 2019 20:08:31 -0800 (PST)
Date:   Tue, 12 Nov 2019 20:08:30 -0800 (PST)
Message-Id: <20191112.200830.1524247803414226770.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8169: use rtl821x_modify_extpage
 exported from Realtek PHY driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112.195603.990766606825592151.davem@davemloft.net>
References: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
        <20191112.195603.990766606825592151.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 20:08:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVHVlLCAxMiBO
b3YgMjAxOSAxOTo1NjowMyAtMDgwMCAoUFNUKQ0KDQo+IEZyb206IEhlaW5lciBLYWxsd2VpdCA8
aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IERhdGU6IFR1ZSwgMTIgTm92IDIwMTkgMjI6MjI6NTUg
KzAxMDANCj4gDQo+PiBDZXJ0YWluIFJlYWx0ZWsgUEhZJ3Mgc3VwcG9ydCBhIHByb3ByaWV0YXJ5
ICJleHRlbmRlZCBwYWdlIiBhY2Nlc3MgbW9kZQ0KPj4gdGhhdCBpcyB1c2VkIGluIHRoZSBSZWFs
dGVrIFBIWSBkcml2ZXIgYW5kIGluIHI4MTY5IG5ldHdvcmsgZHJpdmVyLg0KPj4gTGV0J3MgaW1w
bGVtZW50IGl0IHByb3Blcmx5IGluIHRoZSBSZWFsdGVrIFBIWSBkcml2ZXIgYW5kIGV4cG9ydCBp
dCBmb3INCj4+IHVzZSBpbiBvdGhlciBkcml2ZXJzIGxpa2UgcjgxNjkuDQo+IA0KPiBBcHBsaWVk
LCBidXQgSSByZWFsbHkgd2lzaCB0aGVzZSBkZXBzIHdvcmtlZCBtb3JlIG5pY2VseS4NCj4gDQo+
IE5vdyBJIGhhdmUgdG8ga25vdyB3aGF0IFBIWSBkcml2ZXJzIG15IGV0aGVybmV0IGNhcmQgdXNl
cyBqdXN0IHRvIGhhdmUNCj4gdGhlIG1haW4gZHJpdmVyIHNob3cgdXAgYXMgYSBwb3NzaWJsZSBv
cHRpb24gaW4gdGhlIEtjb25maWcuICBUaGF0J3MNCj4gbm90IG5pY2UgYXQgYWxsLg0KDQpJIGhh
ZCB0byByZXZlcnQsIG1pc3NpbmcgdHlwZXMuaCBpbmNsdWRlIGluIHRoZSBuZXcgaGVhZGVyIGZp
bGUgb3Igc2ltaWxhcjoNCg0KLi9pbmNsdWRlL2xpbnV4L3JlYWx0ZWtfcGh5Lmg6NjoxNjogZXJy
b3I6IHVua25vd24gdHlwZSBuYW1lIKF1MTaiDQogICAgICAgaW50IHJlZywgdTE2IG1hc2ssIHUx
NiB2YWwpOw0KICAgICAgICAgICAgICAgIF5+fg0KLi9pbmNsdWRlL2xpbnV4L3JlYWx0ZWtfcGh5
Lmg6NjoyNjogZXJyb3I6IHVua25vd24gdHlwZSBuYW1lIKF1MTaiDQogICAgICAgaW50IHJlZywg
dTE2IG1hc2ssIHUxNiB2YWwpOw0KICAgICAgICAgICAgICAgICAgICAgICAgICBefn4NCg==
