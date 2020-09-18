Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA64270892
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIRVxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRVxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:53:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726AFC0613CE;
        Fri, 18 Sep 2020 14:53:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDDFF15A0C549;
        Fri, 18 Sep 2020 14:37:03 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:53:50 -0700 (PDT)
Message-Id: <20200918.145350.47731335344156016.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     kuba@kernel.org, gustavoars@kernel.org, mhabets@solarflare.com,
        mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/appletalk: Supply missing net/Space.h
 include file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918125551.12075-1-wanghai38@huawei.com>
References: <20200918125551.12075-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:37:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2FuZyBIYWkgPHdhbmdoYWkzOEBodWF3ZWkuY29tPg0KRGF0ZTogRnJpLCAxOCBTZXAg
MjAyMCAyMDo1NTo1MSArMDgwMA0KDQo+IElmIHRoZSBoZWFkZXIgZmlsZSBjb250YWluaW5nIGEg
ZnVuY3Rpb24ncyBwcm90b3R5cGUgaXNuJ3QgaW5jbHVkZWQgYnkNCj4gdGhlIHNvdXJjZWZpbGUg
Y29udGFpbmluZyB0aGUgYXNzb2NpYXRlZCBmdW5jdGlvbiwgdGhlIGJ1aWxkIHN5c3RlbQ0KPiBj
b21wbGFpbnMgb2YgbWlzc2luZyBwcm90b3R5cGVzLg0KPiANCj4gRml4ZXMgdGhlIGZvbGxvd2lu
ZyBXPTEga2VybmVsIGJ1aWxkIHdhcm5pbmcocyk6DQo+IA0KPiBkcml2ZXJzL25ldC9hcHBsZXRh
bGsvY29wcy5jOjIxMzoyODogd2FybmluZzogbm8gcHJldmlvdXMgcHJvdG90eXBlIGZvciChY29w
c19wcm9iZaIgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiBkcml2ZXJzL25ldC9hcHBsZXRhbGsv
bHRwYy5jOjEwMTQ6Mjg6IHdhcm5pbmc6IG5vIHByZXZpb3VzIHByb3RvdHlwZSBmb3IgoWx0cGNf
cHJvYmWiIFstV21pc3NpbmctcHJvdG90eXBlc10NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFdhbmcg
SGFpIDx3YW5naGFpMzhAaHVhd2VpLmNvbT4NCg0KQXBwbGllZC4NCg==
