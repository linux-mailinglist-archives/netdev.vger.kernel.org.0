Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CECB145CEC
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgAVUM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:12:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVUM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:12:59 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6203015A15CD0;
        Wed, 22 Jan 2020 12:12:57 -0800 (PST)
Date:   Wed, 22 Jan 2020 21:12:55 +0100 (CET)
Message-Id: <20200122.211255.850684379993100511.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, xiyou.wangcong@gmail.com,
        marcelo.leitner@gmail.com, jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [PATCH net] net_sched: use validated TCA_KIND attribute in
 tc_new_tfilter()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121190220.176759-1-edumazet@google.com>
References: <20200121190220.176759-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jan 2020 12:12:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 21 Jan 2020 11:02:20 -0800

> sysbot found another issue in tc_new_tfilter().
> We probably should use @name which contains the sanitized
> version of TCA_KIND.
 ...
> Fixes: 6f96c3c6904c ("net_sched: fix backward compatibility for TCA_KIND")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
