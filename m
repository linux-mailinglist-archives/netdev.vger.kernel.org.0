Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B27BA0DF5
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfH1W6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:58:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38340 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfH1W6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:58:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39A59153B0485;
        Wed, 28 Aug 2019 15:58:39 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:58:38 -0700 (PDT)
Message-Id: <20190828.155838.174372477469386140.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org, pabeni@redhat.com, sbrivio@redhat.com,
        shuali@redhat.com
Subject: Re: [PATCH net] net/sched: pfifo_fast: fix wrong dereference in
 pfifo_fast_enqueue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d5a7a167ab57e035685445ee641840a0c5fd39ae.1566940693.git.dcaratti@redhat.com>
References: <d5a7a167ab57e035685445ee641840a0c5fd39ae.1566940693.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 15:58:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 27 Aug 2019 23:18:53 +0200

> Now that 'TCQ_F_CPUSTATS' bit can be cleared, depending on the value of
> 'TCQ_F_NOLOCK' bit in the parent qdisc, we can't assume anymore that
> per-cpu counters are there in the error path of skb_array_produce().
> Otherwise, the following splat can be seen:
 ...
> Fix this by testing the value of 'TCQ_F_CPUSTATS' bit in 'qdisc->flags',
> before dereferencing 'qdisc->cpu_qstats'.
> 
> Fixes: 8a53e616de29 ("net: sched: when clearing NOLOCK, clear TCQ_F_CPUSTATS, too")
> CC: Paolo Abeni <pabeni@redhat.com>
> CC: Stefano Brivio <sbrivio@redhat.com>
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied and queued up for v5.2 -stable, thanks.
