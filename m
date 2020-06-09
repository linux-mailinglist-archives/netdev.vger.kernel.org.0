Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7DC1F322E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 04:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFICHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 22:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgFICHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 22:07:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09690C08C5C2;
        Mon,  8 Jun 2020 19:07:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D18AB128A517B;
        Mon,  8 Jun 2020 19:07:37 -0700 (PDT)
Date:   Mon, 08 Jun 2020 19:07:37 -0700 (PDT)
Message-Id: <20200608.190737.2279619081686680210.davem@davemloft.net>
To:     xypron.glpk@gmx.de
Cc:     vishal@chelsio.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cxgb4: fix cxgb4_uld_in_use() not used error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200608005823.911290-1-xypron.glpk@gmx.de>
References: <20200608005823.911290-1-xypron.glpk@gmx.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jun 2020 19:07:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSGVpbnJpY2ggU2NodWNoYXJkdCA8eHlwcm9uLmdscGtAZ214LmRlPg0KRGF0ZTogTW9u
LCAgOCBKdW4gMjAyMCAwMjo1ODoyMyArMDIwMA0KDQo+IFdoZW4gYnVpbGRpbmcgd2l0aG91dCBD
T05GSUdfQ0hFTFNJT19UTFNfREVWSUNFIGEgYnVpbGQgZXJyb3Igb2NjdXJzOg0KPiANCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2hlbHNpby9jeGdiNC9jeGdiNF91bGQuYzo2NjY6MTM6IGVycm9y
Og0KPiChY3hnYjRfdWxkX2luX3VzZaIgZGVmaW5lZCBidXQgbm90IHVzZWQgWy1XZXJyb3I9dW51
c2VkLWZ1bmN0aW9uXQ0KPiAgIDY2NiB8IHN0YXRpYyBib29sIGN4Z2I0X3VsZF9pbl91c2Uoc3Ry
dWN0IGFkYXB0ZXIgKmFkYXApDQo+ICAgICAgIHwgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+
fg0KPiANCj4gR3VhcmQgY3hnYjRfdWxkX2luX3VzZSgpIHdpdGggI2lmZGVmIENPTkZJR19DSEVM
U0lPX1RMU19ERVZJQ0UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZWlucmljaCBTY2h1Y2hhcmR0
IDx4eXByb24uZ2xwa0BnbXguZGU+DQoNCg0KUGxlYXNlIHNlZSBjb21taXQgZWYxYzc1NTkzZTc3
MGFmZjg3NDllOTAyYWEwZGViNjg1NWEzZjQ4NSwgd2hpY2ggYWxyZWFkeQ0KZG9lcyB0aGlzLg0K
DQpUaGFuayB5b3UuDQo=
