Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDB9270898
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIRVze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgIRVzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:55:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE238C0613CE;
        Fri, 18 Sep 2020 14:55:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0779D15A0CF33;
        Fri, 18 Sep 2020 14:38:45 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:55:32 -0700 (PDT)
Message-Id: <20200918.145532.864791412975263953.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com, kuba@kernel.org,
        tanhuazhong@huawei.com, liaoguojia@huawei.com,
        liuyonglong@huawei.com, linyunsheng@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: hns3: Supply missing hclge_dcb.h include
 file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918130653.20064-1-wanghai38@huawei.com>
References: <20200918130653.20064-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:38:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2FuZyBIYWkgPHdhbmdoYWkzOEBodWF3ZWkuY29tPg0KRGF0ZTogRnJpLCAxOCBTZXAg
MjAyMCAyMTowNjo1MyArMDgwMA0KDQo+IElmIHRoZSBoZWFkZXIgZmlsZSBjb250YWluaW5nIGEg
ZnVuY3Rpb24ncyBwcm90b3R5cGUgaXNuJ3QgaW5jbHVkZWQgYnkNCj4gdGhlIHNvdXJjZWZpbGUg
Y29udGFpbmluZyB0aGUgYXNzb2NpYXRlZCBmdW5jdGlvbiwgdGhlIGJ1aWxkIHN5c3RlbQ0KPiBj
b21wbGFpbnMgb2YgbWlzc2luZyBwcm90b3R5cGVzLg0KPiANCj4gRml4ZXMgdGhlIGZvbGxvd2lu
ZyBXPTEga2VybmVsIGJ1aWxkIHdhcm5pbmcocyk6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9oaXNpbGljb24vaG5zMy9obnMzcGYvaGNsZ2VfZGNiLmM6NDUzOjY6IHdhcm5pbmc6IG5vIHBy
ZXZpb3VzIHByb3RvdHlwZSBmb3IgoWhjbGdlX2RjYl9vcHNfc2V0oiBbLVdtaXNzaW5nLXByb3Rv
dHlwZXNdDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBXYW5nIEhhaSA8d2FuZ2hhaTM4QGh1YXdlaS5j
b20+DQoNCkFwcGxpZWQuDQo=
