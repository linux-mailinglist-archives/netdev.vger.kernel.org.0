Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712DB1E32C1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404479AbgEZWh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389755AbgEZWh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:37:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66831C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:37:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2446D1210A449;
        Tue, 26 May 2020 15:37:28 -0700 (PDT)
Date:   Tue, 26 May 2020 15:37:27 -0700 (PDT)
Message-Id: <20200526.153727.409469095660583492.davem@davemloft.net>
To:     sworley@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, sworley1995@gmail.com
Subject: Re: [PATCH] net-next: add large ecmp group nexthop tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526164804.477124-1-sworley@cumulusnetworks.com>
References: <20200526164804.477124-1-sworley@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:37:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Worley <sworley@cumulusnetworks.com>
Date: Tue, 26 May 2020 12:48:04 -0400

> Add a couple large ecmp group nexthop selftests to cover
> the remnant fixed by d69100b8eee27c2d60ee52df76e0b80a8d492d34.
> 
> The tests create 100 x32 ecmp groups of ipv4 and ipv6 and then
> dump them. On kernels without the fix, they will fail due
> to data remnant during the dump.
> 
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>

This doesn't apply to net-next, please respin.
