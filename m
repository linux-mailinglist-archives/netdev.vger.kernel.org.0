Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD328A9FEB
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387953AbfIEKjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:39:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732233AbfIEKjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:39:19 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BD771538813A;
        Thu,  5 Sep 2019 03:39:17 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:39:15 +0200 (CEST)
Message-Id: <20190905.123915.113098265973997377.davem@davemloft.net>
To:     kw@linux.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qed: Move static keyword to the front of
 declaration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190904141730.31497-1-kw@linux.com>
References: <20190904141730.31497-1-kw@linux.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:39:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS3J6eXN6dG9mIFdpbGN6eW5za2kgPGt3QGxpbnV4LmNvbT4NCkRhdGU6IFdlZCwgIDQg
U2VwIDIwMTkgMTY6MTc6MzAgKzAyMDANCg0KPiBNb3ZlIHRoZSBzdGF0aWMga2V5d29yZCB0byB0
aGUgZnJvbnQgb2YgZGVjbGFyYXRpb24gb2YgaXdhcnBfc3RhdGVfbmFtZXMsDQo+IGFuZCByZXNv
bHZlIHRoZSBmb2xsb3dpbmcgY29tcGlsZXIgd2FybmluZyB0aGF0IGNhbiBiZSBzZWVuIHdoZW4g
YnVpbGRpbmcNCj4gd2l0aCB3YXJuaW5ncyBlbmFibGVkIChXPTEpOg0KPiANCj4gZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfaXdhcnAuYzozODU6MTogd2FybmluZzoNCj4gICCh
c3RhdGljoiBpcyBub3QgYXQgYmVnaW5uaW5nIG9mIGRlY2xhcmF0aW9uIFstV29sZC1zdHlsZS1k
ZWNsYXJhdGlvbl0NCj4gDQo+IEFsc28sIHJlc29sdmUgY2hlY2twYXRjaC5wbCBzY3JpcHQgd2Fy
bmluZzoNCj4gDQo+IFdBUk5JTkc6IHN0YXRpYyBjb25zdCBjaGFyICogYXJyYXkgc2hvdWxkIHBy
b2JhYmx5IGJlDQo+ICAgc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdA0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogS3J6eXN6dG9mIFdpbGN6eW5za2kgPGt3QGxpbnV4LmNvbT4NCg0KQXBwbGllZCB0byBu
ZXQtbmV4dC4NCg==
