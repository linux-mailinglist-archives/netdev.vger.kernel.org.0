Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0AA2699F2
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgINXyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINXyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:54:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD0EC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:54:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72153128DB6A2;
        Mon, 14 Sep 2020 16:37:23 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:54:09 -0700 (PDT)
Message-Id: <20200914.165409.912008161467332169.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net] net: sched: initialize with 0 before setting
 erspan md->u
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cf5da3ba7ceb318ced1555f42795fcebfb0b870f.1599997383.git.lucien.xin@gmail.com>
References: <cf5da3ba7ceb318ced1555f42795fcebfb0b870f.1599997383.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:37:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 13 Sep 2020 19:43:03 +0800

> In fl_set_erspan_opt(), all bits of erspan md was set 1, as this
> function is also used to set opt MASK. However, when setting for
> md->u.index for opt VALUE, the rest bits of the union md->u will
> be left 1. It would cause to fail the match of the whole md when
> version is 1 and only index is set.
> 
> This patch is to fix by initializing with 0 before setting erspan
> md->u.
> 
> Reported-by: Shuang Li <shuali@redhat.com>
> Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thank you.
