Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74434271087
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgISVO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISVO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:14:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22767C0613CE;
        Sat, 19 Sep 2020 14:14:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DEEB11E3E4CF;
        Sat, 19 Sep 2020 13:57:38 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:14:24 -0700 (PDT)
Message-Id: <20200919.141424.2128438145639819522.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: liquidio: Remove set but not used
 variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919013123.22596-1-zhengyongjun3@huawei.com>
References: <20200919013123.22596-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 13:57:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogU2F0
LCAxOSBTZXAgMjAyMCAwOTozMToyMyArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1
bS9saXF1aWRpby9vY3Rlb25fZGV2aWNlLmM6IEluIGZ1bmN0aW9uIGxpb19wY2lfcmVhZHE6DQo+
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS9saXF1aWRpby9vY3Rlb25fZGV2aWNlLmM6MTMy
Nzo2OiB3YXJuaW5nOiB2YXJpYWJsZSChdmFsMzKiIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2Vk
LWJ1dC1zZXQtdmFyaWFibGVdDQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYXZpdW0vbGlx
dWlkaW8vb2N0ZW9uX2RldmljZS5jOiBJbiBmdW5jdGlvbiBsaW9fcGNpX3dyaXRlcToNCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2F2aXVtL2xpcXVpZGlvL29jdGVvbl9kZXZpY2UuYzoxMzU4OjY6
IHdhcm5pbmc6IHZhcmlhYmxlIKF2YWwzMqIgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZV0NCj4gDQo+IHRoZXNlIHZhcmlhYmxlIGlzIG5ldmVyIHVzZWQsIHNvIHJl
bW92ZSBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpoZW5nIFlvbmdqdW4gPHpoZW5neW9uZ2p1
bjNAaHVhd2VpLmNvbT4NCg0KQXBwbGllZC4NCg==
