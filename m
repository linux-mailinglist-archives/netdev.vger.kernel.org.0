Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5042A270855
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIRVd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgIRVd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:33:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5B9C0613CE;
        Fri, 18 Sep 2020 14:33:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1D26158CA2A3;
        Fri, 18 Sep 2020 14:17:08 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:33:55 -0700 (PDT)
Message-Id: <20200918.143355.1401909827004729879.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     ulli.kroll@googlemail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: cortina: Remove set but not used variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918084951.21130-1-zhengyongjun3@huawei.com>
References: <20200918084951.21130-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:17:09 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogRnJp
LCAxOCBTZXAgMjAyMCAxNjo0OTo1MSArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2NvcnRp
bmEvZ2VtaW5pLmM6IEluIGZ1bmN0aW9uIGdtYWNfZ2V0X3JpbmdwYXJhbToNCj4gZHJpdmVycy9u
ZXQvZXRoZXJuZXQvY29ydGluYS9nZW1pbmkuYzoyMTI1OjIxOiB3YXJuaW5nOiB2YXJpYWJsZSCh
Y29uZmlnMKIgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4g
DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2NvcnRpbmEvZ2VtaW5pLmM6IEluIGZ1bmN0aW9uIGdt
YWNfaW5pdDoNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvY29ydGluYS9nZW1pbmkuYzo1MTI6Njog
d2FybmluZzogdmFyaWFibGUgoXZhbKIgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNl
dC12YXJpYWJsZV0NCj4gDQo+IHRoZXNlIHZhcmlhYmxlIGlzIG5ldmVyIHVzZWQsIHNvIHJlbW92
ZSBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpoZW5nIFlvbmdqdW4gPHpoZW5neW9uZ2p1bjNA
aHVhd2VpLmNvbT4NCg0KQXBwbGllZC4NCg==
