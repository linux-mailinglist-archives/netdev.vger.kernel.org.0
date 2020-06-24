Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F8206A8A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbgFXD0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXD0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:26:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A883C061573;
        Tue, 23 Jun 2020 20:26:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAF5B12985777;
        Tue, 23 Jun 2020 20:26:29 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:26:29 -0700 (PDT)
Message-Id: <20200623.202629.352077396302165327.davem@davemloft.net>
To:     cjhuang@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH] net: qrtr: free flow in __qrtr_node_release
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592882523-12870-1-git-send-email-cjhuang@codeaurora.org>
References: <1592882523-12870-1-git-send-email-cjhuang@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:26:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>
Date: Tue, 23 Jun 2020 11:22:03 +0800

> @@ -168,6 +168,7 @@ static void __qrtr_node_release(struct kref *kref)
>  	struct radix_tree_iter iter;
>  	unsigned long flags;
>  	void __rcu **slot;
> +	struct qrtr_tx_flow *flow;

Please retain the reverse christmas tree ordering of local variables here.

Thanks.
