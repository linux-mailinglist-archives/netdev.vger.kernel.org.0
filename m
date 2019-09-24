Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE46DBCA57
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441417AbfIXOgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:36:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441386AbfIXOgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:36:37 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E77F315269EC4;
        Tue, 24 Sep 2019 07:36:34 -0700 (PDT)
Date:   Tue, 24 Sep 2019 16:36:31 +0200 (CEST)
Message-Id: <20190924.163631.1747631703169589693.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, vladbu@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH net] net: sched: fix possible crash in
 tcf_action_destroy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190918195704.218413-1-edumazet@google.com>
References: <20190918195704.218413-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 07:36:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 18 Sep 2019 12:57:04 -0700

> If the allocation done in tcf_exts_init() failed,
> we end up with a NULL pointer in exts->actions.
 ...
> Fixes: 90b73b77d08e ("net: sched: change action API to use array of pointers to actions")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
