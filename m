Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8481A8F41
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634385AbgDNXqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634364AbgDNXqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:46:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D58C061A0E
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 16:46:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C4B11280ED7A;
        Tue, 14 Apr 2020 16:46:18 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:46:17 -0700 (PDT)
Message-Id: <20200414.164617.151427426974731857.davem@davemloft.net>
To:     jgg@ziepe.ca
Cc:     netdev@vger.kernel.org, vishal@chelsio.com
Subject: Re: [PATCH] net/cxgb4: Check the return from t4_query_params
 properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0-v1-ee3eeeaf7d2e+e7d-cxgb4_gcc10%jgg@mellanox.com>
References: <0-v1-ee3eeeaf7d2e+e7d-cxgb4_gcc10%jgg@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 16:46:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUuY2E+DQpEYXRlOiBUdWUsIDE0IEFwciAy
MDIwIDEyOjI3OjA4IC0wMzAwDQoNCj4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFu
b3guY29tPg0KPiANCj4gUG9zaXRpdmUgcmV0dXJuIHZhbHVlcyBhcmUgYWxzbyBmYWlsdXJlcyB0
aGF0IGRvbid0IHNldCB2YWwsDQo+IGFsdGhvdWdoIHRoaXMgcHJvYmFibHkgY2FuJ3QgaGFwcGVu
LiBGaXhlcyBnY2MgMTAgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2NoZWxz
aW8vY3hnYjQvdDRfaHcuYzogSW4gZnVuY3Rpb24goXQ0X3BoeV9md192ZXKiOg0KPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9jaGVsc2lvL2N4Z2I0L3Q0X2h3LmM6Mzc0NzoxNDogd2FybmluZzogoXZh
bKIgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVu
aW5pdGlhbGl6ZWRdDQo+ICAzNzQ3IHwgICpwaHlfZndfdmVyID0gdmFsOw0KPiANCj4gRml4ZXM6
IDAxYjY5NjE0MTBiNyAoImN4Z2I0OiBBZGQgUEhZIGZpcm13YXJlIHN1cHBvcnQgZm9yIFQ0MjAt
QlQgY2FyZHMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BtZWxsYW5v
eC5jb20+DQoNCkFwcGxpZWQsIHRoYW5rcy4NCg==
