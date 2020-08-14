Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2C8244F74
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgHNVMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgHNVMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 17:12:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFEEC061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 14:12:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EF9212750CC1;
        Fri, 14 Aug 2020 13:55:54 -0700 (PDT)
Date:   Fri, 14 Aug 2020 14:12:39 -0700 (PDT)
Message-Id: <20200814.141239.1395631815275609574.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: sendmsg: reset iter on error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200814135634.12996-1-fw@strlen.de>
References: <20200814135634.12996-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 13:55:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 14 Aug 2020 15:56:34 +0200

> Once we've copied data from the iterator we need to revert in case we
> end up not sending any data.
> 
> This bug doesn't trigger with normal 'poll' based tests, because
> we only feed a small chunk of data to kernel after poll indicated
> POLLOUT.  With blocking IO and large writes this triggers. Receiver
> ends up with less data than it should get.
> 
> Fixes: 72511aab95c94d ("mptcp: avoid blocking in tcp_sendpages")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied and queued up for -stable, thanks.
