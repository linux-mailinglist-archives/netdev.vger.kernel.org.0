Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F050D864A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390888AbfJPDTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:19:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfJPDTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:19:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0364E128F3874;
        Tue, 15 Oct 2019 20:19:50 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:19:50 -0700 (PDT)
Message-Id: <20191015.201950.641044017625677016.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] net_sched: sch_fq: remove one obsolete check
 in fq_dequeue()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014174032.138670-1-edumazet@google.com>
References: <20191014174032.138670-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:19:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 14 Oct 2019 10:40:32 -0700

> After commit eeb84aa0d0aff ("net_sched: sch_fq: do not assume EDT
> packets are ordered"), all skbs get a non zero time_to_send
> in flow_queue_add()
> 
> This means @time_next_packet variable in fq_dequeue()
> can no longer be zero.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
