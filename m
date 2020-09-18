Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12D8270849
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIRVaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgIRVaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:30:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C921C0613CE;
        Fri, 18 Sep 2020 14:30:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B247B159F3C4F;
        Fri, 18 Sep 2020 14:13:26 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:30:13 -0700 (PDT)
Message-Id: <20200918.143013.184259371965563025.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     fmanlunas@marvell.com, sburla@marvell.com, dchickles@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: Remove set but not used
 variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918083938.21046-1-zhengyongjun3@huawei.com>
References: <20200918083938.21046-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:13:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogRnJp
LCAxOCBTZXAgMjAyMCAxNjozOTozOCArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
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
bjNAaHVhd2VpLmNvbT4NCg0KVGhlIHByb3BlciBzdWJzeXN0ZW0gcHJlZml4IGZvciB0aGVzZSBj
aGFuZ2VzIGlzIGp1c3QgImxpcXVpZGlvOiAiLg0KDQpGb3IgY2hhbmdlcyB0byBhIHNwZWNpZmlj
IGRyaXZlciBpdCBpcyBub3QgYXBwcm9wcmlhdGUgdG8gdXNlDQoibmV0OiBldGhlcm5ldDogIiBv
ciBzaW1pbGFyLg0KDQpQbGVhc2UgZml4IHVwIHlvdXIgU3ViamVjdCBsaW5lIGFuZCByZXN1Ym1p
dC4NCg0KVGhhbmsgeW91Lg0K
