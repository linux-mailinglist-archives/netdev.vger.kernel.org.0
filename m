Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D075D271081
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgISVJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgISVJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:09:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4996BC0613CE;
        Sat, 19 Sep 2020 14:09:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF40011E3E4CE;
        Sat, 19 Sep 2020 13:52:52 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:09:39 -0700 (PDT)
Message-Id: <20200919.140939.2137825862652726442.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: microchip: Remove set but not used
 variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919023909.23716-1-zhengyongjun3@huawei.com>
References: <20200919023909.23716-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 13:52:53 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogU2F0
LCAxOSBTZXAgMjAyMCAxMDozOTowOSArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jv
Y2hpcC9sYW43NDN4X21haW4uYzogSW4gZnVuY3Rpb24gbGFuNzQzeF9wbV9zdXNwZW5kOg0KPiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb2NoaXAvbGFuNzQzeF9tYWluLmM6MzA0MTo2OiB3YXJu
aW5nOiB2YXJpYWJsZSChcmV0oiBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZh
cmlhYmxlXQ0KPiANCj4gYHJldGAgaXMgc2V0IGJ1dCBub3QgdXNlZCwgc28gY2hlY2sgaXQncyB2
YWx1ZS4NCg0KU3ViamVjdCBpcyBzdGlsbCB3cm9uZywgcGxlYXNlIGZpeCB0aGlzIGFuZCB0YWtl
IHlvdXIgdGltZSBkb2luZw0Kc28uDQoNClRoYW5rcy4NCg==
