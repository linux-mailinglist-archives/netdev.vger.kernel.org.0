Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4DA255C21
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgH1ORw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgH1ORp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 10:17:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85CFC06121B
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 07:17:41 -0700 (PDT)
Received: from localhost (c-73-193-106-77.hsd1.wa.comcast.net [73.193.106.77])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 103EC12856B5D;
        Fri, 28 Aug 2020 07:00:54 -0700 (PDT)
Date:   Fri, 28 Aug 2020 07:17:31 -0700 (PDT)
Message-Id: <20200828.071731.1630458922977881285.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+b33c1cb0a30ebdc8a5f9@syzkaller.appspotmail.com,
        syzbot+e5ea5f8a3ecfd4427a1c@syzkaller.appspotmail.com,
        petrm@mellanox.com
Subject: Re: [Patch net] net_sched: fix error path in red_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827174041.13300-1-xiyou.wangcong@gmail.com>
References: <20200827174041.13300-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 07:00:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 27 Aug 2020 10:40:41 -0700

> When ->init() fails, ->destroy() is called to clean up.
> So it is unnecessary to clean up in red_init(), and it
> would cause some refcount underflow.
> 
> Fixes: aee9caa03fc3 ("net: sched: sch_red: Add qevents "early_drop" and "mark"")
> Reported-and-tested-by: syzbot+b33c1cb0a30ebdc8a5f9@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+e5ea5f8a3ecfd4427a1c@syzkaller.appspotmail.com
> Cc: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thank you.
