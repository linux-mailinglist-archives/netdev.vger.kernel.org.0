Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3D21D3EEF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgENUWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgENUWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:22:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3879C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 13:22:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58C71128D7312;
        Thu, 14 May 2020 13:22:37 -0700 (PDT)
Date:   Thu, 14 May 2020 13:22:36 -0700 (PDT)
Message-Id: <20200514.132236.1465846961453548902.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, mkalderon@marvell.com,
        dbolotin@marvell.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 00/11] net: qed/qede: critical hw error
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514.130952.794606246311304590.davem@davemloft.net>
References: <20200514095727.1361-1-irusskikh@marvell.com>
        <20200514.130159.1188703412067742485.davem@davemloft.net>
        <20200514.130952.794606246311304590.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:22:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAxNCBN
YXkgMjAyMCAxMzowOTo1MiAtMDcwMCAoUERUKQ0KDQo+IEFjdHVhbGx5LCBJIGhhZCB0byByZXZl
cnQsIHBsZWFzZSBmaXggdGhlc2Ugd2FybmluZ3MgKHdpdGggZ2NjLTEwLjEuMSBvbiBGZWRvcmEp
XzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3Fsb2dpYy9xZWQvcWVkX2Rldi5jOiBJbiBm
dW5jdGlvbiChcWVkX2xsaF9hZGRfbWFjX2ZpbHRlcqI6DQo+IC4vaW5jbHVkZS9saW51eC9wcmlu
dGsuaDozMDM6Mjogd2FybmluZzogoWFic19wcGZpZKIgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXpl
ZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRdDQo+ICAgMzAzIHwgIHBy
aW50ayhLRVJOX05PVElDRSBwcl9mbXQoZm10KSwgIyNfX1ZBX0FSR1NfXykNCj4gICAgICAgfCAg
Xn5+fn5+DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3Fsb2dpYy9xZWQvcWVkX2Rldi5jOjk4Mzox
Nzogbm90ZTogoWFic19wcGZpZKIgd2FzIGRlY2xhcmVkIGhlcmUNCj4gICA5ODMgfCAgdTggZmls
dGVyX2lkeCwgYWJzX3BwZmlkOw0KPiAgICAgICB8ICAgICAgICAgICAgICAgICBefn5+fn5+fn4N
Cg0KSG1tLCB0aGlzIHNlZW1zIHRvIGFjdHVhbGx5IGJlIGFuIGV4aXN0aW5nIHdhcm5pbmcsIHNv
cnJ5Lg0KDQpJJ2xsIHJlYXBwbHkgdGhpcy4NCg==
