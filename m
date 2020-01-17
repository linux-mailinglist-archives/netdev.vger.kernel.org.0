Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13E714072C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 10:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgAQJ7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 04:59:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbgAQJ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 04:59:08 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2EF41555270F;
        Fri, 17 Jan 2020 01:59:06 -0800 (PST)
Date:   Fri, 17 Jan 2020 01:59:05 -0800 (PST)
Message-Id: <20200117.015905.41748238942697639.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, dcaratti@redhat.com
Subject: Re: [PATCH v3 net] net/sched: act_ife: initalize ife->metalist
 earlier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115162039.113706-1-edumazet@google.com>
References: <20200115162039.113706-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 01:59:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 Jan 2020 08:20:39 -0800

> It seems better to init ife->metalist earlier in tcf_ife_init()
> to avoid the following crash :
 ...
> Fixes: 11a94d7fd80f ("net/sched: act_ife: validate the control action inside init()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Davide Caratti <dcaratti@redhat.com>
> ---
> v2,v3: addressed Davide feedbacks.

Applied and queued up for -stable.
