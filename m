Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31723B044
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgHCWiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCWiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:38:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8C5C06174A;
        Mon,  3 Aug 2020 15:38:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D79C412777715;
        Mon,  3 Aug 2020 15:22:04 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:38:49 -0700 (PDT)
Message-Id: <20200803.153849.62600184085381506.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qed: use eth_zero_addr() to clear mac address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596273281-24277-1-git-send-email-linmiaohe@huawei.com>
References: <1596273281-24277-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:22:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Sat, 1 Aug 2020 17:14:41 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Use eth_zero_addr() to clear mac address instead of memset().
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied.
