Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140BE22766D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGUDNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgGUDNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 23:13:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD17C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 20:13:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84EBB1260D090;
        Mon, 20 Jul 2020 19:56:34 -0700 (PDT)
Date:   Mon, 20 Jul 2020 20:12:26 -0700 (PDT)
Message-Id: <20200720.201226.912664403829372463.davem@davemloft.net>
To:     tung.q.nguyen@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [tipc-discussion] [net v1 1/1] tipc: allow to build NACK
 message in link timeout function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721015705.2333-1-tung.q.nguyen@dektech.com.au>
References: <20200721015705.2333-1-tung.q.nguyen@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 19:56:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Date: Tue, 21 Jul 2020 08:57:05 +0700

> Commit 02288248b051 ("tipc: eliminate gap indicator from ACK messages")
> eliminated sending of the 'gap' indicator in regular ACK messages and
> only allowed to build NACK message with enabled probe/probe_reply.
> However, necessary correction for building NACK message was missed
> in tipc_link_timeout() function. This leads to significant delay and
> link reset (due to retransmission failure) in lossy environment.
> 
> This commit fixes it by setting the 'probe' flag to 'true' when
> the receive deferred queue is not empty. As a result, NACK message
> will be built to send back to another peer.
> 
> Fixes: commit 02288248b051 ("tipc: eliminate gap indicator from ACK messages")

"commit" doesn't belong here, I removed it when I applied your patch.

> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>

Applied and queued up for -stable, thanks.
