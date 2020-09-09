Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ADA262568
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIICxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIICxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:53:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608FEC061573;
        Tue,  8 Sep 2020 19:53:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0445111E3E4C2;
        Tue,  8 Sep 2020 19:36:27 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:53:13 -0700 (PDT)
Message-Id: <20200908.195313.1045289785658114479.davem@davemloft.net>
To:     xuwei5@hisilicon.com
Cc:     netdev@vger.kernel.org, linuxarm@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
        john.garry@huawei.com, salil.mehta@huawei.com,
        shiju.jose@huawei.com, jinying@hisilicon.com,
        zhangyi.ac@huawei.com, liguozhu@hisilicon.com,
        tangkunshan@huawei.com, huangdaode@hisilicon.com,
        steve.glendinning@shawell.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next] net: smsc911x: Remove unused variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599536965-162578-1-git-send-email-xuwei5@hisilicon.com>
References: <1599536965-162578-1-git-send-email-xuwei5@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:36:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2VpIFh1IDx4dXdlaTVAaGlzaWxpY29uLmNvbT4NCkRhdGU6IFR1ZSwgOCBTZXAgMjAy
MCAxMTo0OToyNSArMDgwMA0KDQo+IEZpeGVzIHRoZSBmb2xsb3dpbmcgVz0xIGtlcm5lbCBidWls
ZCB3YXJuaW5nKHMpOg0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3Ntc2Mvc21zYzkxMXgu
YzogSW4gZnVuY3Rpb24goXNtc2M5MTF4X3J4X2Zhc3Rmb3J3YXJkojoNCj4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L3Ntc2Mvc21zYzkxMXguYzoxMTk5OjE2OiB3YXJuaW5nOiB2YXJpYWJsZSChdGVt
cKIgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4gDQo+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9zbXNjL3Ntc2M5MTF4LmM6IEluIGZ1bmN0aW9uIKFzbXNjOTEx
eF9lZXByb21fd3JpdGVfbG9jYXRpb26iOg0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvc21zYy9z
bXNjOTExeC5jOjIwNTg6Njogd2FybmluZzogdmFyaWFibGUgoXRlbXCiIHNldCBidXQgbm90IHVz
ZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBXZWkg
WHUgPHh1d2VpNUBoaXNpbGljb24uY29tPg0KDQpBcHBsaWVkLCB0aGFuayB5b3UuDQo=
