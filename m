Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A893934FCA
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfFDSX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:23:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDSX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:23:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 300AB14F2507E;
        Tue,  4 Jun 2019 11:23:58 -0700 (PDT)
Date:   Tue, 04 Jun 2019 11:23:57 -0700 (PDT)
Message-Id: <20190604.112357.1200320783493199233.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net 0/2] net/tls: redo the RX resync locking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190601031201.32027-1-jakub.kicinski@netronome.com>
References: <20190601031201.32027-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 11:23:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFrdWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+DQpEYXRl
OiBGcmksIDMxIE1heSAyMDE5IDIwOjExOjU5IC0wNzAwDQoNCj4gVGFrZSB0d28gb2YgbWFraW5n
IHN1cmUgd2UgZG9uJ3QgdXNlIGEgTlVMTCBuZXRkZXYgcG9pbnRlcg0KPiBmb3IgUlggcmVzeW5j
LiAgVGhpcyB0aW1lIHVzaW5nIGEgYml0IGFuZCBhbiBvcGVuIGNvZGVkDQo+IHdhaXQgbG9vcC4N
Cj4gDQo+IFBvc3RpbmcgYXMgcmV2ZXJ0ICsgbmV3IHBhdGNoLCBob3BlZnVsbHkgdGhpcyB3aWxs
IG1ha2UgaXQNCj4gZWFzaWVyIHRvIGJhY2twb3J0IHRvIHN0YWJsZSAodW5sZXNzIHRoaXJkIHRp
bWUgaXMgdGhlIGNoYXJtLA0KPiBhbmQgdGhpcyBvbmUgaXMgYnVnZ3kgYXMgd2VsbCA6KCkuDQoN
ClN0aWxsIG5lZWRzIHNvbWUgd29yayA6LSkNCg0KbmV0L3Rscy90bHNfZGV2aWNlLmM6IEluIGZ1
bmN0aW9uIKFoYW5kbGVfZGV2aWNlX3Jlc3luY6I6DQpuZXQvdGxzL3Rsc19kZXZpY2UuYzo1Njk6
MjE6IHdhcm5pbmc6IHVudXNlZCB2YXJpYWJsZSChbmV0ZGV2oiBbLVd1bnVzZWQtdmFyaWFibGVd
DQogIHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYgPSB0bHNfY3R4LT5uZXRkZXY7DQogICAgICAg
ICAgICAgICAgICAgICBefn5+fn4NCg==
