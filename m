Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242A02708A2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIRV5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIRV5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:57:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB53C0613CE;
        Fri, 18 Sep 2020 14:57:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BC7315A0D937;
        Fri, 18 Sep 2020 14:40:23 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:57:09 -0700 (PDT)
Message-Id: <20200918.145709.1875065294612270596.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: tipc: Supply missing udp_media.h include
 file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918131819.28062-1-wanghai38@huawei.com>
References: <20200918131819.28062-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:40:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2FuZyBIYWkgPHdhbmdoYWkzOEBodWF3ZWkuY29tPg0KRGF0ZTogRnJpLCAxOCBTZXAg
MjAyMCAyMToxODoxOSArMDgwMA0KDQo+IElmIHRoZSBoZWFkZXIgZmlsZSBjb250YWluaW5nIGEg
ZnVuY3Rpb24ncyBwcm90b3R5cGUgaXNuJ3QgaW5jbHVkZWQgYnkNCj4gdGhlIHNvdXJjZWZpbGUg
Y29udGFpbmluZyB0aGUgYXNzb2NpYXRlZCBmdW5jdGlvbiwgdGhlIGJ1aWxkIHN5c3RlbQ0KPiBj
b21wbGFpbnMgb2YgbWlzc2luZyBwcm90b3R5cGVzLg0KPiANCj4gRml4ZXMgdGhlIGZvbGxvd2lu
ZyBXPTEga2VybmVsIGJ1aWxkIHdhcm5pbmcocyk6DQo+IA0KPiBuZXQvdGlwYy91ZHBfbWVkaWEu
Yzo0NDY6NTogd2FybmluZzogbm8gcHJldmlvdXMgcHJvdG90eXBlIGZvciChdGlwY191ZHBfbmxf
ZHVtcF9yZW1vdGVpcKIgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiBuZXQvdGlwYy91ZHBfbWVk
aWEuYzo1MzI6NTogd2FybmluZzogbm8gcHJldmlvdXMgcHJvdG90eXBlIGZvciChdGlwY191ZHBf
bmxfYWRkX2JlYXJlcl9kYXRhoiBbLVdtaXNzaW5nLXByb3RvdHlwZXNdDQo+IG5ldC90aXBjL3Vk
cF9tZWRpYS5jOjYxNDo1OiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5cGUgZm9yIKF0aXBj
X3VkcF9ubF9iZWFyZXJfYWRkoiBbLVdtaXNzaW5nLXByb3RvdHlwZXNdDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBXYW5nIEhhaSA8d2FuZ2hhaTM4QGh1YXdlaS5jb20+DQoNCkFwcGxpZWQuDQo=
