Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79962CC736
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfJEBaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:30:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEBaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:30:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1EB7E14F36394;
        Fri,  4 Oct 2019 18:30:05 -0700 (PDT)
Date:   Fri, 04 Oct 2019 18:30:04 -0700 (PDT)
Message-Id: <20191004.183004.2249160190157022941.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] sch_dsmark: fix potential NULL deref in
 dsmark_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004173445.81907-1-edumazet@google.com>
References: <20191004173445.81907-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 18:30:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  4 Oct 2019 10:34:45 -0700

> Make sure TCA_DSMARK_INDICES was provided by the user.
> 
> syzbot reported :
 ...
> Fixes: 758cc43c6d73 ("[PKT_SCHED]: Fix dsmark to apply changes consistent")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
