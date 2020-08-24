Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50A424FEA5
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgHXNRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgHXNRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:17:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85002C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 06:17:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 410D81281FC82;
        Mon, 24 Aug 2020 06:00:52 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:17:37 -0700 (PDT)
Message-Id: <20200824.061737.1288546229773264212.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, richardcochran@gmail.com, netdev@vger.kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com
Subject: Re: [PATCH v7 net-next 0/3] Add PTP support for Octeontx2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824.061657.2168445189551301124.davem@davemloft.net>
References: <1598255717-32316-1-git-send-email-sundeep.lkml@gmail.com>
        <20200824.061657.2168445189551301124.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 06:00:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogTW9uLCAyNCBB
dWcgMjAyMCAwNjoxNjo1NyAtMDcwMCAoUERUKQ0KDQo+IFNlcmllcyBhcHBsaWVkLCB0aGFuayB5
b3UuDQoNCkFjdHVhbGx5LCB0aGlzIGRvZXNuJ3QgZXZlbiBjb21waWxlOg0KDQpkcml2ZXJzL25l
dC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9wdHAuYzogSW4gZnVuY3Rpb24goWdldF9j
bG9ja19yYXRlojoNCmRyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL3B0
cC5jOjYwOjI2OiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24goUZJRUxE
X0dFVKI7IGRpZCB5b3UgbWVhbiChRk9MTF9HRVSiPyBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlv
bi1kZWNsYXJhdGlvbl0NCiAgIDYwIHwgIHJldCA9IENMT0NLX0JBU0VfUkFURSAqIEZJRUxEX0dF
VChSU1RfTVVMX0JJVFMsIGNmZyk7DQogICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICBe
fn5+fn5+fn4NCiAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgIEZPTExfR0VUDQo=
