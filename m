Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C92198344
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgC3SVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:21:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40670 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgC3SVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:21:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E600C15C51201;
        Mon, 30 Mar 2020 11:21:35 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:21:35 -0700 (PDT)
Message-Id: <20200330.112135.482388800634154728.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next] mlxsw: spectrum_ptp: Fix build warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330180820.2349593-1-idosch@idosch.org>
References: <20200330180820.2349593-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:21:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSWRvIFNjaGltbWVsIDxpZG9zY2hAaWRvc2NoLm9yZz4NCkRhdGU6IE1vbiwgMzAgTWFy
IDIwMjAgMjE6MDg6MjAgKzAzMDANCg0KPiBGcm9tOiBJZG8gU2NoaW1tZWwgPGlkb3NjaEBtZWxs
YW5veC5jb20+DQo+IA0KPiBDaXRlZCBjb21taXQgZXh0ZW5kZWQgdGhlIGVudW1zICdod3RzdGFt
cF90eF90eXBlcycgYW5kDQo+ICdod3RzdGFtcF9yeF9maWx0ZXJzJyB3aXRoIHZhbHVlcyB0aGF0
IHdlcmUgbm90IGFjY291bnRlZCBmb3IgaW4gdGhlDQo+IHN3aXRjaCBzdGF0ZW1lbnRzLCByZXN1
bHRpbmcgaW4gdGhlIGJ1aWxkIHdhcm5pbmdzIGJlbG93Lg0KPiANCj4gRml4IGJ5IGFkZGluZyBh
IGRlZmF1bHQgY2FzZS4NCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seHN3
L3NwZWN0cnVtX3B0cC5jOiBJbiBmdW5jdGlvbiChbWx4c3dfc3BfcHRwX2dldF9tZXNzYWdlX3R5
cGVzojoNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4c3cvc3BlY3RydW1fcHRw
LmM6OTE1OjI6IHdhcm5pbmc6IGVudW1lcmF0aW9uIHZhbHVlIKFfX0hXVFNUQU1QX1RYX0NOVKIg
bm90IGhhbmRsZWQgaW4gc3dpdGNoIFstV3N3aXRjaF0NCj4gICA5MTUgfCAgc3dpdGNoICh0eF90
eXBlKSB7DQo+ICAgICAgIHwgIF5+fn5+fg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHhzdy9zcGVjdHJ1bV9wdHAuYzo5Mjc6Mjogd2FybmluZzogZW51bWVyYXRpb24gdmFsdWUg
oV9fSFdUU1RBTVBfRklMVEVSX0NOVKIgbm90IGhhbmRsZWQgaW4gc3dpdGNoIFstV3N3aXRjaF0N
Cj4gICA5MjcgfCAgc3dpdGNoIChyeF9maWx0ZXIpIHsNCj4gICAgICAgfCAgXn5+fn5+DQo+IA0K
PiBGaXhlczogZjc2NTEwYjQ1OGE1ICgiZXRodG9vbDogYWRkIHRpbWVzdGFtcGluZyByZWxhdGVk
IHN0cmluZyBzZXRzIikNCj4gU2lnbmVkLW9mZi1ieTogSWRvIFNjaGltbWVsIDxpZG9zY2hAbWVs
bGFub3guY29tPg0KPiBSZXBvcnRlZC1ieTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxv
ZnQubmV0Pg0KDQpBcHBsaWVkLCB0aGFua3MuDQo=
