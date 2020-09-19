Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F8027108E
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgISVPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISVPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:15:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6ECC0613CE;
        Sat, 19 Sep 2020 14:15:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEAD611E3E4CE;
        Sat, 19 Sep 2020 13:58:23 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:15:10 -0700 (PDT)
Message-Id: <20200919.141510.731442596296928108.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: micrel: Remove set but not used variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919023235.23494-1-zhengyongjun3@huawei.com>
References: <20200919023235.23494-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 13:58:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogU2F0
LCAxOSBTZXAgMjAyMCAxMDozMjozNSArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jl
bC9rc3o4ODR4LmM6IEluIGZ1bmN0aW9uIHJ4X3Byb2M6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L21pY3JlbC9rc3o4ODR4LmM6NDk4MTo2OiB3YXJuaW5nOiB2YXJpYWJsZSChcnhfc3RhdHVzoiBz
ZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiANCj4gZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWljcmVsL2tzejg4NHguYzogSW4gZnVuY3Rpb24gbmV0ZGV2X2dldF9l
dGh0b29sX3N0YXRzOg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyZWwva3N6ODg0eC5jOjY1
MTI6Njogd2FybmluZzogdmFyaWFibGUgoXJjoiBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1i
dXQtc2V0LXZhcmlhYmxlXQ0KPiANCj4gdGhlc2UgdmFyaWFibGUgaXMgbmV2ZXIgdXNlZCwgc28g
cmVtb3ZlIGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25n
anVuM0BodWF3ZWkuY29tPg0KDQpBcHBsaWVkLg0K
