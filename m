Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711FF110586
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfLCTxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:53:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfLCTxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:53:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64A301510A323;
        Tue,  3 Dec 2019 11:53:12 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:53:11 -0800 (PST)
Message-Id: <20191203.115311.1412019727224973630.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        ncardwell@google.com, ycheng@google.com, willemb@google.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203160552.31071-1-edumazet@google.com>
References: <20191203160552.31071-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:53:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  3 Dec 2019 08:05:52 -0800

> It appears linux-4.14 stable needs a backport of commit
> 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
> 
> Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
> let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
> 
> I will provide to stable teams the squashed patches.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
