Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAF5141EB1
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgASPDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:03:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASPDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:03:22 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C178C14EC31E8;
        Sun, 19 Jan 2020 07:03:20 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:03:19 +0100 (CET)
Message-Id: <20200119.160319.1807817038862283145.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, ldir@darbyshire-bryant.me.uk,
        xiyou.wangcong@gmail.com, toke@redhat.com
Subject: Re: [PATCH net] net: sched: act_ctinfo: fix memory leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200119044506.209726-1-edumazet@google.com>
References: <20200119044506.209726-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 07:03:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 18 Jan 2020 20:45:06 -0800

> Implement a cleanup method to properly free ci->params
 ...
> Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
