Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A472187180
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405462AbfHIFcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:32:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfHIFcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:32:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF1831433DB45;
        Thu,  8 Aug 2019 22:32:47 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:32:47 -0700 (PDT)
Message-Id: <20190808.223247.493228946898420743.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        dave.taht@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] fq_codel: remove set but not used variables
 'prev_ecn_mark' and 'prev_drop_count'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808.223136.1507513183278607177.davem@davemloft.net>
References: <20190807131055.66668-1-yuehaibing@huawei.com>
        <20190808.223136.1507513183278607177.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:32:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAwOCBB
dWcgMjAxOSAyMjozMTozNiAtMDcwMCAoUERUKQ0KDQo+IEZyb206IFl1ZUhhaWJpbmcgPHl1ZWhh
aWJpbmdAaHVhd2VpLmNvbT4NCj4gRGF0ZTogV2VkLCA3IEF1ZyAyMDE5IDIxOjEwOjU1ICswODAw
DQo+IA0KPj4gRml4ZXMgZ2NjICctV3VudXNlZC1idXQtc2V0LXZhcmlhYmxlJyB3YXJuaW5nOg0K
Pj4gDQo+PiBuZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLmM6IEluIGZ1bmN0aW9uIGZxX2NvZGVsX2Rl
cXVldWU6DQo+PiBuZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLmM6Mjg4OjIzOiB3YXJuaW5nOiB2YXJp
YWJsZSBwcmV2X2Vjbl9tYXJrIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFy
aWFibGVdDQo+PiBuZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLmM6Mjg4OjY6IHdhcm5pbmc6IHZhcmlh
YmxlIHByZXZfZHJvcF9jb3VudCBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZh
cmlhYmxlXQ0KPj4gDQo+PiBUaGV5IGFyZSBub3QgdXNlZCBzaW5jZSBjb21taXQgNzdkZGFmZjIx
OGZjICgiZnFfY29kZWw6IEtpbGwNCj4+IHVzZWxlc3MgcGVyLWZsb3cgZHJvcHBlZCBzdGF0aXN0
aWMiKQ0KPj4gDQo+PiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQo+
IA0KPiBEbyB5b3UgZXZlbiBjb21waWxlIHRlc3QgdGhpcyBzdHVmZj8NCj4gDQo+ICAgQ0MgW01d
ICBuZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLm8NCj4gbmV0L3NjaGVkL3NjaF9mcV9jb2RlbC5jOiBJ
biBmdW5jdGlvbiChZnFfY29kZWxfZGVxdWV1ZaI6DQo+IG5ldC9zY2hlZC9zY2hfZnFfY29kZWwu
YzozMDk6NDI6IGVycm9yOiChcHJldl9kcm9wX2NvdW50oiB1bmRlY2xhcmVkIChmaXJzdCB1c2Ug
aW4gdGhpcyBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiChcGFnZV9yZWZfY291bnSiPw0KDQpOZXZl
ciBtaW5kLCB0aGlzIGlzIG15IGZhdWx0Lg0KDQpJIHdhcyBidWlsZCB0ZXN0aW5nIHRoZSBwYXRj
aCBvbiB0aGUgd3JvbmcgdHJlZSwgSSdtIHZlcnkgc29ycnkuDQo=
