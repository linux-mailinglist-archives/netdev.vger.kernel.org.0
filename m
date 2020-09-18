Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18435270890
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIRVxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRVxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:53:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B45C0613CE;
        Fri, 18 Sep 2020 14:53:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AE7915A09C01;
        Fri, 18 Sep 2020 14:36:23 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:53:09 -0700 (PDT)
Message-Id: <20200918.145309.961435680460105722.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] liquidio: Fix -Wmissing-prototypes warnings
 for liquidio
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918130210.16902-1-wanghai38@huawei.com>
References: <20200918130210.16902-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:36:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2FuZyBIYWkgPHdhbmdoYWkzOEBodWF3ZWkuY29tPg0KRGF0ZTogRnJpLCAxOCBTZXAg
MjAyMCAyMTowMjoxMCArMDgwMA0KDQo+IElmIHRoZSBoZWFkZXIgZmlsZSBjb250YWluaW5nIGEg
ZnVuY3Rpb24ncyBwcm90b3R5cGUgaXNuJ3QgaW5jbHVkZWQgYnkNCj4gdGhlIHNvdXJjZWZpbGUg
Y29udGFpbmluZyB0aGUgYXNzb2NpYXRlZCBmdW5jdGlvbiwgdGhlIGJ1aWxkIHN5c3RlbQ0KPiBj
b21wbGFpbnMgb2YgbWlzc2luZyBwcm90b3R5cGVzLg0KPiANCj4gRml4ZXMgdGhlIGZvbGxvd2lu
ZyBXPTEga2VybmVsIGJ1aWxkIHdhcm5pbmcocyk6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9jYXZpdW0vbGlxdWlkaW8vY242OHh4X2RldmljZS5jOjEyNDo1OiB3YXJuaW5nOiBubyBwcmV2
aW91cyBwcm90b3R5cGUgZm9yIKFsaW9fc2V0dXBfY242OHh4X29jdGVvbl9kZXZpY2WiIFstV21p
c3NpbmctcHJvdG90eXBlc10NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvY2F2aXVtL2xpcXVpZGlv
L29jdGVvbl9tZW1fb3BzLmM6MTU5OjE6IHdhcm5pbmc6IG5vIHByZXZpb3VzIHByb3RvdHlwZSBm
b3IgoW9jdGVvbl9wY2lfcmVhZF9jb3JlX21lbaIgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9jYXZpdW0vbGlxdWlkaW8vb2N0ZW9uX21lbV9vcHMuYzoxNjg6
MTogd2FybmluZzogbm8gcHJldmlvdXMgcHJvdG90eXBlIGZvciChb2N0ZW9uX3BjaV93cml0ZV9j
b3JlX21lbaIgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9j
YXZpdW0vbGlxdWlkaW8vb2N0ZW9uX21lbV9vcHMuYzoxNzY6NTogd2FybmluZzogbm8gcHJldmlv
dXMgcHJvdG90eXBlIGZvciChb2N0ZW9uX3JlYWRfZGV2aWNlX21lbTY0oiBbLVdtaXNzaW5nLXBy
b3RvdHlwZXNdDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS9saXF1aWRpby9vY3Rlb25f
bWVtX29wcy5jOjE4NTo1OiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5cGUgZm9yIKFvY3Rl
b25fcmVhZF9kZXZpY2VfbWVtMzKiIFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gZHJpdmVycy9u
ZXQvZXRoZXJuZXQvY2F2aXVtL2xpcXVpZGlvL29jdGVvbl9tZW1fb3BzLmM6MTk0OjY6IHdhcm5p
bmc6IG5vIHByZXZpb3VzIHByb3RvdHlwZSBmb3IgoW9jdGVvbl93cml0ZV9kZXZpY2VfbWVtMzKi
IFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFdhbmcgSGFpIDx3
YW5naGFpMzhAaHVhd2VpLmNvbT4NCg0KQXBwbGllZC4NCg==
