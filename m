Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14B723B0DE
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgHCXWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728891AbgHCXWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:22:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BD0C06174A;
        Mon,  3 Aug 2020 16:22:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E2591277CEBD;
        Mon,  3 Aug 2020 16:05:18 -0700 (PDT)
Date:   Mon, 03 Aug 2020 16:22:03 -0700 (PDT)
Message-Id: <20200803.162203.547758721051828253.davem@davemloft.net>
To:     huangguobin4@huawei.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tipc: Use is_broadcast_ether_addr() instead
 of memcmp()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803020055.26822-1-huangguobin4@huawei.com>
References: <20200803020055.26822-1-huangguobin4@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 16:05:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huang Guobin <huangguobin4@huawei.com>
Date: Sun, 2 Aug 2020 22:00:55 -0400

> Using is_broadcast_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is broadcast
> address.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>

Applied, thank you.
