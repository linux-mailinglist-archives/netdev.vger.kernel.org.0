Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73F8FD0B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfD3Pjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:39:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3Pjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:39:35 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CCCC1418EB7B;
        Tue, 30 Apr 2019 08:39:34 -0700 (PDT)
Date:   Tue, 30 Apr 2019 11:39:31 -0400 (EDT)
Message-Id: <20190430.113931.1930596224086750181.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, g.nault@alphalink.fr
Subject: Re: [PATCH net] l2ip: fix possible use-after-free
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430132758.163542-1-edumazet@google.com>
References: <20190430132758.163542-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 08:39:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 Apr 2019 06:27:58 -0700

> Before taking a refcount on a rcu protected structure,
> we need to make sure the refcount is not zero.
> 
> syzbot reported :
 ...
> Fixes: 54652eb12c1b ("l2tp: hold tunnel while looking up sessions in l2tp_netlink")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Guillaume Nault <g.nault@alphalink.fr>

Applied, thanks Eric.
