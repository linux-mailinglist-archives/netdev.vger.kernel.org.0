Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36666245B5C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 06:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgHQEMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 00:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgHQEMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 00:12:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323D3C061388
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 21:12:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AC3A1260D071;
        Sun, 16 Aug 2020 20:55:44 -0700 (PDT)
Date:   Sun, 16 Aug 2020 21:12:29 -0700 (PDT)
Message-Id: <20200816.211229.626725476201668565.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH net] mptcp: sendmsg: reset iter on error redux
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200816211420.7337-1-fw@strlen.de>
References: <20200816211420.7337-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 20:55:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sun, 16 Aug 2020 23:14:20 +0200

> This fix wasn't correct: When this function is invoked from the
> retransmission worker, the iterator contains garbage and resetting
> it causes a crash.
> 
> As the work queue should not be performance critical also zero the
> msghdr struct.
> 
> Fixes: 35759383133f64d "(mptcp: sendmsg: reset iter on error)"
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
