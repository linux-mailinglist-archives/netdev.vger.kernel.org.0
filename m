Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F92318C2
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfFAASV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:18:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53024 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfFAASV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:18:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81940150402B2;
        Fri, 31 May 2019 17:18:20 -0700 (PDT)
Date:   Fri, 31 May 2019 17:18:19 -0700 (PDT)
Message-Id: <20190531.171819.1461966494167760290.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] code optimizations & bugfixes for HNS3
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531.171529.1003718945482922118.davem@davemloft.net>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
        <20190531.171529.1003718945482922118.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 17:18:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogRnJpLCAzMSBN
YXkgMjAxOSAxNzoxNToyOSAtMDcwMCAoUERUKQ0KDQo+IEZyb206IEh1YXpob25nIFRhbiA8dGFu
aHVhemhvbmdAaHVhd2VpLmNvbT4NCj4gRGF0ZTogRnJpLCAzMSBNYXkgMjAxOSAxNjo1NDo0NiAr
MDgwMA0KPiANCj4+IFRoaXMgcGF0Y2gtc2V0IGluY2x1ZGVzIGNvZGUgb3B0aW1pemF0aW9ucyBh
bmQgYnVnZml4ZXMgZm9yIHRoZSBITlMzDQo+PiBldGhlcm5ldCBjb250cm9sbGVyIGRyaXZlci4N
Cj4+IA0KPj4gW3BhdGNoIDEvMTJdIHJlbW92ZXMgdGhlIHJlZHVuZGFudCBjb3JlIHJlc2V0IHR5
cGUNCj4+IA0KPj4gW3BhdGNoIDIvMTIgLSAzLzEyXSBmaXhlcyB0d28gVkxBTiByZWxhdGVkIGlz
c3Vlcw0KPj4gDQo+PiBbcGF0Y2ggNC8xMl0gZml4ZXMgYSBUTSBpc3N1ZQ0KPj4gDQo+PiBbcGF0
Y2ggNS8xMiAtIDEyLzEyXSBpbmNsdWRlcyBzb21lIHBhdGNoZXMgcmVsYXRlZCB0byBSQVMgJiBN
U0ktWCBlcnJvcg0KPiANCj4gU2VyaWVzIGFwcGxpZWQuDQoNCkkgcmV2ZXJ0ZWQsIHlvdSBuZWVk
IHRvIGFjdHVhbGx5IGJ1aWxkIHRlc3QgdGhlIGluZmluaWJhbmQgc2lkZSBvZiB5b3VyDQpkcml2
ZXIuDQoNCmRyaXZlcnMvaW5maW5pYmFuZC9ody9obnMvaG5zX3JvY2VfaHdfdjIuYzogSW4gZnVu
Y3Rpb24goWhuc19yb2NlX3YyX21zaXhfaW50ZXJydXB0X2FibqI6DQpkcml2ZXJzL2luZmluaWJh
bmQvaHcvaG5zL2huc19yb2NlX2h3X3YyLmM6NTAzMjoxNDogd2FybmluZzogcGFzc2luZyBhcmd1
bWVudCAyIG9mIKFvcHMtPnNldF9kZWZhdWx0X3Jlc2V0X3JlcXVlc3SiIG1ha2VzIHBvaW50ZXIg
ZnJvbSBpbnRlZ2VyIHdpdGhvdXQgYSBjYXN0IFstV2ludC1jb252ZXJzaW9uXQ0KICAgICAgICAg
ICAgICBITkFFM19GVU5DX1JFU0VUKTsNCiAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fg0K
ZHJpdmVycy9pbmZpbmliYW5kL2h3L2hucy9obnNfcm9jZV9od192Mi5jOjUwMzI6MTQ6IG5vdGU6
IGV4cGVjdGVkIKFsb25nIHVuc2lnbmVkIGludCAqoiBidXQgYXJndW1lbnQgaXMgb2YgdHlwZSCh
aW50og0KICBDLWMgQy1jbWFrZVs1XTogKioqIERlbGV0aW5nIGZpbGUgJ2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9jYXJsOTE3MC9jbWQubycNCg==
