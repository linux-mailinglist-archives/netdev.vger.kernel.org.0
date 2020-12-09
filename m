Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2150E2D376E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgLIAOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:14:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44652 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLIAOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:14:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4ABA84D248DBE;
        Tue,  8 Dec 2020 16:13:25 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:13:24 -0800 (PST)
Message-Id: <20201208.161324.971174324730487173.davem@davemloft.net>
To:     awogbemila@google.com
Cc:     netdev@vger.kernel.org, alexander.duyck@gmail.com,
        saeed@kernel.org, alexanderduyck@fb.com
Subject: Re: [PATCH net-next v10 0/4] GVE Raw Addressing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201207224526.95773-1-awogbemila@google.com>
References: <20201207224526.95773-1-awogbemila@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:13:25 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>
Date: Mon,  7 Dec 2020 14:45:22 -0800

> Patchset description:
> This  patchset introduces "raw addressing" mode to the GVE driver.
> Previously (in "queue_page_list" or "qpl" mode), the driver would
> pre-allocate and dma_map buffers to be used on egress and ingress.
> On egress, it would copy data from the skb provided to the
> pre-allocated buffers - this was expensive.
> In raw addressing mode, the driver can avoid this copy and simply
> dma_map the skb's data so that the NIC can use it.
> On ingress, the driver passes buffers up to the networking stack and
> then frees and reallocates buffers when necessary instead of using
> skb_copy_to_linear_data.
> Patch 3 separates the page refcount tracking mechanism
> into a function gve_rx_can_recycle_buffer which uses get_page - this will
> be changed in a future patch to eliminate the use of get_page in tracking
> page refcounts.
> 
> Changes from v9:
>   Patch 4: Use u64, not u32 for new tx stat counters.

Series applied, thanks.
