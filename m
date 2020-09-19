Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD027108C
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgISVOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISVOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:14:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B23C0613CE;
        Sat, 19 Sep 2020 14:14:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB13C11E3E4CE;
        Sat, 19 Sep 2020 13:58:04 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:14:51 -0700 (PDT)
Message-Id: <20200919.141451.1402061721958434693.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: marvell: Remove set but not used variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919020550.23227-1-zhengyongjun3@huawei.com>
References: <20200919020550.23227-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 13:58:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogU2F0
LCAxOSBTZXAgMjAyMCAxMDowNTo1MCArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZl
bGwvcHhhMTY4X2V0aC5jOiBJbiBmdW5jdGlvbiBweGExNjhfZXRoX2NoYW5nZV9tdHU6DQo+IGRy
aXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvcHhhMTY4X2V0aC5jOjExOTA6Njogd2FybmluZzog
dmFyaWFibGUgoXJldHZhbKIgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJp
YWJsZV0NCj4gDQo+IGByZXR2YWxgIGlzIG5ldmVyIHVzZWQsIHNvIHJlbW92ZSBpdC4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFpoZW5nIFlvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT4N
Cg0KVGhpcyBjaGFuZ2UgaXMgYWxyZWFkeSBpbiB0aGUgbmV0LW5leHQgR0lUIHRyZWUuDQo=
