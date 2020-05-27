Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E751E3688
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgE0D3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0D3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:29:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177A8C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:29:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9BFD712794BE9;
        Tue, 26 May 2020 20:29:52 -0700 (PDT)
Date:   Tue, 26 May 2020 20:29:51 -0700 (PDT)
Message-Id: <20200526.202951.2265572090042382004.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        pabeni@redhat.com, matthieu.baerts@tessares.net
Subject: Re: [PATCH net-next] mptcp: attempt coalescing when moving skbs to
 mptcp rx queue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525214113.3131-1-fw@strlen.de>
References: <20200525214113.3131-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:29:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Mon, 25 May 2020 23:41:13 +0200

> We can try to coalesce skbs we take from the subflows rx queue with the
> tail of the mptcp rx queue.
> 
> If successful, the skb head can be discarded early.
> 
> We can also free the skb extensions, we do not access them after this.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
