Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F285266A26
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgIKVhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgIKVhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:37:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E8C061573;
        Fri, 11 Sep 2020 14:37:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59C841366732A;
        Fri, 11 Sep 2020 14:21:03 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:37:49 -0700 (PDT)
Message-Id: <20200911.143749.112207815452157120.davem@davemloft.net>
To:     luojiaxing@huawei.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: stmmac: set get_rx_header_len() as void
 for it didn't have any error code to return
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599796558-45818-1-git-send-email-luojiaxing@huawei.com>
References: <1599796558-45818-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:21:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTHVvIEppYXhpbmcgPGx1b2ppYXhpbmdAaHVhd2VpLmNvbT4NCkRhdGU6IEZyaSwgMTEg
U2VwIDIwMjAgMTE6NTU6NTggKzA4MDANCg0KPiBXZSBmb3VuZCB0aGUgZm9sbG93aW5nIHdhcm5p
bmcgd2hlbiB1c2luZyBXPTEgdG8gYnVpbGQga2VybmVsOg0KPiANCj4gZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYzozNjM0OjY6IHdhcm5pbmc6IHZhcmlh
YmxlIKFyZXSiIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+
IGludCByZXQsIGNvZSA9IHByaXYtPmh3LT5yeF9jc3VtOw0KPiANCj4gV2hlbiBkaWdnaW5nIHN0
bW1hY19nZXRfcnhfaGVhZGVyX2xlbigpLCBkd21hYzRfZ2V0X3J4X2hlYWRlcl9sZW4oKSBhbmQN
Cj4gZHd4Z21hYzJfZ2V0X3J4X2hlYWRlcl9sZW4oKSByZXR1cm4gMCBvbmx5LCB3aXRob3V0IGFu
eSBlcnJvciBjb2RlIHRvDQo+IHJlcG9ydC4gVGhlcmVmb3JlLCBpdCdzIGJldHRlciB0byBkZWZp
bmUgZ2V0X3J4X2hlYWRlcl9sZW4oKSBhcyB2b2lkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTHVv
IEppYXhpbmcgPGx1b2ppYXhpbmdAaHVhd2VpLmNvbT4NCg0KQXBwbGllZCwgdGhhbmsgeW91Lg0K
