Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8B68717B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405268AbfHIFbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:31:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfHIFbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:31:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FB9E142E8E07;
        Thu,  8 Aug 2019 22:31:37 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:31:36 -0700 (PDT)
Message-Id: <20190808.223136.1507513183278607177.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        dave.taht@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] fq_codel: remove set but not used variables
 'prev_ecn_mark' and 'prev_drop_count'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190807131055.66668-1-yuehaibing@huawei.com>
References: <20190807131055.66668-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:31:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KRGF0ZTogV2VkLCA3IEF1
ZyAyMDE5IDIxOjEwOjU1ICswODAwDQoNCj4gRml4ZXMgZ2NjICctV3VudXNlZC1idXQtc2V0LXZh
cmlhYmxlJyB3YXJuaW5nOg0KPiANCj4gbmV0L3NjaGVkL3NjaF9mcV9jb2RlbC5jOiBJbiBmdW5j
dGlvbiBmcV9jb2RlbF9kZXF1ZXVlOg0KPiBuZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLmM6Mjg4OjIz
OiB3YXJuaW5nOiB2YXJpYWJsZSBwcmV2X2Vjbl9tYXJrIHNldCBidXQgbm90IHVzZWQgWy1XdW51
c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+IG5ldC9zY2hlZC9zY2hfZnFfY29kZWwuYzoyODg6Njog
d2FybmluZzogdmFyaWFibGUgcHJldl9kcm9wX2NvdW50IHNldCBidXQgbm90IHVzZWQgWy1XdW51
c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+IA0KPiBUaGV5IGFyZSBub3QgdXNlZCBzaW5jZSBjb21t
aXQgNzdkZGFmZjIxOGZjICgiZnFfY29kZWw6IEtpbGwNCj4gdXNlbGVzcyBwZXItZmxvdyBkcm9w
cGVkIHN0YXRpc3RpYyIpDQo+IA0KPiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1
YXdlaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2Vp
LmNvbT4NCg0KRG8geW91IGV2ZW4gY29tcGlsZSB0ZXN0IHRoaXMgc3R1ZmY/DQoNCiAgQ0MgW01d
ICBuZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLm8NCm5ldC9zY2hlZC9zY2hfZnFfY29kZWwuYzogSW4g
ZnVuY3Rpb24goWZxX2NvZGVsX2RlcXVldWWiOg0KbmV0L3NjaGVkL3NjaF9mcV9jb2RlbC5jOjMw
OTo0MjogZXJyb3I6IKFwcmV2X2Ryb3BfY291bnSiIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0
aGlzIGZ1bmN0aW9uKTsgZGlkIHlvdSBtZWFuIKFwYWdlX3JlZl9jb3VudKI/DQogIGZsb3ctPmRy
b3BwZWQgKz0gcS0+Y3N0YXRzLmRyb3BfY291bnQgLSBwcmV2X2Ryb3BfY291bnQ7DQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4NCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBhZ2VfcmVmX2NvdW50DQpuZXQv
c2NoZWQvc2NoX2ZxX2NvZGVsLmM6MzA5OjQyOiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRp
ZmllciBpcyByZXBvcnRlZCBvbmx5IG9uY2UgZm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBp
bg0KbmV0L3NjaGVkL3NjaF9mcV9jb2RlbC5jOjMxMDo0MDogZXJyb3I6IKFwcmV2X2Vjbl9tYXJr
oiB1bmRlY2xhcmVkIChmaXJzdCB1c2UgaW4gdGhpcyBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiCh
cG1kX3Bmbl9tYXNroj8NCiAgZmxvdy0+ZHJvcHBlZCArPSBxLT5jc3RhdHMuZWNuX21hcmsgLSBw
cmV2X2Vjbl9tYXJrOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+
fn5+fn5+fn5+fn4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwbWRf
cGZuX21hc2sNCm1ha2VbMV06ICoqKiBbc2NyaXB0cy9NYWtlZmlsZS5idWlsZDoyNzQ6IG5ldC9z
Y2hlZC9zY2hfZnFfY29kZWwub10gRXJyb3IgMQ0KbWFrZTogKioqIFtNYWtlZmlsZToxNzY5OiBu
ZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLm9dIEVycm9yIDINCg==
