Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38481E3686
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgE0D2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0D2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:28:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF56AC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:28:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58A8612793AA8;
        Tue, 26 May 2020 20:28:13 -0700 (PDT)
Date:   Tue, 26 May 2020 20:28:12 -0700 (PDT)
Message-Id: <20200526.202812.2041217173134298145.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, matthieu.baerts@tessares.net,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 0/2] mptcp: adjust tcp rcvspace on rx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525181508.13492-1-fw@strlen.de>
References: <20200525181508.13492-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:28:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Mon, 25 May 2020 20:15:06 +0200

> These two patches improve mptcp throughput by making sure tcp grows
> the receive buffer when we move skbs from subflow socket to the
> mptcp socket.
> 
> The second patch moves mptcp receive buffer increase to the recvmsg
> path, i.e. we only change its size when userspace processes/consumes
> the data.  This is done by using the largest rcvbuf size of the active
> subflows.

What's the follow-up wrt. Christoph's feedback on patch #2?

