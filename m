Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89522250C30
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgHXXQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXXQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 19:16:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1F1C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 16:16:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 133E212924E80;
        Mon, 24 Aug 2020 16:00:10 -0700 (PDT)
Date:   Mon, 24 Aug 2020 16:16:55 -0700 (PDT)
Message-Id: <20200824.161655.863789085344308332.davem@davemloft.net>
To:     luke.w.hsiao@gmail.com
Cc:     netdev@vger.kernel.org, axboe@kernel.dk, kuba@kernel.org,
        lukehsiao@google.com, arjunroy@google.com, soheil@google.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v3 2/2] io_uring: ignore POLLIN for recvmsg on
 MSG_ERRQUEUE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822044105.3097613-2-luke.w.hsiao@gmail.com>
References: <0bc6cc65-e764-6fe0-9b0a-431015835770@kernel.dk>
        <20200822044105.3097613-1-luke.w.hsiao@gmail.com>
        <20200822044105.3097613-2-luke.w.hsiao@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 16:00:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <luke.w.hsiao@gmail.com>
Date: Fri, 21 Aug 2020 21:41:05 -0700

> From: Luke Hsiao <lukehsiao@google.com>
> 
> Currently, io_uring's recvmsg subscribes to both POLLERR and POLLIN. In
> the context of TCP tx zero-copy, this is inefficient since we are only
> reading the error queue and not using recvmsg to read POLLIN responses.
> 
> This patch was tested by using a simple sending program to call recvmsg
> using io_uring with MSG_ERRQUEUE set and verifying with printks that the
> POLLIN is correctly unset when the msg flags are MSG_ERRQUEUE.

Again, selftests additions please.

> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Luke Hsiao <lukehsiao@google.com>

Applied.
