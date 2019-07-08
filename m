Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583F8618E1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 03:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfGHBfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 21:35:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfGHBfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 21:35:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C61A01528891B;
        Sun,  7 Jul 2019 18:35:11 -0700 (PDT)
Date:   Sun, 07 Jul 2019 18:35:11 -0700 (PDT)
Message-Id: <20190707.183511.503486832061897586.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH v8 net-next 0/5] net: ethernet: ti: cpsw: Add XDP
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190707.183146.1123763637704790378.davem@davemloft.net>
References: <20190705150502.6600-1-ivan.khoronzhuk@linaro.org>
        <20190707.183146.1123763637704790378.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 18:35:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogU3VuLCAwNyBK
dWwgMjAxOSAxODozMTo0NiAtMDcwMCAoUERUKQ0KDQo+IEZyb206IEl2YW4gS2hvcm9uemh1ayA8
aXZhbi5raG9yb256aHVrQGxpbmFyby5vcmc+DQo+IERhdGU6IEZyaSwgIDUgSnVsIDIwMTkgMTg6
MDQ6NTcgKzAzMDANCj4gDQo+PiBUaGlzIHBhdGNoc2V0IGFkZHMgWERQIHN1cHBvcnQgZm9yIFRJ
IGNwc3cgZHJpdmVyIGFuZCBiYXNlIGl0IG9uDQo+PiBwYWdlX3Bvb2wgYWxsb2NhdG9yLiBJdCB3
YXMgdmVyaWZpZWQgb24gYWZfeGRwIHNvY2tldCBkcm9wLA0KPj4gYWZfeGRwIGwyZiwgZWJwZiBY
RFBfRFJPUCwgWERQX1JFRElSRUNULCBYRFBfUEFTUywgWERQX1RYLg0KPj4gDQo+PiBJdCB3YXMg
dmVyaWZpZWQgd2l0aCBmb2xsb3dpbmcgY29uZmlncyBlbmFibGVkOg0KPiAgLi4uDQo+IA0KPiBJ
J20gYXBwbHlpbmcgdGhpcyB0byBuZXQtbmV4dCwgcGxlYXNlIGRlYWwgd2l0aCB3aGF0ZXZlciBm
b2xsb3ctdXBzIGFyZQ0KPiBuZWNlc3NhcnkuDQoNCk5ldmVybWluZCwgeW91IHJlYWxseSBoYXZl
IHRvIGZpeCB0aGlzOg0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC90aS9kYXZpbmNpX2NwZG1hLmM6
IEluIGZ1bmN0aW9uIKFjcGRtYV9jaGFuX3N1Ym1pdF9zaaI6DQpkcml2ZXJzL25ldC9ldGhlcm5l
dC90aS9kYXZpbmNpX2NwZG1hLmM6MTA0NzoxMjogd2FybmluZzogY2FzdCBmcm9tIHBvaW50ZXIg
dG8gaW50ZWdlciBvZiBkaWZmZXJlbnQgc2l6ZSBbLVdwb2ludGVyLXRvLWludC1jYXN0XQ0KICAg
YnVmZmVyID0gKHUzMilzaS0+ZGF0YTsNCiAgICAgICAgICAgIF4NCmRyaXZlcnMvbmV0L2V0aGVy
bmV0L3RpL2RhdmluY2lfY3BkbWEuYzogSW4gZnVuY3Rpb24goWNwZG1hX2NoYW5faWRsZV9zdWJt
aXRfbWFwcGVkojoNCmRyaXZlcnMvbmV0L2V0aGVybmV0L3RpL2RhdmluY2lfY3BkbWEuYzoxMTE0
OjEyOiB3YXJuaW5nOiBjYXN0IHRvIHBvaW50ZXIgZnJvbSBpbnRlZ2VyIG9mIGRpZmZlcmVudCBz
aXplIFstV2ludC10by1wb2ludGVyLWNhc3RdDQogIHNpLmRhdGEgPSAodm9pZCAqKSh1MzIpZGF0
YTsNCiAgICAgICAgICAgIF4NCmRyaXZlcnMvbmV0L2V0aGVybmV0L3RpL2RhdmluY2lfY3BkbWEu
YzogSW4gZnVuY3Rpb24goWNwZG1hX2NoYW5fc3VibWl0X21hcHBlZKI6DQpkcml2ZXJzL25ldC9l
dGhlcm5ldC90aS9kYXZpbmNpX2NwZG1hLmM6MTE2NDoxMjogd2FybmluZzogY2FzdCB0byBwb2lu
dGVyIGZyb20gaW50ZWdlciBvZiBkaWZmZXJlbnQgc2l6ZSBbLVdpbnQtdG8tcG9pbnRlci1jYXN0
XQ0KICBzaS5kYXRhID0gKHZvaWQgKikodTMyKWRhdGE7DQogICAgICAgICAgICBeDQo=
