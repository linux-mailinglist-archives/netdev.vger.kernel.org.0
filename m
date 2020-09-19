Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83C827108A
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgISVOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISVOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:14:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726BAC0613CE;
        Sat, 19 Sep 2020 14:14:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3F0311E3E4CE;
        Sat, 19 Sep 2020 13:57:46 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:14:33 -0700 (PDT)
Message-Id: <20200919.141433.905827192285572567.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     jeffrey.t.kirsher@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: e1000: Remove set but not used variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919015020.22963-1-zhengyongjun3@huawei.com>
References: <20200919015020.22963-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 13:57:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KRGF0ZTogU2F0
LCAxOSBTZXAgMjAyMCAwOTo1MDoyMCArMDgwMA0KDQo+IEZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0
LXNldC12YXJpYWJsZScgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2UxMDAwL2UxMDAwX2h3LmM6IEluIGZ1bmN0aW9uIGUxMDAwX3BoeV9pbml0X3NjcmlwdDoNCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDAvZTEwMDBfaHcuYzoxMzI6Njogd2Fybmlu
ZzogdmFyaWFibGUgoXJldF92YWyiIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQt
dmFyaWFibGVdDQo+IA0KPiBgcmV0X3ZhbGAgaXMgbmV2ZXIgdXNlZCwgc28gcmVtb3ZlIGl0Lg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWku
Y29tPg0KDQpBcHBsaWVkLg0K
