Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8DC273540
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgIUVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbgIUVyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:54:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEFBC061755;
        Mon, 21 Sep 2020 14:54:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B96B911E49F62;
        Mon, 21 Sep 2020 14:37:35 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:54:22 -0700 (PDT)
Message-Id: <20200921.145422.1591767190368974647.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: natsemi: Remove set but not used
 variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921121841.31682-1-zhengyongjun3@huawei.com>
References: <20200921121841.31682-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 14:37:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogTW9u
LCAyMSBTZXAgMjAyMCAyMDoxODo0MSArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L25hdHNl
bWkvbnM4MzgyMC5jOiBJbiBmdW5jdGlvbiBuczgzODIwX2dldF9saW5rX2tzZXR0aW5nczoNCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbmF0c2VtaS9uczgzODIwLmM6MTIxMDoxMTogd2FybmluZzog
dmFyaWFibGUgoXRhbmFyoiBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZhcmlh
YmxlXQ0KPiANCj4gYHRhbmFyYCBpcyBuZXZlciB1c2VkLCBzbyByZW1vdmUgaXQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBaaGVuZyBZb25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQoN
CkFwcGxpZWQuDQo=
